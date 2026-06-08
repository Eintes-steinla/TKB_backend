/**
 * fix_names.js
 * - teachers table + users(TEACHER): xóa "Thầy"/"Cô" tiền tố, thêm họ đầy đủ
 * - users(STUDENT): tên đầy đủ họ tên tiếng Việt có dấu
 * - users(ADMIN): tên thực
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// ── Tên đầy đủ cho từng giáo viên (theo id) ─────────────────────────────────
const TEACHER_FULL_NAMES = {
  gv_cuong:       'Nguyễn Văn Cường',
  gv_binh_cuong:  'Trần Thị Bích',
  gv_han:         'Phạm Thị Hân',
  gv_muoi:        'Lê Thị Mười Phương',
  gv_trung:       'Nguyễn Văn Trung',
  gv_tung_ct:     'Hoàng Công Tùng',
  gv_tung_ng:     'Nguyễn Anh Tùng',
  gv_hoa:         'Vũ Thị Hoa',
  gv_uy:          'Đặng Văn Uy',
  gv_toan:        'Bùi Quốc Toàn',
  gv_loi_lt:      'Trương Văn Lợi',
  gv_quoc_tuan:   'Lý Quốc Tuấn',
  gv_ho_tung:     'Hồ Minh Tùng',
  gv_van_pt:      'Phan Thị Vân',
  gv_linh_cq:     'Ngô Thị Linh',
  gv_thanh_tung:  'Đinh Thanh Tùng',
  gv_quoc:        'Đỗ Minh Quốc',
  gv_huyen:       'Trần Thị Huyền',
  gv_ninh_ha:     'Lê Ninh Hà',
  gv_quynh_anh:   'Phạm Quỳnh Anh',
  gv_anh_tkdh:    'Nguyễn Thị Ánh',
  gv_nhung:       'Hoàng Thị Nhung',
  gv_trang:       'Vũ Thị Trang',
  gv_quang_tkdh:  'Đặng Minh Quang',
  gv_thanh_tkdh:  'Trần Văn Thành',
  gv_loi_tkdh:    'Bùi Đức Lợi',
  // Các giáo viên khác từ seed_bulk (nếu có trong DB)
  gv_phuong_dt:   'Nguyễn Thị Phương',
  gv_tien_dt:     'Lê Văn Tiến',
  gv_huong_dt:    'Phạm Thị Hương',
  gv_long_dt:     'Trần Thanh Long',
  gv_thinh:       'Đỗ Văn Thịnh',
  gv_duc_md:      'Hoàng Đức Minh',
  gv_liên_dcn:    'Nguyễn Thị Liên',
  gv_long_dcn:    'Vũ Văn Long',
  gv_sang:        'Lý Văn Sáng',
  gv_mui:         'Trương Văn Mùi',
  gv_sy:          'Đinh Văn Sỹ',
  gv_tuyen:       'Bùi Thị Tuyền',
  gv_cuong_tg:    'Ngô Văn Cường',
  gv_huong_ck:    'Đặng Thị Hương',
  gv_lam:         'Hồ Văn Lâm',
  gv_tien_dung:   'Phan Tiến Dũng',
  gv_thang:       'Lê Văn Thắng',
  gv_binh_oto:    'Nguyễn Văn Bình',
  gv_thanh_ct:    'Trần Thị Thanh',
  gv_ngoc:        'Phạm Thị Ngọc',
  gv_lan_ct:      'Vũ Thị Lan',
  gv_dung_toan:   'Đỗ Xuân Dũng',
  gv_sam:         'Hoàng Văn Sâm',
  gv_thao:        'Lê Thị Thảo',
};

// ── Tên đầy đủ cho admin ────────────────────────────────────────────────────
const ADMIN_NAMES = {
  'admin@hactech.edu.vn':        'Quản Trị Viên',
  'phongdaotao@hactech.edu.vn':  'Phòng Đào Tạo',
};

// ── Helpers sinh viên ───────────────────────────────────────────────────────
const HO = ['Nguyễn','Trần','Lê','Phạm','Hoàng','Huỳnh','Phan','Vũ','Võ','Đặng',
            'Bùi','Đỗ','Hồ','Ngô','Dương','Lý','Đinh','Tô','Trương','Đoàn'];
const TEN_NAM = ['Minh','Hùng','Tuấn','Dũng','Đức','Long','Thành','Nam','Quân','Hải',
                 'Khoa','Phúc','Bảo','Tâm','Thiện','Nhân','Khánh','Hiếu','Quang','Trung',
                 'Vũ','Đạt','Lâm','Sơn','Tài','Tín','Vinh','Cường','Hưng','Phong'];
const TEN_NU  = ['Linh','Hương','Trang','Lan','Mai','Ngọc','Thảo','Hà','Yến','Ánh',
                 'Nhung','Oanh','Diệu','Trinh','Châu','Quỳnh','Nhi','Thy','Phương','Trâm',
                 'Hân','Ngân','Tiên','Vân','Dung','Thùy','Khánh','Bích','Thư','Xuân'];
const DEM_NAM = ['Văn','Đức','Xuân','Công','Minh','Thanh','Quốc','Hữu','Bá','Gia'];
const DEM_NU  = ['Thị','Ngọc','Minh','Thu','Thanh','Bích','Hoài','Diễm','Như','Phương'];

function rng(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[rng(0, arr.length - 1)]; }

// Tạo tên đầy đủ dựa theo phần tên cuối trong email (để khớp giới tính/tên nếu có thể)
const FEMALE_NAMES = new Set([...TEN_NU, ...DEM_NU.filter(d => d !== 'Minh' && d !== 'Thanh')]);

function randomFullName(firstNameHint) {
  // Đoán giới tính từ tên trong email (hint là firstName không dấu)
  // Thử match với TEN_NU (đã bỏ dấu)
  const femaleHints = ['linh','huong','trang','lan','mai','ngoc','thao','ha','yen','anh',
                        'nhung','oanh','dieu','trinh','chau','quynh','nhi','thy','phuong','tram',
                        'han','ngan','tien','van','dung','thuy','khanh','bich','thu','xuan',
                        'thi','thanh'];
  const isFemale = femaleHints.includes(firstNameHint.toLowerCase());
  const ho = pick(HO);
  const dem = isFemale ? pick(DEM_NU) : pick(DEM_NAM);
  const ten = isFemale ? pick(TEN_NU) : pick(TEN_NAM);
  return `${ho} ${dem} ${ten}`;
}

async function main() {
  // ── 1. Cập nhật teachers table ───────────────────────────────────────────
  const teachers = await prisma.teacher.findMany({ select: { id: true, name: true } });
  let teacherTableUpdated = 0;
  for (const t of teachers) {
    const newName = TEACHER_FULL_NAMES[t.id];
    if (newName && newName !== t.name) {
      await prisma.teacher.update({ where: { id: t.id }, data: { name: newName } });
      teacherTableUpdated++;
    } else if (!newName) {
      // Fallback: xóa tiền tố Thầy/Cô nếu không có trong map
      const stripped = t.name.replace(/^(Thầy|Cô)\s+/u, '');
      if (stripped !== t.name) {
        await prisma.teacher.update({ where: { id: t.id }, data: { name: stripped } });
        teacherTableUpdated++;
      }
    }
  }
  console.log(`✅ teachers table: ${teacherTableUpdated}/${teachers.length} updated`);

  // ── 2. Cập nhật users(TEACHER) ────────────────────────────────────────────
  const teacherUsers = await prisma.user.findMany({
    where: { role: 'TEACHER', refId: { not: null } },
    select: { id: true, refId: true },
  });
  let teacherUsersUpdated = 0;
  for (const u of teacherUsers) {
    const newName = TEACHER_FULL_NAMES[u.refId];
    if (newName) {
      await prisma.user.update({ where: { id: u.id }, data: { name: newName } });
      teacherUsersUpdated++;
    } else {
      // Lấy từ teachers table (đã cập nhật ở bước trên)
      const t = await prisma.teacher.findUnique({ where: { id: u.refId }, select: { name: true } });
      if (t?.name) {
        await prisma.user.update({ where: { id: u.id }, data: { name: t.name } });
        teacherUsersUpdated++;
      }
    }
  }
  console.log(`✅ users(TEACHER): ${teacherUsersUpdated}/${teacherUsers.length} updated`);

  // ── 3. Cập nhật users(STUDENT) — tên đầy đủ ─────────────────────────────
  const students = await prisma.user.findMany({
    where: { role: 'STUDENT' },
    select: { id: true, email: true },
  });

  const BATCH = 100;
  let studentUpdated = 0;
  for (let i = 0; i < students.length; i += BATCH) {
    const chunk = students.slice(i, i + BATCH);
    await Promise.all(chunk.map(u => {
      const prefix = u.email.split('@')[0];     // "minh.231234"
      const firstNameHint = prefix.split('.')[0]; // "minh"
      const fullName = randomFullName(firstNameHint);
      return prisma.user.update({ where: { id: u.id }, data: { name: fullName } });
    }));
    studentUpdated += chunk.length;
    process.stdout.write(`\r  Sinh viên: ${studentUpdated}/${students.length}`);
  }
  console.log(`\n✅ users(STUDENT): ${studentUpdated}/${students.length} updated`);

  // ── 4. Cập nhật users(ADMIN) ─────────────────────────────────────────────
  const admins = await prisma.user.findMany({
    where: { role: 'ADMIN' },
    select: { id: true, email: true },
  });
  let adminUpdated = 0;
  for (const u of admins) {
    const newName = ADMIN_NAMES[u.email];
    if (newName) {
      await prisma.user.update({ where: { id: u.id }, data: { name: newName } });
      adminUpdated++;
    }
  }
  console.log(`✅ users(ADMIN): ${adminUpdated}/${admins.length} updated`);
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
