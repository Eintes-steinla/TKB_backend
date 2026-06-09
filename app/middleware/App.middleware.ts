import express, { Application, Request } from "express";
import helmet from "helmet";
import cors, { CorsOptions } from "cors";
import morgan from "morgan";
import compression from "compression";
import rateLimit from "express-rate-limit";
import { appConf } from "../config/app.conf";

// Xây dựng danh sách origin được phép
function buildAllowedOrigins(): (string | RegExp)[] {
  const raw = appConf.corsOrigin;

  // Nếu config trả về mảng (string[])
  const list: string[] = Array.isArray(raw)
    ? raw
    : (raw as string)
        .split(",")
        .map((s: string) => s.trim())
        .filter(Boolean);

  if (list.includes("*")) return ["*"];

  const origins: (string | RegExp)[] = [...list];

  // Tự động cho phép Vercel preview deployments
  origins.push(
    /^https:\/\/[a-zA-Z0-9-]+-[a-zA-Z0-9-]+-[a-zA-Z0-9-]+\.vercel\.app$/,
  );
  origins.push(/^https:\/\/tkb-web[a-zA-Z0-9-]*\.vercel\.app$/);

  return origins;
}

const allowedOrigins = buildAllowedOrigins();

function isOriginAllowed(origin: string | undefined): boolean {
  if (!origin) return true; // server-to-server, Postman, curl

  for (const allowed of allowedOrigins) {
    if (allowed === "*") return true;
    if (typeof allowed === "string" && allowed === origin) return true;
    if (allowed instanceof RegExp && allowed.test(origin)) return true;
  }
  return false;
}

const corsOptions: CorsOptions = {
  origin(origin, callback) {
    if (isOriginAllowed(origin)) {
      callback(null, true);
    } else {
      callback(new Error(`CORS blocked: ${origin}`));
    }
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  // Trả về origin cụ thể thay vì wildcard '*' (bắt buộc khi credentials: true)
  exposedHeaders: ["X-Request-Id"],
};

export function applyMiddleware(app: Application): void {
  app.use(helmet());

  // Preflight cho tất cả routes
  app.options("*", cors(corsOptions));
  app.use(cors(corsOptions));

  app.use(compression());
  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: true, limit: "10mb" }));

  if (appConf.isDev) {
    app.use(morgan("dev"));
  } else {
    app.use(morgan("combined"));
  }

  const limiter = rateLimit({
    windowMs: appConf.rateLimit.windowMs,
    max: appConf.rateLimit.max,
    standardHeaders: true,
    legacyHeaders: false,
    skip: (req: Request) => req.method === "GET",
    message: {
      error: "TooManyRequests",
      message: "Too many requests, please try again later.",
    },
  });
  app.use(limiter);
}
