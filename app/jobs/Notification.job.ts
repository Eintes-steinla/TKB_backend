import Bull from 'bull';
import { redisConf } from '../config/redis.conf';
import { sendNotification } from '../services/Notification.service';

export interface NotificationJobData {
  room: string;
  type: string;
  title: string;
  message: string;
  data?: unknown;
  delay?: number;
}

let notificationQueue: Bull.Queue<NotificationJobData> | null = null;

export function getNotificationQueue(): Bull.Queue<NotificationJobData> {
  if (!notificationQueue) {
    notificationQueue = new Bull<NotificationJobData>('notification', {
      redis: {
        host: redisConf.host,
        port: redisConf.port,
        password: redisConf.password,
        db: redisConf.db,
      },
      defaultJobOptions: {
        attempts: 3,
        backoff: { type: 'fixed', delay: 500 },
        removeOnComplete: true,
        removeOnFail: false,
      },
    });

    notificationQueue.process(async (job) => {
      const { room, type, title, message, data } = job.data;

      sendNotification(room, { type, title, message, data });
      console.log(`[NotificationJob] Sent ${type} to room "${room}"`);
    });

    notificationQueue.on('failed', (job, err) => {
      console.error(`[NotificationJob] Job ${job.id} failed:`, err.message);
    });
  }

  return notificationQueue;
}

export async function scheduleNotification(data: NotificationJobData): Promise<string> {
  const queue = getNotificationQueue();
  const job = await queue.add(data, {
    delay: data.delay ?? 0,
  });
  return String(job.id);
}
