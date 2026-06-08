const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const LOCATION_EN = [
  { code: 'A17',  nameEn: 'Building A17' },
  { code: 'PM',   nameEn: 'Building PM' },
  { code: 'B4',   nameEn: 'Building B4' },
  { code: 'D',    nameEn: 'Building D' },
  { code: 'C4B',  nameEn: 'Building C4B (HUST)' },
  { code: 'TH1A', nameEn: 'Lab Block TH1A' },
];

async function main() {
  for (const loc of LOCATION_EN) {
    const result = await prisma.location.updateMany({
      where: { code: loc.code },
      data: { nameEn: loc.nameEn },
    });
    console.log(`${loc.code}: updated ${result.count} row(s) → ${loc.nameEn}`);
  }
  console.log('Done seeding location nameEn.');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
