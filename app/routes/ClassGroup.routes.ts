import { Router } from "express";
import {
  getClassGroupsHandler,
  getClassGroupByIdHandler,
  createClassGroupHandler,
  updateClassGroupHandler,
  deleteClassGroupHandler,
} from "../controllers/ClassGroup.controller";
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import {
  CreateClassGroupSchema,
  UpdateClassGroupSchema,
} from "../models/ClassGroup.model";

const router = Router();

// Toàn bộ chức năng Class Group yêu cầu phải Đăng nhập
router.use(verifyJWT);

// Xem danh sách và chi tiết (Sinh viên, Giáo viên, Admin đều có quyền xem)
router.get("/", getClassGroupsHandler);
router.get("/:id", getClassGroupByIdHandler);

// Các thao tác thay đổi dữ liệu chỉ cho phép ADMIN thực hiện
router.post(
  "/",
  roleGuard(["ADMIN"]),
  validate(CreateClassGroupSchema),
  createClassGroupHandler,
);
router.put(
  "/:id",
  roleGuard(["ADMIN"]),
  validate(UpdateClassGroupSchema),
  updateClassGroupHandler,
);
router.delete("/:id", roleGuard(["ADMIN"]), deleteClassGroupHandler);

export default router;
