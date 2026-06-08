import { Request, Response, NextFunction } from 'express';
import { ZodSchema, ZodError } from 'zod';

export function validate(schema: ZodSchema) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      const err = result.error as ZodError;
      const messages = err.errors.map((e) => `${e.path.join('.')}: ${e.message}`).join('; ');
      next({ statusCode: 400, message: messages, name: 'ValidationError' });
      return;
    }
    req.body = result.data;
    next();
  };
}

export function validateQuery(schema: ZodSchema) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req.query);
    if (!result.success) {
      const err = result.error as ZodError;
      const messages = err.errors.map((e) => `${e.path.join('.')}: ${e.message}`).join('; ');
      next({ statusCode: 400, message: messages, name: 'ValidationError' });
      return;
    }
    req.query = result.data as Record<string, string>;
    next();
  };
}
