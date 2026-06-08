import { Request, Response, NextFunction } from "express";

/**
 * POST /scheduler/run
 * Kicks off the auto-scheduling job for the given teaching units.
 */
export async function runSchedulerHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // TODO: integrate with your scheduling algorithm / job queue
    const { teachingUnitIds, config } = req.body;
    const jobId = `job_${Date.now()}`;
    res.status(202).json({
      jobId,
      message: "Scheduler job queued",
      teachingUnitIds,
      config,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * GET /scheduler/status/:jobId
 * Returns the current status of a scheduling job.
 */
export async function getSchedulerStatusHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { jobId } = req.params;
    // TODO: look up real job status from queue / DB
    res.status(200).json({
      jobId,
      status: "pending",
      progress: 0,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /scheduler/validate
 * Validates a proposed set of schedule slots against all constraints.
 */
export async function validateScheduleHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { slots } = req.body;
    // TODO: run constraint checks on each slot
    res.status(200).json({
      valid: true,
      violations: [],
      checkedSlots: slots?.length ?? 0,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * GET /scheduler/conflicts
 * Returns all unresolved constraint violation logs.
 */
export async function getSchedulerConflictsHandler(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    // TODO: query real violations from DB
    res.status(200).json([]);
  } catch (err) {
    next(err);
  }
}
