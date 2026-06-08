import { Router } from 'express';
import { z } from 'zod';
import { loginHandler, refreshHandler, logoutHandler, registerHandler, meHandler } from '../controllers/Auth.controller';
import { verifyJWT, roleGuard } from '../middleware/Auth.middleware';
import { validate } from '../middleware/Validation.middleware';

const router = Router();

const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

const RefreshSchema = z.object({
  refreshToken: z.string().min(1),
});

const RegisterSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  role: z.enum(['ADMIN', 'TEACHER', 'STUDENT']),
  refId: z.string().uuid().optional(),
});

router.post('/login', validate(LoginSchema), loginHandler);
router.post('/refresh', validate(RefreshSchema), refreshHandler);
router.post('/logout', verifyJWT, logoutHandler);
router.get('/me', verifyJWT, meHandler);
router.post('/register', verifyJWT, roleGuard(['ADMIN']), validate(RegisterSchema), registerHandler);

export default router;
