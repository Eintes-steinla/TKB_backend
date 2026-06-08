/*
  Warnings:

  - You are about to drop the column `weekNumber` on the `schedules` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[classGroupId,teacherId]` on the table `assignments` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[assignmentId,subjectId]` on the table `teaching_units` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `academicYear` to the `schedules` table without a default value. This is not possible if the table is not empty.
  - Added the required column `weekOfYear` to the `schedules` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "schedules" DROP COLUMN "weekNumber",
ADD COLUMN     "academicYear" TEXT NOT NULL,
ADD COLUMN     "weekOfYear" INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "assignments_classGroupId_teacherId_key" ON "assignments"("classGroupId", "teacherId");

-- CreateIndex
CREATE UNIQUE INDEX "teaching_units_assignmentId_subjectId_key" ON "teaching_units"("assignmentId", "subjectId");
