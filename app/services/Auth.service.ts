import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../database/Postgres.database';
import { appKeys } from '../config/app.keys';
import { UnauthorizedError, NotFoundError } from '../middleware/ErrorHandler.middleware';
import { JwtPayload } from '../middleware/Auth.middleware';

export interface LoginResult {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    email: string;
    role: string;
    refId: string | null;
    name: string | null;
    code: string | null;
    studentCode: string | null;
    department: string | null;
    majorCode: string | null;
  };
}

function extractStudentCode(email: string): string | null {
  // "lam.221004@student.hactech.edu.vn" → "CD221004"
  const local = email.split('@')[0];
  const parts = local.split('.');
  const num = parts[parts.length - 1];
  return /^\d+$/.test(num) ? `CD${num}` : null;
}

export async function login(email: string, password: string): Promise<LoginResult> {
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    throw new UnauthorizedError('Invalid credentials');
  }

  const valid = await bcrypt.compare(password, user.passwordHash);
  if (!valid) {
    throw new UnauthorizedError('Invalid credentials');
  }

  const payload: JwtPayload = { userId: user.id, email: user.email, role: user.role };

  const accessToken = jwt.sign(payload, appKeys.jwtSecret, {
    expiresIn: appKeys.jwtExpiresIn,
  } as jwt.SignOptions);

  const refreshToken = jwt.sign(
    { userId: user.id },
    appKeys.jwtRefreshSecret,
    { expiresIn: appKeys.jwtRefreshExpiresIn } as jwt.SignOptions,
  );

  await prisma.user.update({
    where: { id: user.id },
    data: { refreshToken },
  });

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
      if (cg) { code = cg.code; department = cg.major?.name ?? null; majorCode = cg.major?.code ?? null; }
    }
  }

  const studentCode = user.role === 'STUDENT' ? extractStudentCode(user.email) : null;

  return {
    accessToken,
    refreshToken,
    user: { id: user.id, email: user.email, role: user.role, refId: user.refId, name: user.name ?? null, code, studentCode, department, majorCode },
  };
}

export async function refresh(refreshToken: string): Promise<{ accessToken: string }> {
  let decoded: { userId: string };
  try {
    decoded = jwt.verify(refreshToken, appKeys.jwtRefreshSecret) as { userId: string };
  } catch {
    throw new UnauthorizedError('Invalid or expired refresh token');
  }

  const user = await prisma.user.findUnique({ where: { id: decoded.userId } });
  if (!user || user.refreshToken !== refreshToken) {
    throw new UnauthorizedError('Refresh token mismatch');
  }

  const payload: JwtPayload = { userId: user.id, email: user.email, role: user.role };
  const accessToken = jwt.sign(payload, appKeys.jwtSecret, {
    expiresIn: appKeys.jwtExpiresIn,
  } as jwt.SignOptions);

  return { accessToken };
}

export async function logout(userId: string): Promise<void> {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) throw new NotFoundError('User');

  await prisma.user.update({
    where: { id: userId },
    data: { refreshToken: null },
  });
}

export async function registerUser(
  email: string,
  password: string,
  role: 'ADMIN' | 'TEACHER' | 'STUDENT',
  refId?: string,
): Promise<{ id: string; email: string; role: string }> {
  const passwordHash = await bcrypt.hash(password, 12);
  const user = await prisma.user.create({
    data: { email, passwordHash, role, refId },
    select: { id: true, email: true, role: true },
  });
  return user;
}
