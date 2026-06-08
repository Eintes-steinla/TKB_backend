import { Request, Response } from 'express';
import { prisma } from '../database/Postgres.database';
import { redis } from '../database/Redis.database';

export async function healthCheck(_req: Request, res: Response): Promise<void> {
  let dbStatus = 'ok';
  let redisStatus = 'ok';

  try {
    await prisma.$queryRaw`SELECT 1`;
  } catch {
    dbStatus = 'error';
  }

  try {
    await redis.ping();
  } catch {
    redisStatus = 'error';
  }

  const status = dbStatus === 'ok' && redisStatus === 'ok' ? 200 : 503;

  res.status(status).json({
    status: status === 200 ? 'healthy' : 'degraded',
    timestamp: new Date().toISOString(),
    services: {
      database: dbStatus,
      redis: redisStatus,
    },
  });
}

export function notFound(_req: Request, res: Response): void {
  res.status(404).json({
    error: 'NotFound',
    message: 'The requested resource does not exist',
  });
}
