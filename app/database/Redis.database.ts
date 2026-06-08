import Redis from 'ioredis';
import { redisConf } from '../config/redis.conf';

let redisInstance: Redis | null = null;

export function getRedisClient(): Redis {
  if (!redisInstance) {
    redisInstance = new Redis({
      host: redisConf.host,
      port: redisConf.port,
      password: redisConf.password,
      db: redisConf.db,
      keyPrefix: redisConf.keyPrefix,
      retryStrategy: redisConf.retryStrategy,
      lazyConnect: true,
    });

    redisInstance.on('connect', () => {
      console.log('[Redis] Connected successfully');
    });

    redisInstance.on('error', (err: Error) => {
      console.error('[Redis] Error:', err.message);
    });

    redisInstance.on('close', () => {
      console.log('[Redis] Connection closed');
    });
  }
  return redisInstance;
}

export const redis = getRedisClient();

export async function connectRedis(): Promise<void> {
  try {
    await redis.connect();
    console.log('[Redis] Connection established');
  } catch (error) {
    console.error('[Redis] Failed to connect:', error);
    // Redis is optional; warn but do not throw
  }
}

export async function disconnectRedis(): Promise<void> {
  if (redisInstance) {
    await redisInstance.quit();
    redisInstance = null;
    console.log('[Redis] Disconnected');
  }
}

export async function redisGet(key: string): Promise<string | null> {
  try {
    return await redis.get(key);
  } catch {
    return null;
  }
}

export async function redisSet(key: string, value: string, ttl?: number): Promise<void> {
  try {
    if (ttl) {
      await redis.setex(key, ttl, value);
    } else {
      await redis.set(key, value);
    }
  } catch (err) {
    console.error('[Redis] Set error:', err);
  }
}

export async function redisDel(key: string): Promise<void> {
  try {
    await redis.del(key);
  } catch (err) {
    console.error('[Redis] Del error:', err);
  }
}

export async function redisDelPattern(pattern: string): Promise<void> {
  try {
    const keys = await redis.keys(pattern);
    if (keys.length > 0) {
      // Remove keyPrefix since keys() returns them with prefix
      const rawKeys = keys.map((k) => k.replace(redisConf.keyPrefix, ''));
      await redis.del(...rawKeys);
    }
  } catch (err) {
    console.error('[Redis] DelPattern error:', err);
  }
}
