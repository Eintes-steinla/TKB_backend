import dotenv from "dotenv";
dotenv.config();

export const dbConf = {
  url:
    process.env.DATABASE_URL ??
    "postgresql://postgres:password@localhost:5432/tkb_db",
  host: process.env.DB_HOST ?? "localhost",
  port: parseInt(process.env.DB_PORT ?? "5432", 10),
  name: process.env.DB_NAME ?? "tkb_db",
  user: process.env.DB_USER ?? "postgres",
  password: process.env.DB_PASSWORD ?? "password",
  poolMin: parseInt(process.env.DB_POOL_MIN ?? "2", 10),
  poolMax: parseInt(process.env.DB_POOL_MAX ?? "10", 10),
  ssl: process.env.DB_SSL === "true",
};
