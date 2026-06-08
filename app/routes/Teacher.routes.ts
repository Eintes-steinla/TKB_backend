import { Router } from "express";
import {
  getTeachersHandler,
  getTeacherByIdHandler,
  createTeacherHandler,
  updateTeacherHandler,
  deleteTeacherHandler,
} from "../controllers/Teacher.controller";
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import {
  CreateTeacherSchema,
  UpdateTeacherSchema,
} from "../models/Teacher.model";

const router = Router();

// Toàn bộ các API liên quan đến Teacher đều yêu cầu phải đăng nhập thành công
router.use(verifyJWT);

// Bất cứ ai (Sinh viên, Giảng viên khác, Admin) đều có quyền xem danh sách và chi tiết giảng viên
router.get("/", getTeachersHandler);
router.get("/:id", getTeacherByIdHandler);

// Riêng các thao tác can thiệp dữ liệu, chỉ ADMIN hệ thống mới được thực hiện
router.post(
  "/",
  roleGuard(["ADMIN"]),
  validate(CreateTeacherSchema),
  createTeacherHandler,
);
router.put(
  "/:id",
  roleGuard(["ADMIN"]),
  validate(UpdateTeacherSchema),
  updateTeacherHandler,
);
router.delete("/:id", roleGuard(["ADMIN"]), deleteTeacherHandler);

export default router;
