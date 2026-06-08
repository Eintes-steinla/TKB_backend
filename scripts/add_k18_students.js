/**
 * add_k18_students.js
 *
 * Thay thế 18 tài khoản placeholder K18 (1/lớp) bằng tài khoản sinh viên đầy đủ:
 *   - Tên tiếng Việt thật, mã SV CD25xxxx
 *   - Email: ten.mssv@student.hactech.edu.vn
 *   - refId → classGroup.id (liên kết đúng)
 *   - ~studentCount tài khoản / lớp
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const Redis = require('ioredis');

const prisma = new PrismaClient();

// ─── Helpers ────────────────────────────────────────────────────────────────
function rng(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[rng(0, arr.length - 1)]; }

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

function randomViName() {
  const isFemale = Math.random() < 0.45;
  const ho = pick(HO);
  const dem = isFemale ? pick(DEM_NU) : pick(DEM_NAM);
  const ten = isFemale ? pick(TEN_NU) : pick(TEN_NAM);
  return `${ho} ${dem} ${ten}`;
}

function nameToLogin(fullName) {
  const parts = fullName.split(' ');
  return removeDiacritics(parts[parts.length - 1]).toLowerCase();
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

const usedCodes = new Set();
function genStudentCode() {
  // K18 nhập học 2026 → CD26xxxx
  let code;
  do {
    code = `CD26${rng(1000, 9999)}`;
  } while (usedCodes.has(code));
  usedCodes.add(code);
  return code;
}

// ─── MAIN ────────────────────────────────────────────────────────────────────
async function main() {
  // Load all existing emails to avoid duplicates
  const existingEmailRows = await prisma.user.findMany({ select: { email: true } });
  const existingEmails = new Set(existingEmailRows.map(u => u.email));

  // ── 1. Không cần xóa — placeholder đã xóa ở lần chạy trước ─────────────────
  console.log('Bước 1: Bỏ qua (placeholder đã xóa trước đó)');

  // ── 2. Load K18 classes ────────────────────────────────────────────────────
  console.log('\nBước 2: Load lớp K18...');
  const k18Classes = await prisma.classGroup.findMany({
    where: { cohort: { code: 'K18' } },
    orderBy: { id: 'asc' },
  });
  console.log(`  ✓ ${k18Classes.length} lớp K18`);

  // ── 3. Tạo student accounts ───────────────────────────────────────────────
  console.log('\nBước 3: Tạo tài khoản sinh viên K18...');
  const studentHash = await bcrypt.hash('Student@123', 10);
  let totalCreated = 0;

  for (const cls of k18Classes) {
    const existing = await prisma.user.count({ where: { role: 'STUDENT', refId: cls.id } });
    const count = cls.studentCount - existing;
    if (count <= 0) { console.log(`  ✓ ${cls.code}: đủ (${existing})`); continue; }
    console.log(`  👥 ${cls.code}: thêm ${count} sinh viên (hiện có ${existing})...`);
    const usersToCreate = [];

    for (let i = 0; i < count; i++) {
      const name = randomViName();
      const svCode = genStudentCode();
      const loginName = nameToLogin(name);
      let email = `${loginName}.${svCode.replace('CD', '')}@student.hactech.edu.vn`;
      let suffix = 1;
      while (existingEmails.has(email)) {
        email = `${loginName}${suffix}.${svCode.replace('CD', '')}@student.hactech.edu.vn`;
        suffix++;
      }
      existingEmails.add(email);

      usersToCreate.push({
        email,
        passwordHash: studentHash,
        role: 'STUDENT',
        refId: cls.id,
        name,
      });
    }

    await prisma.user.createMany({ data: usersToCreate, skipDuplicates: true });
    totalCreated += usersToCreate.length;
  }
  console.log(`\n  ✓ Tổng cộng: ${totalCreated} tài khoản sinh viên K18`);

  // ── 4. Flush Redis cache ──────────────────────────────────────────────────
  console.log('\nBước 4: Flush Redis cache...');
  try {
    const redis = new Redis({ host: 'localhost', port: 6379 });
    const keys = await redis.keys('tkb:cache:*');
    if (keys.length > 0) { await redis.del(...keys); console.log(`  Xóa ${keys.length} cache keys`); }
    else console.log('  Cache trống');
    await redis.quit();
  } catch (e) {
    console.log('  Redis không kết nối được (bỏ qua):', e.message);
  }

  // ── Tổng kết ─────────────────────────────────────────────────────────────
  const totalStudents = await prisma.user.count({ where: { role: 'STUDENT' } });
  const k18count = await prisma.user.count({
    where: { role: 'STUDENT', refId: { in: k18Classes.map(c => c.id) } },
  });
  console.log('\n═══════════════════════════════════════════════');
  console.log('KẾT QUẢ:');
  console.log(`  Sinh viên K18: ${k18count}`);
  console.log(`  Tổng sinh viên: ${totalStudents}`);
  console.log('═══════════════════════════════════════════════');
}

main()
  .catch(e => { console.error('Lỗi:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
