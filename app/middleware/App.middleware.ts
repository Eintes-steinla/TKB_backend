import express, { Application } from "express";
import helmet from "helmet";
import cors from "cors";
import morgan from "morgan";
import compression from "compression";
import rateLimit from "express-rate-limit";
import { appConf } from "../config/app.conf";

export function applyMiddleware(app: Application): void {
  // Security headers
  app.use(helmet());

  // CORS — wildcard '*' is incompatible with credentials:true
  const isWildcard = appConf.corsOrigin === "*";
  app.use(
    cors({
      origin: isWildcard ? true : appConf.corsOrigin,
      credentials: !isWildcard,
      methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
      allowedHeaders: ["Content-Type", "Authorization"],
    }),
  );

  // Compression
  app.use(compression());

  // Body parsers
  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: true, limit: "10mb" }));

  // Logging
  if (appConf.isDev) {
    app.use(morgan("dev"));
  } else {
    app.use(morgan("combined"));
  }

  // Rate limiting
  const limiter = rateLimit({
    windowMs: appConf.rateLimit.windowMs,
    max: appConf.rateLimit.max,
    standardHeaders: true,
    legacyHeaders: false,
    skip: (req) => req.method === "GET",
    message: {
      error: "TooManyRequests",
      message: "Too many requests, please try again later.",
    },
  });
  app.use(limiter);
}
