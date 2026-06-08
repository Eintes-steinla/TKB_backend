import { prisma } from "../database/Postgres.database";
import {
  checkAllConstraints,
  persistViolations,
  ScheduleInput,
} from "./Constraint.service";
import { NotFoundError, AppError } from "../middleware/ErrorHandler.middleware";
import { CreateScheduleDto, UpdateScheduleDto } from "../models/Schedule.model";
import { invalidateCache } from "../middleware/Cache.middleware";
import {
  emitScheduleCreated,
  emitScheduleDeleted,
  emitConflictDetected,
} from "../socket/events";

const scheduleInclude = {
  teachingUnit: {
    include: {
      subject: true,
      assignment: {
        include: {
          teacher: { include: { user: true } },
          classGroup: true,
        },
      },
    },
  },
  room: { include: { location: true } },
  violations: true,
};

function mapScheduleData(s: any) {
  const assignment = s?.teachingUnit?.assignment;
  if (assignment) {
    if (assignment.teacher) {
      assignment.teacher = {
        id: assignment.teacher.id,
        code: assignment.teacher.code || "N/A",
        name: assignment.teacher.user?.name || "Chưa cập nhật",
      };
    } else {
      assignment.teacher = {
        id: "no-teacher",
        code: "N/A",
        name: "Chưa phân công giảng viên",
      };
    }
  }
  return s;
}

/** Lấy classGroupId từ schedule đã include để emit socket đúng room */
function getClassId(schedule: any): string {
  return schedule?.teachingUnit?.assignment?.classGroup?.id ?? "";
}

export async function createSchedule(data: CreateScheduleDto) {
  const input: ScheduleInput = {
    teachingUnitId: data.teachingUnitId,
    roomId: data.roomId || null,
    dayOfWeek: data.dayOfWeek,
    periodStart: data.periodStart,
    periodEnd: data.periodEnd,
    academicYear: data.academicYear,
    weekOfYear: data.weekOfYear,
    mode: data.mode,
  };

  const result = await checkAllConstraints(input);
  if (!result.valid) {
    const errorMsg = result.violations
      .filter((v) => v.severity === "error")
      .map((v) => v.message)
      .join(", ");
    if (errorMsg) throw new AppError(errorMsg, 400);
  }

  const schedule = await prisma.schedule.create({
    data: input,
    include: scheduleInclude,
  });
  await persistViolations(schedule.id, result.violations);
  await invalidateScheduleCache();

  // FIX: emitConflictDetected nhận 1 object { scheduleId, violations }
  if (result.violations.length > 0) {
    emitConflictDetected({
      scheduleId: schedule.id,
      violations: result.violations,
    });
  }
  // FIX: emitScheduleCreated(classId: string, schedule: unknown)
  emitScheduleCreated(getClassId(schedule), schedule);

  return mapScheduleData(schedule);
}

export async function updateSchedule(id: string, data: UpdateScheduleDto) {
  const existing = await prisma.schedule.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError("Schedule");

  const input: ScheduleInput = {
    teachingUnitId: data.teachingUnitId || existing.teachingUnitId,
    roomId: data.roomId !== undefined ? data.roomId : existing.roomId,
    dayOfWeek: data.dayOfWeek ?? existing.dayOfWeek,
    periodStart: data.periodStart ?? existing.periodStart,
    periodEnd: data.periodEnd ?? existing.periodEnd,
    academicYear: data.academicYear || existing.academicYear,
    weekOfYear: data.weekOfYear ?? existing.weekOfYear,
    mode: data.mode || existing.mode,
  };

  const result = await checkAllConstraints(input);
  if (!result.valid) {
    const errorMsg = result.violations
      .filter((v) => v.severity === "error")
      .map((v) => v.message)
      .join(", ");
    if (errorMsg) throw new AppError(errorMsg, 400);
  }

  await prisma.constraintViolationLog.deleteMany({ where: { scheduleId: id } });
  const updated = await prisma.schedule.update({
    where: { id },
    data: input,
    include: scheduleInclude,
  });
  await persistViolations(updated.id, result.violations);
  await invalidateScheduleCache();

  // FIX: emitConflictDetected nhận 1 object { scheduleId, violations }
  if (result.violations.length > 0) {
    emitConflictDetected({
      scheduleId: updated.id,
      violations: result.violations,
    });
  }

  return mapScheduleData(updated);
}

export async function deleteSchedule(id: string) {
  // Fetch with include để lấy classGroupId trước khi xóa
  const existing = await prisma.schedule.findUnique({
    where: { id },
    include: scheduleInclude,
  });
  if (!existing) throw new NotFoundError("Schedule");

  const classId = getClassId(existing);

  await prisma.constraintViolationLog.deleteMany({ where: { scheduleId: id } });
  await prisma.schedule.delete({ where: { id } });
  await invalidateScheduleCache();

  // FIX: emitScheduleDeleted(classId: string, scheduleId: string)
  emitScheduleDeleted(classId, id);
}

export async function getSchedulesByClass(
  classId: string,
  academicYear?: string,
  week?: number,
) {
  const schedules = await prisma.schedule.findMany({
    where: {
      teachingUnit: { assignment: { classGroupId: classId } },
      ...(academicYear ? { academicYear } : {}),
      ...(week ? { weekOfYear: week } : {}),
    },
    include: scheduleInclude,
  });
  return schedules.map(mapScheduleData);
}

export async function getSchedulesByTeacher(
  teacherId: string,
  academicYear?: string,
  week?: number,
) {
  const schedules = await prisma.schedule.findMany({
    where: {
      teachingUnit: { assignment: { teacherId } },
      ...(academicYear ? { academicYear } : {}),
      ...(week ? { weekOfYear: week } : {}),
    },
    include: scheduleInclude,
  });
  return schedules.map(mapScheduleData);
}

export async function getSchedulesByRoom(roomId: string, week?: number) {
  const schedules = await prisma.schedule.findMany({
    where: {
      roomId,
      ...(week ? { weekOfYear: week } : {}),
    },
    include: scheduleInclude,
  });
  return schedules.map(mapScheduleData);
}

export async function getSchedulesByWeek(
  academicYear: string,
  weekNum: number,
) {
  const schedules = await prisma.schedule.findMany({
    where: {
      weekOfYear: weekNum,
      ...(academicYear ? { academicYear } : {}),
    },
    include: scheduleInclude,
  });
  return schedules.map(mapScheduleData);
}

export async function getAllSchedulesPaginated(options: any) {
  const {
    page,
    limit,
    search,
    sortKey = "dayOfWeek",
    sortDir = "asc",
    academicYear,
    cohortId,
    weekOfYear,
  } = options;
  const skip = (page - 1) * limit;

  const where: any = {};
  if (academicYear) where.academicYear = academicYear;
  if (weekOfYear) where.weekOfYear = weekOfYear;
  if (cohortId) {
    where.teachingUnit = { assignment: { classGroup: { cohortId } } };
  }
  if (search && search.trim() !== "") {
    where.OR = [
      { teachingUnit: { name: { contains: search, mode: "insensitive" } } },
      { room: { code: { contains: search, mode: "insensitive" } } },
    ];
  }

  const [schedules, total] = await prisma.$transaction([
    prisma.schedule.findMany({
      skip,
      take: limit,
      where,
      orderBy: { [sortKey]: sortDir },
      include: scheduleInclude,
    }),
    prisma.schedule.count({ where }),
  ]);

  return { schedules: schedules.map(mapScheduleData), total, page, limit };
}

export async function getConflicts() {
  const logs = await prisma.constraintViolationLog.findMany({
    where: { resolvedAt: null },
    include: { schedule: { include: scheduleInclude } },
    orderBy: { createdAt: "desc" },
  });
  return logs.map((l: any) => {
    if (l.schedule) l.schedule = mapScheduleData(l.schedule);
    return l;
  });
}

async function invalidateScheduleCache() {
  try {
    await invalidateCache("schedules*");
  } catch (e) {
    console.warn("Lỗi dọn cache:", e);
  }
}
