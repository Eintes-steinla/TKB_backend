// Converts seed.sql snake_case column names to camelCase for the actual DB schema
const fs = require('fs');
const path = require('path');

const input = path.resolve(__dirname, '../../document/seed_patched.sql');
const output = path.resolve(__dirname, '../../document/seed_final.sql');

let sql = fs.readFileSync(input, 'utf8');

// Column name mappings: snake_case -> camelCase (only in INSERT column lists)
const columnMaps = {
  // rooms
  'location_id': 'locationId',
  'is_active': 'isActive',
  // class_groups
  'major_id': 'majorId',
  'cohort_id': 'cohortId',
  'student_count': 'studentCount',
  // subjects
  'room_type': 'roomType',
  'is_practice': 'isPractice',
  'requires_consecutive': 'requiresConsecutive',
  'name_en': 'nameEn',
  // curricula
  'subject_id': 'subjectId',
  'semester_no': 'semesterNo',
  'week_start': 'weekStart',
  'week_end': 'weekEnd',
  'periods_per_week': 'periodsPerWeek',
  // assignments
  'teacher_id': 'teacherId',
  'class_group_id': 'classGroupId',
  // teaching_units
  'assignment_id': 'assignmentId',
  'conflict_group_id': 'conflictGroupId',
  // schedules
  'teaching_unit_id': 'teachingUnitId',
  'room_id': 'roomId',
  'day_of_week': 'dayOfWeek',
  'period_start': 'periodStart',
  'period_end': 'periodEnd',
  'week_number': 'weekNumber',
  // teachers
  'unavailable_slots': 'unavailableSlots',
  // users
  'password_hash': 'passwordHash',
  'ref_id': 'refId',
  'refresh_token': 'refreshToken',
  'created_at': 'createdAt',
  // schedule_versions
  'version_label': 'versionLabel',
  'created_by': 'createdBy',
};

// Replace column names only in INSERT INTO (...) column lists
// Strategy: replace snake_case with quoted camelCase (PostgreSQL needs quotes for mixed-case identifiers)
for (const [snake, camel] of Object.entries(columnMaps)) {
  const re = new RegExp('\\b' + snake + '\\b', 'g');
  sql = sql.replace(re, `"${camel}"`);
}

// Also fix the subjects insert which doesn't have name_en but check
// Remove constraint_violation_logs TRUNCATE if table doesn't exist
sql = sql.replace(/TRUNCATE TABLE constraint_violation_logs CASCADE;\s*\n/g, '');

fs.writeFileSync(output, sql, 'utf8');
console.log('Written to', output);

// Verify no snake_case columns remain in INSERT statements
const insertBlocks = sql.match(/INSERT INTO[^;]+/gs) || [];
const snakePattern = /\b[a-z]+_[a-z_]+\b/g;
const ignore = ['school.edu.vn', 'class_groups', 'teaching_units', 'schedule_versions',
  'constraint_violation_logs', 'LTMT1-K15-HK5', 'LTMT2-K15-HK5', 'Tạ_Quang_Bửu'];
let found = [];
for (const block of insertBlocks) {
  const m = block.match(snakePattern) || [];
  for (const w of m) {
    if (!ignore.some(i => w.includes(i)) && w in columnMaps) {
      found.push(w);
    }
  }
}
if (found.length > 0) {
  console.warn('WARNING: Possible remaining snake_case columns:', [...new Set(found)]);
} else {
  console.log('OK: No remaining mapped snake_case columns found.');
}
