/**
 * populate_user_names.js
 * Cập nhật cột name trong bảng users:
 *   TEACHER → lấy từ teachers.name qua refId
 *   STUDENT → capitalize first part of email prefix (vì tên đầy đủ không có trong DB)
 *   ADMIN   → capitalize email prefix
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // ── TEACHER ──────────────────────────────────────────────────────────────────
  const teachers = await prisma.user.findMany({
    where: { role: 'TEACHER', refId: { not: null } },
    select: { id: true, refId: true },
  });

  let teacherUpdated = 0;
  for (const u of teachers) {
    const teacher = await prisma.teacher.findUnique({ where: { id: u.refId }, select: { name: true } });
    if (teacher?.name) {
      await prisma.user.update({ where: { id: u.id }, data: { name: teacher.name } });
      teacherUpdated++;
    }
  }
  console.log(`✅ TEACHER: ${teacherUpdated}/${teachers.length} updated`);

  // ── STUDENT ───────────────────────────────────────────────────────────────────
  const students = await prisma.user.findMany({
    where: { role: 'STUDENT' },
    select: { id: true, email: true },
  });

  let studentUpdated = 0;
  for (const u of students) {
    const prefix = u.email.split('@')[0];      // "minh.231234"
    const firstName = prefix.split('.')[0];    // "minh"
    const name = firstName.charAt(0).toUpperCase() + firstName.slice(1);
    await prisma.user.update({ where: { id: u.id }, data: { name } });
    studentUpdated++;
  }
  console.log(`✅ STUDENT: ${studentUpdated}/${students.length} updated`);

  // ── ADMIN ─────────────────────────────────────────────────────────────────────
  const admins = await prisma.user.findMany({
    where: { role: 'ADMIN' },
    select: { id: true, email: true },
  });

  let adminUpdated = 0;
  for (const u of admins) {
    const prefix = u.email.split('@')[0];
    const name = prefix.charAt(0).toUpperCase() + prefix.slice(1);
    await prisma.user.update({ where: { id: u.id }, data: { name } });
    adminUpdated++;
  }
  console.log(`✅ ADMIN: ${adminUpdated}/${admins.length} updated`);
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
