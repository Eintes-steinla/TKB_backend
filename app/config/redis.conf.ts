import dotenv from 'dotenv';
dotenv.config();

export const redisConf = {
  host: process.env.REDIS_HOST ?? 'localhost',
  port: parseInt(process.env.REDIS_PORT ?? '6379', 10),
  password: process.env.REDIS_PASSWORD ?? undefined,
  db: parseInt(process.env.REDIS_DB ?? '0', 10),
  keyPrefix: 'tkb:',
  retryStrategy: (times: number): number | null => {
    if (times > 10) return null;
    return Math.min(times * 100, 3000);
  },
};
