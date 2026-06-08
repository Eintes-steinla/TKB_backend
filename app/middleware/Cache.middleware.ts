import { Request, Response, NextFunction } from 'express';
import { redisGet, redisSet, redisDelPattern } from '../database/Redis.database';
import { appConf } from '../config/app.conf';

function buildCacheKey(req: Request): string {
  const query = JSON.stringify(req.query);
  return `cache:${req.path}:${query}`;
}

export function cacheMiddleware(ttl: number = appConf.cacheTtl) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    if (req.method !== 'GET') {
      next();
      return;
    }

    const key = buildCacheKey(req);

    try {
      const cached = await redisGet(key);
      if (cached) {
        res.setHeader('X-Cache', 'HIT');
        res.json(JSON.parse(cached));
        return;
      }
    } catch {
      // Cache miss or error — continue
    }

    // Monkey-patch res.json to store result in cache
    const originalJson = res.json.bind(res);
    res.json = (body: unknown): Response => {
      res.setHeader('X-Cache', 'MISS');
      // Only cache successful responses
      if (res.statusCode >= 200 && res.statusCode < 300) {
        redisSet(key, JSON.stringify(body), ttl).catch(() => {});
      }
      return originalJson(body);
    };

    next();
  };
}

export async function invalidateCache(pattern: string): Promise<void> {
  await redisDelPattern(`cache:${pattern}*`);
}
