import { getIO } from '../socket/events';

export interface Notification {
  type: string;
  title: string;
  message: string;
  data?: unknown;
  createdAt: Date;
}

/**
 * Send a notification to a specific socket room.
 */
export function sendNotification(room: string, notification: Omit<Notification, 'createdAt'>): void {
  const io = getIO();
  if (!io) {
    console.warn('[Notification] Socket.IO not initialized, skipping notification');
    return;
  }

  const payload: Notification = { ...notification, createdAt: new Date() };
  io.to(room).emit('notification', payload);
}

/**
 * Broadcast a notification to all connected clients.
 */
export function broadcastNotification(notification: Omit<Notification, 'createdAt'>): void {
  const io = getIO();
  if (!io) return;

  const payload: Notification = { ...notification, createdAt: new Date() };
  io.emit('notification', payload);
}

/**
 * Notify admins about a scheduling conflict.
 */
export function notifyConflict(scheduleId: string, message: string): void {
  sendNotification('admin', {
    type: 'CONFLICT',
    title: 'Scheduling Conflict Detected',
    message,
    data: { scheduleId },
  });
}

/**
 * Notify a class group about schedule changes.
 */
export function notifyClassScheduleChange(
  classId: string,
  action: 'created' | 'updated' | 'deleted',
  scheduleId: string,
): void {
  sendNotification(`class:${classId}`, {
    type: 'SCHEDULE_CHANGE',
    title: `Schedule ${action}`,
    message: `A schedule entry has been ${action}`,
    data: { scheduleId, action },
  });
}
