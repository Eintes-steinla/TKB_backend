import { PrismaClient } from '@prisma/client';
import { appConf } from '../config/app.conf';

let prismaInstance: PrismaClient | null = null;

export function getPrismaClient(): PrismaClient {
  if (!prismaInstance) {
    prismaInstance = new PrismaClient({
      log: appConf.isDev ? ['query', 'info', 'warn', 'error'] : ['error'],
    });
  }
  return prismaInstance;
}

export const prisma = getPrismaClient();

export async function connectPostgres(): Promise<void> {
  try {
    await prisma.$connect();
    console.log('[Postgres] Connected successfully');
  } catch (error) {
    console.error('[Postgres] Connection failed:', error);
    throw error;
  }
}

export async function disconnectPostgres(): Promise<void> {
  if (prismaInstance) {
    await prismaInstance.$disconnect();
    prismaInstance = null;
    console.log('[Postgres] Disconnected');
  }
}
