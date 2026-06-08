import Bull from "bull";
import { redisConf } from "../config/redis.conf";
import { prisma } from "../database/Postgres.database";
import { checkAllConstraints } from "./Constraint.service";
import {
  emitSchedulerProgress,
  emitSchedulerCompleted,
} from "../socket/events";

export interface SchedulerConfig {
  academicYear: string; // "2025-2026"
  weekStart: number; // 1..40
  weekEnd: number; // 1..40
  allowedDays?: number[]; // default 2..7 (Mon-Sat)
  allowedPeriods?: number[]; // default 1..12
  maxBacktrackDepth?: number;
}

export interface SchedulerJobData {
  teachingUnitIds: string[];
  config: SchedulerConfig;
}

export interface SchedulerJobResult {
  jobId: string;
  status: "queued" | "running" | "completed" | "failed";
  progress?: number;
  result?: ScheduledSlot[];
  error?: string;
}

export interface ScheduledSlot {
  teachingUnitId: string;
  dayOfWeek: number;
  periodStart: number;
  periodEnd: number;
  academicYear: string; // mới
  weekOfYear: number; // thay weekNumber
  roomId?: string;
  mode: "ONLINE" | "OFFLINE";
}

// Các hàm getSchedulesByTeacher và getSchedulesByClass không liên quan đến scheduler, có thể xóa hoặc giữ.
// Tôi sẽ giữ nguyên chúng (vì chúng đã được cập nhật từ trước, nhưng trong file này có thể bị trùng lặp với Schedule.service.ts).
// Để tránh lỗi, bạn nên xóa chúng khỏi file này.

let schedulingQueue: Bull.Queue<SchedulerJobData> | null = null;

export function getSchedulingQueue(): Bull.Queue<SchedulerJobData> {
  if (!schedulingQueue) {
    schedulingQueue = new Bull<SchedulerJobData>("scheduling", {
      redis: {
        host: redisConf.host,
        port: redisConf.port,
        password: redisConf.password,
        db: redisConf.db,
      },
    });

    schedulingQueue.process(async (job) => {
      const { teachingUnitIds, config } = job.data;
      const jobId = String(job.id);
      const result = await runCSPScheduler(
        teachingUnitIds,
        config,
        (progress) => {
          job.progress(progress);
          emitSchedulerProgress(jobId, progress);
        },
      );
      emitSchedulerCompleted(jobId, result);
      return result;
    });
  }
  return schedulingQueue;
}

export async function enqueueSchedulingJob(
  data: SchedulerJobData,
): Promise<string> {
  const queue = getSchedulingQueue();
  const job = await queue.add(data, {
    attempts: 2,
    backoff: { type: "exponential", delay: 2000 },
    removeOnComplete: false,
    removeOnFail: false,
  });
  return String(job.id);
}

export async function getJobStatus(jobId: string): Promise<SchedulerJobResult> {
  const queue = getSchedulingQueue();
  const job = await queue.getJob(jobId);

  if (!job) {
    return { jobId, status: "failed", error: "Job not found" };
  }

  const state = await job.getState();
  const progress =
    typeof job.progress === "function"
      ? await (job.progress as () => Promise<number>)()
      : 0;

  if (state === "completed") {
    return {
      jobId,
      status: "completed",
      progress: 100,
      result: job.returnvalue,
    };
  }
  if (state === "failed") {
    return { jobId, status: "failed", error: job.failedReason };
  }
  if (state === "active") {
    return { jobId, status: "running", progress: Number(progress) };
  }
  return { jobId, status: "queued", progress: 0 };
}

/**
 * Validate constraints without creating schedules.
 */
export async function validateSchedules(slots: ScheduledSlot[]): Promise<{
  valid: boolean;
  results: Array<{ slot: ScheduledSlot; violations: unknown[] }>;
}> {
  const results = [];
  let allValid = true;

  for (const slot of slots) {
    const res = await checkAllConstraints({
      teachingUnitId: slot.teachingUnitId,
      roomId: slot.roomId,
      dayOfWeek: slot.dayOfWeek,
      periodStart: slot.periodStart,
      periodEnd: slot.periodEnd,
      academicYear: slot.academicYear,
      weekOfYear: slot.weekOfYear,
      mode: slot.mode,
    });

    if (!res.valid) allValid = false;
    results.push({ slot, violations: res.violations });
  }

  return { valid: allValid, results };
}

// ─── CSP Backtracking Scheduler ──────────────────────────────────────────────

interface TUVariable {
  tuId: string;
  periodsNeeded: number;
  domain: ScheduledSlot[];
  assigned?: ScheduledSlot;
}

async function runCSPScheduler(
  teachingUnitIds: string[],
  config: SchedulerConfig,
  onProgress: (pct: number) => void,
): Promise<ScheduledSlot[]> {
  const allowedDays = config.allowedDays ?? [2, 3, 4, 5, 6, 7];
  const allowedPeriods = config.allowedPeriods ?? [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
  ];
  const weeks = buildWeekRange(config.weekStart, config.weekEnd); // weeks là mảng các weekOfYear
  const academicYear = config.academicYear;

  // Load teaching units with subjects
  const tus = await prisma.teachingUnit.findMany({
    where: { id: { in: teachingUnitIds } },
    include: {
      subject: true,
      assignment: { include: { classGroup: true, teacher: true } },
    },
  });

  // Available rooms
  const rooms = await prisma.room.findMany({ where: { isActive: true } });

  // Build variables with initial domains
  const variables: TUVariable[] = tus.map((tu) => {
    const periodsNeeded = 2; // default 2 periods per session
    const domain = buildDomain(
      tu,
      periodsNeeded,
      allowedDays,
      allowedPeriods,
      weeks,
      rooms,
      academicYear,
    );
    return { tuId: tu.id, periodsNeeded, domain };
  });

  // MRV: sort by domain size ascending (most constrained first)
  variables.sort((a, b) => a.domain.length - b.domain.length);

  const assignment: ScheduledSlot[] = [];
  const total = variables.length;

  const success = await backtrack(variables, 0, assignment, config, (step) => {
    onProgress(Math.floor((step / total) * 100));
  });

  if (!success) {
    throw new Error(
      "CSP scheduler could not find a valid assignment for all teaching units",
    );
  }

  return assignment;
}

function buildWeekRange(start: number, end: number): number[] {
  const weeks: number[] = [];
  for (let w = start; w <= end; w++) weeks.push(w);
  return weeks;
}

function buildDomain(
  tu: {
    id: string;
    subject: { roomType: string };
    assignment: { teacher?: { unavailableSlots: unknown } | null };
  },
  periodsNeeded: number,
  days: number[],
  periods: number[],
  weeks: number[],
  rooms: Array<{ id: string; type: string }>,
  academicYear: string,
): ScheduledSlot[] {
  const domain: ScheduledSlot[] = [];
  const matchingRooms = rooms
    .filter((r) => r.type === tu.subject.roomType)
    .map((r) => r.id);
  const unavailable =
    (tu.assignment.teacher?.unavailableSlots as Array<{
      day: number;
      periodStart: number;
      periodEnd: number;
    }>) ?? [];

  for (const week of weeks) {
    for (const day of days) {
      for (const ps of periods) {
        const pe = ps + periodsNeeded - 1;
        if (pe > 12) continue;

        // Skip if teacher is unavailable
        const blocked = unavailable.some(
          (u) => u.day === day && u.periodStart <= pe && u.periodEnd >= ps,
        );
        if (blocked) continue;

        // OFFLINE slot — needs matching room
        if (matchingRooms.length > 0) {
          for (const roomId of matchingRooms) {
            domain.push({
              teachingUnitId: tu.id,
              dayOfWeek: day,
              periodStart: ps,
              periodEnd: pe,
              academicYear,
              weekOfYear: week,
              roomId,
              mode: "OFFLINE",
            });
          }
        } else {
          // ONLINE fallback
          domain.push({
            teachingUnitId: tu.id,
            dayOfWeek: day,
            periodStart: ps,
            periodEnd: pe,
            academicYear,
            weekOfYear: week,
            mode: "ONLINE",
          });
        }
      }
    }
  }

  return domain;
}

async function backtrack(
  variables: TUVariable[],
  index: number,
  assignment: ScheduledSlot[],
  config: SchedulerConfig,
  onStep: (step: number) => void,
): Promise<boolean> {
  if (index === variables.length) return true;

  onStep(index);
  const variable = variables[index];
  const maxDepth = config.maxBacktrackDepth ?? 1000;

  for (const slot of variable.domain) {
    // Check constraints against already assigned slots
    const res = await checkAllConstraints({
      teachingUnitId: slot.teachingUnitId,
      roomId: slot.roomId,
      dayOfWeek: slot.dayOfWeek,
      periodStart: slot.periodStart,
      periodEnd: slot.periodEnd,
      academicYear: slot.academicYear,
      weekOfYear: slot.weekOfYear,
      mode: slot.mode,
    });

    // Only accept hard-constraint-passing slots
    const hasHardViolation = res.violations.some((v) => v.severity === "error");
    if (hasHardViolation) continue;

    variable.assigned = slot;
    assignment.push(slot);

    if (index < maxDepth) {
      const success = await backtrack(
        variables,
        index + 1,
        assignment,
        config,
        onStep,
      );
      if (success) return true;
    }

    assignment.pop();
    variable.assigned = undefined;
  }

  return false;
}
