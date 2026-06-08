/**
 * fix_student_ids.js
 * Sửa email + id sinh viên để MSSV khớp với khóa học:
 *   K15 (nhập 2023) → CDxxxxxxxx bắt đầu bằng 23
 *   K16 (nhập 2024) → CDxxxxxxxx bắt đầu bằng 24
 *   K17 (nhập 2025) → CDxxxxxxxx bắt đầu bằng 25
 *
 * Logic:
 *   - Lấy số hiện tại trong email (vd "22xxxx") → giữ 4 chữ số cuối
 *   - Ghép năm nhập học mới: "23" + 4 chữ số → "23xxxx"
 *   - Email mới: name.23xxxx@student.hactech.edu.vn
 *   - id mới: usr_sv_cd23xxxx
 *   - name field trong users: giữ nguyên
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const COHORT_YEAR = { K15: '23', K16: '24', K17: '25' };

async function main() {
  // Lấy tất cả sinh viên kèm cohort code
  const rows = await prisma.$queryRawUnsafe(`
    SELECT u.id, u.email, u.name, co.code as cohort_code
    FROM users u
    JOIN class_groups cg ON cg.id = u."refId"
    JOIN cohorts co ON co.id = cg."cohortId"
    WHERE u.role = 'STUDENT'
    ORDER BY co.code, u.email
  `);

  console.log(`Tổng sinh viên: ${rows.length}`);

  // Theo dõi email mới để xử lý trùng
  const usedEmails = new Set();
  const usedIds    = new Set();

  // Trước: thu thập toàn bộ email/id hiện tại để không bị conflict khi update
  const existingEmails = new Set(rows.map(r => r.email));
  const existingIds    = new Set(rows.map(r => r.id));

  let updated = 0;
  let skipped = 0;

  for (const row of rows) {
    const yearPrefix = COHORT_YEAR[row.cohort_code];
    if (!yearPrefix) {
      console.warn(`  Bỏ qua: không có mapping cho ${row.cohort_code}`);
      skipped++;
      continue;
    }

    // Tách prefix tên từ email: "lam.221004@..." → "lam", "221004"
    const emailLocal = row.email.split('@')[0]; // "lam.221004"
    const parts = emailLocal.split('.');
    const namePart = parts[0];
    const numPart  = parts[1] ?? '0000';

    // Lấy 4 chữ số cuối của số hiện tại
    const last4 = numPart.slice(-4).padStart(4, '0');
    const newNum = yearPrefix + last4; // "23" + "1004" = "231004"

    // Email mới
    let newEmail = `${namePart}.${newNum}@student.hactech.edu.vn`;
    // Xử lý trùng email
    let suffix = 1;
    while (usedEmails.has(newEmail) || (existingEmails.has(newEmail) && newEmail !== row.email)) {
      newEmail = `${namePart}${suffix}.${newNum}@student.hactech.edu.vn`;
      suffix++;
    }
    usedEmails.add(newEmail);

    // Id mới: usr_sv_cd + newNum
    let newId = `usr_sv_cd${newNum}`;
    let idSuffix = 1;
    while (usedIds.has(newId) || (existingIds.has(newId) && newId !== row.id)) {
      newId = `usr_sv_cd${newNum}_${idSuffix}`;
      idSuffix++;
    }
    usedIds.add(newId);

    // Bỏ qua nếu không thay đổi
    if (newEmail === row.email && newId === row.id) {
      skipped++;
      continue;
    }

    // Update: id là primary key, cần dùng raw SQL để đổi cả id
    await prisma.$executeRawUnsafe(
      `UPDATE users SET id = $1, email = $2 WHERE id = $3`,
      newId, newEmail, row.id
    );
    updated++;

    if (updated % 100 === 0) {
      process.stdout.write(`\r  Đã xử lý: ${updated + skipped}/${rows.length}`);
    }
  }

  console.log(`\n✅ Đã cập nhật: ${updated}`);
  console.log(`⏭  Bỏ qua (không đổi): ${skipped}`);
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
