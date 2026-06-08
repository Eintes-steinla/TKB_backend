import dotenv from 'dotenv';

export function initConfig(): void {
  dotenv.config();
  validateRequiredEnv();
}

function validateRequiredEnv(): void {
  const required = [
    'DATABASE_URL',
    'JWT_SECRET',
    'JWT_REFRESH_SECRET',
  ];

  const missing = required.filter((key) => !process.env[key]);
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }
}
