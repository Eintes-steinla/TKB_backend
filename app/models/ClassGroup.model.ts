import { z } from "zod";

export const CreateClassGroupSchema = z.object({
  majorId: z.string().min(1, "Vui lòng chọn ngành học"),
  cohortId: z.string().min(1, "Vui lòng chọn khóa học"),
  code: z
    .string()
    .min(1, "Mã lớp không được để trống")
    .max(50, "Mã lớp tối đa 50 ký tự"),
});

export const UpdateClassGroupSchema = CreateClassGroupSchema.partial();

export type CreateClassGroupDto = z.infer<typeof CreateClassGroupSchema>;
export type UpdateClassGroupDto = z.infer<typeof UpdateClassGroupSchema>;

export interface ClassGroupFilters {
  majorId?: string;
  cohortId?: string;
}
