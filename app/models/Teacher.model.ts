import { z } from "zod";

export const CreateTeacherSchema = z.object({
  name: z.string().min(1, "Họ tên giảng viên không được để trống"),

  // 🌟 Chấp nhận email hợp lệ HOẶC chuỗi rỗng/bỏ trống (khi tự động sinh)
  email: z
    .string()
    .email("Email không đúng định dạng")
    .optional()
    .or(z.literal("")),

  // 🌟 Chấp nhận mã hợp lệ HOẶC chuỗi rỗng/bỏ trống (khi tự động sinh)
  code: z
    .string()
    .max(30, "Mã giảng viên tối đa 30 ký tự")
    .optional()
    .or(z.literal("")),

  dept: z.string().optional().nullable(),
  password: z.string().min(6, "Mật khẩu tối thiểu 6 ký tự").optional(),
});

export const UpdateTeacherSchema = CreateTeacherSchema.partial();

export type CreateTeacherDto = z.infer<typeof CreateTeacherSchema>;
export type UpdateTeacherDto = z.infer<typeof UpdateTeacherSchema>;
