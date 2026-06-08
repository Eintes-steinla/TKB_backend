import { Server as SocketIOServer } from 'socket.io';

let ioInstance: SocketIOServer | null = null;

export function setIO(io: SocketIOServer): void {
  ioInstance = io;
}

export function getIO(): SocketIOServer | null {
  return ioInstance;
}

/**
 * Broadcast that a new schedule was created to the class room.
 */
export function emitScheduleCreated(classId: string, schedule: unknown): void {
  if (!ioInstance) return;
  ioInstance.to(`class:${classId}`).emit('schedule:created', { schedule });
}

/**
 * Broadcast that a schedule was deleted to the class room.
 */
export function emitScheduleDeleted(classId: string, scheduleId: string): void {
  if (!ioInstance) return;
  ioInstance.to(`class:${classId}`).emit('schedule:deleted', { scheduleId });
}

/**
 * Broadcast a constraint conflict detection to the admin room.
 */
export function emitConflictDetected(payload: { scheduleId: string; violations: unknown[] }): void {
  if (!ioInstance) return;
  ioInstance.to('admin').emit('conflict:detected', payload);
}

/**
 * Broadcast scheduler job progress to admins.
 */
export function emitSchedulerProgress(jobId: string, progress: number): void {
  if (!ioInstance) return;
  ioInstance.to('admin').emit('scheduler:progress', { jobId, progress });
}

/**
 * Broadcast scheduler job completion to admins.
 */
export function emitSchedulerCompleted(jobId: string, result: unknown): void {
  if (!ioInstance) return;
  ioInstance.to('admin').emit('scheduler:completed', { jobId, result });
}
