/**
 * fill_all_weeks.js
 *
 * Lấp đầy TẤT CẢ tuần 1→140 với lịch học.
 * Chiến lược:
 *   - Với mỗi tuần w còn thiếu → xác định học kỳ đang diễn ra → lấy TU của HK đó → tạo schedule
 *   - Tuần 1-3: dùng HK đầu tiên của mỗi khóa (tuần khai giảng / nhập học / định hướng)
 *   - Tuần "khoảng cách" (26, 47-52, 73-78, 99): là tuần trong học kỳ đang chạy, chỉ bị bỏ sót
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

function rng(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[rng(0, arr.length - 1)]; }
function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) { const j = rng(0, i); [a[i], a[j]] = [a[j], a[i]]; }
  return a;
}

// Học kỳ → range tuần (PHẢI khớp với seed_bulk / cleanup_and_rebuild)
// K15: HK5=[4,25], HK6=[27,46]
// K16: HK1=[4,25], HK2=[27,46], HK3=[53,72], HK4=[79,98], HK5=[100,119], HK6=[120,139]
// K17: HK1=[4,25], HK2=[27,46], HK3=[53,72], HK4=[79,98]
const SEM_PLAN = {
  K15: [ [5,1,140], [6,27,46] ],   // HK5→tuần1-25(mở rộng về 1), HK6→27-46
  K16: [ [1,1,25], [2,27,52], [3,53,78], [4,79,99], [5,100,119], [6,120,139] ],
  K17: [ [1,1,25], [2,27,52], [3,53,78], [4,79,99] ],
};
// Phạm vi tuần mỗi HK (mở rộng để bao phủ khoảng trống)
function semForWeek(cohort, week) {
  for (const [hk, start, end] of SEM_PLAN[cohort]) {
    if (week >= start && week <= end) return hk;
  }
  return null;
}

// Phòng
const THEORY_ROOMS   = ['room_a17_401','room_a17_402','room_a17_403','room_a17_404','room_a17_405',
                        'room_a17_406','room_a17_407','room_a17_408','room_a17_409',
                        'room_a17_501a','room_a17_501b','room_a17_502','room_a17_504',
                        'room_c4b_1','room_c4b_2','room_c4b_3','room_c4b_4','room_c4b_5','room_c4b_6'];
const PRACTICE_ROOMS = ['room_pm_301','room_pm_302','room_pm_303','room_pm_304','room_pm_305',
                        'room_pm_306','room_pm_401','room_pm_402','room_pm_403','room_pm_404',
                        'room_pm_405','room_pm_406','room_pm_407','room_pm_408','room_pm_409',
                        'room_b4_301','room_d_303'];

// Slot booking per week
const usedSlots = new Map();
function bookSlot(week, day, ps, roomId) {
  const k = `${day}-${ps}-${roomId}`;
  if (!usedSlots.has(week)) usedSlots.set(week, new Set());
  usedSlots.get(week).add(k);
}
function slotFree(week, day, ps, roomId) {
  return !usedSlots.has(week) || !usedSlots.get(week).has(`${day}-${ps}-${roomId}`);
}
const SLOTS = [[1,3],[2,4],[4,6],[7,9],[8,10],[10,12]];
function findSlot(week, roomId) {
  for (const day of shuffle([2,3,4,5,6,7])) {
    for (const [ps, pe] of shuffle(SLOTS)) {
      if (slotFree(week, day, ps, roomId)) {
        bookSlot(week, day, ps, roomId);
        return { day, ps, pe };
      }
    }
  }
  return null;
}

async function main() {
  console.log('🔍 Phân tích tuần còn thiếu...');

  // Tìm tất cả tuần đã có trong DB
  const existingWeeks = await prisma.schedule.groupBy({
    by: ['weekNumber'], _count: { id: true }, orderBy: { weekNumber: 'asc' },
  });
  const existingWeekSet = new Set(existingWeeks.map(w => w.weekNumber));

  // Mục tiêu: tuần 1 → 140
  const TARGET_WEEKS = [];
  for (let w = 1; w <= 140; w++) TARGET_WEEKS.push(w);
  const missingWeeks = TARGET_WEEKS.filter(w => !existingWeekSet.has(w));
  console.log(`  Tuần đã có: ${existingWeeks.length} | Tuần thiếu: ${missingWeeks.length}`);
  console.log('  Tuần thiếu:', missingWeeks.join(', '));

  // Load existing schedules để pre-populate slot tracker
  console.log('\n📦 Load slots đã dùng...');
  const existingScheds = await prisma.schedule.findMany({
    select: { weekNumber: true, dayOfWeek: true, periodStart: true, roomId: true },
  });
  for (const s of existingScheds) {
    if (s.roomId) bookSlot(s.weekNumber, s.dayOfWeek, s.periodStart, s.roomId);
  }
  console.log(`  Loaded ${existingScheds.length} slots`);

  // Load tất cả TU kèm subject type và assignment.classGroupId
  const allTU = await prisma.teachingUnit.findMany({
    include: { subject: true, assignment: true },
  });
  // Map: tuId → { subjectType, classGroupId, semNo }
  const tuMap = {};
  allTU.forEach(t => {
    const m = t.id.match(/_hk(\d+)$/);
    const semNo = m ? parseInt(m[1]) : 0;
    tuMap[t.id] = {
      id: t.id,
      isPractice: t.subject.isPractice,
      classGroupId: t.assignment.classGroupId,
      semNo,
    };
  });

  // Load cohort cho mỗi lớp
  const classGroups = await prisma.classGroup.findMany({ include: { cohort: true } });
  const classCohort = Object.fromEntries(classGroups.map(c => [c.id, c.cohort.code]));

  // Tìm tất cả scheduleId đã tồn tại để tránh trùng
  const existingSchedIds = new Set(
    (await prisma.schedule.findMany({ select: { id: true } })).map(s => s.id)
  );

  let totalAdded = 0;

  for (const week of missingWeeks) {
    console.log(`\n  📅 Tuần ${week}...`);
    const rows = [];

    // Với mỗi TU, kiểm tra xem tuần này có thuộc học kỳ của TU không
    for (const tu of Object.values(tuMap)) {
      const cohort = classCohort[tu.classGroupId];
      if (!cohort) continue;
      const hkForThisWeek = semForWeek(cohort, week);
      if (hkForThisWeek !== tu.semNo) continue;

      // TU này nên có lịch ở tuần này
      const roomPool = tu.isPractice ? PRACTICE_ROOMS : THEORY_ROOMS;
      const roomId = pick(roomPool);
      const slot = findSlot(week, roomId);
      if (!slot) continue;

      const schId = `sch_${tu.id.replace('tu_','')}_w${week}`;
      if (existingSchedIds.has(schId)) continue;
      existingSchedIds.add(schId);

      rows.push({
        id: schId,
        teachingUnitId: tu.id,
        roomId,
        dayOfWeek: slot.day,
        periodStart: slot.ps,
        periodEnd: slot.pe,
        weekNumber: week,
        mode: 'OFFLINE',
      });
    }

    if (rows.length > 0) {
      // Insert theo batch 500
      for (let i = 0; i < rows.length; i += 500) {
        await prisma.schedule.createMany({ data: rows.slice(i, i+500), skipDuplicates: true });
      }
      totalAdded += rows.length;
      console.log(`    → Thêm ${rows.length} slots`);
    } else {
      console.log(`    → Không có TU nào cho tuần này (ngoài phạm vi tất cả HK)`);
    }
  }

  // Kiểm tra kết quả
  console.log('\n🔍 Kiểm tra lại tuần còn thiếu...');
  const finalWeeks = await prisma.schedule.groupBy({
    by: ['weekNumber'], _count: { id: true }, orderBy: { weekNumber: 'asc' },
  });
  const finalSet = new Set(finalWeeks.map(w => w.weekNumber));
  const stillMissing = TARGET_WEEKS.filter(w => !finalSet.has(w));

  const [totalSched] = await Promise.all([ prisma.schedule.count() ]);

  console.log('\n═══════════════════════════════════════════════');
  console.log('📊 KẾT QUẢ:');
  console.log(`  Slots mới thêm:    ${totalAdded}`);
  console.log(`  Tổng lịch học:     ${totalSched}`);
  console.log(`  Tuần có lịch:      ${finalWeeks.length} / 140`);
  console.log(`  Tuần vẫn còn trống: ${stillMissing.length}${stillMissing.length > 0 ? ' → ' + stillMissing.join(',') : ' ✅'}`);
  // Sample coverage
  console.log('\n  Lịch theo tuần đại diện:');
  [1,2,3,4,10,20,26,27,40,46,47,52,53,60,73,79,99,100,120,139,140].forEach(w => {
    const g = finalWeeks.find(x => x.weekNumber === w);
    console.log(`    Tuần ${String(w).padStart(3)}: ${g ? g._count.id + ' slots' : '❌ trống'}`);
  });
  console.log('═══════════════════════════════════════════════');

  await prisma.$disconnect();
}

main().catch(e => { console.error('❌', e.message); prisma.$disconnect(); process.exit(1); });
