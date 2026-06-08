import { Request, Response, NextFunction } from 'express';
import * as AuthService from '../services/Auth.service';
import { prisma } from '../database/Postgres.database';
import { NotFoundError } from '../middleware/ErrorHandler.middleware';

export async function loginHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { email, password } = req.body as { email: string; password: string };
    const result = await AuthService.login(email, password);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
}

export async function refreshHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { refreshToken } = req.body as { refreshToken: string };
    const result = await AuthService.refresh(refreshToken);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
}

export async function logoutHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const userId = req.user!.userId;
    await AuthService.logout(userId);
    res.status(200).json({ message: 'Logged out successfully' });
  } catch (err) {
    next(err);
  }
}

export async function registerHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { email, password, role, refId } = req.body as {
      email: string;
      password: string;
      role: 'ADMIN' | 'TEACHER' | 'STUDENT';
      refId?: string;
    };
    const user = await AuthService.registerUser(email, password, role, refId);
    res.status(201).json(user);
  } catch (err) {
    next(err);
  }
}

export async function meHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.userId },
      select: { id: true, email: true, role: true, refId: true, name: true, createdAt: true },
    });
    if (!user) throw new NotFoundError('User');

    let code: string | null = null;
    let department: string | null = null;
    let majorCode: string | null = null;

    if (user.refId) {
      if (user.role === 'TEACHER') {
        const teacher = await prisma.teacher.findUnique({ where: { id: user.refId } });
        if (teacher) { code = teacher.code; department = teacher.dept ?? null; }
      } else if (user.role === 'STUDENT') {
        const cg = await prisma.classGroup.findUnique({
          where: { id: user.refId },
          include: { major: true },
        });
        if (cg) {
          code = cg.code;
          department = (cg as any).major?.name ?? null;
          majorCode = (cg as any).major?.code ?? null;
        }
      }
    }

    const studentCode = user.role === 'STUDENT'
      ? (() => { const parts = user.email.split('@')[0].split('.'); const num = parts[parts.length - 1]; return /^\d+$/.test(num) ? `CD${num}` : null; })()
      : null;

    res.status(200).json({ ...user, code, studentCode, department, majorCode });
  } catch (err) {
    next(err);
  }
}
