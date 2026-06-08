-- AlterTable
ALTER TABLE "constraint_violation_logs" ADD COLUMN     "severity" TEXT NOT NULL DEFAULT 'error';
