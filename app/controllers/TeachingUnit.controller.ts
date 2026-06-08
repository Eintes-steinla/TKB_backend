import { Request, Response, NextFunction } from "express";
import { prisma } from "../database/Postgres.database";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";

const tuInclude = {
  subject: true,
  assignment: {
    include: {
      teacher: { include: { user: true } },
      classGroup: true,
    },
  },
};

// Hàm hỗ trợ map dữ liệu phẳng tên giảng viên tương thích với Frontend cũ
function mapTeachingUnitData(unit: any) {
  if (unit && unit.assignment && unit.assignment.teacher) {
    unit.assignment.teacher = {
      ...unit.assignment.teacher,
      name: unit.assignment.teacher.user?.name || "Chưa cập nhật",
    };
  }
  return unit;
}

// 1. LẤY DANH SÁCH ĐƠN VỊ GIẢNG DẠY
export async function getTeachingUnitsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { subjectId, assignmentId, type } = req.query;
    const units = await prisma.teachingUnit.findMany({
      where: {
        ...(subjectId ? { subjectId: subjectId as string } : {}),
        ...(assignmentId ? { assignmentId: assignmentId as string } : {}),
        ...(type ? { type: type as "THEORY" | "PRACTICE" | "EXERCISE" } : {}),
      },
      include: tuInclude,
      orderBy: { name: "asc" },
    });

    const mappedUnits = units.map(mapTeachingUnitData);
    res.status(200).json(mappedUnits);
  } catch (err) {
    next(err);
  }
}

// 2. LẤY CHI TIẾT THEO ID
export async function getTeachingUnitByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const unit = await prisma.teachingUnit.findUnique({
      where: { id: req.params.id },
      include: tuInclude,
    });
    if (!unit) throw new NotFoundError("TeachingUnit");
    res.status(200).json(mapTeachingUnitData(unit));
  } catch (err) {
    next(err);
  }
}

// 3. TẠO MỚI ĐƠN VỊ GIẢNG DẠY (Tự động hóa hoàn toàn loại và tên)
export async function createTeachingUnitHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { subjectId, assignmentId, conflictGroupId } = req.body;

    // Bước A: Truy vấn thông tin Môn học (Subject)
    const subject = await prisma.subject.findUnique({
      where: { id: subjectId },
    });
    if (!subject) {
      res.status(400).json({ message: "Không tìm thấy môn học hợp lệ!" });
      return;
    }

    // Bước B: Truy vấn thông tin Phân công để lấy mã Lớp học (ClassGroup)
    const assignment = await prisma.assignment.findUnique({
      where: { id: assignmentId },
      include: { classGroup: true },
    });
    if (!assignment || !assignment.classGroup) {
      res
        .status(400)
        .json({ message: "Không tìm thấy thông tin phân công lớp học!" });
      return;
    }

    // Bước C: Tự động phân loại dựa trên tên môn học
    let autoType: "THEORY" | "PRACTICE" | "EXERCISE" = "THEORY";
    const lowerSubjectName = subject.name.toLowerCase();

    if (
      lowerSubjectName.includes("thực hành") ||
      lowerSubjectName.includes("thí nghiệm") ||
      lowerSubjectName.includes("lab") ||
      lowerSubjectName.includes("p") // Ký hiệu lớp hành (nếu có)
    ) {
      autoType = "PRACTICE";
    }

    // Bước D: Tự động sinh tên theo định dạng: "Tên môn học - Tên lớp"
    const autoName = `${subject.name} - ${assignment.classGroup.code}`;

    // Bước E: Tiến hành lưu vào cơ sở dữ liệu
    const unit = await prisma.teachingUnit.create({
      data: {
        subjectId,
        assignmentId,
        conflictGroupId: conflictGroupId || null,
        name: autoName,
        type: autoType,
      },
      include: tuInclude,
    });

    res.status(201).json(mapTeachingUnitData(unit));
  } catch (err) {
    console.error("❌ Lỗi tạo Đơn vị giảng dạy:", err);
    next(err);
  }
}

// 4. CẬP NHẬT ĐƠN VỊ GIẢNG DẠY
export async function updateTeachingUnitHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { subjectId, assignmentId, conflictGroupId } = req.body;
    const payload: any = { conflictGroupId: conflictGroupId || null };

    // Nếu thay đổi môn học hoặc phân công lớp, cập nhật lại cả tên và loại tự động
    if (subjectId || assignmentId) {
      const currentUnit = await prisma.teachingUnit.findUnique({
        where: { id: req.params.id },
      });
      const targetSubjectId = subjectId || currentUnit?.subjectId;
      const targetAssignmentId = assignmentId || currentUnit?.assignmentId;

      const subject = await prisma.subject.findUnique({
        where: { id: targetSubjectId },
      });
      const assignment = await prisma.assignment.findUnique({
        where: { id: targetAssignmentId },
        include: { classGroup: true },
      });

      if (subject && assignment?.classGroup) {
        payload.subjectId = targetSubjectId;
        payload.assignmentId = targetAssignmentId;
        payload.name = `${subject.name} - ${assignment.classGroup.code}`;

        const lowerSubjectName = subject.name.toLowerCase();
        payload.type =
          lowerSubjectName.includes("thực hành") ||
          lowerSubjectName.includes("thí nghiệm") ||
          lowerSubjectName.includes("lab")
            ? "PRACTICE"
            : "THEORY";
      }
    }

    const unit = await prisma.teachingUnit.update({
      where: { id: req.params.id },
      data: payload,
      include: tuInclude,
    });

    res.status(200).json(mapTeachingUnitData(unit));
  } catch (err) {
    next(err);
  }
}

// 5. XÓA ĐƠN VỊ GIẢNG DẠY
export async function deleteTeachingUnitHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const existing = await prisma.teachingUnit.findUnique({
      where: { id: req.params.id },
    });
    if (!existing) throw new NotFoundError("TeachingUnit");

    const schedules = await prisma.schedule.findMany({
      where: { teachingUnitId: req.params.id },
    });
    for (const s of schedules) {
      await prisma.constraintViolationLog.deleteMany({
        where: { scheduleId: s.id },
      });
    }
    await prisma.schedule.deleteMany({
      where: { teachingUnitId: req.params.id },
    });

    await prisma.teachingUnit.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}
