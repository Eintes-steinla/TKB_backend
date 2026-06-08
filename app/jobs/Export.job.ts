import Bull from 'bull';
import { redisConf } from '../config/redis.conf';

export interface ExportJobData {
  type: 'PDF' | 'EXCEL';
  params: {
    classId?: string;
    teacherId?: string;
    weekNumber?: number;
  };
  requestedBy: string;
}

let exportQueue: Bull.Queue<ExportJobData> | null = null;

export function getExportQueue(): Bull.Queue<ExportJobData> {
  if (!exportQueue) {
    exportQueue = new Bull<ExportJobData>('export', {
      redis: {
        host: redisConf.host,
        port: redisConf.port,
        password: redisConf.password,
        db: redisConf.db,
      },
      defaultJobOptions: {
        attempts: 3,
        backoff: { type: 'exponential', delay: 1000 },
        removeOnComplete: false,
        removeOnFail: false,
      },
    });

    exportQueue.process(async (job) => {
      const { type, params } = job.data;
      console.log(`[ExportJob] Processing ${type} export`, params);

      // Phase 2: implement actual PDF/Excel generation here
      // For now, simulate processing time and return a stub result
      await new Promise((resolve) => setTimeout(resolve, 1000));

      return {
        fileId: job.id,
        type,
        status: 'completed',
        message: `${type} export stub completed. Phase 2 will generate real files.`,
      };
    });

    exportQueue.on('completed', (job) => {
      console.log(`[ExportJob] Job ${job.id} completed`);
    });

    exportQueue.on('failed', (job, err) => {
      console.error(`[ExportJob] Job ${job.id} failed:`, err.message);
    });
  }

  return exportQueue;
}

export async function addExportJob(data: ExportJobData): Promise<string> {
  const queue = getExportQueue();
  const job = await queue.add(data);
  return String(job.id);
}

export async function getExportJobStatus(jobId: string): Promise<{
  status: string;
  result?: unknown;
  error?: string;
}> {
  const queue = getExportQueue();
  const job = await queue.getJob(jobId);

  if (!job) return { status: 'not_found' };

  const state = await job.getState();
  if (state === 'completed') return { status: 'completed', result: job.returnvalue };
  if (state === 'failed') return { status: 'failed', error: job.failedReason };
  return { status: state };
}
