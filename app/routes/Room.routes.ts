import { Router } from 'express';
import {
  getRoomsHandler,
  getRoomByIdHandler,
  createRoomHandler,
  updateRoomHandler,
  deleteRoomHandler,
  getRoomScheduleHandler,
} from '../controllers/Room.controller';
import { verifyJWT, roleGuard } from '../middleware/Auth.middleware';
import { validate } from '../middleware/Validation.middleware';
import { cacheMiddleware } from '../middleware/Cache.middleware';
import { CreateRoomSchema, UpdateRoomSchema } from '../models/Room.model';

const router = Router();

router.use(verifyJWT);

router.get('/', getRoomsHandler);
router.get('/:id', getRoomByIdHandler);
router.get('/:id/schedule', cacheMiddleware(), getRoomScheduleHandler);

router.post('/', roleGuard(['ADMIN']), validate(CreateRoomSchema), createRoomHandler);
router.put('/:id', roleGuard(['ADMIN']), validate(UpdateRoomSchema), updateRoomHandler);
router.delete('/:id', roleGuard(['ADMIN']), deleteRoomHandler);

export default router;
