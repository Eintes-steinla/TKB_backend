import { z } from "zod";

export const CreateTeachingUnitSchema = z.object({
  subjectId: z.string().min(1, "Vui lòng chọn môn học"),
  assignmentId: z.string().min(1, "Vui lòng chọn phân công / lớp học"),
  // Chuyển sang optional() vì Backend sẽ tự động xử lý điền dữ liệu
  type: z.enum(["THEORY", "PRACTICE", "EXERCISE"]).optional(),
  name: z.string().max(255).optional(),
  conflictGroupId: z.string().optional().nullable(),
});

export const UpdateTeachingUnitSchema = CreateTeachingUnitSchema.partial();

export type CreateTeachingUnitDto = z.infer<typeof CreateTeachingUnitSchema>;
export type UpdateTeachingUnitDto = z.infer<typeof UpdateTeachingUnitSchema>;
