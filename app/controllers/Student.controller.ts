import { Request, Response, NextFunction } from "express";
import { prisma } from "../database/Postgres.database";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";
import bcrypt from "bcryptjs";

function removeVietnameseTones(str: string): string {
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .replace(/[^a-zA-Z0-9]/g, "")
    .toLowerCase();
}

// Helper: lấy danh sách student kèm user và classGroup
export async function getStudentsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { search, classGroupId } = req.query;
    const students = await prisma.student.findMany({
      where: {
        ...(classGroupId ? { classGroupId: classGroupId as string } : {}),
        ...(search
          ? {
              OR: [
                {
                  studentCode: {
                    contains: search as string,
                    mode: "insensitive",
                  },
                },
                {
                  user: {
                    name: { contains: search as string, mode: "insensitive" },
                  },
                },
                {
                  user: {
                    email: { contains: search as string, mode: "insensitive" },
                  },
                },
              ],
            }
          : {}),
      },
      include: {
        user: { select: { name: true, email: true } },
        classGroup: { select: { code: true } },
      },
      orderBy: { studentCode: "asc" },
    });
    res.status(200).json(students);
  } catch (err) {
    next(err);
  }
}

export async function getStudentsByClassHandler(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const { classId } = req.params;
    const students = await prisma.student.findMany({
      where: { classGroupId: classId },
      include: { user: { select: { name: true, email: true } } },
    });
    res.json(students);
  } catch (err) {
    next(err);
  }
}

export async function getStudentByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const student = await prisma.student.findUnique({
      where: { id: req.params.id },
      include: {
        user: { select: { name: true, email: true } },
        classGroup: { select: { code: true } },
      },
    });
    if (!student) throw new NotFoundError("Student");
    res.status(200).json(student);
  } catch (err) {
    next(err);
  }
}

// 1. THÊM SINH VIÊN & TỰ ĐỘNG TĂNG STUDENTCOUNT CỦA LỚP ĐÓ
export async function createStudentHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { name, email, password, studentCode, classGroupId } = req.body;

    if (!name || name.trim() === "") {
      res.status(400).json({ message: "Họ tên sinh viên không được để trống" });
      return;
    }
    if (!classGroupId) {
      res.status(400).json({ message: "Vui lòng chọn lớp học" });
      return;
    }

    const trimmedName = name.trim();

    // Lấy thông tin lớp để tự sinh MSSV theo khóa (Kxx)
    const classGroup = await prisma.classGroup.findUnique({
      where: { id: classGroupId },
      select: { code: true },
    });

    if (!classGroup) {
      res.status(404).json({ message: "Lớp học đã chọn không tồn tại" });
      return;
    }

    // Logic tự sinh MSSV
    let finalStudentCode = studentCode ? studentCode.trim() : "";
    if (!finalStudentCode) {
      const cohortMatch = classGroup.code.match(/K(\d+)/i);
      if (!cohortMatch) {
        res.status(400).json({ message: `Mã lớp không đúng định dạng -Kxx` });
        return;
      }
      const cohortNumber = parseInt(cohortMatch[1], 10);
      const prefixYear = (cohortNumber + 8).toString();

      const lastStudent = await prisma.student.findFirst({
        where: { studentCode: { startsWith: prefixYear } },
        orderBy: { studentCode: "desc" },
      });

      if (lastStudent && /^\d+$/.test(lastStudent.studentCode)) {
        finalStudentCode = (
          parseInt(lastStudent.studentCode, 10) + 1
        ).toString();
      } else {
        finalStudentCode = `${prefixYear}0001`;
      }
    }

    // Logic tự sinh Email
    let finalEmail = email ? email.trim().toLowerCase() : "";
    if (!finalEmail) {
      const nameParts = trimmedName.split(/\s+/);
      const firstName = nameParts[nameParts.length - 1];
      finalEmail = `${removeVietnameseTones(firstName)}${finalStudentCode}@student.hactech.edu.vn`;
    }

    const rawPassword =
      password && password.trim() !== "" ? password : "Student@123";
    const hashedPassword = bcrypt.hashSync(rawPassword, 10);

    // Dùng Transaction để liên kết refId tự động và tuyệt đối an toàn
    const result = await prisma.$transaction(async (tx) => {
      // Bước 1: Tạo tài khoản User gốc trước
      const user = await tx.user.create({
        data: {
          email: finalEmail,
          passwordHash: hashedPassword,
          role: "STUDENT",
          name: trimmedName,
        },
      });

      // Bước 2: Tạo thông tin Student liên kết với User vừa tạo
      const student = await tx.student.create({
        data: {
          userId: user.id,
          studentCode: finalStudentCode,
          classGroupId,
        },
        include: {
          user: { select: { name: true, email: true } },
          classGroup: { select: { code: true } },
        },
      });

      // Bước 3: CẬP NHẬT NGƯỢC REFID VÀO BẢNG USERS
      // (Kiểm tra nếu trong model User của bạn có trường refId, tiến hành update)
      await tx.user.update({
        where: { id: user.id },
        data: {
          refId: student.id, // Gán ID của sinh viên vừa sinh ra vào cột refId của user
        },
      });

      // Bước 4: Tự động cập nhật tăng sĩ số lớp (studentCount)
      await tx.classGroup.update({
        where: { id: classGroupId },
        data: { studentCount: { increment: 1 } },
      });

      return student;
    });

    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
}

// 2. CHỈNH SỬA SINH VIÊN & ĐIỀU CHỈNH STUDENTCOUNT KHI THAY ĐỔI CHUYỂN LỚP (TRỪ LỚP CŨ, CỘNG LỚP MỚI)
export async function updateStudentHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { id } = req.params;
    const { name, email, password, studentCode, classGroupId } = req.body;

    // Lấy thông tin sinh viên hiện tại trước khi cập nhật để lấy classGroupId cũ và userId
    const existingStudent = await prisma.student.findUnique({
      where: { id },
      select: { classGroupId: true, userId: true },
    });

    if (!existingStudent) {
      throw new NotFoundError("Không tìm thấy sinh viên");
    }

    const updatedStudent = await prisma.$transaction(async (tx) => {
      // 1. Cập nhật bảng tài khoản User nếu có thay đổi thông tin cá nhân
      const updateUserData: any = {};
      if (name !== undefined) updateUserData.name = name.trim();
      if (email !== undefined)
        updateUserData.email = email.trim().toLowerCase();
      if (password && password.length >= 8) {
        updateUserData.passwordHash = bcrypt.hashSync(password, 10);
      }

      if (Object.keys(updateUserData).length > 0) {
        await tx.user.update({
          where: { id: existingStudent.userId },
          data: updateUserData,
        });
      }

      // 2. Cập nhật thông tin bảng Student
      const updateStudentData: any = {};
      if (studentCode !== undefined)
        updateStudentData.studentCode = studentCode.trim();
      if (classGroupId !== undefined)
        updateStudentData.classGroupId = classGroupId;

      const student = await tx.student.update({
        where: { id },
        data: updateStudentData,
        include: {
          user: { select: { name: true, email: true } },
          classGroup: { select: { code: true } },
        },
      });

      // 🌟 3. TỰ TÍNH TOÁN LẠI STUDENTCOUNT KHI SINH VIÊN CHUYỂN LỚP:
      if (classGroupId && classGroupId !== existingStudent.classGroupId) {
        // Trừ sĩ số lớp cũ đi 1
        await tx.classGroup.update({
          where: { id: existingStudent.classGroupId },
          data: { studentCount: { decrement: 1 } },
        });

        // Cộng sĩ số lớp mới lên 1
        await tx.classGroup.update({
          where: { id: classGroupId },
          data: { studentCount: { increment: 1 } },
        });
      }

      return student;
    });

    res.status(200).json(updatedStudent);
  } catch (err) {
    next(err);
  }
}

// 3. XÓA SINH VIÊN & TỰ ĐỘNG GIẢM STUDENTCOUNT CỦA LỚP ĐÓ
export async function deleteStudentHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { id } = req.params;

    const student = await prisma.student.findUnique({
      where: { id },
      select: { classGroupId: true, userId: true },
    });

    if (!student) {
      res.status(404).json({ message: "Không tìm thấy sinh viên" });
      return;
    }

    await prisma.$transaction(async (tx) => {
      // 1. Xóa bản ghi Student phụ trước
      await tx.student.delete({ where: { id } });

      // 2. Xóa tài khoản User chính liên kết
      await tx.user.delete({ where: { id: student.userId } });

      // 🌟 3. CẬP NHẬT LỚP HỌC: Giảm sĩ số của lớp học hiện tại đi 1
      await tx.classGroup.update({
        where: { id: student.classGroupId },
        data: { studentCount: { decrement: 1 } },
      });
    });

    res.status(200).json({
      message: "Xóa sinh viên và cập nhật lại sĩ số lớp học thành công",
    });
  } catch (err) {
    next(err);
  }
}
