import { z } from "zod";

// roomId có thể là string bất kỳ (không bắt buộc UUID), null, hoặc undefined
const roomIdSchema = z.preprocess(
  (val) => {
    if (
      val === "" ||
      val === null ||
      val === undefined ||
      val === "null" ||
      val === "undefined"
    ) {
      return null;
    }
    return val;
  },
  z.string().min(1).nullable(), // bỏ .uuid() — roomId thực tế không phải UUID
);

const ScheduleCoreSchema = z.object({
  teachingUnitId: z.string().min(1, "Vui lòng chọn đơn vị giảng dạy hợp lệ"),
  roomId: roomIdSchema.optional(),
  dayOfWeek: z.number().int().min(2).max(8),
  periodStart: z.number().int().min(1).max(12),
  periodEnd: z.number().int().min(1).max(12),
  academicYear: z
    .string()
    .regex(/^\d{4}-\d{4}$/, "Định dạng năm học phải là YYYY-YYYY"),
  weekOfYear: z.number().int().min(1).max(53),
  mode: z.enum(["ONLINE", "OFFLINE"]),
});

export const CreateScheduleSchema = ScheduleCoreSchema.refine(
  (d) => d.periodEnd >= d.periodStart,
  {
    message: "Tiết kết thúc phải lớn hơn hoặc bằng tiết bắt đầu",
    path: ["periodEnd"],
  },
);

export const UpdateScheduleSchema = ScheduleCoreSchema.partial().refine(
  (d) => {
    if (d.periodStart !== undefined && d.periodEnd !== undefined) {
      return d.periodEnd >= d.periodStart;
    }
    return true;
  },
  {
    message: "Tiết kết thúc phải lớn hơn hoặc bằng tiết bắt đầu",
    path: ["periodEnd"],
  },
);

export type CreateScheduleDto = z.infer<typeof CreateScheduleSchema>;
export type UpdateScheduleDto = z.infer<typeof UpdateScheduleSchema>;
