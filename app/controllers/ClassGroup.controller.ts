import { Request, Response, NextFunction } from "express";
import { prisma } from "../database/Postgres.database";
import { ClassGroupFilters } from "../models/ClassGroup.model";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";

// 1. LẤY DANH SÁCH LỚP (Có kèm bộ lọc theo ngành/khóa nếu cần)
export async function getClassGroupsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { majorId, cohortId } = req.query;
    const filters: ClassGroupFilters = {};
    if (majorId) filters.majorId = majorId as string;
    if (cohortId) filters.cohortId = cohortId as string;

    const classGroups = await prisma.classGroup.findMany({
      where: {
        ...(filters.majorId ? { majorId: filters.majorId } : {}),
        ...(filters.cohortId ? { cohortId: filters.cohortId } : {}),
      },
      include: {
        major: true,
        cohort: true,
      },
      orderBy: { code: "asc" },
    });
    res.status(200).json(classGroups);
  } catch (err) {
    next(err);
  }
}

// 2. LẤY CHI TIẾT MỘT LỚP THEO ID
export async function getClassGroupByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const classGroup = await prisma.classGroup.findUnique({
      where: { id: req.params.id },
      include: { major: true, cohort: true },
    });
    if (!classGroup) throw new NotFoundError("ClassGroup");
    res.status(200).json(classGroup);
  } catch (err) {
    next(err);
  }
}

// 3. TẠO MỚI LỚP HỌC (Sĩ số mặc định = 0)
export async function createClassGroupHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { majorId, cohortId, code } = req.body;

    const cleanCode = code.trim();

    const classGroup = await prisma.classGroup.create({
      data: {
        majorId: majorId,
        cohortId: cohortId,
        code: cleanCode,
        studentCount: 0, // 🌟 Ép sĩ số mặc định ban đầu luôn luôn bằng 0
      },
      include: { major: true, cohort: true },
    });

    res.status(201).json(classGroup);
  } catch (err: any) {
    // 🌟 Đánh chặn lỗi trùng mã lớp (Lỗi P2002 hệ thống database)
    if (err.code === "P2002") {
      res.status(400).json({
        message:
          "Mã lớp học này đã tồn tại trong hệ thống, vui lòng nhập mã khác!",
      });
      return;
    }
    next(err);
  }
}

// 4. CẬP NHẬT LỚP HỌC
export async function updateClassGroupHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { majorId, cohortId, code } = req.body;

    // Ngăn chặn việc client cố tình cập nhật sửa sĩ số thông qua API này
    const payload: any = {};
    if (majorId) payload.majorId = majorId;
    if (cohortId) payload.cohortId = cohortId;
    if (code) payload.code = code.trim();

    const classGroup = await prisma.classGroup.update({
      where: { id: req.params.id },
      data: payload,
      include: { major: true, cohort: true },
    });
    res.status(200).json(classGroup);
  } catch (err: any) {
    if (err.code === "P2002") {
      res.status(400).json({
        message: "Mã lớp học này đã bị trùng với một lớp khác tồn tại sẵn!",
      });
      return;
    }
    next(err);
  }
}

// 5. XÓA LỚP HỌC
export async function deleteClassGroupHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // Lưu ý: Nếu lớp đã có sinh viên, DB có thể chặn cascade tùy vào cấu hình quan hệ của bạn
    await prisma.classGroup.delete({
      where: { id: req.params.id },
    });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}
