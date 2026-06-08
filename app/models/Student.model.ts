import { z } from "zod";

// Zod schema cho create student
export const CreateStudentSchema = z.object({
  name: z.string().min(1, "Họ tên sinh viên không được để trống").max(255),

  // Chấp nhận email hợp lệ HOẶC chuỗi rỗng khi tự động sinh
  email: z
    .string()
    .email("Email không đúng định dạng")
    .optional()
    .or(z.literal("")),

  // Mật khẩu không bắt buộc khi tạo, nếu trống sẽ dùng pass mặc định "123456"
  password: z
    .string()
    .min(8, "Mật khẩu phải chứa ít nhất 8 ký tự")
    .optional()
    .or(z.literal("")),

  // Chấp nhận MSSV hợp lệ HOẶC chuỗi rỗng khi tự động sinh
  studentCode: z
    .string()
    .max(50, "Mã số sinh viên tối đa 50 ký tự")
    .optional()
    .or(z.literal("")),

  classGroupId: z.string().uuid("Vui lòng chọn lớp học hợp lệ"),
});

// Update student (tất cả các trường đều optional)
export const UpdateStudentSchema = CreateStudentSchema.partial();

export type CreateStudentDto = z.infer<typeof CreateStudentSchema>;
export type UpdateStudentDto = z.infer<typeof UpdateStudentSchema>;
