/**
 * add_k18_2026_2027.js
 *
 * Thêm incremental (không xóa data cũ):
 *   1. Cohort K18 (offset=120, nhập học ~Mar 2026)
 *   2. Lớp học K18 cho 4 ngành
 *   3. User accounts cho sinh viên K18
 *   4. Lịch học K18 HK1-HK6 (tuần 121-240)
 *   5. Lịch học K17 HK5-HK6 (tuần 161-200) nếu chưa có — năm 2026-2027
 *
 * K18 offset=120:
 *   HK1=121-140, HK2=141-160, HK3=161-180, HK4=181-200, HK5=201-220, HK6=221-240
 * K17 offset=80:
 *   HK5=161-180, HK6=181-200 → năm học 2026-2027
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const Redis = require('ioredis');

const prisma = new PrismaClient();

// ─── Helpers ────────────────────────────────────────────────────────────────
function rng(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[rng(0, arr.length - 1)]; }
function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = rng(0, i);
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
function removeDiacritics(str) {
  const map = {
    'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ằ':'a','ắ':'a','ẳ':'a','ẵ':'a','ặ':'a',
    'â':'a','ầ':'a','ấ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d',
    'è':'e','é':'e','ẻ':'e','ẽ':'e','ẹ':'e','ê':'e','ề':'e','ế':'e','ể':'e','ễ':'e','ệ':'e',
    'ì':'i','í':'i','ỉ':'i','ĩ':'i','ị':'i',
    'ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ồ':'o','ố':'o','ổ':'o','ỗ':'o','ộ':'o',
    'ơ':'o','ờ':'o','ớ':'o','ở':'o','ỡ':'o','ợ':'o',
    'ù':'u','ú':'u','ủ':'u','ũ':'u','ụ':'u','ư':'u','ừ':'u','ứ':'u','ử':'u','ữ':'u','ự':'u',
    'ỳ':'y','ý':'y','ỷ':'y','ỹ':'y','ỵ':'y',
  };
  return str.split('').map(c => map[c.toLowerCase()] || c.toLowerCase()).join('');
}

// ─── K18 lớp học ─────────────────────────────────────────────────────────────
const K18_CLASSES = {
  major_ltmt: [
    { id:'cls_ltmt1_k18', code:'LTMT1-K18', cnt:45 },
    { id:'cls_ltmt2_k18', code:'LTMT2-K18', cnt:43 },
    { id:'cls_ltmt3_k18', code:'LTMT3-K18', cnt:42 },
    { id:'cls_ltmt4_k18', code:'LTMT4-K18', cnt:40 },
    { id:'cls_ltmt5_k18', code:'LTMT5-K18', cnt:38 },
  ],
  major_qtm: [
    { id:'cls_qtm1_k18', code:'QTM1-K18', cnt:45 },
    { id:'cls_qtm2_k18', code:'QTM2-K18', cnt:43 },
    { id:'cls_qtm3_k18', code:'QTM3-K18', cnt:40 },
  ],
  major_udpm: [
    { id:'cls_udpm1_k18', code:'UDPM1-K18', cnt:43 },
    { id:'cls_udpm2_k18', code:'UDPM2-K18', cnt:41 },
    { id:'cls_udpm3_k18', code:'UDPM3-K18', cnt:40 },
  ],
  major_tkdh: [
    { id:'cls_tkdh1_k18', code:'TKĐH1-K18', cnt:48 },
    { id:'cls_tkdh2_k18', code:'TKĐH2-K18', cnt:47 },
    { id:'cls_tkdh3_k18', code:'TKĐH3-K18', cnt:46 },
    { id:'cls_tkdh4_k18', code:'TKĐH4-K18', cnt:45 },
    { id:'cls_tkdh5_k18', code:'TKĐH5-K18', cnt:44 },
    { id:'cls_tkdh6_k18', code:'TKĐH6-K18', cnt:43 },
    { id:'cls_tkdh7_k18', code:'TKĐH7-K18', cnt:42 },
  ],
};

// ─── SEM_WEEKS mới ───────────────────────────────────────────────────────────
// K18 offset=120, K17 HK5-6 = tuần 161-200
const ADD_WEEKS = {
  K18: { 1:[121,140], 2:[141,160], 3:[161,180], 4:[181,200], 5:[201,220], 6:[221,240] },
  K17_hk56: { 5:[161,180], 6:[181,200] }, // chỉ thêm nếu chưa có
};

// ─── Chương trình đào tạo (copy từ reset script) ─────────────────────────────
const CTDT = {
  LTMT: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_laptC','sub_ctxh','sub_nmmt','sub_dhua','sub_sql'],
    3: ['sub_lphuong','sub_lapCsharp','sub_csdl','sub_pttkht','sub_xdweb','sub_av3'],
    4: ['sub_lapPHP','sub_lapPython','sub_ltdidong','sub_ctdlgt','sub_cnpm','sub_qtwebfw'],
    5: ['sub_xdpm','sub_lpservice','sub_udai','sub_qldacntt','sub_antoabm','sub_thuctapcs'],
    6: ['sub_dotancs'],
  },
  QTM: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_nmmt','sub_sql','sub_dieuhanh','sub_baotrimt'],
    3: ['sub_hdlinux','sub_qtmangwin','sub_lapCsharp','sub_pttkht','sub_av3','sub_xdweb'],
    4: ['sub_qtmanglin','sub_anninh','sub_lpmangg','sub_cnkhong','sub_tkxdmang','sub_laptnguon'],
    5: ['sub_iot','sub_qtcloudfw','sub_aotoanbm','sub_xdwebpmm','sub_qldacntt','sub_antoabm'],
    6: ['sub_dotancs'],
  },
  UDPM: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_nmmt','sub_sql','sub_dhua','sub_xdweb'],
    3: ['sub_ud_csdl','sub_ud_csharp','sub_ud_pttkht','sub_lapPHP','sub_av3','sub_ctdlgt'],
    4: ['sub_ud_java','sub_ud_php','sub_ud_xdweb','sub_ud_mobile','sub_cnpm','sub_ud_qlda'],
    5: ['sub_ud_test','sub_ud_atbm','sub_ud_ai','sub_xdpm','sub_qldacntt','sub_qtwebfw'],
    6: ['sub_ud_dotantn'],
  },
  'TKĐH': {
    1: ['sub_ct','sub_pl','sub_av1','sub_hinhhoaco','sub_cstaohinh','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_tahinh2d','sub_coreldraw','sub_pshop'],
    3: ['sub_illustrator','sub_dhoahn','sub_dh3d','sub_tkgdweb','sub_av3','sub_toan'],
    4: ['sub_tkbapbi','sub_tkqbsp','sub_dungvideo','sub_ktchanh','sub_cnpm','sub_dhua'],
    5: ['sub_tkdantrang','sub_tkthieuhi','sub_tk_ai','sub_qldacntt','sub_xdweb','sub_antoabm'],
    6: ['sub_tk_dotantn'],
  },
};

const THEORY_ROOMS   = ['room_a17_401','room_a17_402','room_a17_403','room_a17_404','room_a17_405',
                        'room_a17_406','room_a17_407','room_a17_408','room_a17_409',
                        'room_a17_501a','room_a17_501b','room_a17_502','room_a17_504',
                        'room_c4b_1','room_c4b_2','room_c4b_3','room_c4b_4','room_c4b_5','room_c4b_6'];
const PRACTICE_ROOMS = ['room_pm_301','room_pm_302','room_pm_303','room_pm_304','room_pm_305',
                        'room_pm_306','room_pm_401','room_pm_402','room_pm_403','room_pm_404',
                        'room_pm_405','room_pm_406','room_pm_407','room_pm_408','room_pm_409',
                        'room_b4_301','room_d_303'];

const ALL_DAYS = [2, 3, 4, 5, 6, 7, 8];
const SLOTS    = [[1,3],[4,6],[7,9],[10,12]];

const usedSlots = new Map();
function bookSlot(week, day, ps, roomId) {
  const k = `${day}-${ps}-${roomId}`;
  if (!usedSlots.has(week)) usedSlots.set(week, new Set());
  usedSlots.get(week).add(k);
}
function slotFree(week, day, ps, roomId) {
  return !usedSlots.has(week) || !usedSlots.get(week).has(`${day}-${ps}-${roomId}`);
}
function findSlot(week, roomId, excludeDay) {
  const days  = shuffle(ALL_DAYS.filter(d => d !== excludeDay));
  const slots = shuffle(SLOTS);
  for (const day of days) {
    for (const [ps, pe] of slots) {
      if (slotFree(week, day, ps, roomId)) {
        bookSlot(week, day, ps, roomId);
        return { day, ps, pe };
      }
    }
  }
  return null;
}

const MAJOR_CODE_MAP = { major_ltmt:'LTMT', major_qtm:'QTM', major_udpm:'UDPM', major_tkdh:'TKĐH' };

// ─── MAIN ────────────────────────────────────────────────────────────────────
async function main() {
  // ── 1. Upsert cohort K18 ─────────────────────────────────────────────────────
  console.log('Bước 1: Upsert cohort K18...');
  await prisma.cohort.upsert({
    where: { code: 'K18' },
    update: {},
    create: { id: 'cohort_k18', code: 'K18', year: 2026 },
  });
  console.log('  ✓ cohort_k18');

  // ── 2. Upsert K18 classes ────────────────────────────────────────────────────
  console.log('\nBước 2: Upsert lớp học K18...');
  const cohortK18 = await prisma.cohort.findUnique({ where: { code: 'K18' } });
  let classCount = 0;
  for (const [majorId, classes] of Object.entries(K18_CLASSES)) {
    for (const cls of classes) {
      await prisma.classGroup.upsert({
        where: { id: cls.id },
        update: { code: cls.code, majorId, cohortId: cohortK18.id, studentCount: cls.cnt },
        create: { id: cls.id, code: cls.code, majorId, cohortId: cohortK18.id, studentCount: cls.cnt },
      });
      classCount++;
    }
  }
  console.log(`  ✓ ${classCount} lớp K18`);

  // ── 3. Tạo user accounts cho sinh viên K18 ───────────────────────────────────
  console.log('\nBước 3: Tạo user accounts sinh viên K18...');
  const hash = await bcrypt.hash('Student@123', 10);
  let userCount = 0;
  for (const [majorId, classes] of Object.entries(K18_CLASSES)) {
    for (const cls of classes) {
      const clsRecord = await prisma.classGroup.findUnique({ where: { id: cls.id } });
      if (!clsRecord) continue;
      // Tạo 1 tài khoản đại diện mỗi lớp
      const email = `sv.${cls.code.toLowerCase().replace(/[^a-z0-9]/g, '')}@hactech.edu.vn`;
      const existing = await prisma.user.findUnique({ where: { email } });
      if (!existing) {
        await prisma.user.create({
          data: {
            email,
            passwordHash: hash,
            role: 'STUDENT',
            refId: clsRecord.id,
            name: `Sinh viên ${cls.code}`,
          },
        });
        userCount++;
      }
    }
  }
  console.log(`  ✓ ${userCount} user accounts K18`);

  // ── 4. Lấy dữ liệu cần thiết ─────────────────────────────────────────────────
  console.log('\nBước 4: Load subjects & teachers...');
  const subjects  = await prisma.subject.findMany();
  const subjectMap = Object.fromEntries(subjects.map(s => [s.id, s]));
  const teachers  = await prisma.teacher.findMany();
  const tvCNTT = teachers.filter(t => t.dept === 'CNTT').map(t => t.id);
  const tvTKDH = teachers.filter(t => t.dept === 'TKĐH').map(t => t.id);
  const tvTA   = teachers.filter(t => t.dept === 'TA').map(t => t.id);
  const tvDC   = teachers.filter(t => t.dept === 'DC').map(t => t.id);

  function getTeachersForSubject(subId) {
    if (['sub_av1','sub_av2','sub_av3'].includes(subId)) return tvTA;
    if (['sub_toan','sub_pl','sub_ct','sub_ctxh','sub_knm','sub_gdtc'].includes(subId))
      return tvDC.length > 0 ? tvDC : tvCNTT;
    if (subId.startsWith('sub_hinhhoaco') || subId.startsWith('sub_cstaohinh') ||
        subId.startsWith('sub_tahinh2d')  || subId.startsWith('sub_coreldraw')  ||
        subId.startsWith('sub_pshop')     || subId.startsWith('sub_illustrator')||
        subId.startsWith('sub_dhoahn')    || subId.startsWith('sub_dh3d')       ||
        subId.startsWith('sub_tkgdweb')   || subId.startsWith('sub_tkbapbi')    ||
        subId.startsWith('sub_tkqbsp')    || subId.startsWith('sub_dungvideo')  ||
        subId.startsWith('sub_tkdantrang')|| subId.startsWith('sub_tkthieuhi')  ||
        subId.startsWith('sub_ktchanh')   || subId.startsWith('sub_tk_')) return tvTKDH;
    return tvCNTT;
  }
  console.log(`  ✓ ${subjects.length} subjects, ${teachers.length} teachers`);

  // ── 5. Tạo lịch học K18 (HK1-6) ─────────────────────────────────────────────
  console.log('\nBước 5: Tạo lịch học K18 (tuần 121-240)...');
  const k18Classes = await prisma.classGroup.findMany({
    where: { cohort: { code: 'K18' } },
    include: { major: true, cohort: true },
  });

  let totalSched = 0;
  totalSched += await buildSchedules(k18Classes, ADD_WEEKS.K18, subjectMap, getTeachersForSubject);
  console.log(`  ✓ ${totalSched} schedules K18`);

  // ── 6. Thêm K17 HK5-6 nếu chưa có (năm 2026-2027) ──────────────────────────
  console.log('\nBước 6: Kiểm tra và thêm K17 HK5-6 (tuần 161-200)...');
  const existK17hk5 = await prisma.schedule.count({
    where: {
      weekNumber: { gte: 161, lte: 180 },
      teachingUnit: { assignment: { classGroup: { cohort: { code: 'K17' } } } },
    },
  });
  if (existK17hk5 > 0) {
    console.log(`  ✓ K17 HK5-6 đã có (${existK17hk5} schedules), bỏ qua`);
  } else {
    const k17Classes = await prisma.classGroup.findMany({
      where: { cohort: { code: 'K17' } },
      include: { major: true, cohort: true },
    });
    const k17Sched = await buildSchedules(k17Classes, ADD_WEEKS.K17_hk56, subjectMap, getTeachersForSubject);
    console.log(`  ✓ ${k17Sched} schedules K17 HK5-6`);
    totalSched += k17Sched;
  }

  // ── 7. Flush Redis cache ──────────────────────────────────────────────────────
  console.log('\nBước 7: Flush Redis cache...');
  try {
    const redis = new Redis({ host: 'localhost', port: 6379 });
    const keys = await redis.keys('tkb:cache:*');
    if (keys.length > 0) { await redis.del(...keys); console.log(`  Xóa ${keys.length} cache keys`); }
    else console.log('  Cache trống');
    await redis.quit();
  } catch (e) {
    console.log('  Redis không kết nối được (bỏ qua):', e.message);
  }

  // ── Tổng kết ──────────────────────────────────────────────────────────────────
  const [schCount, wks] = await Promise.all([
    prisma.schedule.count(),
    prisma.schedule.findMany({ select:{ weekNumber:true }, distinct:['weekNumber'], orderBy:{ weekNumber:'asc' } }),
  ]);
  const wNums = wks.map(w => w.weekNumber);
  console.log('\n═══════════════════════════════════════════════');
  console.log('KẾT QUẢ:');
  console.log(`  Lịch học tổng: ${schCount}`);
  console.log(`  Tuần bao phủ:  ${wNums[0]} → ${wNums[wNums.length-1]}  (${wNums.length} tuần)`);
  console.log('═══════════════════════════════════════════════');
}

// ─── Build schedules helper ──────────────────────────────────────────────────
async function buildSchedules(classes, semWeeks, subjectMap, getTeachers) {
  let total = 0;
  for (const cls of classes) {
    const cohortCode = cls.cohort.code;
    const majorCode  = MAJOR_CODE_MAP[cls.majorId];
    const ctdt       = CTDT[majorCode];
    const shortId    = cls.id.replace('cls_', '');
    if (!ctdt) continue;

    for (const [semNoStr, [wStart, wEnd]] of Object.entries(semWeeks)) {
      const semNo = parseInt(semNoStr);
      const subIds = ctdt[semNo] || [];
      if (!subIds.length) continue;

      const asnRows = [], tuRows = [], schRows = [];

      for (const subId of subIds) {
        const sub = subjectMap[subId];
        if (!sub) continue;

        const pool      = getTeachers(subId);
        if (!pool.length) continue;
        const teacherId = pick(pool);
        const asnId = `asn_${subId.replace('sub_','')}_${shortId}_hk${semNo}`;
        const tuId  = `tu_${subId.replace('sub_','')}_${shortId}_hk${semNo}`;

        asnRows.push({ id: asnId, teacherId, classGroupId: cls.id });
        tuRows.push({
          id: tuId,
          subjectId: subId,
          assignmentId: asnId,
          type: sub.isPractice ? 'PRACTICE' : 'THEORY',
          name: `${sub.code}-${cls.code}-HK${semNo}`,
        });

        const rooms = sub.isPractice ? PRACTICE_ROOMS : THEORY_ROOMS;
        for (let w = wStart; w <= wEnd; w++) {
          const roomId1 = pick(rooms);
          const slot1 = findSlot(w, roomId1, null);
          if (slot1) {
            schRows.push({
              id: `sch_${subId.replace('sub_','')}_${shortId}_w${w}_a`,
              teachingUnitId: tuId,
              roomId: roomId1,
              dayOfWeek: slot1.day,
              periodStart: slot1.ps,
              periodEnd: slot1.pe,
              weekNumber: w,
              mode: 'OFFLINE',
            });
          }
          const roomId2 = pick(rooms);
          const slot2 = findSlot(w, roomId2, slot1?.day ?? null);
          if (slot2) {
            schRows.push({
              id: `sch_${subId.replace('sub_','')}_${shortId}_w${w}_b`,
              teachingUnitId: tuId,
              roomId: roomId2,
              dayOfWeek: slot2.day,
              periodStart: slot2.ps,
              periodEnd: slot2.pe,
              weekNumber: w,
              mode: 'OFFLINE',
            });
          }
        }
      }

      if (asnRows.length) await prisma.assignment.createMany({ data: asnRows, skipDuplicates: true });
      if (tuRows.length)  await prisma.teachingUnit.createMany({ data: tuRows, skipDuplicates: true });
      if (schRows.length) {
        await prisma.schedule.createMany({ data: schRows, skipDuplicates: true });
        total += schRows.length;
      }
    }
    process.stdout.write('.');
  }
  console.log();
  return total;
}

main()
  .catch(e => { console.error('Lỗi:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
