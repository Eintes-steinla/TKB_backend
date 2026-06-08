import { z } from "zod";

export const CreateRoomSchema = z.object({
  // 🌟 ĐÃ SỬA: Bỏ ràng buộc .uuid(), chỉ yêu cầu là chuỗi ký tự không để trống để khớp với ID dạng `location_code`
  locationId: z.string().min(1, { message: "Mã tòa nhà không được để trống" }),

  code: z.string().min(1).max(50),
  type: z.enum(["THEORY", "PRACTICE", "HALL"]),

  // 🌟 ĐÃ TỐI ƯU: Sử dụng preprocess để tự động chuyển chuỗi rỗng "" hoặc ký tự text thành Number an toàn
  capacity: z.preprocess(
    (val) =>
      val === "" || val === undefined || val === null ? undefined : Number(val),
    z
      .number()
      .int()
      .min(1, { message: "Sức chứa phải là số nguyên lớn hơn 0" })
      .optional()
      .default(60),
  ),

  isActive: z.boolean().optional().default(true),
});

export const UpdateRoomSchema = CreateRoomSchema.partial();

export type CreateRoomDto = z.infer<typeof CreateRoomSchema>;
export type UpdateRoomDto = z.infer<typeof UpdateRoomSchema>;

export interface RoomFilters {
  type?: "THEORY" | "PRACTICE" | "HALL";
  locationId?: string;
  isActive?: boolean;
}
