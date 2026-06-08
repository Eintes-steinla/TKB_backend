/**
 * Migrates all teacher IDs from custom strings (gv_xxx) to proper UUIDs.
 * Uses raw SQL UPDATE to change PKs in-place, updating FK columns first
 * by temporarily using a temp column approach — actually we just loop one
 * teacher at a time: null FK → update PK → set FK to new value.
 */
const { PrismaClient } = require('@prisma/client');
const { randomUUID } = require('crypto');

const prisma = new PrismaClient();
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

async function main() {
  const teachers = await prisma.teacher.findMany();
  const toMigrate = teachers.filter(t => !UUID_RE.test(t.id));

  if (toMigrate.length === 0) {
    console.log('All teacher IDs are already UUIDs. Nothing to do.');
    return;
  }

  const idMap = new Map();
  for (const t of toMigrate) {
    idMap.set(t.id, randomUUID());
  }

  console.log(`Migrating ${toMigrate.length} teacher IDs...`);

  // Process one teacher at a time (each in its own transaction)
  // Per teacher:
  //   1. Collect which assignment IDs and user IDs reference oldId
  //   2. Set those FK cols to NULL
  //   3. Update teacher.id = newId
  //   4. Restore FK cols to newId using the collected IDs
  let done = 0;
  for (const [oldId, newId] of idMap) {
    // Collect FK holders before nulling
    const affectedAssignments = await prisma.assignment.findMany({
      where: { teacherId: oldId },
      select: { id: true },
    });
    const affectedUsers = await prisma.user.findMany({
      where: { refId: oldId },
      select: { id: true },
    });
    const assignmentIds = affectedAssignments.map(a => a.id);
    const userIds = affectedUsers.map(u => u.id);

    await prisma.$transaction(async (tx) => {
      // 1. Null FKs
      if (assignmentIds.length > 0) {
        await tx.$executeRaw`UPDATE assignments SET "teacherId" = NULL WHERE id = ANY(${assignmentIds}::text[])`;
      }
      if (userIds.length > 0) {
        await tx.$executeRaw`UPDATE users SET "refId" = NULL WHERE id = ANY(${userIds}::text[])`;
      }

      // 2. Update PK
      await tx.$executeRaw`UPDATE teachers SET id = ${newId} WHERE id = ${oldId}`;

      // 3. Restore FKs to new ID
      if (assignmentIds.length > 0) {
        await tx.$executeRaw`UPDATE assignments SET "teacherId" = ${newId} WHERE id = ANY(${assignmentIds}::text[])`;
      }
      if (userIds.length > 0) {
        await tx.$executeRaw`UPDATE users SET "refId" = ${newId} WHERE id = ANY(${userIds}::text[])`;
      }
    });

    done++;
    const teacher = teachers.find(t => t.id === oldId);
    console.log(`  [${done}/${toMigrate.length}] ${oldId} -> ${newId}  (${teacher?.name})`);
  }

  // Verification
  console.log('\nVerification:');
  const remaining = await prisma.teacher.findMany();
  const nonUUID = remaining.filter(t => !UUID_RE.test(t.id));
  console.log('  Non-UUID teacher IDs remaining:', nonUUID.length);
  if (nonUUID.length > 0) nonUUID.forEach(t => console.log('   ', t.id, t.name));

  const users = await prisma.user.findMany({ where: { role: 'TEACHER' } });
  const nullRefIds = users.filter(u => !u.refId);
  console.log('  Teacher users with NULL refId:', nullRefIds.length);
  if (nullRefIds.length > 0) nullRefIds.forEach(u => console.log('    ', u.email));

  const assignmentsWithTeacher = await prisma.assignment.count({ where: { teacherId: { not: null } } });
  console.log('  Assignments with teacherId set:', assignmentsWithTeacher);

  console.log('\nDone.');
}

main().catch(console.error).finally(() => prisma.$disconnect());
