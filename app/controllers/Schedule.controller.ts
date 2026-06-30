import { Request, Response, NextFunction } from "express";
import * as ScheduleService from "../services/Schedule.service";
import { sendNotificationToTopic } from "../services/Fcm.service";
import { prisma } from "../database/Postgres.database";

const DAY_NAMES: Record<number, string> = {
  2: "Thứ 2",
  3: "Thứ 3",
  4: "Thứ 4",
  5: "Thứ 5",
  6: "Thứ 6",
  7: "Thứ 7",
};

function getSubjectAndClass(schedule: any): {
  subjectName: string;
  classCode: string;
} {
  return {
    subjectName: schedule?.teachingUnit?.subject?.name ?? "Môn học",
    classCode: schedule?.teachingUnit?.assignment?.classGroup?.code ?? "",
  };
}

export async function createScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    if (
      req.body.roomId === "" ||
      req.body.roomId === "null" ||
      req.body.roomId === "undefined"
    ) {
      req.body.roomId = null;
    }

    const schedule = await ScheduleService.createSchedule(req.body);
    res.status(201).json(schedule);

    // ── Thông báo lịch mới được tạo ──
    const { subjectName, classCode } = getSubjectAndClass(schedule);
    const dayLabel =
      DAY_NAMES[(schedule as any).dayOfWeek] ??
      `Thứ ${(schedule as any).dayOfWeek}`;
    const roomCode = (schedule as any).room?.code ?? "chưa xếp phòng";

    const title = `Lịch mới: ${subjectName}${classCode ? ` (${classCode})` : ""}`;
    const body = `${dayLabel}, tiết ${(schedule as any).periodStart}-${
      (schedule as any).periodEnd
    }, tuần ${(schedule as any).weekOfYear}, phòng ${roomCode}.`;

    sendNotificationToTopic("role_student", title, body);
    sendNotificationToTopic("role_teacher", title, body);
  } catch (err) {
    next(err);
  }
}

export async function updateScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    if (
      req.body.roomId === "" ||
      req.body.roomId === "null" ||
      req.body.roomId === "undefined"
    ) {
      req.body.roomId = null;
    }

    // Lấy schedule cũ kèm room để so sánh sau khi update
    const oldSchedule = await prisma.schedule.findUnique({
      where: { id: req.params.id },
      include: { room: true },
    });

    const schedule = await ScheduleService.updateSchedule(
      req.params.id,
      req.body,
    );

    res.status(200).json(schedule);

    // ── Gửi thông báo chi tiết theo đúng thay đổi ──
    if (oldSchedule) {
      const { subjectName, classCode } = getSubjectAndClass(schedule);
      const changes: string[] = [];

      const oldRoomCode = oldSchedule.room?.code ?? null;
      const newRoomCode = (schedule as any).room?.code ?? null;
      if (oldSchedule.roomId !== (schedule as any).roomId) {
        changes.push(
          `chuyển phòng từ ${oldRoomCode ?? "chưa xếp"} sang ${
            newRoomCode ?? "chưa xếp"
          }`,
        );
      }

      if (
        oldSchedule.periodStart !== (schedule as any).periodStart ||
        oldSchedule.periodEnd !== (schedule as any).periodEnd
      ) {
        changes.push(
          `đổi tiết ${oldSchedule.periodStart}-${oldSchedule.periodEnd} sang tiết ${
            (schedule as any).periodStart
          }-${(schedule as any).periodEnd}`,
        );
      }

      if (oldSchedule.dayOfWeek !== (schedule as any).dayOfWeek) {
        const oldDay =
          DAY_NAMES[oldSchedule.dayOfWeek] ?? `Thứ ${oldSchedule.dayOfWeek}`;
        const newDay =
          DAY_NAMES[(schedule as any).dayOfWeek] ??
          `Thứ ${(schedule as any).dayOfWeek}`;
        changes.push(`chuyển từ ${oldDay} sang ${newDay}`);
      }

      if (oldSchedule.weekOfYear !== (schedule as any).weekOfYear) {
        changes.push(
          `chuyển từ tuần ${oldSchedule.weekOfYear} sang tuần ${
            (schedule as any).weekOfYear
          }`,
        );
      }

      if (oldSchedule.mode !== (schedule as any).mode) {
        changes.push(
          `đổi hình thức từ ${oldSchedule.mode} sang ${(schedule as any).mode}`,
        );
      }

      const changeText =
        changes.length > 0 ? changes.join("; ") : "có cập nhật thông tin";

      const title = `Lịch ${subjectName}${classCode ? ` (${classCode})` : ""} đã thay đổi`;
      const body = `${changeText.charAt(0).toUpperCase()}${changeText.slice(1)}.`;

      sendNotificationToTopic("role_student", title, body);
      sendNotificationToTopic("role_teacher", title, body);
    }
  } catch (err) {
    next(err);
  }
}

export async function deleteScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // Lấy thông tin trước khi xóa để báo đúng nội dung
    const existing = await prisma.schedule.findUnique({
      where: { id: req.params.id },
      include: {
        teachingUnit: {
          include: {
            subject: true,
            assignment: { include: { classGroup: true } },
          },
        },
      },
    });

    await ScheduleService.deleteSchedule(req.params.id);
    res.status(204).send();

    // ── Thông báo xóa lịch ──
    if (existing) {
      const { subjectName, classCode } = getSubjectAndClass(existing);
      const dayLabel =
        DAY_NAMES[existing.dayOfWeek] ?? `Thứ ${existing.dayOfWeek}`;

      const title = `Lịch đã bị xóa: ${subjectName}${classCode ? ` (${classCode})` : ""}`;
      const body = `${dayLabel}, tiết ${existing.periodStart}-${existing.periodEnd}, tuần ${existing.weekOfYear} không còn diễn ra.`;

      sendNotificationToTopic("role_student", title, body);
      sendNotificationToTopic("role_teacher", title, body);
    }
  } catch (err) {
    next(err);
  }
}

export async function getByTeacherHandler(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const { id } = req.params;
    const { academicYear, week } = req.query;

    if (!academicYear || !week) {
      res.status(400).json({
        message: "Missing required query parameters: academicYear and week",
      });
      return;
    }

    const weekOfYear = parseInt(week as string, 10);
    if (isNaN(weekOfYear) || weekOfYear < 1 || weekOfYear > 40) {
      res
        .status(400)
        .json({ message: "Week must be a number between 1 and 40" });
      return;
    }

    const schedules = await ScheduleService.getSchedulesByTeacher(
      id,
      academicYear as string,
      weekOfYear,
    );
    res.status(200).json(schedules);
  } catch (err) {
    next(err);
  }
}

export async function getByClassHandler(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const { classId } = req.params;
    const { academicYear, week } = req.query;

    if (!academicYear || !week) {
      res.status(400).json({
        message: "Missing required query parameters: academicYear and week",
      });
      return;
    }

    const weekOfYear = parseInt(week as string, 10);
    if (isNaN(weekOfYear) || weekOfYear < 1 || weekOfYear > 40) {
      res
        .status(400)
        .json({ message: "Week must be a number between 1 and 40" });
      return;
    }

    const schedules = await ScheduleService.getSchedulesByClass(
      classId,
      academicYear as string,
      weekOfYear,
    );
    res.status(200).json(schedules);
  } catch (err) {
    next(err);
  }
}

export async function getByRoomHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { roomId } = req.params;
    const { academicYear, week } = req.query;

    if (!academicYear || !week) {
      res.status(400).json({
        message: "Missing required query parameters: academicYear and week",
      });
      return;
    }

    const weekOfYear = parseInt(week as string, 10);
    if (isNaN(weekOfYear) || weekOfYear < 1 || weekOfYear > 40) {
      res
        .status(400)
        .json({ message: "Week must be a number between 1 and 40" });
      return;
    }

    const schedules = await ScheduleService.getSchedulesByRoom(
      roomId,
      weekOfYear,
    );
    res.status(200).json(schedules);
  } catch (err) {
    next(err);
  }
}

export async function getByWeekHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { academicYear, week } = req.query;

    if (!academicYear || !week) {
      res.status(400).json({
        message: "Missing required query parameters: academicYear and week",
      });
      return;
    }

    const weekOfYear = parseInt(week as string, 10);
    if (isNaN(weekOfYear) || weekOfYear < 1 || weekOfYear > 40) {
      res
        .status(400)
        .json({ message: "Week must be a number between 1 and 40" });
      return;
    }

    const schedules = await ScheduleService.getSchedulesByWeek(
      academicYear as string,
      weekOfYear,
    );
    res.status(200).json(schedules);
  } catch (err) {
    next(err);
  }
}

export async function getConflictsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const conflicts = await ScheduleService.getConflicts();
    res.status(200).json(conflicts);
  } catch (err) {
    next(err);
  }
}

export async function getAllSchedulesHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = Math.min(parseInt(req.query.limit as string) || 50, 200);
    const search = req.query.search as string;
    const sortKey = req.query.sortKey as string;
    const sortDir = req.query.sortDir as "asc" | "desc";

    const academicYear = req.query.academicYear as string;
    const cohortId = req.query.cohortId as string;
    const weekParam = req.query.weekOfYear;
    const weekOfYear = weekParam
      ? parseInt(weekParam as string, 10)
      : undefined;

    const result = await ScheduleService.getAllSchedulesPaginated({
      page,
      limit,
      search,
      sortKey,
      sortDir,
      academicYear,
      weekOfYear,
      cohortId,
    });
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
}
