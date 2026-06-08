import { Router } from "express";
import {
  createScheduleHandler,
  updateScheduleHandler,
  deleteScheduleHandler,
  getByClassHandler,
  getByTeacherHandler,
  getByRoomHandler,
  getByWeekHandler,
  getConflictsHandler,
  getAllSchedulesHandler,
} from "../controllers/Schedule.controller"; // FIX: Đảm bảo tên file controller là "Schedule.controller" (không phải "Scheduler")
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import { cacheMiddleware } from "../middleware/Cache.middleware";
import {
  CreateScheduleSchema,
  UpdateScheduleSchema,
} from "../models/Schedule.model";

const router = Router();

router.use(verifyJWT);

// GET routes — đặt /conflicts TRƯỚC /:id để tránh bị bắt nhầm bởi dynamic param
router.get("/conflicts", getConflictsHandler);
router.get("/class/:classId", cacheMiddleware(), getByClassHandler);
router.get("/teacher/:id", cacheMiddleware(), getByTeacherHandler);
router.get("/room/:roomId", cacheMiddleware(), getByRoomHandler);
router.get("/week/:weekNum", cacheMiddleware(), getByWeekHandler);
router.get("/", cacheMiddleware(), getAllSchedulesHandler);

// POST / PUT / DELETE — chỉ ADMIN
router.post(
  "/",
  roleGuard(["ADMIN"]),
  validate(CreateScheduleSchema),
  createScheduleHandler,
);

router.put(
  "/:id",
  roleGuard(["ADMIN"]),
  validate(UpdateScheduleSchema),
  updateScheduleHandler,
);

router.delete("/:id", roleGuard(["ADMIN"]), deleteScheduleHandler);

export default router;
