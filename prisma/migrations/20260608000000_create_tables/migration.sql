-- ============================================================================
-- DDL — TKB (Thời Khóa Biểu) System
-- Generated from: schema.prisma
-- Database: PostgreSQL 14+
--
-- Idempotent: safe to run on a clean DB or re-run (DROP IF EXISTS + CREATE).
-- Execution order respects all FK dependencies.
-- ============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- gen_random_uuid(), crypt()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- uuid_generate_v4() fallback

-- ============================================================================
-- ENUMS
-- ============================================================================

DO $$ BEGIN
  CREATE TYPE "RoomType" AS ENUM ('THEORY', 'PRACTICE', 'HALL');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE "TUType" AS ENUM ('THEORY', 'PRACTICE', 'EXERCISE');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE "ScheduleMode" AS ENUM ('ONLINE', 'OFFLINE');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'TEACHER', 'STUDENT');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================================
-- TABLES (drop order = reverse FK dependency)
-- ============================================================================

DROP TABLE IF EXISTS constraint_violation_logs CASCADE;
DROP TABLE IF EXISTS schedule_versions         CASCADE;
DROP TABLE IF EXISTS schedules                 CASCADE;
DROP TABLE IF EXISTS teaching_units            CASCADE;
DROP TABLE IF EXISTS assignments               CASCADE;
DROP TABLE IF EXISTS curricula                 CASCADE;
DROP TABLE IF EXISTS students                  CASCADE;
DROP TABLE IF EXISTS class_groups              CASCADE;
DROP TABLE IF EXISTS teachers                  CASCADE;
DROP TABLE IF EXISTS users                     CASCADE;
DROP TABLE IF EXISTS rooms                     CASCADE;
DROP TABLE IF EXISTS locations                 CASCADE;
DROP TABLE IF EXISTS subjects                  CASCADE;
DROP TABLE IF EXISTS majors                    CASCADE;
DROP TABLE IF EXISTS cohorts                   CASCADE;

-- ────────────────────────────────────────────────────────────────────────────
-- users
-- Root auth table — referenced by teachers (1:1) and students (1:1)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE users (
  id             TEXT          NOT NULL DEFAULT gen_random_uuid()::TEXT,
  email          TEXT          NOT NULL,
  "passwordHash" TEXT          NOT NULL,
  role           "UserRole"    NOT NULL,
  "refId"        TEXT,                          -- denorm pointer → teachers.id or students.id
  "refreshToken" TEXT,
  "createdAt"    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  name           TEXT,

  CONSTRAINT users_pkey        PRIMARY KEY (id),
  CONSTRAINT users_email_key   UNIQUE      (email)
);

-- ────────────────────────────────────────────────────────────────────────────
-- locations
-- Physical campuses / buildings
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE locations (
  id          TEXT  NOT NULL DEFAULT gen_random_uuid()::TEXT,
  name        TEXT  NOT NULL,
  code        TEXT  NOT NULL,
  address     TEXT,
  "nameEn"    TEXT,
  "addressEn" TEXT,
  lat         DOUBLE PRECISION,
  lng         DOUBLE PRECISION,

  CONSTRAINT locations_pkey     PRIMARY KEY (id),
  CONSTRAINT locations_code_key UNIQUE      (code)
);

-- ────────────────────────────────────────────────────────────────────────────
-- rooms
-- Classrooms / labs; belongs to one location
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE rooms (
  id           TEXT        NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "locationId" TEXT        NOT NULL,
  code         TEXT        NOT NULL,
  type         "RoomType"  NOT NULL,
  capacity     INTEGER     NOT NULL,
  "isActive"   BOOLEAN     NOT NULL DEFAULT TRUE,

  CONSTRAINT rooms_pkey       PRIMARY KEY (id),
  CONSTRAINT rooms_code_key   UNIQUE      (code),
  CONSTRAINT rooms_location_fk
    FOREIGN KEY ("locationId") REFERENCES locations (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- teachers
-- One teacher = one user (CASCADE delete propagates from users)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE teachers (
  id                 TEXT    NOT NULL DEFAULT gen_random_uuid()::TEXT,
  code               TEXT    NOT NULL,
  dept               TEXT,
  "unavailableSlots" JSONB   NOT NULL DEFAULT '[]',
  "userId"           TEXT    NOT NULL,

  CONSTRAINT teachers_pkey      PRIMARY KEY (id),
  CONSTRAINT teachers_code_key  UNIQUE      (code),
  CONSTRAINT teachers_userId_key UNIQUE     ("userId"),
  CONSTRAINT teachers_user_fk
    FOREIGN KEY ("userId") REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- majors
-- Academic programmes (e.g. LTMT, QTM)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE majors (
  id   TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
  code TEXT NOT NULL,
  name TEXT NOT NULL,

  CONSTRAINT majors_pkey     PRIMARY KEY (id),
  CONSTRAINT majors_code_key UNIQUE      (code)
);

-- ────────────────────────────────────────────────────────────────────────────
-- cohorts
-- Intake year groups (K15 = 2023, K16 = 2024 …)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE cohorts (
  id   TEXT    NOT NULL DEFAULT gen_random_uuid()::TEXT,
  code TEXT    NOT NULL,
  year INTEGER NOT NULL,

  CONSTRAINT cohorts_pkey     PRIMARY KEY (id),
  CONSTRAINT cohorts_code_key UNIQUE      (code)
);

-- ────────────────────────────────────────────────────────────────────────────
-- subjects
-- Course catalogue; roomType drives room assignment in scheduler
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE subjects (
  id                   TEXT       NOT NULL DEFAULT gen_random_uuid()::TEXT,
  code                 TEXT       NOT NULL,
  name                 TEXT       NOT NULL,
  "nameEn"             TEXT,
  credits              INTEGER    NOT NULL DEFAULT 3,
  "roomType"           "RoomType" NOT NULL,
  "isPractice"         BOOLEAN    NOT NULL DEFAULT FALSE,
  "requiresConsecutive" BOOLEAN   NOT NULL DEFAULT FALSE,

  CONSTRAINT subjects_pkey     PRIMARY KEY (id),
  CONSTRAINT subjects_code_key UNIQUE      (code)
);

-- ────────────────────────────────────────────────────────────────────────────
-- class_groups
-- A class = one major × one cohort (e.g. LTMT1-K15)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE class_groups (
  id             TEXT    NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "majorId"      TEXT    NOT NULL,
  "cohortId"     TEXT    NOT NULL,
  code           TEXT    NOT NULL,
  "studentCount" INTEGER NOT NULL DEFAULT 0,

  CONSTRAINT class_groups_pkey     PRIMARY KEY (id),
  CONSTRAINT class_groups_code_key UNIQUE      (code),
  CONSTRAINT class_groups_major_fk
    FOREIGN KEY ("majorId") REFERENCES majors (id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT class_groups_cohort_fk
    FOREIGN KEY ("cohortId") REFERENCES cohorts (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- students
-- One student = one user + assigned to one class_group
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE students (
  id             TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "userId"       TEXT NOT NULL,
  "classGroupId" TEXT NOT NULL,
  "studentCode"  TEXT NOT NULL,

  CONSTRAINT students_pkey           PRIMARY KEY (id),
  CONSTRAINT students_userId_key     UNIQUE      ("userId"),
  CONSTRAINT students_studentCode_key UNIQUE     ("studentCode"),
  CONSTRAINT students_user_fk
    FOREIGN KEY ("userId") REFERENCES users (id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT students_classGroup_fk
    FOREIGN KEY ("classGroupId") REFERENCES class_groups (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- curricula
-- Defines which subjects belong to which major, in which semester,
-- and the week/period cadence expected by the scheduler
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE curricula (
  id               TEXT    NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "majorId"        TEXT    NOT NULL,
  "subjectId"      TEXT    NOT NULL,
  "semesterNo"     INTEGER NOT NULL,
  "weekStart"      INTEGER NOT NULL,
  "weekEnd"        INTEGER NOT NULL,
  "periodsPerWeek" INTEGER NOT NULL,

  CONSTRAINT curricula_pkey     PRIMARY KEY (id),
  CONSTRAINT curricula_major_fk
    FOREIGN KEY ("majorId") REFERENCES majors (id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT curricula_subject_fk
    FOREIGN KEY ("subjectId") REFERENCES subjects (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- assignments
-- Links one teacher to one class_group for scheduling purposes.
-- teacherId nullable = unassigned slot (to-be-filled later).
-- Unique constraint: one teacher cannot be assigned twice to same class.
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE assignments (
  id             TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "teacherId"    TEXT,               -- nullable: unassigned
  "classGroupId" TEXT NOT NULL,

  CONSTRAINT assignments_pkey PRIMARY KEY (id),
  CONSTRAINT assignments_classGroup_teacher_key
    UNIQUE ("classGroupId", "teacherId"),
  CONSTRAINT assignments_teacher_fk
    FOREIGN KEY ("teacherId") REFERENCES teachers (id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT assignments_classGroup_fk
    FOREIGN KEY ("classGroupId") REFERENCES class_groups (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- teaching_units
-- One teaching unit = one subject within one assignment.
-- Unique per (assignment, subject) — prevents duplicate subject per class-teacher pair.
-- conflictGroupId groups units that must not overlap (e.g. shared lab sessions).
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE teaching_units (
  id                TEXT     NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "subjectId"       TEXT     NOT NULL,
  "assignmentId"    TEXT     NOT NULL,
  type              "TUType" NOT NULL,
  name              TEXT     NOT NULL,
  "conflictGroupId" TEXT,

  CONSTRAINT teaching_units_pkey PRIMARY KEY (id),
  CONSTRAINT teaching_units_assignment_subject_key
    UNIQUE ("assignmentId", "subjectId"),
  CONSTRAINT teaching_units_subject_fk
    FOREIGN KEY ("subjectId") REFERENCES subjects (id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT teaching_units_assignment_fk
    FOREIGN KEY ("assignmentId") REFERENCES assignments (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- schedules
-- One row = one time slot allocated to a teaching_unit.
-- dayOfWeek: 1=Mon … 7=Sun  |  periodStart/End: period numbers within day
-- weekOfYear: 1-based week within the academic year (not ISO week)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE schedules (
  id               TEXT           NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "teachingUnitId" TEXT           NOT NULL,
  "roomId"         TEXT,                        -- nullable: ONLINE mode
  "dayOfWeek"      INTEGER        NOT NULL CHECK ("dayOfWeek" BETWEEN 1 AND 7),
  "periodStart"    INTEGER        NOT NULL CHECK ("periodStart" >= 1),
  "periodEnd"      INTEGER        NOT NULL CHECK ("periodEnd" >= "periodStart"),
  mode             "ScheduleMode" NOT NULL,
  "academicYear"   TEXT           NOT NULL,     -- e.g. '2024-2025'
  "weekOfYear"     INTEGER        NOT NULL CHECK ("weekOfYear" BETWEEN 1 AND 52),

  CONSTRAINT schedules_pkey PRIMARY KEY (id),
  CONSTRAINT schedules_teachingUnit_fk
    FOREIGN KEY ("teachingUnitId") REFERENCES teaching_units (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT schedules_room_fk
    FOREIGN KEY ("roomId") REFERENCES rooms (id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────
-- schedule_versions
-- Immutable snapshots of scheduler output (audit / rollback).
-- snapshot is free-form JSONB — structure defined by the scheduler service.
-- createdBy stores user email (denorm; no FK to keep versions independent).
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE schedule_versions (
  id             TEXT        NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "versionLabel" TEXT        NOT NULL,
  snapshot       JSONB       NOT NULL,
  "createdAt"    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "createdBy"    TEXT        NOT NULL,

  CONSTRAINT schedule_versions_pkey PRIMARY KEY (id)
);

-- ────────────────────────────────────────────────────────────────────────────
-- constraint_violation_logs
-- Records every constraint failure detected during or after scheduling.
-- resolvedAt NULL = still open.  severity: 'error' | 'warning'.
-- constraintStep maps to CSP phase: 1=Teacher 2=Room 3=Consecutive 4=Cohort 5=Unavailable
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE constraint_violation_logs (
  id               TEXT        NOT NULL DEFAULT gen_random_uuid()::TEXT,
  "scheduleId"     TEXT        NOT NULL,
  "constraintStep" INTEGER     NOT NULL,
  message          TEXT        NOT NULL,
  "resolvedAt"     TIMESTAMPTZ,
  "createdAt"      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  severity         TEXT        NOT NULL DEFAULT 'error',

  CONSTRAINT constraint_violation_logs_pkey PRIMARY KEY (id),
  CONSTRAINT cvl_severity_check
    CHECK (severity IN ('error', 'warning')),
  CONSTRAINT cvl_schedule_fk
    FOREIGN KEY ("scheduleId") REFERENCES schedules (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================================
-- INDEXES
-- Covering the most critical query paths: schedule lookup by week/day,
-- teacher workload queries, student→class navigation, constraint log triage
-- ============================================================================

-- schedules: most-queried filter combination in timetable rendering
CREATE INDEX idx_schedules_week_day
  ON schedules ("academicYear", "weekOfYear", "dayOfWeek");

-- schedules: join path from teaching_unit
CREATE INDEX idx_schedules_teaching_unit
  ON schedules ("teachingUnitId");

-- schedules: room conflict check in CSP solver
CREATE INDEX idx_schedules_room
  ON schedules ("roomId");

-- teaching_units: lookup by assignment (teacher+class pivot)
CREATE INDEX idx_teaching_units_assignment
  ON teaching_units ("assignmentId");

-- teaching_units: subject filter (curriculum alignment)
CREATE INDEX idx_teaching_units_subject
  ON teaching_units ("subjectId");

-- assignments: teacher workload queries
CREATE INDEX idx_assignments_teacher
  ON assignments ("teacherId");

-- students: class roster queries
CREATE INDEX idx_students_classgroup
  ON students ("classGroupId");

-- constraint_violation_logs: open violation triage dashboard
CREATE INDEX idx_cvl_schedule
  ON constraint_violation_logs ("scheduleId");

CREATE INDEX idx_cvl_unresolved
  ON constraint_violation_logs ("resolvedAt")
  WHERE "resolvedAt" IS NULL;

-- users: role-based admin queries
CREATE INDEX idx_users_role
  ON users (role);

-- ============================================================================
-- VERIFICATION
-- ============================================================================
SELECT
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns c
   WHERE c.table_name = t.table_name
     AND c.table_schema = 'public') AS col_count
FROM information_schema.tables t
WHERE table_schema = 'public'
  AND table_type   = 'BASE TABLE'
ORDER BY table_name;
