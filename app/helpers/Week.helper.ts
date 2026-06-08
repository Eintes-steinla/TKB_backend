const MS_PER_WEEK = 7 * 24 * 60 * 60 * 1000;

/**
 * Returns true if the given week number falls within [start, end] inclusive.
 */
export function isWeekInRange(week: number, start: number, end: number): boolean {
  return week >= start && week <= end;
}

/**
 * Returns the 1-based week number for the current date relative to a semester start date.
 * If the date is before semesterStart, returns 0.
 */
export function getCurrentWeek(semesterStart: Date): number {
  const now = new Date();
  const startMs = semesterStart.getTime();
  const nowMs   = now.getTime();
  if (nowMs < startMs) return 0;
  return Math.floor((nowMs - startMs) / MS_PER_WEEK) + 1;
}

/**
 * Returns the calendar date for the start of a given week number (1-based)
 * relative to the semester start.
 */
export function weekStartDate(semesterStart: Date, weekNumber: number): Date {
  const offsetMs = (weekNumber - 1) * MS_PER_WEEK;
  return new Date(semesterStart.getTime() + offsetMs);
}

/**
 * Returns the total number of weeks between two dates (inclusive, rounded up).
 */
export function totalWeeks(semesterStart: Date, semesterEnd: Date): number {
  const diff = semesterEnd.getTime() - semesterStart.getTime();
  return Math.ceil(diff / MS_PER_WEEK);
}

/**
 * Returns a display string for a week, e.g. "Tuần 3 (10/03 - 16/03/2025)"
 */
export function weekLabel(semesterStart: Date, weekNumber: number): string {
  const start = weekStartDate(semesterStart, weekNumber);
  const end   = new Date(start.getTime() + 6 * 24 * 60 * 60 * 1000);
  const fmt   = (d: Date): string =>
    `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}`;
  return `Tuần ${weekNumber} (${fmt(start)} - ${fmt(end)}/${end.getFullYear()})`;
}

/**
 * Maps a dayOfWeek integer (2=Mon, 3=Tue, ... 8=Sun) to a Vietnamese label.
 */
export function dayLabel(dayOfWeek: number): string {
  const map: Record<number, string> = {
    2: 'Thứ Hai',
    3: 'Thứ Ba',
    4: 'Thứ Tư',
    5: 'Thứ Năm',
    6: 'Thứ Sáu',
    7: 'Thứ Bảy',
    8: 'Chủ Nhật',
  };
  return map[dayOfWeek] ?? `Ngày ${dayOfWeek}`;
}
