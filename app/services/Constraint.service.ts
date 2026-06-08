import { prisma } from "../database/Postgres.database";
import { periodsOverlap } from "../helpers/Period.helper";
// Bỏ isWeekInRange vì không dùng nữa
import {
  ConstraintResult,
  ConstraintViolation,
} from "../models/ConstraintResult.model";

export interface ScheduleInput {
  id?: string; // existing schedule id if updating
  teachingUnitId: string;
  roomId?: string | null;
  dayOfWeek: number;
  periodStart: number;
  periodEnd: number;
  academicYear: string; // "YYYY-YYYY"
  weekOfYear: number; // 1-40
  mode: "ONLINE" | "OFFLINE";
}

/**
 * Runs all 7 constraint steps against a proposed schedule slot.
 * Returns a ConstraintResult with all violations found.
 */
export async function checkAllConstraints(
  input: ScheduleInput,
): Promise<ConstraintResult> {
  const violations: ConstraintViolation[] = [];

  const tu = await prisma.teachingUnit.findUnique({
    where: { id: input.teachingUnitId },
    include: {
      subject: true,
      assignment: {
        include: {
          teacher: true,
          classGroup: true,
        },
      },
    },
  });

  if (!tu) {
    return {
      valid: false,
      violations: [
        {
          step: 0,
          stepName: "load",
          message: "TeachingUnit not found",
          severity: "error",
        },
      ],
    };
  }

  // Step 1: checkWeekRange (temporarily disabled – needs curriculum adaptation)
  // const step1 = await checkWeekRange(input, tu);
  // violations.push(...step1);

  // Step 2: checkRoomType (skip if ONLINE)
  if (input.mode === "OFFLINE") {
    const step2 = await checkRoomType(input, tu);
    violations.push(...step2);
  }

  // Step 3: checkRoomConflict (skip if ONLINE)
  if (input.mode === "OFFLINE" && input.roomId) {
    const step3 = await checkRoomConflict(input);
    violations.push(...step3);
  }

  // Step 4: checkTeacherConflict
  if (tu.assignment.teacher) {
    const step4 = await checkTeacherConflict(
      input,
      tu.assignment.teacher.id,
      tu.assignment.teacher,
    );
    violations.push(...step4);
  }

  // Step 5: checkClassConflict
  const step5 = await checkClassConflict(input, tu.assignment.classGroupId);
  violations.push(...step5);

  // Step 6: checkCrossGroupConflict
  if (tu.conflictGroupId) {
    const step6 = await checkCrossGroupConflict(
      input,
      tu.conflictGroupId,
      tu.id,
    );
    violations.push(...step6);
  }

  // Step 7: checkMovementConstraint (soft warning)
  if (input.mode === "OFFLINE" && input.roomId) {
    const step7 = await checkMovementConstraint(
      input,
      tu.assignment.classGroupId,
    );
    violations.push(...step7);
  }

  return {
    valid: violations.filter((v) => v.severity === "error").length === 0,
    violations,
  };
}

// ─── Step 1 (disabled) ───────────────────────────────────────────────────────
// async function checkWeekRange(...) – removed

// ─── Step 2 ──────────────────────────────────────────────────────────────────

async function checkRoomType(
  input: ScheduleInput,
  tu: { subject: { roomType: string } },
): Promise<ConstraintViolation[]> {
  if (!input.roomId) {
    return [
      {
        step: 2,
        stepName: "checkRoomType",
        message: "OFFLINE schedule requires a room",
        severity: "error",
      },
    ];
  }

  const room = await prisma.room.findUnique({ where: { id: input.roomId } });
  if (!room) {
    return [
      {
        step: 2,
        stepName: "checkRoomType",
        message: "Room not found",
        severity: "error",
      },
    ];
  }

  if (!room.isActive) {
    return [
      {
        step: 2,
        stepName: "checkRoomType",
        message: `Room ${room.code} is inactive`,
        severity: "error",
      },
    ];
  }

  if (room.type !== tu.subject.roomType) {
    return [
      {
        step: 2,
        stepName: "checkRoomType",
        message: `Room type mismatch: room is ${room.type}, subject requires ${tu.subject.roomType}`,
        severity: "error",
      },
    ];
  }
  return [];
}

// ─── Step 3 ──────────────────────────────────────────────────────────────────

async function checkRoomConflict(
  input: ScheduleInput,
): Promise<ConstraintViolation[]> {
  const conflicting = await prisma.schedule.findMany({
    where: {
      roomId: input.roomId,
      dayOfWeek: input.dayOfWeek,
      academicYear: input.academicYear,
      weekOfYear: input.weekOfYear,
      ...(input.id ? { NOT: { id: input.id } } : {}),
    },
  });

  const overlapping = conflicting.filter((s) =>
    periodsOverlap(
      s.periodStart,
      s.periodEnd,
      input.periodStart,
      input.periodEnd,
    ),
  );

  if (overlapping.length > 0) {
    return [
      {
        step: 3,
        stepName: "checkRoomConflict",
        message: `Room is already booked for day ${input.dayOfWeek}, ${input.academicYear} week ${input.weekOfYear}, periods ${input.periodStart}-${input.periodEnd}`,
        severity: "error",
      },
    ];
  }
  return [];
}

// ─── Step 4 ──────────────────────────────────────────────────────────────────

async function checkTeacherConflict(
  input: ScheduleInput,
  teacherId: string,
  teacher: { unavailableSlots: unknown },
): Promise<ConstraintViolation[]> {
  const violations: ConstraintViolation[] = [];

  // Check teacher unavailable slots (still based on day and periods, not week)
  const slots =
    (teacher.unavailableSlots as Array<{
      day: number;
      periodStart: number;
      periodEnd: number;
    }>) ?? [];
  for (const slot of slots) {
    if (
      slot.day === input.dayOfWeek &&
      periodsOverlap(
        slot.periodStart,
        slot.periodEnd,
        input.periodStart,
        input.periodEnd,
      )
    ) {
      violations.push({
        step: 4,
        stepName: "checkTeacherConflict",
        message: `Teacher ${teacherId} is unavailable on day ${input.dayOfWeek} periods ${slot.periodStart}-${slot.periodEnd}`,
        severity: "error",
      });
    }
  }

  // Check existing schedules for teacher
  const teacherSchedules = await prisma.schedule.findMany({
    where: {
      dayOfWeek: input.dayOfWeek,
      academicYear: input.academicYear,
      weekOfYear: input.weekOfYear,
      ...(input.id ? { NOT: { id: input.id } } : {}),
      teachingUnit: {
        assignment: {
          teacherId,
        },
      },
    },
  });

  const overlapping = teacherSchedules.filter((s) =>
    periodsOverlap(
      s.periodStart,
      s.periodEnd,
      input.periodStart,
      input.periodEnd,
    ),
  );

  if (overlapping.length > 0) {
    violations.push({
      step: 4,
      stepName: "checkTeacherConflict",
      message: `Teacher has a conflicting schedule on day ${input.dayOfWeek}, ${input.academicYear} week ${input.weekOfYear}, periods ${input.periodStart}-${input.periodEnd}`,
      severity: "error",
    });
  }

  return violations;
}

// ─── Step 5 ──────────────────────────────────────────────────────────────────

async function checkClassConflict(
  input: ScheduleInput,
  classGroupId: string,
): Promise<ConstraintViolation[]> {
  const classSchedules = await prisma.schedule.findMany({
    where: {
      dayOfWeek: input.dayOfWeek,
      academicYear: input.academicYear,
      weekOfYear: input.weekOfYear,
      ...(input.id ? { NOT: { id: input.id } } : {}),
      teachingUnit: {
        assignment: {
          classGroupId,
        },
      },
    },
  });

  const overlapping = classSchedules.filter((s) =>
    periodsOverlap(
      s.periodStart,
      s.periodEnd,
      input.periodStart,
      input.periodEnd,
    ),
  );

  if (overlapping.length > 0) {
    return [
      {
        step: 5,
        stepName: "checkClassConflict",
        message: `Class has a conflicting schedule on day ${input.dayOfWeek}, ${input.academicYear} week ${input.weekOfYear}, periods ${input.periodStart}-${input.periodEnd}`,
        severity: "error",
      },
    ];
  }
  return [];
}

// ─── Step 6 ──────────────────────────────────────────────────────────────────

async function checkCrossGroupConflict(
  input: ScheduleInput,
  conflictGroupId: string,
  currentTuId: string,
): Promise<ConstraintViolation[]> {
  const groupSchedules = await prisma.schedule.findMany({
    where: {
      dayOfWeek: input.dayOfWeek,
      academicYear: input.academicYear,
      weekOfYear: input.weekOfYear,
      ...(input.id ? { NOT: { id: input.id } } : {}),
      teachingUnit: {
        conflictGroupId,
        NOT: { id: currentTuId },
      },
    },
  });

  const overlapping = groupSchedules.filter((s) =>
    periodsOverlap(
      s.periodStart,
      s.periodEnd,
      input.periodStart,
      input.periodEnd,
    ),
  );

  if (overlapping.length > 0) {
    return [
      {
        step: 6,
        stepName: "checkCrossGroupConflict",
        message: `Conflict group "${conflictGroupId}" has overlapping slots on day ${input.dayOfWeek}, ${input.academicYear} week ${input.weekOfYear}`,
        severity: "error",
      },
    ];
  }
  return [];
}

// ─── Step 7 (soft) ───────────────────────────────────────────────────────────

async function checkMovementConstraint(
  input: ScheduleInput,
  classGroupId: string,
): Promise<ConstraintViolation[]> {
  if (!input.roomId) return [];

  const currentRoom = await prisma.room.findUnique({
    where: { id: input.roomId },
    include: { location: true },
  });
  if (!currentRoom) return [];

  // Find schedules adjacent in time (periods immediately before or after)
  const adjacentSchedules = await prisma.schedule.findMany({
    where: {
      dayOfWeek: input.dayOfWeek,
      academicYear: input.academicYear,
      weekOfYear: input.weekOfYear,
      roomId: { not: null },
      ...(input.id ? { NOT: { id: input.id } } : {}),
      teachingUnit: {
        assignment: { classGroupId },
      },
    },
    include: {
      room: { include: { location: true } },
    },
  });

  const violations: ConstraintViolation[] = [];

  for (const sched of adjacentSchedules) {
    const isAdjacent =
      sched.periodEnd + 1 === input.periodStart ||
      input.periodEnd + 1 === sched.periodStart;

    if (
      isAdjacent &&
      sched.room &&
      sched.room.location &&
      currentRoom.location
    ) {
      if (sched.room.location.id !== currentRoom.location.id) {
        violations.push({
          step: 7,
          stepName: "checkMovementConstraint",
          message: `Adjacent schedule is in a different building (${sched.room.location.name} vs ${currentRoom.location.name}). Students may not have enough time to move.`,
          severity: "warning",
        });
      }
    }
  }

  return violations;
}

/**
 * Persist violation logs to DB for a given schedule.
 */
export async function persistViolations(
  scheduleId: string,
  violations: ConstraintViolation[],
): Promise<void> {
  if (violations.length === 0) return;
  await prisma.constraintViolationLog.createMany({
    data: violations.map((v) => ({
      scheduleId,
      constraintStep: v.step,
      severity: v.severity,
      message: v.message,
    })),
  });
}
