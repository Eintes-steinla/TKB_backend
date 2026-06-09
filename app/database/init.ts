import { connectPostgres, disconnectPostgres } from "./Postgres.database";
import { connectRedis, disconnectRedis } from "./Redis.database";

export async function initDatabases(): Promise<void> {
  await connectPostgres();
  // await connectRedis();
}

export async function closeDatabases(): Promise<void> {
  await disconnectPostgres();
  // await disconnectRedis();
}
