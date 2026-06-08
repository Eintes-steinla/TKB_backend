import { Application, Router, Request, Response } from "express";
import { appConf } from "../config/app.conf";
import { healthCheck } from "../controllers/App.controller";

import authRoutes from "./Auth.routes";
import roomRoutes from "./Room.routes";
import teacherRoutes from "./Teacher.routes";
import studentRoutes from "./Student.routes";
import teachingUnitRoutes from "./TeachingUnit.routes";
import scheduleRoutes from "./Schedule.routes";
import schedulerRoutes from "./Scheduler.routes";
import classGroupRoutes from "./ClassGroup.routes";

// Inline subject/class/version routes (lightweight, no separate controller file needed)
import { prisma } from "../database/Postgres.database";
import { verifyJWT, roleGuard } from "../middleware/Auth.middleware";
import { validate } from "../middleware/Validation.middleware";
import { z } from "zod";
import { NotFoundError } from "../middleware/ErrorHandler.middleware";
import { registerUser } from "../services/Auth.service";

import bcrypt from "bcryptjs";
import { translate } from "google-translate-api-x";
import axios from "axios";

// Hàm dịch tự động bằng Google Translate hoàn toàn miễn phí
async function smartTranslateSubjectName(
  vietnameseName: string,
): Promise<string> {
  try {
    const res = await translate(vietnameseName, { from: "vi", to: "en" });

    // Chuẩn hóa kết quả dịch: Viết Hoa Chữ Cái Đầu Mỗi Từ cho đúng chuẩn tên môn học
    return res.text
      .split(/\s+/)
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  } catch (error) {
    // Chế độ dự phòng (Fallback): Nếu mất mạng hoặc Google chặn, tự động chuyển ngữ thô không dấu
    let str = vietnameseName.trim();
    str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
    str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
    str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
    str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
    str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
    str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
    str = str.replace(/đ/g, "d");
    return str
      .split(/\s+/)
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  }
}
// Hàm hỗ trợ tạo ký tự viết tắt từ tên tiếng Anh
function getAbbreviation(text: string): string {
  return text
    .trim()
    .toLowerCase()
    .split(/\s+/) // Tách các từ bằng khoảng trắng
    .map((word) => word[0]) // Lấy chữ cái đầu tiên của mỗi từ
    .join("")
    .replace(/[^a-z0-9_]/g, ""); // Loại bỏ ký tự đặc biệt nếu có
}

const SubjectSchema = z.object({
  code: z.string().min(1),
  name: z.string().min(1),
  nameEn: z.string().optional().nullable(), // Cho phép trống hoặc null
  credits: z.number().int().min(1).optional().default(3),
  roomType: z.enum(["THEORY", "PRACTICE", "HALL"]),
  isPractice: z.boolean().optional().default(false), // Cho phép không truyền lên từ UI
  requiresConsecutive: z.boolean().optional().default(false),
});

const ClassGroupSchema = z.object({
  majorId: z.string().uuid(),
  cohortId: z.string().uuid(),
  code: z.string().min(1),
  studentCount: z.number().int().min(0).optional().default(0),
});

const MajorSchema = z.object({
  code: z.string().min(1),
  name: z.string().min(1),
});

const CohortSchema = z.object({
  code: z.string().min(1),
  year: z.number().int().min(2000).max(2100),
});

const LocationSchema = z.object({
  name: z.string().min(1),
  code: z.string().min(1),
  address: z.string().optional(),
});

const CurriculumSchema = z.object({
  majorId: z.string().min(1),
  subjectId: z.string().min(1),
  semesterNo: z.number().int().min(1),
  weekStart: z.number().int().min(1),
  weekEnd: z.number().int().min(1),
  periodsPerWeek: z.number().int().min(1),
});

const AssignmentSchema = z.object({
  teacherId: z.string().uuid().optional(),
  classGroupId: z.string().uuid(),
});

function buildSubjectRouter(): Router {
  const r = Router();
  r.use(verifyJWT);

  // 1. Lấy danh sách môn học
  r.get("/", async (req, res, next) => {
    try {
      const subjects = await prisma.subject.findMany({
        orderBy: { code: "asc" },
      });
      res.status(200).json(subjects);
    } catch (e) {
      next(e);
    }
  });

  // 2. Tạo mới Môn học
  r.post("/", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      let { code, name, nameEn, credits, roomType, requiresConsecutive } =
        req.body;

      if (!code || !name || !roomType) {
        res
          .status(400)
          .json({ message: "Mã môn, Tên môn và Loại phòng là bắt buộc" });
        return;
      }

      const cleanCode = code.trim();

      // 🔥 DỊCH THÔNG MINH: Nếu trống nameEn, tự động tra từ điển dịch chuẩn
      let finalNameEn =
        nameEn && nameEn.trim().length > 0
          ? nameEn.trim()
          : await smartTranslateSubjectName(name);

      // TỰ SINH ID: Trích xuất chữ cái đầu từ tên tiếng Anh chuẩn (Ví dụ: "Advanced Mathematics" -> "am" -> "subj_am")
      const subPart = getAbbreviation(finalNameEn);
      const generatedId = `subj_${subPart || cleanCode.toLowerCase()}`;

      // 🔥 ĐỒNG BỘ ISPRACTICE: Nếu chọn PRACTICE thì true, chọn THEORY/HALL thì false
      const finalIsPractice = roomType === "PRACTICE";

      const subject = await prisma.subject.create({
        data: {
          id: generatedId,
          code: cleanCode,
          name: name.trim(),
          nameEn: finalNameEn,
          credits: credits ? Number(credits) : 3,
          roomType: roomType,
          isPractice: finalIsPractice,
          requiresConsecutive: !!requiresConsecutive,
        },
      });

      res.status(201).json(subject);
    } catch (e: any) {
      if (e.code === "P2002") {
        res.status(400).json({
          message:
            "ID viết tắt môn học hoặc Mã môn bị trùng, vui lòng kiểm tra lại!",
        });
        return;
      }
      next(e);
    }
  });

  // 3. Cập nhật Môn học
  r.put("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      let { code, name, nameEn, credits, roomType, requiresConsecutive } =
        req.body;

      // ĐỒNG BỘ ISPRACTICE KHI ĐỔI PHÒNG (Đảm bảo luôn luôn trả về true hoặc false rõ ràng)
      let finalIsPractice = undefined;
      if (roomType) {
        finalIsPractice = roomType === "PRACTICE";
      }

      // Xử lý dịch thuật lại nếu họ thay đổi trường name hoặc xóa trống nameEn
      let finalNameEn = undefined;
      if (nameEn !== undefined) {
        finalNameEn =
          nameEn && nameEn.trim().length > 0
            ? nameEn.trim()
            : await smartTranslateSubjectName(name || "");
      } else if (name) {
        finalNameEn = await smartTranslateSubjectName(name);
      }

      const subject = await prisma.subject.update({
        where: { id: req.params.id },
        data: {
          code: code !== undefined ? code.trim() : undefined,
          name: name !== undefined ? name.trim() : undefined,
          nameEn: finalNameEn || undefined,
          credits: credits !== undefined ? Number(credits) : undefined,
          roomType: roomType || undefined,
          // Kiểm tra an toàn: Nếu có thay đổi phòng thì cập nhật chuẩn xác kiểu dữ liệu boolean
          isPractice:
            finalIsPractice !== undefined ? !!finalIsPractice : undefined,
          requiresConsecutive:
            requiresConsecutive !== undefined
              ? !!requiresConsecutive
              : undefined,
        },
      });

      res.status(200).json(subject);
    } catch (e) {
      console.error("Lỗi cập nhật môn học:", e); // Ghi log ra màn hình console để dễ debug nếu có lỗi khác
      next(e);
    }
  });

  // 4. Xóa môn học
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.subject.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });

  return r;
}

function buildVersionRouter(): Router {
  const r = Router();
  r.use(verifyJWT);

  r.get("/", async (_req, res, next) => {
    try {
      const versions = await prisma.scheduleVersion.findMany({
        orderBy: { createdAt: "desc" },
      });
      res.json(versions);
    } catch (e) {
      next(e);
    }
  });

  const SnapshotSchema = z.object({
    versionLabel: z.string().min(1),
  });

  r.post(
    "/snapshot",
    roleGuard(["ADMIN"]),
    validate(SnapshotSchema),
    async (req, res, next) => {
      try {
        const schedules = await prisma.schedule.findMany({
          include: {
            teachingUnit: true,
            room: true,
            violations: true,
          },
        });

        const version = await prisma.scheduleVersion.create({
          data: {
            versionLabel: req.body.versionLabel,
            snapshot: JSON.parse(JSON.stringify(schedules)),
            createdBy: req.user!.userId,
          },
        });
        res.status(201).json(version);
      } catch (e) {
        next(e);
      }
    },
  );

  r.post(
    "/:id/restore",
    roleGuard(["ADMIN"]),
    async (req: Request, res: Response, next) => {
      try {
        const version = await prisma.scheduleVersion.findUnique({
          where: { id: req.params.id },
        });
        if (!version) throw new NotFoundError("ScheduleVersion");

        // Restore: delete all current schedules and violations, then recreate from snapshot
        await prisma.constraintViolationLog.deleteMany({});
        await prisma.schedule.deleteMany({});

        const snapshotSchedules = version.snapshot as Array<{
          id: string;
          teachingUnitId: string;
          roomId: string | null;
          dayOfWeek: number;
          periodStart: number;
          periodEnd: number;
          academicYear: string;
          weekOfYear: number;
          mode: string;
        }>;

        for (const s of snapshotSchedules) {
          await prisma.schedule.create({
            data: {
              id: s.id,
              teachingUnitId: s.teachingUnitId,
              roomId: s.roomId,
              dayOfWeek: s.dayOfWeek,
              periodStart: s.periodStart,
              periodEnd: s.periodEnd,
              academicYear: s.academicYear,
              weekOfYear: s.weekOfYear,
              mode: s.mode as "ONLINE" | "OFFLINE",
            },
          });
        }

        res.json({
          message: `Restored version "${version.versionLabel}"`,
          count: snapshotSchedules.length,
        });
      } catch (e) {
        next(e);
      }
    },
  );

  return r;
}

function buildMajorRouter(): Router {
  const r = Router();
  r.use(verifyJWT);
  r.get("/", async (_req, res, next) => {
    try {
      res.json(await prisma.major.findMany({ orderBy: { code: "asc" } }));
    } catch (e) {
      next(e);
    }
  });
  r.get("/:id", async (req, res, next) => {
    try {
      const m = await prisma.major.findUnique({
        where: { id: req.params.id },
        include: { classes: true },
      });
      if (!m) throw new NotFoundError("Major");
      res.json(m);
    } catch (e) {
      next(e);
    }
  });
  r.post("/", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { code, name } = req.body;
      if (!code || !name) {
        res
          .status(400)
          .json({ message: "Mã ngành và tên ngành không được để trống" });
        return;
      }

      const cleanCode = code.trim();
      // 🔥 TỰ ĐỘNG GENERATE ID THEO FORMAT: it1, it2, it_e10 (Chuyển hết thành chữ thường)
      const generatedId = `major_${cleanCode.toLowerCase()}`;

      const major = await prisma.major.create({
        data: {
          id: generatedId,
          code: cleanCode,
          name: name.trim(),
        },
      });
      res.status(201).json(major);
    } catch (e) {
      next(e);
    }
  });
  r.put("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { code, name } = req.body;
      const major = await prisma.major.update({
        where: { id: req.params.id },
        data: {
          code: code?.trim(),
          name: name?.trim(),
        },
      });
      res.status(200).json(major);
    } catch (e) {
      next(e);
    }
  });
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.major.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });
  return r;
}

function buildCohortRouter(): Router {
  const r = Router();
  r.use(verifyJWT);
  r.get("/", async (_req, res, next) => {
    try {
      res.json(await prisma.cohort.findMany({ orderBy: { year: "desc" } }));
    } catch (e) {
      next(e);
    }
  });
  r.get("/:id", async (req, res, next) => {
    try {
      const c = await prisma.cohort.findUnique({
        where: { id: req.params.id },
        include: { classes: true },
      });
      if (!c) throw new NotFoundError("Cohort");
      res.json(c);
    } catch (e) {
      next(e);
    }
  });
  r.post("/", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { code, year } = req.body;
      if (!code) {
        res.status(400).json({ message: "Mã khóa không được để trống" });
        return;
      }

      const cleanCode = code.trim();
      // 🔥 TỰ ĐỘNG GENERATE ID THEO FORMAT: cohort_k18, cohort_k19...
      const generatedId = `cohort_${cleanCode.toLowerCase()}`;

      const cohort = await prisma.cohort.create({
        data: {
          id: generatedId, // 🌟 Ép Prisma dùng ID này thay vì tự tạo chuỗi UUID ngẫu nhiên
          code: cleanCode,
          year: Number(year),
        },
      });
      res.status(201).json(cohort);
    } catch (e) {
      next(e);
    }
  });
  r.put("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { code, year } = req.body;
      const cohort = await prisma.cohort.update({
        where: { id: req.params.id },
        data: {
          code: code?.trim(),
          year: year ? Number(year) : undefined,
        },
      });
      res.status(200).json(cohort);
    } catch (e) {
      next(e);
    }
  });
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.cohort.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });
  return r;
}

// Hàm tự động lấy tọa độ Lat/Lng từ chuỗi địa chỉ (Sử dụng OpenStreetMap Nominatim API Free)
async function getCoordinates(
  address: string,
): Promise<{ lat: number | null; lng: number | null }> {
  if (!address || address.trim().length === 0) {
    return { lat: null, lng: null };
  }

  try {
    // OpenStreetMap yêu cầu phải có User-Agent rõ ràng trong Header để định danh request
    const response = await axios.get(
      "https://nominatim.openstreetmap.org/search",
      {
        params: {
          q: address,
          format: "json",
          limit: 1,
        },
        headers: {
          "User-Agent": "HUSTSmartScheduleApp/1.0 (IT Student Project)",
        },
      },
    );

    if (response.data && response.data.length > 0) {
      return {
        lat: parseFloat(response.data[0].lat),
        lng: parseFloat(response.data[0].lon),
      };
    }
    return { lat: null, lng: null };
  } catch (error) {
    console.error("Lỗi khi tự động lấy tọa độ từ địa chỉ:", error);
    return { lat: null, lng: null }; // Fallback an toàn nếu lỗi mạng/API giới hạn
  }
}

function buildLocationRouter(): Router {
  const r = Router();
  r.use(verifyJWT);

  // 1. Lấy danh sách địa điểm
  r.get("/", async (_req, res, next) => {
    try {
      res.json(
        await prisma.location.findMany({
          include: { rooms: true },
          orderBy: { code: "asc" },
        }),
      );
    } catch (e) {
      next(e);
    }
  });

  // 2. Lấy chi tiết một địa điểm
  r.get("/:id", async (req, res, next) => {
    try {
      const l = await prisma.location.findUnique({
        where: { id: req.params.id },
        include: { rooms: true },
      });
      if (!l) throw new NotFoundError("Location");
      res.json(l);
    } catch (e) {
      next(e);
    }
  });

  // 3. Tạo mới Địa điểm (TỰ ĐỘNG HÓA ID, DỊCH THUẬT VÀ TRA CỨU TOẠ ĐỘ)
  r.post(
    "/",
    roleGuard(["ADMIN"]),
    validate(LocationSchema),
    async (req, res, next) => {
      try {
        let { name, code, address } = req.body;

        const cleanCode = code.trim();
        // Sinh ID tự động theo quy chuẩn: location_code (ví dụ: location_a17)
        const generatedId = `location_${cleanCode.toLowerCase()}`;

        // Gọi tiến trình xử lý bất đồng bộ song song để tối ưu hiệu năng phản hồi mạng
        const [translatedName, translatedAddress, coords] = await Promise.all([
          smartTranslateSubjectName(name), // Dịch tự động tên địa điểm
          address ? smartTranslateSubjectName(address) : Promise.resolve(null), // Dịch tự động địa chỉ
          address
            ? getCoordinates(address)
            : Promise.resolve({ lat: null, lng: null }), // Tra tọa độ lý trình
        ]);

        const l = await prisma.location.create({
          data: {
            id: generatedId,
            code: cleanCode,
            name: name.trim(),
            address: address ? address.trim() : null,
            nameEn: translatedName,
            addressEn: translatedAddress,
            lat: coords.lat,
            lng: coords.lng,
          },
        });

        res.status(201).json(l);
      } catch (e: any) {
        if (e.code === "P2002") {
          res.status(400).json({
            message: "Mã địa điểm hoặc ID thực thể đã tồn tại trong hệ thống!",
          });
          return;
        }
        next(e);
      }
    },
  );

  // 4. Cập nhật thông tin Địa điểm
  r.put(
    "/:id",
    roleGuard(["ADMIN"]),
    validate(LocationSchema.partial()),
    async (req, res, next) => {
      try {
        let { name, code, address } = req.body;

        // Tạo đối tượng chứa dữ liệu động để cập nhật
        const updateData: any = {};
        if (code !== undefined) updateData.code = code.trim();
        if (name !== undefined) {
          updateData.name = name.trim();
          updateData.nameEn = await smartTranslateSubjectName(name);
        }

        if (address !== undefined) {
          const cleanAddress = address ? address.trim() : null;
          updateData.address = cleanAddress;

          if (cleanAddress) {
            // Nếu người dùng thay đổi hoặc cập nhật lại địa chỉ, hệ thống tính toán lại dịch thuật và Lat/Lng
            const [translatedAddress, coords] = await Promise.all([
              smartTranslateSubjectName(cleanAddress),
              getCoordinates(cleanAddress),
            ]);
            updateData.addressEn = translatedAddress;
            updateData.lat = coords.lat;
            updateData.lng = coords.lng;
          } else {
            updateData.addressEn = null;
            updateData.lat = null;
            updateData.lng = null;
          }
        }

        const l = await prisma.location.update({
          where: { id: req.params.id },
          data: updateData,
        });

        res.json(l);
      } catch (e) {
        next(e);
      }
    },
  );

  // 5. Xóa địa điểm
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.location.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });

  return r;
}

function buildCurriculumRouter(): Router {
  const r = Router();
  r.use(verifyJWT);
  r.get("/", async (req, res, next) => {
    try {
      const { majorId } = req.query;
      res.json(
        await prisma.curriculum.findMany({
          where: majorId ? { majorId: majorId as string } : {},
          include: { major: true, subject: true },
          orderBy: [{ majorId: "asc" }, { semesterNo: "asc" }],
        }),
      );
    } catch (e) {
      next(e);
    }
  });
  r.get("/:id", async (req, res, next) => {
    try {
      const c = await prisma.curriculum.findUnique({
        where: { id: req.params.id },
        include: { major: true, subject: true },
      });
      if (!c) throw new NotFoundError("Curriculum");
      res.json(c);
    } catch (e) {
      next(e);
    }
  });
  r.post(
    "/",
    roleGuard(["ADMIN"]),
    validate(CurriculumSchema),
    async (req, res, next) => {
      try {
        const {
          majorId,
          subjectId,
          semesterNo,
          weekStart,
          weekEnd,
          periodsPerWeek,
        } = req.body;

        // Tiến hành lưu vào bảng curricula thực tế của bạn
        const newCurriculum = await prisma.curriculum.create({
          data: {
            majorId: majorId.trim(),
            subjectId: subjectId.trim(),
            semesterNo: Number(semesterNo),
            weekStart: Number(weekStart),
            weekEnd: Number(weekEnd),
            periodsPerWeek: Number(periodsPerWeek),
          },
        });

        res.status(201).json(newCurriculum);
      } catch (e: any) {
        // Đánh chặn lỗi nếu môn học đó đã được gán vào ngành này ở học kỳ này rồi (P2002)
        if (e.code === "P2002") {
          res.status(400).json({
            message:
              "Môn học này đã được cấu hình trong chương trình đào tạo của ngành!",
          });
          return;
        }
        console.error("Lỗi lưu chương trình môn học:", e);
        next(e);
      }
    },
  );
  r.put(
    "/:id",
    roleGuard(["ADMIN"]),
    validate(CurriculumSchema.partial()),
    async (req, res, next) => {
      try {
        res.json(
          await prisma.curriculum.update({
            where: { id: req.params.id },
            data: req.body,
            include: { major: true, subject: true },
          }),
        );
      } catch (e) {
        next(e);
      }
    },
  );
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.curriculum.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });
  return r;
}

export function buildAssignmentRouter(): Router {
  const r = Router();
  r.use(verifyJWT);

  // 1. LẤY DANH SÁCH PHÂN CÔNG
  r.get("/", async (req, res, next) => {
    try {
      const { classGroupId, teacherId } = req.query;

      const rawAssignments = await prisma.assignment.findMany({
        where: {
          ...(classGroupId ? { classGroupId: classGroupId as string } : {}),
          ...(teacherId ? { teacherId: teacherId as string } : {}),
        },
        include: {
          teacher: {
            include: { user: true },
          },
          classGroup: {
            include: { major: true, cohort: true },
          },
        },
        // 🌟 ĐÃ BỎ orderBy: { createdAt: "desc" } để sửa lỗi sập backend
      });

      // 🌟 MAP DỮ LIỆU PHẲNG: Đẩy name từ user ra ngoài teacher.name để cứu ô tìm kiếm ở Frontend cũ
      const mappedAssignments = rawAssignments.map((a: any) => {
        if (a.teacher) {
          return {
            ...a,
            teacher: {
              id: a.teacher.id,
              code: a.teacher.code,
              dept: a.teacher.dept,
              userId: a.teacher.userId,
              name: a.teacher.user?.name || "Chưa cập nhật", // Khắc phục lỗi gõ tìm kiếm bị trắng màn hình
            },
          };
        }
        return a;
      });

      res.json(mappedAssignments);
    } catch (e) {
      console.error("❌ Lỗi GET /assignments:", e);
      next(e);
    }
  });

  // 2. LẤY CHI TIẾT PHÂN CÔNG THEO ID
  r.get("/:id", async (req, res, next) => {
    try {
      const a: any = await prisma.assignment.findUnique({
        where: { id: req.params.id },
        include: {
          teacher: { include: { user: true } },
          classGroup: { include: { major: true, cohort: true } },
        },
      });
      if (!a) {
        res.status(404).json({ message: "Không tìm thấy bản ghi phân công" });
        return;
      }

      if (a.teacher) {
        a.teacher.name = a.teacher.user?.name || "Chưa cập nhật";
      }

      res.json(a);
    } catch (e) {
      next(e);
    }
  });

  // 3. TẠO MỚI PHÂN CÔNG
  r.post("/", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { classGroupId, teacherId } = req.body;

      if (!classGroupId) {
        res.status(400).json({ message: "Vui lòng chọn lớp hành chính!" });
        return;
      }

      const a: any = await prisma.assignment.create({
        data: {
          classGroupId,
          teacherId: teacherId && teacherId.trim() !== "" ? teacherId : null,
        },
        include: {
          teacher: { include: { user: true } },
          classGroup: { include: { major: true, cohort: true } },
        },
      });

      if (a.teacher) {
        a.teacher.name = a.teacher.user?.name || "Chưa cập nhật";
      }

      res.status(201).json(a);
    } catch (e) {
      console.error("❌ Lỗi POST /assignments:", e);
      next(e);
    }
  });

  // 4. CHỈNH SỬA PHÂN CÔNG
  r.put("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      const { classGroupId, teacherId } = req.body;

      const a: any = await prisma.assignment.update({
        where: { id: req.params.id },
        data: {
          classGroupId,
          teacherId: teacherId && teacherId.trim() !== "" ? teacherId : null,
        },
        include: {
          teacher: { include: { user: true } },
          classGroup: { include: { major: true, cohort: true } },
        },
      });

      if (a.teacher) {
        a.teacher.name = a.teacher.user?.name || "Chưa cập nhật";
      }

      res.json(a);
    } catch (e) {
      console.error("❌ Lỗi PUT /assignments:", e);
      next(e);
    }
  });

  // 5. XÓA PHÂN CÔNG
  r.delete("/:id", roleGuard(["ADMIN"]), async (req, res, next) => {
    try {
      await prisma.assignment.delete({ where: { id: req.params.id } });
      res.status(204).send();
    } catch (e) {
      next(e);
    }
  });

  return r;
}

export function buildUserRouter(): Router {
  const r = Router();

  r.use(verifyJWT);
  r.use(roleGuard(["ADMIN"]));

  // API 1: Lấy danh sách toàn bộ tài khoản (Hỗ trợ lọc theo Role và Tìm kiếm Email)
  r.get("/", async (req, res, next) => {
    try {
      const { search, role } = req.query;
      const users = await prisma.user.findMany({
        where: {
          ...(role && role !== "ALL" ? { role: role as any } : {}),
          ...(search
            ? { email: { contains: search as string, mode: "insensitive" } }
            : {}),
        },
        orderBy: { createdAt: "desc" },
      });
      res.status(200).json(users);
    } catch (e) {
      next(e);
    }
  });

  // API 2: Chỉ tạo tài khoản ADMIN (Mặc định ép role ADMIN, mật khẩu mặc định Admin@123)
  r.post("/", async (req, res, next) => {
    try {
      const { email, password, name } = req.body;

      if (!email || email.trim() === "") {
        res.status(400).json({ message: "Email không được để trống" });
        return;
      }

      // Ép buộc mật khẩu mặc định là Admin@123 nếu UI để trống
      const rawPassword =
        password && password.trim() !== "" ? password : "Admin@123";

      // Sử dụng service có sẵn registerUser hoặc tự băm bằng bcrypt
      const hashedPassword = bcrypt.hashSync(rawPassword, 10);

      const user = await prisma.user.create({
        data: {
          email: email.trim().toLowerCase(),
          passwordHash: hashedPassword,
          role: "ADMIN", // Mặc định luôn là ADMIN
          name: name ? name.trim() : "Quản trị viên",
        },
      });

      res.status(201).json(user);
    } catch (e: any) {
      if (e.code === "P2002") {
        res.status(400).json({ message: "Địa chỉ email này đã được sử dụng!" });
        return;
      }
      next(e);
    }
  });

  // API 3: Sửa tài khoản (Chỉnh sửa được Email & Mật khẩu của TẤT CẢ các loại tài khoản)
  r.put("/:id", async (req, res, next) => {
    try {
      const { id } = req.params;
      const { email, password } = req.body;

      const existingUser = await prisma.user.findUnique({ where: { id } });
      if (!existingUser) {
        res
          .status(404)
          .json({ message: "Không tìm thấy tài khoản người dùng" });
        return;
      }

      const updateData: any = {};
      if (email !== undefined && email.trim() !== "") {
        updateData.email = email.trim().toLowerCase();
      }
      if (password && password.trim() !== "") {
        updateData.passwordHash = bcrypt.hashSync(password, 10);
      }

      const updatedUser = await prisma.user.update({
        where: { id },
        data: updateData,
      });

      res.status(200).json(updatedUser);
    } catch (e: any) {
      if (e.code === "P2002") {
        res
          .status(400)
          .json({ message: "Email cập nhật bị trùng với tài khoản khác!" });
        return;
      }
      next(e);
    }
  });

  // API 4: Xóa tài khoản người dùng
  r.delete("/:id", async (req, res, next) => {
    try {
      await prisma.user.delete({ where: { id: req.params.id } });
      res.status(200).json({ message: "Xóa tài khoản thành công" });
    } catch (e) {
      next(e);
    }
  });

  return r;
}

export function registerRoutes(app: Application): void {
  const prefix = appConf.apiPrefix;

  app.get(`${prefix}/health`, healthCheck);

  app.use(`${prefix}/auth`, authRoutes);
  app.use(`${prefix}/rooms`, roomRoutes);
  app.use(`${prefix}/teachers`, teacherRoutes);
  app.use(`${prefix}/students`, studentRoutes);
  app.use(`${prefix}/subjects`, buildSubjectRouter());
  // app.use(`${prefix}/classes`, buildClassRouter());
  app.use(`${prefix}/classes`, classGroupRoutes);
  app.use(`${prefix}/teaching-units`, teachingUnitRoutes);
  app.use(`${prefix}/schedules`, scheduleRoutes);
  app.use(`${prefix}/scheduler`, schedulerRoutes);
  app.use(`${prefix}/versions`, buildVersionRouter());
  app.use(`${prefix}/majors`, buildMajorRouter());
  app.use(`${prefix}/cohorts`, buildCohortRouter());
  app.use(`${prefix}/locations`, buildLocationRouter());
  app.use(`${prefix}/curricula`, buildCurriculumRouter());
  app.use(`${prefix}/assignments`, buildAssignmentRouter());
  app.use(`${prefix}/users`, buildUserRouter());

  // 404 fallback
  app.use((_req, res) => {
    res.status(404).json({ error: "NotFound", message: "Route not found" });
  });
}
