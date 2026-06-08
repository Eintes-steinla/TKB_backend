import { Request, Response, NextFunction } from "express";
import { prisma } from "../database/Postgres.database";
import { RoomFilters } from "../models/Room.model";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";
import { getSchedulesByRoom } from "../services/Schedule.service";

export async function getRoomsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { type, locationId, isActive } = req.query;
    const filters: RoomFilters = {};
    if (type) filters.type = type as "THEORY" | "PRACTICE" | "HALL";
    if (locationId) filters.locationId = locationId as string;
    if (isActive !== undefined) filters.isActive = isActive === "true";

    const rooms = await prisma.room.findMany({
      where: {
        ...(filters.type ? { type: filters.type } : {}),
        ...(filters.locationId ? { locationId: filters.locationId } : {}),
        ...(filters.isActive !== undefined
          ? { isActive: filters.isActive }
          : {}),
      },
      include: { location: true },
      orderBy: { code: "asc" },
    });
    res.status(200).json(rooms);
  } catch (err) {
    next(err);
  }
}

export async function getRoomByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const room = await prisma.room.findUnique({
      where: { id: req.params.id },
      include: { location: true },
    });
    if (!room) throw new NotFoundError("Room");
    res.status(200).json(room);
  } catch (err) {
    next(err);
  }
}

export async function createRoomHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { code, type, capacity, locationId, isActive } = req.body;

    if (!code) {
      res.status(400).json({ message: "Mã phòng học không được để trống" });
      return;
    }

    const cleanCode = code.trim();

    // 🔥 TỰ SINH ID: Chuyển toàn bộ về chữ thường và xóa sạch khoảng trắng thừa (ví dụ: "A17 - 401" -> "room_a17-401")
    const generatedId = `room_${cleanCode.toLowerCase().replace(/\s+/g, "")}`;

    const parsedCapacity =
      capacity !== undefined && capacity !== null && capacity !== ""
        ? Number(capacity)
        : 60;

    const room = await prisma.room.create({
      data: {
        id: generatedId, // 🌟 Ép Prisma dùng ID tự sinh này thay vì để DB tạo chuỗi ngẫu nhiên
        code: cleanCode,
        type: type,
        capacity: parsedCapacity,
        locationId: locationId,
        isActive: isActive !== undefined ? !!isActive : true,
      },
      include: { location: true },
    });

    res.status(201).json(room);
  } catch (err: any) {
    // 🌟 Đánh chặn lỗi trùng khóa chính / trùng mã phòng (Lỗi P2002 của Prisma)
    if (err.code === "P2002") {
      res.status(400).json({
        message:
          "Mã phòng học này đã tồn tại trong cơ sở dữ liệu, vui lòng kiểm tra lại!",
      });
      return;
    }
    next(err);
  }
}

export async function updateRoomHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const room = await prisma.room.update({
      where: { id: req.params.id },
      data: req.body,
      include: { location: true },
    });
    res.status(200).json(room);
  } catch (err) {
    next(err);
  }
}

export async function deleteRoomHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    await prisma.room.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

export async function getRoomScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const week = req.query.week ? Number(req.query.week) : undefined;
    const schedules = await getSchedulesByRoom(req.params.id, week);
    res.status(200).json(schedules);
  } catch (err) {
    next(err);
  }
}
