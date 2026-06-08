import { Request, Response, NextFunction } from "express";
import { prisma } from "../database/Postgres.database";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";
import bcrypt from "bcrypt"; // Cần thiết để tạo mật khẩu băm mặc định khi cấp tài khoản mới

// Hàm hỗ trợ chuyển đổi chuỗi tiếng Việt có dấu thành không dấu, viết liền để làm email
function removeVietnameseTones(str: string): string {
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .replace(/[^a-zA-Z0-9]/g, "") // Loại bỏ khoảng trắng và ký tự đặc biệt
    .toLowerCase();
}

// 1. LẤY DANH SÁCH GIẢNG VIÊN (Kèm thông tin User liên kết)
export async function getTeachersHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { search } = req.query;

    const teachers = await prisma.teacher.findMany({
      where: search
        ? {
            OR: [
              { code: { contains: search as string, mode: "insensitive" } },
              { dept: { contains: search as string, mode: "insensitive" } },
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
        : undefined,
      include: {
        user: {
          select: { id: true, name: true, email: true, role: true },
        },
      },
      orderBy: { code: "asc" },
    });
    res.status(200).json(teachers);
  } catch (err) {
    next(err);
  }
}

// 2. LẤY CHI TIẾT MỘT GIẢNG VIÊN THEO ID
export async function getTeacherByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const teacher = await prisma.teacher.findUnique({
      where: { id: req.params.id },
      include: {
        user: {
          select: { id: true, name: true, email: true, role: true },
        },
      },
    });
    if (!teacher) throw new NotFoundError("Teacher");
    res.status(200).json(teacher);
  } catch (err) {
    next(err);
  }
}

// 3. TẠO MỚI GIẢNG VIÊN (Đồng thời tạo tài khoản User)
// HÀM TẠO MỚI GIẢNG VIÊN TỰ ĐỘNG SINH MÃ VÀ EMAIL
// Sửa đoạn cuối cùng của hàm createTeacherHandler trong Backend:
export async function createTeacherHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { name, code, email, dept, password } = req.body;

    if (!name || name.trim() === "") {
      res
        .status(400)
        .json({ message: "Họ tên giảng viên không được để trống" });
      return;
    }
    const trimmedName = name.trim();

    // Logic tự sinh mã GV
    let nextCode = code ? code.trim() : "";
    if (!nextCode) {
      const lastTeacher = await prisma.teacher.findFirst({
        where: { code: { startsWith: "GV" } },
        orderBy: { code: "desc" },
      });
      nextCode = "GV001";
      if (lastTeacher) {
        const lastNumberStr = lastTeacher.code.replace("GV", "");
        const lastNumber = parseInt(lastNumberStr, 10);
        if (!isNaN(lastNumber)) {
          nextCode = `GV${(lastNumber + 1).toString().padStart(3, "0")}`;
        }
      }
    }

    // Logic tự sinh Email giảng viên
    let finalEmail = email ? email.trim().toLowerCase() : "";
    if (!finalEmail) {
      const nameParts = trimmedName.split(/\s+/);
      const firstName = nameParts[nameParts.length - 1];
      finalEmail = `${removeVietnameseTones(firstName).toLowerCase()}@hactech.edu.vn`;
    }

    const rawPassword =
      password && password.trim() !== "" ? password : "Teacher@123";
    const hashedPassword = bcrypt.hashSync(rawPassword, 10);

    // Thực thi tuần tự qua Transaction để gán chặt refId
    const result = await prisma.$transaction(async (tx) => {
      // 1. Tạo bản ghi User trước
      const user = await tx.user.create({
        data: {
          email: finalEmail,
          passwordHash: hashedPassword,
          role: "TEACHER",
          name: trimmedName,
        },
      });

      // 2. Tạo bản ghi Teacher trỏ đến userId
      const teacher = await tx.teacher.create({
        data: {
          userId: user.id,
          code: nextCode,
          dept: dept ? dept.trim() : null,
        },
        include: {
          user: true,
        },
      });

      // 3. CẬP NHẬT NGƯỢC REFID VÀO BẢNG USERS CHO GIẢNG VIÊN
      await tx.user.update({
        where: { id: user.id },
        data: {
          refId: teacher.id, // Gán ID giảng viên vào cột refId
        },
      });

      return teacher;
    });

    res.status(201).json(result);
  } catch (err: any) {
    if (err.code === "P2002") {
      res.status(400).json({
        message: "Mã giảng viên hoặc Email đã tồn tại trên hệ thống!",
      });
      return;
    }
    next(err);
  }
}

// 4. CẬP NHẬT THÔNG TIN GIẢNG VIÊN & TÀI KHOẢN
export async function updateTeacherHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { name, email, code, dept } = req.body;

    // 🌟 1. Khởi tạo Object chứa dữ liệu thay đổi ở phạm vi gốc của hàm
    const updateData: any = {};

    // Kiểm tra và chuẩn hóa dữ liệu Mã giảng viên nếu có truyền lên
    if (code !== undefined) {
      updateData.code = code.trim();
    }

    // Kiểm tra và chuẩn hóa dữ liệu Khoa/Viện (Tối ưu theo SonarLint tránh toán tử 3 ngôi lồng nhau)
    if (dept !== undefined) {
      updateData.dept = dept && dept.trim() !== "" ? dept.trim() : null;
    }

    // Kiểm tra dữ liệu liên quan đến bảng User (Họ tên, Email)
    if (name !== undefined || email !== undefined) {
      updateData.user = {
        update: {
          name: name ? name.trim() : undefined,
          email: email ? email.trim().toLowerCase() : undefined,
        },
      };
    }

    // 🌟 2. Thực hiện cập nhật dữ liệu xuống PostgreSQL thông qua Prisma
    const updated = await prisma.teacher.update({
      where: { id: req.params.id },
      data: updateData,
      include: { user: true },
    });

    // 🌟 3. Trả về cấu trúc lồng nhau chứa object 'user' để khớp 100% với giao diện Frontend React
    res.status(200).json({
      id: updated.id,
      code: updated.code,
      dept: updated.dept || "",
      user: {
        id: updated.user.id,
        name: updated.user.name,
        email: updated.user.email,
      },
    });
  } catch (err: any) {
    // Đón đầu lỗi trùng lặp mã giảng viên hoặc email khác trong hệ thống
    if (err.code === "P2002") {
      res.status(400).json({
        message:
          "Dữ liệu cập nhật (Mã hoặc Email) bị trùng lặp với giảng viên khác!",
      });
      return;
    }
    next(err);
  }
}

// 5. XÓA GIẢNG VIÊN
export async function deleteTeacherHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // Do chúng ta thiết lập ON DELETE CASCADE ở mức database hoặc Prisma relation,
    // khi ta xóa bảng Teacher, hoặc xóa bảng User thì bảng còn lại sẽ tự động xóa theo (Tùy thuộc setup của bạn).
    // Ở đây, xóa bản ghi Teacher:
    const teacher = await prisma.teacher.findUnique({
      where: { id: req.params.id },
    });
    if (!teacher) throw new NotFoundError("Teacher");

    // Xóa User trước để kích hoạt cascade sang Teacher, hoặc ngược lại.
    // Tốt nhất là xóa trực tiếp tài khoản User liên kết để dọn dẹp sạch sẽ cả 2 bảng:
    await prisma.user.delete({
      where: { id: teacher.userId },
    });

    res.status(204).send();
  } catch (err) {
    next(err);
  }
}
