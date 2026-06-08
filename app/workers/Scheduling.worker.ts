/**
 * Scheduling Worker — CSP with MRV heuristic
 *
 * This module can be invoked directly by the Scheduler.service via Bull queue,
 * or as a standalone worker_threads worker when workerData is provided.
 *
 * Message protocol (when used as worker_threads):
 *   { type: 'progress', progress: number }
 *   { type: 'result',   result: ScheduledSlot[] }
 *   { type: 'error',    error: string }
 */

import { prisma } from "../database/Postgres.database";
import {
  checkAllConstraints,
  ScheduleInput,
} from "../services/Constraint.service";
import { periodsOverlap } from "../helpers/Period.helper";

export interface WorkerInput {
  teachingUnitIds: string[];
  config: {
    academicYear: string; // thay weekStart, weekEnd
    weekStart: number; // vẫn giữ nhưng sẽ dùng để xác định weekOfYear từ 1-40
    weekEnd: number;
    allowedDays?: number[];
    allowedPeriods?: number[];
    maxBacktrackDepth?: number;
  };
}

export interface ScheduledSlot {
  teachingUnitId: string;
  dayOfWeek: number;
  periodStart: number;
  periodEnd: number;
  academicYear: string; // thay weekNumber
  weekOfYear: number; // thay weekNumber
  roomId?: string;
  mode: "ONLINE" | "OFFLINE";
}

interface CSPVariable {
  tuId: string;
  periodsNeeded: number;
  subjectRoomType: string;
  teacherUnavailable: Array<{
    day: number;
    periodStart: number;
    periodEnd: number;
  }>;
  domain: ScheduledSlot[];
  assigned?: ScheduledSlot;
}

/**
 * Main entry point for in-process scheduling.
 */
export async function runSchedulingWorker(
  input: WorkerInput,
  onProgress?: (pct: number) => void,
): Promise<ScheduledSlot[]> {
  const { teachingUnitIds, config } = input;
  const allowedDays = config.allowedDays ?? [2, 3, 4, 5, 6, 7];
  const allowedPeriods = config.allowedPeriods ?? [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
  ];
  const academicYear = config.academicYear;
  const weeks = rangeArray(config.weekStart, config.weekEnd); // weeks là 1-40
  const maxDepth = config.maxBacktrackDepth ?? 500;

  // Load all teaching units
  const tus = await prisma.teachingUnit.findMany({
    where: { id: { in: teachingUnitIds } },
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

  if (tus.length === 0) {
    return [];
  }

  // Load active rooms
  const rooms = await prisma.room.findMany({ where: { isActive: true } });

  // Build CSP variables
  const variables: CSPVariable[] = tus.map((tu) => {
    const periodsNeeded = 2;
    const teacherUnavailable =
      (tu.assignment.teacher?.unavailableSlots as Array<{
        day: number;
        periodStart: number;
        periodEnd: number;
      }>) ?? [];

    const matchingRooms = rooms
      .filter((r) => r.type === tu.subject.roomType)
      .map((r) => r.id);

    const domain = buildInitialDomain(
      tu.id,
      periodsNeeded,
      tu.subject.roomType,
      teacherUnavailable,
      allowedDays,
      allowedPeriods,
      weeks,
      matchingRooms,
      academicYear, // thêm
    );

    return {
      tuId: tu.id,
      periodsNeeded,
      subjectRoomType: tu.subject.roomType,
      teacherUnavailable,
      domain,
      assigned: undefined,
    };
  });

  // MRV: sort variables by domain size (smallest domain = most constrained = schedule first)
  variables.sort((a, b) => a.domain.length - b.domain.length);

  const result: ScheduledSlot[] = [];
  const succeeded = await backtrackSearch(
    variables,
    0,
    result,
    maxDepth,
    onProgress,
  );

  if (!succeeded) {
    throw new Error(
      `CSP failed: could not schedule all ${teachingUnitIds.length} teaching units within the given constraints`,
    );
  }

  return result;
}

function rangeArray(start: number, end: number): number[] {
  const arr: number[] = [];
  for (let i = start; i <= end; i++) arr.push(i);
  return arr;
}

function buildInitialDomain(
  tuId: string,
  periodsNeeded: number,
  roomType: string,
  teacherUnavailable: Array<{
    day: number;
    periodStart: number;
    periodEnd: number;
  }>,
  days: number[],
  periods: number[],
  weeks: number[],
  matchingRoomIds: string[],
  academicYear: string, // thêm
): ScheduledSlot[] {
  const domain: ScheduledSlot[] = [];

  for (const weekOfYear of weeks) {
    for (const day of days) {
      for (const ps of periods) {
        const pe = ps + periodsNeeded - 1;
        if (pe > 12) continue;

        // Filter teacher unavailability
        const blocked = teacherUnavailable.some(
          (u) =>
            u.day === day && periodsOverlap(u.periodStart, u.periodEnd, ps, pe),
        );
        if (blocked) continue;

        if (matchingRoomIds.length > 0) {
          for (const roomId of matchingRoomIds) {
            domain.push({
              teachingUnitId: tuId,
              dayOfWeek: day,
              periodStart: ps,
              periodEnd: pe,
              academicYear,
              weekOfYear,
              roomId,
              mode: "OFFLINE",
            });
          }
        } else {
          domain.push({
            teachingUnitId: tuId,
            dayOfWeek: day,
            periodStart: ps,
            periodEnd: pe,
            academicYear,
            weekOfYear,
            mode: "ONLINE",
          });
        }
      }
    }
  }

  return domain;
}

async function backtrackSearch(
  variables: CSPVariable[],
  index: number,
  assignment: ScheduledSlot[],
  maxDepth: number,
  onProgress?: (pct: number) => void,
): Promise<boolean> {
  if (index >= variables.length) return true;
  if (index > maxDepth) return false;

  if (onProgress) {
    onProgress(Math.round((index / variables.length) * 100));
  }

  const variable = variables[index];

  // Filter domain using forward checking against already assigned slots
  const filteredDomain = forwardCheck(variable.domain, assignment);

  for (const slot of filteredDomain) {
    // Run full constraint check
    const constraintInput: ScheduleInput = {
      teachingUnitId: slot.teachingUnitId,
      roomId: slot.roomId,
      dayOfWeek: slot.dayOfWeek,
      periodStart: slot.periodStart,
      periodEnd: slot.periodEnd,
      academicYear: slot.academicYear, // thay weekNumber
      weekOfYear: slot.weekOfYear, // mới
      mode: slot.mode,
    };

    const res = await checkAllConstraints(constraintInput);
    const hasError = res.violations.some((v) => v.severity === "error");
    if (hasError) continue;

    variable.assigned = slot;
    assignment.push(slot);

    const success = await backtrackSearch(
      variables,
      index + 1,
      assignment,
      maxDepth,
      onProgress,
    );
    if (success) return true;

    assignment.pop();
    variable.assigned = undefined;
  }

  return false;
}

/**
 * Forward checking: remove domain values that conflict with already assigned slots.
 * This is a lightweight consistency pruning step before full constraint evaluation.
 */
function forwardCheck(
  domain: ScheduledSlot[],
  assigned: ScheduledSlot[],
): ScheduledSlot[] {
  return domain.filter((candidate) => {
    for (const existing of assigned) {
      if (
        existing.dayOfWeek === candidate.dayOfWeek &&
        existing.academicYear === candidate.academicYear &&
        existing.weekOfYear === candidate.weekOfYear
      ) {
        // Same room conflict
        if (
          candidate.roomId &&
          existing.roomId === candidate.roomId &&
          periodsOverlap(
            existing.periodStart,
            existing.periodEnd,
            candidate.periodStart,
            candidate.periodEnd,
          )
        ) {
          return false;
        }
      }
    }
    return true;
  });
}
