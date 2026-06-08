import { Router } from "express";
import {
  getStudentsHandler,
  getStudentByIdHandler,
  createStudentHandler,
  updateStudentHandler,
  deleteStudentHandler,
  getStudentsByClassHandler,
} from "../controllers/Student.controller";
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import {
  CreateStudentSchema,
  UpdateStudentSchema,
} from "../models/Student.model";

const router = Router();

router.use(verifyJWT);

router.get("/", getStudentsHandler);
router.get("/:id", getStudentByIdHandler);
router.get("/class/:classId", getStudentsByClassHandler);

router.post(
  "/",
  roleGuard(["ADMIN"]),
  validate(CreateStudentSchema),
  createStudentHandler,
);
router.put(
  "/:id",
  roleGuard(["ADMIN"]),
  validate(UpdateStudentSchema),
  updateStudentHandler,
);
router.delete("/:id", roleGuard(["ADMIN"]), deleteStudentHandler);

export default router;
