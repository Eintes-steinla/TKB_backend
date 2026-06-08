import { Router } from 'express';
import { z } from 'zod';
import {
  runSchedulerHandler,
  getSchedulerStatusHandler,
  validateScheduleHandler,
  getSchedulerConflictsHandler,
} from '../controllers/Scheduler.controller';
import { verifyJWT, roleGuard } from '../middleware/Auth.middleware';
import { validate } from '../middleware/Validation.middleware';

const router = Router();

router.use(verifyJWT);

const RunSchedulerSchema = z.object({
  teachingUnitIds: z.array(z.string().uuid()).min(1),
  config: z.object({
    weekStart: z.number().int().min(1),
    weekEnd: z.number().int().min(1),
    allowedDays: z.array(z.number().int().min(2).max(8)).optional(),
    allowedPeriods: z.array(z.number().int().min(1).max(12)).optional(),
    maxBacktrackDepth: z.number().int().optional(),
  }),
});

const ValidateSchema = z.object({
  slots: z.array(
    z.object({
      teachingUnitId: z.string().uuid(),
      dayOfWeek: z.number().int().min(2).max(8),
      periodStart: z.number().int().min(1).max(12),
      periodEnd: z.number().int().min(1).max(12),
      weekNumber: z.number().int().min(1),
      roomId: z.string().uuid().optional(),
      mode: z.enum(['ONLINE', 'OFFLINE']),
    }),
  ),
});

router.post('/run', roleGuard(['ADMIN']), validate(RunSchedulerSchema), runSchedulerHandler);
router.get('/status/:jobId', roleGuard(['ADMIN']), getSchedulerStatusHandler);
router.post('/validate', roleGuard(['ADMIN']), validate(ValidateSchema), validateScheduleHandler);
router.get('/conflicts', getSchedulerConflictsHandler);

export default router;
