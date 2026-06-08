/**
 * seed_teachers.js
 * Tạo 18 giảng viên mới với tài khoản user, phân theo chuyên môn.
 * Mỗi giảng viên được ghi nhận dạy 3-5 môn liên quan
 * (thông tin lưu trong field dept + unavailableSlots comment).
 *
 * Phân nhóm chuyên môn:
 *  - Nhóm LT: Lập trình (LTMT / UDPM)
 *  - Nhóm QT: Quản trị mạng (QTM)
 *  - Nhóm TK: Thiết kế đồ họa (TKĐH)
 *  - Nhóm DC: Đại cương / Kỹ năng chung
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

// ─── Dữ liệu giảng viên mới ──────────────────────────────────────────────────
// subjects: mảng subjectId mà GV đảm nhiệm (3-5 môn liên quan)
const NEW_TEACHERS = [
  // ── Nhóm Lập trình căn bản & Hướng đối tượng ─────────────────────────────
  {
    id: 'gv_phuong_lt', code: 'GV018', name: 'Nguyễn Thị Phương',
    email: 'phuong.lt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh11', 'sub_lt_mh17', 'sub_lt_mh20', 'sub_lt_mh21'],
    // Lập trình căn bản, Kỹ thuật lập trình, LT HĐT, Lập trình C#
  },
  {
    id: 'gv_duc_lt', code: 'GV019', name: 'Trần Văn Đức',
    email: 'duc.lt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh18', 'sub_lt_mh19', 'sub_lt_mh25', 'sub_lt_mh26'],
    // LT HĐT (QTM), Cấu trúc DL & giải thuật, LT Service, Nhập môn CNPM
  },
  {
    id: 'gv_nam_lt', code: 'GV020', name: 'Lê Hoài Nam',
    email: 'nam.lt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_lt_mh32', 'sub_lt_mh33', 'sub_lt_mh35', 'sub_lt_mh36'],
    // Lập trình PHP.NET, LT thiết bị di động, XD phần mềm quản lý, LT XML
  },
  {
    id: 'gv_linh_lt', code: 'GV021', name: 'Phạm Thị Linh',
    email: 'linh.lt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_lt_mh27', 'sub_lt_mh28', 'sub_ud_mh26', 'sub_ud_mh20'],
    // Phân tích TK hệ thống, TK Website (LTMT), Lập trình Web, HTML5
  },
  {
    id: 'gv_khoa_lt', code: 'GV022', name: 'Vũ Minh Khoa',
    email: 'khoa.lt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_lt_mh18', 'sub_lt_mh24', 'sub_mh17', 'sub_mh19'],
    // HQT CSDL M.Access, HQT SQL (LTMT), Cơ sở DL, Cấu trúc DL & GT
  },

  // ── Nhóm Quản trị mạng ────────────────────────────────────────────────────
  {
    id: 'gv_tuan_qt', code: 'GV023', name: 'Hoàng Anh Tuấn',
    email: 'tuan.qt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh13', 'sub_mh21', 'sub_mh25', 'sub_mh33'],
    // Nhập môn mạng MT, QT mạng Windows, LT mạng, QT mạng Linux
  },
  {
    id: 'gv_hung_qt', code: 'GV024', name: 'Đặng Quốc Hưng',
    email: 'hung.qt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh26', 'sub_mh28', 'sub_mh30', 'sub_mh34'],
    // QT WebServer & MailServer, HĐH Linux, Tường lửa, Bảo trì hệ thống mạng
  },
  {
    id: 'gv_son_qt', code: 'GV025', name: 'Ngô Văn Sơn',
    email: 'son.qt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh35', 'sub_mh36', 'sub_mh37', 'sub_mh14'],
    // An toàn mạng, TK xây dựng mạng LAN, Kỹ thuật truyền số liệu, Mạng không dây
  },
  {
    id: 'gv_bao_qt', code: 'GV026', name: 'Lý Thanh Bảo',
    email: 'bao.qt@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_mh12', 'sub_mh15', 'sub_mh10', 'sub_mh24'],
    // Cài đặt & bảo trì máy tính, Kỹ thuật điện tử, Cấu trúc máy tính, HQT CSDL SQL
  },

  // ── Nhóm Ứng dụng phần mềm ───────────────────────────────────────────────
  {
    id: 'gv_mai_ud', code: 'GV027', name: 'Trần Thị Mai',
    email: 'mai.ud@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_ud_mh16', 'sub_ud_mh18', 'sub_ud_mh24', 'sub_ud_mh19'],
    // Cơ sở DL (UDPM), HQT M.Access, HQT SQL Server, Cấu trúc DL & GT
  },
  {
    id: 'gv_tung_ud', code: 'GV028', name: 'Bùi Công Tùng',
    email: 'tung.ud@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_ud_mh27', 'sub_ud_mh34', 'sub_ud_mh35', 'sub_mh27'],
    // Phân tích TK (UDPM), QL dự án CNTT, Tổ chức QL doanh nghiệp, Phân tích TK HT
  },
  {
    id: 'gv_huong_ud', code: 'GV029', name: 'Đinh Thị Hương',
    email: 'huong.ud@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_ud_mh17', 'sub_ud_mh28', 'sub_ud_mh32', 'sub_ud_mh33'],
    // QT mạng Windows (UDPM), HĐH Linux, An toàn bảo mật, XD Website PMMNM
  },
  {
    id: 'gv_dat_ud', code: 'GV030', name: 'Nguyễn Trọng Đạt',
    email: 'dat.ud@hactech.edu.vn', dept: 'CNTT',
    subjects: ['sub_ud_mh36', 'sub_ud_mh37', 'sub_ud_mh23', 'sub_ud_mh25'],
    // XD phần mềm quản lý, TK trình diễn, Xử lý ảnh, TK đồ họa Corel Draw
  },

  // ── Nhóm Thiết kế đồ họa ─────────────────────────────────────────────────
  {
    id: 'gv_lan_tk', code: 'GV031', name: 'Hoàng Thị Lan',
    email: 'lan.tk@hactech.edu.vn', dept: 'TKĐH',
    subjects: ['sub_tk_mh12', 'sub_tk_mh13', 'sub_tk_mh18', 'sub_tk_mh21'],
    // Hình họa cơ bản, Lịch sử mỹ thuật, TK đồ họa cơ bản, Cơ sở tạo hình mặt phẳng
  },
  {
    id: 'gv_thu_tk', code: 'GV032', name: 'Phạm Thu Thảo',
    email: 'thu.tk@hactech.edu.vn', dept: 'TKĐH',
    subjects: ['sub_tk_mh14', 'sub_tk_mh20', 'sub_tk_mh22', 'sub_tk_mh33'],
    // Corel Draw, Corel Draw nâng cao, Tạo hình 2D Illustrator, TK đồ họa tổng hợp
  },
  {
    id: 'gv_cuong_tk', code: 'GV033', name: 'Vũ Đức Cường',
    email: 'cuong.tk@hactech.edu.vn', dept: 'TKĐH',
    subjects: ['sub_tk_mh25', 'sub_tk_mh26', 'sub_tk_mh36', 'sub_tk_mh28'],
    // TK đồ họa CN công thương, Chế bản điện tử, TK đồ họa CN văn hóa, Xử lý ảnh
  },
  {
    id: 'gv_hien_tk', code: 'GV034', name: 'Lê Thị Hiền',
    email: 'hien.tk@hactech.edu.vn', dept: 'TKĐH',
    subjects: ['sub_tk_mh27', 'sub_tk_mh29', 'sub_tk_mh32', 'sub_tk_mh34', 'sub_tk_mh35'],
    // TK Website (TKĐH), Cơ sở tạo hình khối KG, Thiết bị ngoại vi, Dựng Video, Flash
  },

  // ── Nhóm Đại cương / Kỹ năng chung ──────────────────────────────────────
  {
    id: 'gv_oanh_dc', code: 'GV035', name: 'Nguyễn Thị Oanh',
    email: 'oanh.dc@hactech.edu.vn', dept: 'DC',
    subjects: ['sub_mh01', 'sub_mh02', 'sub_mh31', 'sub_ud_mh31'],
    // Chính trị, Pháp luật, Kỹ năng mềm (QTM), Kỹ năng mềm (UDPM)
  },
  {
    id: 'gv_thanh_dc', code: 'GV036', name: 'Trần Minh Thành',
    email: 'thanh.dc@hactech.edu.vn', dept: 'DC',
    subjects: ['sub_mh03', 'sub_mh04', 'sub_mh09', 'sub_ud_mh09'],
    // Toán cao cấp, Tin học căn bản, Tin học VP (QTM), Soạn thảo VB (UDPM)
  },
];

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🚀 Tạo giảng viên mới...\n');

  const teacherHash = await bcrypt.hash('Teacher@123', 10);

  // Lấy user hiện có để tránh trùng email
  const existingUsers = await prisma.user.findMany({ select: { email: true } });
  const existingEmails = new Set(existingUsers.map(u => u.email));

  let created = 0, skipped = 0;

  for (const gv of NEW_TEACHERS) {
    // Upsert teacher
    const existing = await prisma.teacher.findUnique({ where: { id: gv.id } });
    if (existing) {
      console.log(`  ⏭  Bỏ qua (đã có): ${gv.code} ${gv.name}`);
      skipped++;
      continue;
    }

    await prisma.teacher.create({
      data: {
        id: gv.id,
        code: gv.code,
        name: gv.name,
        email: gv.email,
        dept: gv.dept,
        unavailableSlots: [],
      },
    });

    // Tạo user account nếu chưa có
    if (!existingEmails.has(gv.email)) {
      const userId = `usr_${gv.id}`;
      await prisma.user.create({
        data: {
          id: userId,
          email: gv.email,
          passwordHash: teacherHash,
          role: 'TEACHER',
          refId: gv.id,
          name: gv.name,
        },
      });
      existingEmails.add(gv.email);
    }

    const subList = gv.subjects.join(', ');
    console.log(`  ✅ ${gv.code} ${gv.name} (${gv.dept}) — ${gv.subjects.length} môn`);
    created++;
  }

  console.log(`\n✅ Tạo mới: ${created} | Bỏ qua: ${skipped}`);

  // In bảng phân công tóm tắt
  console.log('\n📋 Phân công giảng viên — môn học:');
  const allTeachers = await prisma.teacher.findMany({
    where: { id: { in: NEW_TEACHERS.map(t => t.id) } },
    select: { code: true, name: true, dept: true },
    orderBy: { code: 'asc' },
  });
  for (const t of allTeachers) {
    const gvData = NEW_TEACHERS.find(g => g.code === t.code);
    if (!gvData) continue;
    // Resolve subject names
    const subs = await prisma.subject.findMany({
      where: { id: { in: gvData.subjects } },
      select: { code: true, name: true },
    });
    const subNames = subs.map(s => `${s.code}: ${s.name}`).join('\n           ');
    console.log(`  ${t.code} ${t.name} [${t.dept}]:\n           ${subNames}`);
  }

  console.log('\n🔑 Đăng nhập: <email> / Teacher@123');
}

main()
  .catch(e => { console.error('❌ Lỗi:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
