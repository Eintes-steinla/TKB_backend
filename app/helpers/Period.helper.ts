export interface PeriodTime {
  start: string;
  end: string;
}

export const PERIOD_TIMES: Record<number, PeriodTime> = {
  1:  { start: '06:45', end: '07:30' },
  2:  { start: '07:30', end: '08:15' },
  3:  { start: '08:25', end: '09:10' },
  4:  { start: '09:20', end: '10:05' },
  5:  { start: '10:15', end: '11:00' },
  6:  { start: '11:00', end: '11:45' },
  7:  { start: '12:30', end: '13:15' },
  8:  { start: '13:15', end: '14:00' },
  9:  { start: '14:10', end: '14:55' },
  10: { start: '15:05', end: '15:50' },
  11: { start: '16:00', end: '16:45' },
  12: { start: '16:45', end: '17:30' },
};

export const MIN_PERIOD = 1;
export const MAX_PERIOD = 12;

/**
 * Returns start/end time strings for a given period number (1-12).
 */
export function periodToTime(period: number): PeriodTime {
  const t = PERIOD_TIMES[period];
  if (!t) {
    throw new RangeError(`Period ${period} is out of range (${MIN_PERIOD}-${MAX_PERIOD})`);
  }
  return t;
}

/**
 * Returns true if the two period ranges [s1,e1] and [s2,e2] overlap (inclusive).
 */
export function periodsOverlap(s1: number, e1: number, s2: number, e2: number): boolean {
  return s1 <= e2 && s2 <= e1;
}

/**
 * Converts a period range to a human-readable string, e.g. "Tiết 1-3 (06:45-09:10)"
 */
export function periodRangeLabel(start: number, end: number): string {
  const startTime = PERIOD_TIMES[start];
  const endTime   = PERIOD_TIMES[end];
  if (!startTime || !endTime) return `Tiết ${start}-${end}`;
  return `Tiết ${start}-${end} (${startTime.start}-${endTime.end})`;
}

/**
 * Returns true if the period number is valid.
 */
export function isValidPeriod(period: number): boolean {
  return Number.isInteger(period) && period >= MIN_PERIOD && period <= MAX_PERIOD;
}

/**
 * Returns the session a period belongs to: 'morning' (1-6), 'afternoon' (7-12).
 */
export function periodSession(period: number): 'morning' | 'afternoon' {
  return period <= 6 ? 'morning' : 'afternoon';
}
