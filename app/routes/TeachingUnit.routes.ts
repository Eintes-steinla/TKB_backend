import { Router } from "express";
import {
  getTeachingUnitsHandler,
  getTeachingUnitByIdHandler,
  createTeachingUnitHandler,
  updateTeachingUnitHandler,
  deleteTeachingUnitHandler,
} from "../controllers/TeachingUnit.controller";
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import {
  CreateTeachingUnitSchema,
  UpdateTeachingUnitSchema,
} from "../models/TeachingUnit.model";

const router = Router();

router.use(verifyJWT);

router.get("/", getTeachingUnitsHandler);
router.get("/:id", getTeachingUnitByIdHandler);

router.post(
  "/",
  roleGuard(["ADMIN"]),
  validate(CreateTeachingUnitSchema),
  createTeachingUnitHandler,
);
router.put(
  "/:id",
  roleGuard(["ADMIN"]),
  validate(UpdateTeachingUnitSchema),
  updateTeachingUnitHandler,
);
router.delete("/:id", roleGuard(["ADMIN"]), deleteTeachingUnitHandler);

export default router;
