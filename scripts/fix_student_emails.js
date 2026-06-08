/**
 * fix_student_emails.js
 * Cập nhật email sinh viên: prefix = từ cuối tên đầy đủ, bỏ dấu, lowercase
 * VD: "Nguyễn Thị Nhài" → "nhai.231322@student.hactech.edu.vn"
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const DIACRITIC_MAP = {
  'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ằ':'a','ắ':'a','ẳ':'a','ẵ':'a','ặ':'a',
  'â':'a','ầ':'a','ấ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d','è':'e','é':'e','ẻ':'e','ẽ':'e',
  'ẹ':'e','ê':'e','ề':'e','ế':'e','ể':'e','ễ':'e','ệ':'e','ì':'i','í':'i','ỉ':'i','ĩ':'i',
  'ị':'i','ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ồ':'o','ố':'o','ổ':'o','ỗ':'o',
  'ộ':'o','ơ':'o','ờ':'o','ớ':'o','ở':'o','ỡ':'o','ợ':'o','ù':'u','ú':'u','ủ':'u','ũ':'u',
  'ụ':'u','ư':'u','ừ':'u','ứ':'u','ử':'u','ữ':'u','ự':'u','ỳ':'y','ý':'y','ỷ':'y','ỹ':'y','ỵ':'y',
};

function removeDiacritics(str) {
  return str.split('').map(c => DIACRITIC_MAP[c.toLowerCase()] || c.toLowerCase()).join('');
}

// Lấy từ cuối cùng trong tên (chữ tên, không phải họ/đệm)
function lastWordNoDiacritics(fullName) {
  const parts = fullName.trim().split(/\s+/);
  return removeDiacritics(parts[parts.length - 1]);
}

async function main() {
  const students = await prisma.user.findMany({
    where: { role: 'STUDENT' },
    select: { id: true, email: true, name: true },
  });

  console.log(`Cập nhật email cho ${students.length} sinh viên...`);

  // Build set email đang dùng (để tránh trùng)
  const usedEmails = new Set(
    (await prisma.user.findMany({ select: { email: true } })).map(u => u.email)
  );

  let updated = 0;
  let skipped = 0;
  const BATCH = 50;

  for (let i = 0; i < students.length; i += BATCH) {
    const chunk = students.slice(i, i + BATCH);

    await Promise.all(chunk.map(async u => {
      // Tách mã số từ email cũ: "vinh.221004@..." → "221004"
      const emailLocal = u.email.split('@')[0];         // "vinh.221004"
      const parts = emailLocal.split('.');
      const numPart = parts[parts.length - 1];          // "221004"

      // Tạo prefix mới từ tên đầy đủ
      const newPrefix = lastWordNoDiacritics(u.name);   // "lam" (từ "Võ Bá Lâm")
      let newEmail = `${newPrefix}.${numPart}@student.hactech.edu.vn`;

      // Xử lý trùng email
      if (newEmail !== u.email) {
        usedEmails.delete(u.email); // bỏ email cũ khỏi set trước khi check
        let suffix = 1;
        while (usedEmails.has(newEmail)) {
          newEmail = `${newPrefix}${suffix}.${numPart}@student.hactech.edu.vn`;
          suffix++;
        }
        usedEmails.add(newEmail);
        await prisma.user.update({ where: { id: u.id }, data: { email: newEmail } });
        updated++;
      } else {
        usedEmails.add(u.email);
        skipped++;
      }
    }));

    process.stdout.write(`\r  ${i + chunk.length}/${students.length}`);
  }

  console.log(`\n✅ Cập nhật: ${updated}, Bỏ qua (không đổi): ${skipped}`);

  // Verify mẫu
  const sample = await prisma.user.findMany({
    where: { role: 'STUDENT' }, take: 6, select: { email: true, name: true },
  });
  console.log('\nMẫu kiểm tra:');
  sample.forEach(u => console.log(`  ${u.name.padEnd(25)} → ${u.email}`));
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
