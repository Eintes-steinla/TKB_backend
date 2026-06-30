import admin from "firebase-admin";
import path from "path";

let initialized = false;

function ensureInit() {
  if (initialized) return;
  const serviceAccountPath = path.join(
    process.cwd(),
    "firebase-service-account.json",
  );
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccountPath),
  });
  initialized = true;
}

/**
 * Gửi thông báo tới một topic (role_student / role_teacher).
 * Dùng cho demo — không cần lưu device token vào DB.
 */
export async function sendNotificationToTopic(
  topic: string,
  title: string,
  body: string,
): Promise<void> {
  try {
    ensureInit();
    await admin.messaging().send({
      topic,
      notification: { title, body },
    });
    console.log(`[FCM] Sent to topic "${topic}": ${title}`);
  } catch (err) {
    // Không throw — FCM lỗi không nên làm fail request update lịch
    console.error("[FCM] Failed to send notification:", err);
  }
}
