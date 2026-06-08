import { Request, Response, NextFunction } from 'express';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly step?: number;

  constructor(message: string, statusCode: number = 500, step?: number) {
    super(message);
    this.statusCode = statusCode;
    this.step = step;
    Object.setPrototypeOf(this, new.target.prototype);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404);
  }
}

export class ValidationError extends AppError {
  constructor(message: string) {
    super(message, 400);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 401);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Forbidden') {
    super(message, 403);
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409);
  }
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void {
  if (err instanceof AppError) {
    const body: Record<string, unknown> = {
      error: err.constructor.name,
      message: err.message,
    };
    if (err.step !== undefined) body.step = err.step;
    res.status(err.statusCode).json(body);
    return;
  }

  // Prisma known errors
  const prismaErr = err as { code?: string; meta?: { target?: string[] } };
  if (prismaErr.code === 'P2002') {
    res.status(409).json({
      error: 'ConflictError',
      message: `Duplicate value for unique field: ${prismaErr.meta?.target?.join(', ')}`,
    });
    return;
  }
  if (prismaErr.code === 'P2025') {
    res.status(404).json({
      error: 'NotFoundError',
      message: 'Record not found',
    });
    return;
  }

  console.error('[Unhandled Error]', err);
  res.status(500).json({
    error: 'InternalServerError',
    message: 'An unexpected error occurred',
  });
}
