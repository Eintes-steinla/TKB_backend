import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main(): Promise<void> {
  console.log('🌱 Seeding database...');

  // ── Locations ────────────────────────────────────────────────────────────────
  const locB1 = await prisma.location.upsert({
    where: { code: 'B1' },
    update: {},
    create: { code: 'B1', name: 'Nhà B1', address: 'Số 1 Đại Cồ Việt, Hà Nội' },
  });
  const locB4 = await prisma.location.upsert({
    where: { code: 'B4' },
    update: {},
    create: { code: 'B4', name: 'Nhà B4', address: 'Số 1 Đại Cồ Việt, Hà Nội' },
  });
  const locB6 = await prisma.location.upsert({
    where: { code: 'B6' },
    update: {},
    create: { code: 'B6', name: 'Nhà B6 - Thực hành', address: 'Số 1 Đại Cồ Việt, Hà Nội' },
  });
  console.log('✓ Locations created');

  // ── Rooms ────────────────────────────────────────────────────────────────────
  const roomsData = [
    { locationId: locB1.id, code: 'B1-101', type: 'THEORY' as const, capacity: 60 },
    { locationId: locB1.id, code: 'B1-102', type: 'THEORY' as const, capacity: 60 },
    { locationId: locB1.id, code: 'B1-201', type: 'THEORY' as const, capacity: 80 },
    { locationId: locB4.id, code: 'B4-G01', type: 'HALL' as const, capacity: 200 },
    { locationId: locB4.id, code: 'B4-G02', type: 'HALL' as const, capacity: 150 },
    { locationId: locB6.id, code: 'B6-Lab1', type: 'PRACTICE' as const, capacity: 35 },
    { locationId: locB6.id, code: 'B6-Lab2', type: 'PRACTICE' as const, capacity: 35 },
    { locationId: locB6.id, code: 'B6-Lab3', type: 'PRACTICE' as const, capacity: 30 },
  ];
  for (const r of roomsData) {
    await prisma.room.upsert({
      where: { code: r.code },
      update: {},
      create: r,
    });
  }
  console.log('✓ Rooms created');

  // ── Majors ───────────────────────────────────────────────────────────────────
  const majCNTT = await prisma.major.upsert({
    where: { code: 'CNTT' },
    update: {},
    create: { code: 'CNTT', name: 'Công nghệ thông tin' },
  });
  const majDT = await prisma.major.upsert({
    where: { code: 'DT' },
    update: {},
    create: { code: 'DT', name: 'Điện tử viễn thông' },
  });
  console.log('✓ Majors created');

  // ── Cohorts ──────────────────────────────────────────────────────────────────
  const cohort24 = await prisma.cohort.upsert({
    where: { code: 'K24' },
    update: {},
    create: { code: 'K24', year: 2024 },
  });
  const cohort23 = await prisma.cohort.upsert({
    where: { code: 'K23' },
    update: {},
    create: { code: 'K23', year: 2023 },
  });
  console.log('✓ Cohorts created');

  // ── Classes ──────────────────────────────────────────────────────────────────
  const classIT1 = await prisma.classGroup.upsert({
    where: { code: 'CNTT-K24-01' },
    update: {},
    create: { majorId: majCNTT.id, cohortId: cohort24.id, code: 'CNTT-K24-01', studentCount: 45 },
  });
  const classIT2 = await prisma.classGroup.upsert({
    where: { code: 'CNTT-K24-02' },
    update: {},
    create: { majorId: majCNTT.id, cohortId: cohort24.id, code: 'CNTT-K24-02', studentCount: 42 },
  });
  const classDT1 = await prisma.classGroup.upsert({
    where: { code: 'DT-K24-01' },
    update: {},
    create: { majorId: majDT.id, cohortId: cohort24.id, code: 'DT-K24-01', studentCount: 40 },
  });
  await prisma.classGroup.upsert({
    where: { code: 'CNTT-K23-01' },
    update: {},
    create: { majorId: majCNTT.id, cohortId: cohort23.id, code: 'CNTT-K23-01', studentCount: 48 },
  });
  console.log('✓ Class groups created');

  // ── Subjects ─────────────────────────────────────────────────────────────────
  const subDS = await prisma.subject.upsert({
    where: { code: 'IT3370' },
    update: {},
    create: {
      code: 'IT3370', name: 'Cơ sở dữ liệu', nameEn: 'Database Systems',
      credits: 3, roomType: 'THEORY', isPractice: false, requiresConsecutive: false,
    },
  });
  const subDSLab = await prisma.subject.upsert({
    where: { code: 'IT3371' },
    update: {},
    create: {
      code: 'IT3371', name: 'Thực hành cơ sở dữ liệu', nameEn: 'Database Lab',
      credits: 1, roomType: 'PRACTICE', isPractice: true, requiresConsecutive: true,
    },
  });
  const subOOP = await prisma.subject.upsert({
    where: { code: 'IT3100' },
    update: {},
    create: {
      code: 'IT3100', name: 'Lập trình hướng đối tượng', nameEn: 'Object-Oriented Programming',
      credits: 3, roomType: 'THEORY', isPractice: false, requiresConsecutive: false,
    },
  });
  const subAlgo = await prisma.subject.upsert({
    where: { code: 'IT3020' },
    update: {},
    create: {
      code: 'IT3020', name: 'Giải tích toán học', nameEn: 'Mathematical Analysis',
      credits: 4, roomType: 'HALL', isPractice: false, requiresConsecutive: false,
    },
  });
  const subNet = await prisma.subject.upsert({
    where: { code: 'ET3200' },
    update: {},
    create: {
      code: 'ET3200', name: 'Mạng viễn thông', nameEn: 'Telecommunications Networks',
      credits: 3, roomType: 'THEORY', isPractice: false, requiresConsecutive: false,
    },
  });
  console.log('✓ Subjects created');

  // ── Teachers ─────────────────────────────────────────────────────────────────
  const t1 = await prisma.teacher.upsert({
    where: { code: 'GV001' },
    update: {},
    create: {
      code: 'GV001', name: 'TS. Nguyễn Văn An', email: 'an.nv@hust.edu.vn',
      dept: 'Khoa CNTT', unavailableSlots: [],
    },
  });
  const t2 = await prisma.teacher.upsert({
    where: { code: 'GV002' },
    update: {},
    create: {
      code: 'GV002', name: 'PGS. Trần Thị Bình', email: 'binh.tt@hust.edu.vn',
      dept: 'Khoa CNTT',
      unavailableSlots: [{ day: 6, periodStart: 7, periodEnd: 12 }], // no Saturday afternoon
    },
  });
  const t3 = await prisma.teacher.upsert({
    where: { code: 'GV003' },
    update: {},
    create: {
      code: 'GV003', name: 'ThS. Lê Minh Cường', email: 'cuong.lm@hust.edu.vn',
      dept: 'Khoa Điện tử', unavailableSlots: [],
    },
  });
  console.log('✓ Teachers created');

  // ── Curricula ────────────────────────────────────────────────────────────────
  await prisma.curriculum.upsert({
    where: { id: 'cur-cntt-ds' },
    update: {},
    create: {
      id: 'cur-cntt-ds', majorId: majCNTT.id, subjectId: subDS.id,
      semesterNo: 3, weekStart: 1, weekEnd: 15, periodsPerWeek: 3,
    },
  });
  await prisma.curriculum.upsert({
    where: { id: 'cur-cntt-dslab' },
    update: {},
    create: {
      id: 'cur-cntt-dslab', majorId: majCNTT.id, subjectId: subDSLab.id,
      semesterNo: 3, weekStart: 1, weekEnd: 15, periodsPerWeek: 2,
    },
  });
  await prisma.curriculum.upsert({
    where: { id: 'cur-cntt-oop' },
    update: {},
    create: {
      id: 'cur-cntt-oop', majorId: majCNTT.id, subjectId: subOOP.id,
      semesterNo: 2, weekStart: 1, weekEnd: 15, periodsPerWeek: 3,
    },
  });
  await prisma.curriculum.upsert({
    where: { id: 'cur-cntt-algo' },
    update: {},
    create: {
      id: 'cur-cntt-algo', majorId: majCNTT.id, subjectId: subAlgo.id,
      semesterNo: 1, weekStart: 1, weekEnd: 15, periodsPerWeek: 4,
    },
  });
  await prisma.curriculum.upsert({
    where: { id: 'cur-dt-net' },
    update: {},
    create: {
      id: 'cur-dt-net', majorId: majDT.id, subjectId: subNet.id,
      semesterNo: 4, weekStart: 1, weekEnd: 15, periodsPerWeek: 3,
    },
  });
  console.log('✓ Curricula created');

  // ── Assignments ──────────────────────────────────────────────────────────────
  const aIT1DS = await prisma.assignment.upsert({
    where: { id: 'asgn-it1-ds' },
    update: {},
    create: { id: 'asgn-it1-ds', teacherId: t1.id, classGroupId: classIT1.id },
  });
  const aIT2DS = await prisma.assignment.upsert({
    where: { id: 'asgn-it2-ds' },
    update: {},
    create: { id: 'asgn-it2-ds', teacherId: t1.id, classGroupId: classIT2.id },
  });
  const aIT1DSLab = await prisma.assignment.upsert({
    where: { id: 'asgn-it1-dslab' },
    update: {},
    create: { id: 'asgn-it1-dslab', teacherId: t2.id, classGroupId: classIT1.id },
  });
  const aDT1Net = await prisma.assignment.upsert({
    where: { id: 'asgn-dt1-net' },
    update: {},
    create: { id: 'asgn-dt1-net', teacherId: t3.id, classGroupId: classDT1.id },
  });
  console.log('✓ Assignments created');

  // ── Teaching Units ───────────────────────────────────────────────────────────
  await prisma.teachingUnit.upsert({
    where: { id: 'tu-it1-ds' },
    update: {},
    create: {
      id: 'tu-it1-ds', subjectId: subDS.id, assignmentId: aIT1DS.id,
      type: 'THEORY', name: 'CSDL - CNTT-K24-01', conflictGroupId: 'cg-ds',
    },
  });
  await prisma.teachingUnit.upsert({
    where: { id: 'tu-it2-ds' },
    update: {},
    create: {
      id: 'tu-it2-ds', subjectId: subDS.id, assignmentId: aIT2DS.id,
      type: 'THEORY', name: 'CSDL - CNTT-K24-02', conflictGroupId: 'cg-ds',
    },
  });
  await prisma.teachingUnit.upsert({
    where: { id: 'tu-it1-dslab' },
    update: {},
    create: {
      id: 'tu-it1-dslab', subjectId: subDSLab.id, assignmentId: aIT1DSLab.id,
      type: 'PRACTICE', name: 'TH CSDL - CNTT-K24-01',
    },
  });
  await prisma.teachingUnit.upsert({
    where: { id: 'tu-dt1-net' },
    update: {},
    create: {
      id: 'tu-dt1-net', subjectId: subNet.id, assignmentId: aDT1Net.id,
      type: 'THEORY', name: 'Mạng VT - DT-K24-01',
    },
  });
  console.log('✓ Teaching units created');

  // ── Users ────────────────────────────────────────────────────────────────────
  const adminHash = await bcrypt.hash('Admin@123', 12);
  const t1Hash = await bcrypt.hash('Teacher@123', 12);
  const t2Hash = await bcrypt.hash('Teacher@123', 12);

  await prisma.user.upsert({
    where: { email: 'admin@hust.edu.vn' },
    update: {},
    create: { email: 'admin@hust.edu.vn', passwordHash: adminHash, role: 'ADMIN' },
  });
  await prisma.user.upsert({
    where: { email: t1.email },
    update: {},
    create: { email: t1.email, passwordHash: t1Hash, role: 'TEACHER', refId: t1.id },
  });
  await prisma.user.upsert({
    where: { email: t2.email },
    update: {},
    create: { email: t2.email, passwordHash: t2Hash, role: 'TEACHER', refId: t2.id },
  });
  console.log('✓ Users created');

  console.log('\n✅ Seed complete!');
  console.log('   Admin login: admin@hust.edu.vn / Admin@123');
  console.log('   Teacher login: an.nv@hust.edu.vn / Teacher@123');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
