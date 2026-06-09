import dotenv from "dotenv";
dotenv.config();

export const appConf = {
  env: process.env.NODE_ENV ?? "development",
  port: parseInt(process.env.PORT ?? "3000", 10),
  apiPrefix: process.env.API_PREFIX ?? "/api/v1",
  corsOrigin: process.env.CORS_ORIGIN || "https://tkb-web-chi.vercel.app",
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS ?? "900000", 10),
    max: parseInt(process.env.RATE_LIMIT_MAX ?? "100", 10),
  },
  cacheTtl: parseInt(process.env.CACHE_TTL ?? "3600", 10),
  isDev: (process.env.NODE_ENV ?? "development") === "development",
  isProd: process.env.NODE_ENV === "production",
};
