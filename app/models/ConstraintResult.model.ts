export interface ConstraintViolation {
  step: number;
  stepName: string;
  message: string;
  severity: 'error' | 'warning';
}

export interface ConstraintResult {
  valid: boolean;
  violations: ConstraintViolation[];
}

export const CONSTRAINT_STEP_NAMES: Record<number, string> = {
  1: 'checkWeekRange',
  2: 'checkRoomType',
  3: 'checkRoomConflict',
  4: 'checkTeacherConflict',
  5: 'checkClassConflict',
  6: 'checkCrossGroupConflict',
  7: 'checkMovementConstraint',
};
