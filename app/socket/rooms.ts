import { Server as SocketIOServer, Socket } from 'socket.io';
import jwt from 'jsonwebtoken';
import { appKeys } from '../config/app.keys';
import { JwtPayload } from '../middleware/Auth.middleware';

/**
 * Configure Socket.IO authentication and room management.
 */
export function configureSocketRooms(io: SocketIOServer): void {
  // Middleware: authenticate socket connections via token query param
  io.use((socket, next) => {
    const token = socket.handshake.auth.token ?? socket.handshake.query.token as string;
    if (!token) {
      return next(new Error('Authentication token required'));
    }

    try {
      const payload = jwt.verify(token, appKeys.jwtSecret) as JwtPayload;
      (socket as Socket & { user: JwtPayload }).user = payload;
      next();
    } catch {
      next(new Error('Invalid or expired token'));
    }
  });

  io.on('connection', (socket: Socket & { user?: JwtPayload }) => {
    const user = socket.user;
    if (!user) {
      socket.disconnect(true);
      return;
    }

    console.log(`[Socket] Connected: ${user.email} (${user.role}) [${socket.id}]`);

    // Admins always join admin room
    if (user.role === 'ADMIN') {
      socket.join('admin');
    }

    // Join class room based on refId (for STUDENT/TEACHER role)
    socket.on('join:class', (classId: string) => {
      socket.join(`class:${classId}`);
      socket.emit('joined', { room: `class:${classId}` });
    });

    socket.on('leave:class', (classId: string) => {
      socket.leave(`class:${classId}`);
      socket.emit('left', { room: `class:${classId}` });
    });

    socket.on('join:teacher', (teacherId: string) => {
      socket.join(`teacher:${teacherId}`);
      socket.emit('joined', { room: `teacher:${teacherId}` });
    });

    socket.on('disconnect', (reason: string) => {
      console.log(`[Socket] Disconnected: ${user.email} — ${reason}`);
    });
  });
}
