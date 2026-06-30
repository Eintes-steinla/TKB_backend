import { initializeApp, cert, getApps, type App } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";
import path from "path";

let app: App | undefined;

function ensureInit(): App {
  if (app) return app;

  const existing = getApps();
  if (existing.length > 0) {
    app = existing[0];
    return app;
  }

  const serviceAccountPath = path.join(
    process.cwd(),
    "firebase-service-account.json",
  );

  app = initializeApp({
    credential: cert(serviceAccountPath),
  });

  return app;
}

export async function sendNotificationToTopic(
  topic: string,
  title: string,
  body: string,
): Promise<void> {
  try {
    const firebaseApp = ensureInit();
    await getMessaging(firebaseApp).send({
      topic,
      notification: { title, body },
    });
    console.log(`[FCM] Sent to topic "${topic}": ${title}`);
  } catch (err) {
    console.error("[FCM] Failed to send notification:", err);
  }
}
