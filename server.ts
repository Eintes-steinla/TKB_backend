import "dotenv/config";
import http from "http";
import express from "express";
import { Server as SocketIOServer } from "socket.io";

import { initConfig } from "./app/config/init";
import { appConf } from "./app/config/app.conf";
import { initDatabases, closeDatabases } from "./app/database/init";
import { applyMiddleware } from "./app/middleware/App.middleware";
import { errorHandler } from "./app/middleware/ErrorHandler.middleware";
import { registerRoutes } from "./app/routes/App.routes";
import { setIO } from "./app/socket/events";
import { configureSocketRooms } from "./app/socket/rooms";

async function bootstrap(): Promise<void> {
  // 1. Init config & validate env
  initConfig();

  // 2. Init databases
  await initDatabases();

  // 3. Create Express app
  const app = express();
  const server = http.createServer(app);

  // 4. Apply middleware (helmet, cors, compression, morgan, rate-limit, body-parser)
  applyMiddleware(app);

  // 5. Register routes
  registerRoutes(app);

  // 6. Global error handler (must be last)
  app.use(errorHandler);

  // 7. Setup Socket.IO
  const io = new SocketIOServer(server, {
    cors: {
      origin: appConf.corsOrigin,
      methods: ["GET", "POST"],
      credentials: true,
    },
  });
  setIO(io);
  configureSocketRooms(io);

  // 8. Start server
  const port = appConf.port;
  server.listen(port, "0.0.0.0", () => {
    console.log(
      `\n[TKB Backend] Server running on http://0.0.0.0:${port} (LAN: http://192.168.1.11:${port})`,
    );
    console.log(`[TKB Backend] API prefix: ${appConf.apiPrefix}`);
    console.log(`[TKB Backend] Environment: ${appConf.env}`);
    console.log(
      `[TKB Backend] Health check: http://localhost:${port}${appConf.apiPrefix}/health\n`,
    );
  });

  // 9. Graceful shutdown
  const shutdown = async (signal: string): Promise<void> => {
    console.log(
      `\n[TKB Backend] Received ${signal}. Shutting down gracefully...`,
    );
    server.close(async () => {
      await closeDatabases();
      console.log("[TKB Backend] Server closed.");
      process.exit(0);
    });

    // Force exit after 10s
    setTimeout(() => {
      console.error("[TKB Backend] Forced shutdown after timeout");
      process.exit(1);
    }, 10_000);
  };

  process.on("SIGTERM", () => shutdown("SIGTERM"));
  process.on("SIGINT", () => shutdown("SIGINT"));

  process.on("unhandledRejection", (reason) => {
    console.error("[TKB Backend] Unhandled rejection:", reason);
  });

  process.on("uncaughtException", (err) => {
    console.error("[TKB Backend] Uncaught exception:", err);
    process.exit(1);
  });
}

bootstrap().catch((err) => {
  console.error("[TKB Backend] Fatal bootstrap error:", err);
  process.exit(1);
});
