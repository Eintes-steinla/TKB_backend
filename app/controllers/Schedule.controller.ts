import { Request, Response, NextFunction } from "express";
import * as ScheduleService from "../services/Schedule.service";

export async function createScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // Nếu roomId truyền lên là chuỗi rỗng từ form, chuyển nó về null / undefined
    if (
      req.body.roomId === "" ||
      req.body.roomId === "null" ||
      req.body.roomId === "undefined"
    ) {
      req.body.roomId = null;
    }

    const schedule = await ScheduleService.createSchedule(req.body);
    res.status(201).json(schedule);
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

    const schedule = await ScheduleService.updateSchedule(
      req.params.id,
      req.body,
    );
    res.status(200).json(schedule);
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
    await ScheduleService.deleteSchedule(req.params.id);
    res.status(204).send();
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

    // FIX: Gọi đúng tên hàm getSchedulesByTeacher
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

    // FIX: Gọi đúng tên hàm getSchedulesByClass
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

    // FIX: Gọi đúng tên hàm getSchedulesByRoom với 2 tham số (roomId, weekOfYear)
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

    // FIX: Gọi đúng tên hàm getSchedulesByWeek, đổi thứ tự tham số (academicYear, weekOfYear)
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
