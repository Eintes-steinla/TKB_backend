-- ============================================================================
-- MASTER SEED FILE — TKB (Thời Khóa Biểu) System
-- Run once on a clean database to populate all tables.
--
-- Execution order (respects FK dependencies):
--   users → locations → rooms → majors → cohorts → subjects
--   → teachers → class_groups → curricula
--   → assignments → teaching_units → schedules
--   → students
--
-- Schema changes applied vs original seed files:
--   [schedules] "weekNumber" renamed to "weekOfYear"
--   [schedules] "academicYear" (VARCHAR) added — defaults to '2024-2025'
--   [assignments/teaching_units/schedules] Consolidated into single source
--     (files 10_assignments, 11_teaching_units, 12_schedules REPLACED by
--      the richer schedule.sql which includes full real data)
-- ============================================================================
-- Ensure pgcrypto is available (used for bcrypt password hashing)
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- Disable FK checks during bulk load for performance
-- SET session_replication_role = 'replica';
-- ============================================================================
-- 01. USERS (admin + 20 teachers + 480 students)
-- ============================================================================
-- ============================================================================
-- FILE: 01_users.sql
-- Xóa dữ liệu cũ, tạo mới users cho admin, teacher, student
-- Mật khẩu đã được hash bcrypt (cost=10)
-- ============================================================================
-- TRUNCATE TABLE users RESTART IDENTITY CASCADE;
-- Bật extension pgcrypto nếu chưa có (cần cho bcrypt)
-- ============================================================================
-- 1. ADMIN (1 tài khoản)
-- ============================================================================
INSERT INTO users (
        id,
        email,
        "passwordHash",
        role,
        "refId",
        name,
        "refreshToken",
        "createdAt"
    )
VALUES (
        gen_random_uuid(),
        'admin@hactech.edu.vn',
        crypt('Admin@123', gen_salt('bf', 10)),
        'ADMIN',
        NULL,
        'Administrator',
        NULL,
        NOW()
    );

-- ============================================================================
-- 2. TEACHERS (20 giáo viên)
-- ============================================================================
INSERT INTO users (
        id,
        email,
        "passwordHash",
        role,
        "refId",
        name,
        "refreshToken",
        "createdAt"
    )
VALUES (
        gen_random_uuid(),
        'nhuantt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Trần Thị Nhuận',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hungnv@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Văn Hùng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngocnt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thị Ngọc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhth@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Trần Hoàng Minh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'linhttk@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Lê Thị Thanh Linh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'tuannda@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Đỗ Anh Tuấn',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hainguyet@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thị Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quangpv@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Phạm Văn Quang',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hoabt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Bùi Thị Hòa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'dungnt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thế Dũng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuytd@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Trần Thị Thúy',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonlh@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Lê Hoàng Sơn',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vannt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thị Vân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thanhnt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thị Thanh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuclt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Lê Trọng Phúc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hiennt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Thị Hiền',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cuongnm@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Nguyễn Mạnh Cường',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'trangtt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Trịnh Thị Trang',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ducpt@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Phạm Trung Đức',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thulh@hactech.edu.vn',
        crypt('Teacher@123', gen_salt('bf', 10)),
        'TEACHER',
        NULL,
        'Lê Hồng Thu',
        NULL,
        NOW()
    );

-- ============================================================================
-- 3. STUDENTS (200 sinh viên - mỗi lớp 5 sinh viên)
-- Email đúng dạng: tên + 6 chữ số @student.hactech.edu.vn
-- Mật khẩu: Student@123
-- ============================================================================
INSERT INTO users (
        id,
        email,
        "passwordHash",
        role,
        "refId",
        name,
        "refreshToken",
        "createdAt"
    )
VALUES -- LTMT K15 (2 lớp x 5 = 10 SV)
    (
        gen_random_uuid(),
        'anh230101@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Hoàng Anh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binh230102@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Văn Bình',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cuong230103@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Mạnh Cường',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'duyen230104@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Duyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hai230105@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Thị Hải',
        NULL,
        NOW()
    ),
    -- LTMT2-K15
    (
        gen_random_uuid(),
        'hung230106@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Văn Hưng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'linh230107@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Thị Linh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minh230108@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Hoàng Minh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'nguyet230109@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Nguyệt',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phong230110@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Văn Phong',
        NULL,
        NOW()
    ),
    -- LTMT K16 (2 lớp)
    (
        gen_random_uuid(),
        'quang240101@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Quang',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuy240102@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Thị Thúy',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'tuan240103@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Tuấn',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vanh240104@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Vân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'xuan240105@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Xuân',
        NULL,
        NOW()
    ),
    -- LTMT2-K16
    (
        gen_random_uuid(),
        'yen240106@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Yến',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'bang240107@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Văn Bằng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chung240108@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Đức Chung',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'dung240109@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Văn Dũng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giang240110@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Thị Giang',
        NULL,
        NOW()
    ),
    -- LTMT K17 (2 lớp)
    (
        gen_random_uuid(),
        'hoang250101@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Văn Hoàng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khan250102@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Đức Khánh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'lam250103@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Thị Lam',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'mai250104@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Mai',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'nam250105@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Văn Nam',
        NULL,
        NOW()
    ),
    -- LTMT2-K17
    (
        gen_random_uuid(),
        'oanh250106@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Oanh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuc250107@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Đức Phúc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quyen250108@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Thị Quyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'son250109@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Văn Sơn',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thu250110@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Thị Thư',
        NULL,
        NOW()
    ),
    -- LTMT K18 (2 lớp)
    (
        gen_random_uuid(),
        'uyen260101@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Uyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinh260102@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Văn Vinh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'xuanh260103@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Xuân Hòa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yen260104@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Yên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anh260105@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Thị Ánh',
        NULL,
        NOW()
    ),
    -- LTMT2-K18
    (
        gen_random_uuid(),
        'binhan260106@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Bình An',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chi260107@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Thị Chi',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'duoc260108@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Văn Dược',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'enl260109@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị En',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phucn260110@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Phúc Ninh',
        NULL,
        NOW()
    ),
    -- QTM K15 (2 lớp)
    (
        gen_random_uuid(),
        'diem230201@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Diễm',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hoanglm230202@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Hoàng Long',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khuc230203@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Đức Khúc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'my230204@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Mỹ',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'nhat230205@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Văn Nhật',
        NULL,
        NOW()
    ),
    -- QTM2-K15
    (
        gen_random_uuid(),
        'phuong230206@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Phương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quynh230207@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Quỳnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonh230208@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Sơn Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thu230209@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Thu',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinhq230210@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh Quang',
        NULL,
        NOW()
    ),
    -- QTM K16
    (
        gen_random_uuid(),
        'am240201@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Á',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'bangh240202@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Bảo Hân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chat240203@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Chất',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'dom240204@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Đỗ Mạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangn240205@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Thị Giang',
        NULL,
        NOW()
    ),
    -- QTM2-K16
    (
        gen_random_uuid(),
        'huong240206@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Hương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khai240207@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Khải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'long240208@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Long',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'mai240209@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Mai',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'nghia240210@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Nghĩa',
        NULL,
        NOW()
    ),
    -- QTM K17
    (
        gen_random_uuid(),
        'oanh250201@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Thị Oanh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phucb250202@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Phúc Bảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quyet250203@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Quyết',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'tam250204@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thị Tâm',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinh250205@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh',
        NULL,
        NOW()
    ),
    -- QTM2-K17
    (
        gen_random_uuid(),
        'xuanh250206@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Hạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yenht250207@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Hoa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhqc250208@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Quốc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhpn250209@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Phương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chungd250210@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Chung Đức',
        NULL,
        NOW()
    ),
    -- QTM K18
    (
        gen_random_uuid(),
        'ducanh260201@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Đức Anh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hong260202@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Hồng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khue260203@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Khue',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minht260204@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Minh Tân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'nghiem260205@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Nghiêm',
        NULL,
        NOW()
    ),
    -- QTM2-K18
    (
        gen_random_uuid(),
        'phuoc260206@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Phước',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quoc260207@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Quốc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sang260208@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Sang',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuyv260209@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thúy Vân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vuong260210@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vương',
        NULL,
        NOW()
    ),
    -- UDPM K15 (2 lớp)
    (
        gen_random_uuid(),
        'ancc230301@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn An C',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhp230302@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Bình',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cong230303@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Công',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'diuc230304@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Diệu',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangv230305@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Giang',
        NULL,
        NOW()
    ),
    -- UDPM2-K15
    (
        gen_random_uuid(),
        'hanh230306@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Hạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hieu230307@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Hiếu',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khang230308@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Khang',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhk230309@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Minh Khoa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngocd230310@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Ngọc',
        NULL,
        NOW()
    ),
    -- UDPM K16 (2 lớp)
    (
        gen_random_uuid(),
        'phongc240301@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Phong',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quyen240302@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Quyền',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sont240303@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Sơn Tùng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuct240304@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thực',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'uenth240305@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Uyên Thư',
        NULL,
        NOW()
    ),
    -- UDPM2-K16
    (
        gen_random_uuid(),
        'vinhh240306@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Vinh Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'xuan240307@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Xuân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yenl240308@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Yến Linh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhv240309@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Anh Vũ',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhq240310@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Bình Quân',
        NULL,
        NOW()
    ),
    -- UDPM K17 (2 lớp)
    (
        gen_random_uuid(),
        'chi250301@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Chí',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'diep250302@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Diệp',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'eng250303@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Ếch',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuocd250304@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Phước Đức',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giap250305@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Giáp',
        NULL,
        NOW()
    ),
    -- UDPM2-K17
    (
        gen_random_uuid(),
        'hanh250306@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Hạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khanh250307@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Khánh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ly250308@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Ly',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhh250309@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Minh Hằng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'namc250310@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Nam Cường',
        NULL,
        NOW()
    ),
    -- UDPM K18 (2 lớp)
    (
        gen_random_uuid(),
        'oanh260301@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Oanh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phucn260302@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Phúc Nguyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quocb260303@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Quốc Bảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuyh260304@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thúy Hằng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vuha260305@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vũ Hà',
        NULL,
        NOW()
    ),
    -- UDPM2-K18
    (
        gen_random_uuid(),
        'xuanm260306@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Mạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yenp260307@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Phương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhd260308@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Dũng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binht260309@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Thuận',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cuongt260310@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Cường Thịnh',
        NULL,
        NOW()
    ),
    -- TKĐH K15 (4 lớp)
    (
        gen_random_uuid(),
        'anh230401@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Anh Thư',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binh230402@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Bình Thảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cuongh230403@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Cường Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'duyenth230404@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Duyên Thùy',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangnt230405@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Giang Nam',
        NULL,
        NOW()
    ),
    -- TKĐH2-K15
    (
        gen_random_uuid(),
        'hanhnt230406@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Hạnh Nhi',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hieuph230407@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Hiếu Phong',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'khangv230408@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Khang Vũ',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhtr230409@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Minh Trí',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngocd230410@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Ngọc Diệp',
        NULL,
        NOW()
    ),
    -- TKĐH3-K15
    (
        gen_random_uuid(),
        'phucnt230411@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Phúc Nguyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'quyen230412@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Quyên',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonmt230413@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Sơn Minh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuykt230414@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Thúy Kiều',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinhn230415@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh Ngọc',
        NULL,
        NOW()
    ),
    -- TKĐH4-K15
    (
        gen_random_uuid(),
        'xuanm230416@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Mai',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yenp230417@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Phụng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhq230418@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Quân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhdu230419@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Dương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chith230420@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Chí Thành',
        NULL,
        NOW()
    ),
    -- TKĐH K16 (4 lớp, 20 SV)
    (
        gen_random_uuid(),
        'dungtd240421@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Dũng Tiến',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'engt240422@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Ếch Tâm',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuoch240423@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Phước Hậu',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangb240424@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Giang Bảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hanhh240425@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Hạnh Hoa',
        NULL,
        NOW()
    ),
    -- TKĐH2-K16
    (
        gen_random_uuid(),
        'khanhv240426@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Khánh Vân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'linhm240427@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Linh My',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhn240428@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Minh Nhật',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngoch240429@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Ngọc Hân',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phongt240430@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Phong Thái',
        NULL,
        NOW()
    ),
    -- TKĐH3-K16
    (
        gen_random_uuid(),
        'quynhn240431@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Quỳnh Nga',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonhh240432@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Sơn Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuyan240433@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Thúy An',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'uthai240434@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Út Hải',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinhp240435@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh Phúc',
        NULL,
        NOW()
    ),
    -- TKĐH4-K16
    (
        gen_random_uuid(),
        'xuann240436@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Nghi',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yennh240437@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Nhi',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhth240438@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Thư',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhma240439@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Mai',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'cuongd240440@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Cường Đạt',
        NULL,
        NOW()
    ),
    -- TKĐH K17 (4 lớp, 20 SV)
    (
        gen_random_uuid(),
        'diept250441@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Diệp Thư',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'engtn250442@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Ếch Tuyết',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuoch250443@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Phước Hòa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangc250444@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Giang Cường',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hanhn250445@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Hạnh Nguyên',
        NULL,
        NOW()
    ),
    -- TKĐH2-K17
    (
        gen_random_uuid(),
        'khanhl250446@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Khánh Linh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'linhmh250447@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Linh Mai',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhan250448@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Minh Anh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngocb250449@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Ngọc Bảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phongv250450@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Phong Vũ',
        NULL,
        NOW()
    ),
    -- TKĐH3-K17
    (
        gen_random_uuid(),
        'quynhn250451@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Quỳnh Như',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonh250452@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Sơn Hòa',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuyh250453@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Thúy Hồng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'uthan250454@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Út Hạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinhn250455@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh Nghĩa',
        NULL,
        NOW()
    ),
    -- TKĐH4-K17
    (
        gen_random_uuid(),
        'xuanm250456@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Minh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yenth250457@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Thảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhq250458@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Quốc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhth250459@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Thư',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chit250460@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Chí Thiện',
        NULL,
        NOW()
    ),
    -- TKĐH K18 (4 lớp, 20 SV)
    (
        gen_random_uuid(),
        'dungt260461@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Dũng Thành',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'engt260462@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Ếch Tuyền',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phuch260463@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Phúc Hưng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'giangd260464@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Giang Đông',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'hanhh260465@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Hạnh Hương',
        NULL,
        NOW()
    ),
    -- TKĐH2-K18
    (
        gen_random_uuid(),
        'khanhn260466@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Khánh Ngọc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'linht260467@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Linh Thảo',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'minhn260468@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Minh Như',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'ngocp260469@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Ngọc Phương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'phongn260470@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Phong Nhã',
        NULL,
        NOW()
    ),
    -- TKĐH3-K18
    (
        gen_random_uuid(),
        'quynh260471@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Quỳnh Hương',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'sonn260472@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Sơn Ngọc',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'thuym260473@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Thúy My',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'utth260474@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Út Thơ',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'vinhn260475@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Vinh Nhân',
        NULL,
        NOW()
    ),
    -- TKĐH4-K18
    (
        gen_random_uuid(),
        'xuanh260476@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Nguyễn Xuân Hạnh',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'yent260477@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Trần Yến Thư',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'anhv260478@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Lê Anh Việt',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'binhh260479@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Phạm Bình Hưng',
        NULL,
        NOW()
    ),
    (
        gen_random_uuid(),
        'chih260480@student.hactech.edu.vn',
        crypt('Student@123', gen_salt('bf', 10)),
        'STUDENT',
        NULL,
        'Đỗ Chí Hiếu',
        NULL,
        NOW()
    );

-- ============================================================================
-- Kết thúc
-- ============================================================================
-- ============================================================================
-- 02. LOCATIONS
-- ============================================================================
-- TRUNCATE TABLE locations RESTART IDENTITY CASCADE;
INSERT INTO locations (
        id,
        name,
        "nameEn",
        code,
        address,
        "addressEn",
        lat,
        lng
    )
VALUES (
        'location_a17',
        'A17 - Tạ Quang Bửu',
        'A17 - Ta Quang Buu',
        'A17',
        'Số 101, Tạ Quang Bửu, Hai Bà Trưng, Hà Nội',
        '101 Ta Quang Buu, Hai Ba Trung, Hanoi',
        21.0145,
        105.8522
    ),
    (
        'location_pm',
        '75 Phương Mai',
        '75 Phuong Mai',
        'PM',
        '75 Phương Mai, Đống Đa, Hà Nội',
        '75 Phuong Mai, Dong Da, Hanoi',
        21.0140,
        105.8330
    ),
    (
        'location_1a',
        'Nhà 1A - Tạ Quang Bửu',
        'Building 1A - Ta Quang Buu',
        '1A',
        'Tạ Quang Bửu, Hai Bà Trưng, Hà Nội',
        'Ta Quang Buu, Hai Ba Trung, Hanoi',
        21.0150,
        105.8525
    );

-- ============================================================================
-- 03. ROOMS
-- ============================================================================
-- TRUNCATE TABLE rooms RESTART IDENTITY CASCADE;
INSERT INTO rooms (
        id,
        "locationId",
        code,
        TYPE,
        capacity,
        "isActive"
    )
VALUES (
        'room_a17_401',
        'location_a17',
        'A17-401',
        'THEORY',
        120,
        TRUE
    ),
    (
        'room_a17_402',
        'location_a17',
        'A17-402',
        'THEORY',
        120,
        TRUE
    ),
    (
        'room_a17_403',
        'location_a17',
        'A17-403',
        'THEORY',
        100,
        TRUE
    ),
    (
        'room_a17_404',
        'location_a17',
        'A17-404',
        'THEORY',
        100,
        TRUE
    ),
    (
        'room_a17_405',
        'location_a17',
        'A17-405',
        'THEORY',
        80,
        TRUE
    ),
    (
        'room_pm_304',
        'location_pm',
        'PM-304',
        'THEORY',
        90,
        TRUE
    ),
    (
        'room_pm_305',
        'location_pm',
        'PM-305',
        'THEORY',
        90,
        TRUE
    ),
    (
        'room_pm_406',
        'location_pm',
        'PM-406',
        'THEORY',
        100,
        TRUE
    ),
    (
        'room_pm_407',
        'location_pm',
        'PM-407',
        'THEORY',
        100,
        TRUE
    ),
    (
        'room_pm_408',
        'location_pm',
        'PM-408',
        'THEORY',
        80,
        TRUE
    ),
    (
        'room_a17_501a',
        'location_a17',
        'A17-501A',
        'PRACTICE',
        60,
        TRUE
    ),
    (
        'room_a17_501b',
        'location_a17',
        'A17-501B',
        'PRACTICE',
        60,
        TRUE
    ),
    (
        'room_a17_502',
        'location_a17',
        'A17-502',
        'PRACTICE',
        70,
        TRUE
    ),
    (
        'room_a17_503',
        'location_a17',
        'A17-503',
        'PRACTICE',
        50,
        TRUE
    ),
    (
        'room_a17_504',
        'location_a17',
        'A17-504',
        'PRACTICE',
        50,
        TRUE
    ),
    (
        'room_1a_101',
        'location_1a',
        '1A-101',
        'PRACTICE',
        40,
        TRUE
    ),
    (
        'room_1a_102',
        'location_1a',
        '1A-102',
        'PRACTICE',
        40,
        TRUE
    ),
    (
        'room_1a_draw1',
        'location_1a',
        '1A-Phòng vẽ 1',
        'PRACTICE',
        35,
        TRUE
    ),
    (
        'room_1a_draw2',
        'location_1a',
        '1A-Phòng vẽ 2',
        'PRACTICE',
        35,
        TRUE
    ),
    (
        'room_1a_draw3',
        'location_1a',
        '1A-Phòng vẽ 3',
        'PRACTICE',
        35,
        TRUE
    ),
    (
        'room_a17_hall',
        'location_a17',
        'A17-Hội trường',
        'HALL',
        300,
        TRUE
    ),
    (
        'room_pm_hall',
        'location_pm',
        'PM-Hội trường',
        'HALL',
        250,
        TRUE
    );

-- ============================================================================
-- 04. MAJORS
-- ============================================================================
-- TRUNCATE TABLE majors RESTART IDENTITY CASCADE;
INSERT INTO majors (id, code, name)
VALUES ('major_ltmt', 'LTMT', 'Lập trình máy tính'),
    ('major_qtm', 'QTM', 'Quản trị mạng máy tính'),
    ('major_udpm', 'UDPM', 'Ứng dụng phần mềm'),
    ('major_tkdh', 'TKĐH', 'Thiết kế đồ họa');

-- ============================================================================
-- 05. COHORTS
-- ============================================================================
-- TRUNCATE TABLE cohorts RESTART IDENTITY CASCADE;
INSERT INTO cohorts (id, code, year)
VALUES ('cohort_k15', 'K15', 2023),
    ('cohort_k16', 'K16', 2024),
    ('cohort_k17', 'K17', 2025),
    ('cohort_k18', 'K18', 2026);

-- ============================================================================
-- 06. SUBJECTS
-- ============================================================================
-- TRUNCATE TABLE subjects RESTART IDENTITY CASCADE;
-- Các môn học chung (giữ nguyên code)
INSERT INTO subjects (
        id,
        code,
        name,
        "nameEn",
        credits,
        "roomType",
        "isPractice",
        "requiresConsecutive"
    )
VALUES (
        'subj_politics',
        'MH01',
        'Chính trị',
        'Politics',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_law',
        'MH02',
        'Pháp luật',
        'Law',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_math',
        'MH03',
        'Toán cao cấp',
        'Advanced Mathematics',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_basic_it',
        'MH04',
        'Tin học căn bản',
        'Basic Informatics',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_eng1',
        'MH05',
        'Anh văn 1',
        'English 1',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_defense',
        'MH06',
        'Giáo dục Quốc phòng',
        'National Defense',
        4,
        'THEORY',
        false,
        false
    ),
    (
        'subj_physed',
        'MH07',
        'Giáo dục thể chất',
        'Physical Education',
        2,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_eng2',
        'MH08',
        'Anh văn 2',
        'English 2',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_office',
        'MH09',
        'Tin học văn phòng',
        'Office Informatics',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_comarch',
        'MH10',
        'Cấu trúc máy tính',
        'Computer Architecture',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_progbasic',
        'MH11',
        'Lập trình căn bản',
        'Basic Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_install_pc',
        'MH12',
        'Cài đặt & bảo trì máy tính',
        'PC Installation & Maintenance',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_netintro',
        'MH13',
        'Nhập môn mạng máy tính',
        'Introduction to Networks',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_esp1',
        'MH16',
        'Anh văn chuyên ngành 1',
        'ESP 1',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_esp2',
        'MH23',
        'Anh văn chuyên ngành 2',
        'ESP 2',
        2,
        'THEORY',
        false,
        false
    ),
    -- =================== NGÀNH QUẢN TRỊ MẠNG (QTM) ===================
    (
        'subj_datacom',
        'MH37QTM',
        'Kỹ thuật truyền số liệu',
        'Data Communication',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_wireless',
        'MH14QTM',
        'Công nghệ mạng không dây',
        'Wireless Network',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_db_qtm',
        'MH17QTM',
        'Cơ sở dữ liệu',
        'Database',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_dsalg_qtm',
        'MH19QTM',
        'Cấu trúc dữ liệu & giải thuật',
        'Data Structures & Algorithms',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_webdesign_qtm',
        'MH20QTM',
        'Thiết kế Website',
        'Web Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_winadmin',
        'MH21QTM',
        'Quản trị mạng Windows',
        'Windows Network Admin',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_sqlserver_qtm',
        'MH24QTM',
        'Hệ quản trị CSDL SQL Server',
        'SQL Server DBMS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_netprog',
        'MH25QTM',
        'Lập trình mạng',
        'Network Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_webmail_admin',
        'MH26QTM',
        'Quản trị WebServer & MailServer',
        'Web & Mail Server Admin',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_analysis_qtm',
        'MH27QTM',
        'Phân tích thiết kế hệ thống',
        'System Analysis & Design',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_linux',
        'MH28QTM',
        'Hệ điều hành Linux',
        'Linux OS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_softskill',
        'MH31',
        'Kỹ năng mềm',
        'Soft Skills',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_cms_web',
        'MH32QTM',
        'Xây dựng Website bằng PMMNM',
        'CMS Web Development',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_linuxadmin',
        'MH33QTM',
        'Quản trị mạng Linux',
        'Linux Network Admin',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_netmain',
        'MH34QTM',
        'Bảo trì hệ thống mạng',
        'Network Maintenance',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_netsec',
        'MH35QTM',
        'An toàn mạng',
        'Network Security',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_lan_design',
        'MH36QTM',
        'Thiết kế xây dựng mạng LAN',
        'LAN Design & Construction',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_elec_tech',
        'MH15QTM',
        'Kỹ thuật điện tử',
        'Electronics',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_firewall',
        'MH30QTM',
        'Hệ thống tường lửa',
        'Firewall System',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_oop_qtm',
        'MH18QTM',
        'Lập trình hướng đối tượng',
        'OOP',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_internship',
        'MH38',
        'Thực tập tốt nghiệp',
        'Internship',
        10,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_graduation',
        'MH39',
        'Đồ án/Thi tốt nghiệp',
        'Graduation Project',
        15,
        'PRACTICE',
        TRUE,
        false
    ),
    -- =================== NGÀNH LẬP TRÌNH MÁY TÍNH (LTMT) ===================
    (
        'subj_imageproc',
        'MH14LTMT',
        'Xử lý ảnh',
        'Image Processing',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_db_ltmt',
        'MH15LTMT',
        'Cơ sở dữ liệu',
        'Database',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_progtech',
        'MH17LTMT',
        'Kỹ thuật lập trình',
        'Programming Techniques',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_access',
        'MH18LTMT',
        'Hệ quản trị CSDL M.Access',
        'MS Access DBMS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_dsalg_ltmt',
        'MH19LTMT',
        'Cấu trúc dữ liệu & giải thuật',
        'Data Structures & Algorithms',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_oop_ltmt',
        'MH20LTMT',
        'Lập trình hướng đối tượng',
        'OOP',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_csharp',
        'MH21LTMT',
        'Lập trình C#',
        'C# Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_sqlserver_ltmt',
        'MH24LTMT',
        'Hệ quản trị CSDL SQL Server',
        'SQL Server DBMS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_service_prog',
        'MH25LTMT',
        'Lập trình Service',
        'Service Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_se_intro',
        'MH26LTMT',
        'Nhập môn công nghệ phần mềm',
        'Intro to SE',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_analysis_ltmt',
        'MH27LTMT',
        'Phân tích & thiết kế hệ thống',
        'System Analysis & Design',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_webdesign_ltmt',
        'MH28LTMT',
        'Thiết kế Website',
        'Web Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_softskill_ltmt',
        'MH31LTMT',
        'Kỹ năng mềm',
        'Soft Skills',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_php_net',
        'MH32LTMT',
        'Lập trình PHP.NET',
        'PHP.NET Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_mobile',
        'MH33LTMT',
        'Lập trình thiết bị di động',
        'Mobile Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_linux_ltmt',
        'MH29LTMT',
        'Hệ điều hành Linux',
        'Linux OS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_xml',
        'MH36LTMT',
        'Lập trình XML',
        'XML Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_sw_manage_ltmt',
        'MH35LTMT',
        'Xây dựng phần mềm quản lý',
        'Management Software',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_internship_ltmt',
        'MH37LTMT',
        'Thực tập tốt nghiệp',
        'Internship',
        10,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_graduation_ltmt',
        'MH38LTMT',
        'Đồ án/Thi tốt nghiệp',
        'Graduation Project',
        15,
        'PRACTICE',
        TRUE,
        false
    ),
    -- =================== NGÀNH ỨNG DỤNG PHẦN MỀM (UDPM) ===================
    (
        'subj_word',
        'MH09UDPM',
        'Soạn thảo văn bản',
        'Word Processing',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_excel',
        'MH14UDPM',
        'Bảng tính Excel',
        'Excel',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_db_udpm',
        'MH16UDPM',
        'Cơ sở dữ liệu',
        'Database',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_dsalg_udpm',
        'MH19UDPM',
        'Cấu trúc dữ liệu & giải thuật',
        'Data Structures & Algorithms',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_winadmin_udpm',
        'MH17UDPM',
        'Quản trị mạng Windows',
        'Windows Network Admin',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_access_udpm',
        'MH18UDPM',
        'Hệ quản trị CSDL M.Access',
        'MS Access DBMS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_corel_udpm',
        'MH25UDPM',
        'Thiết kế đồ họa bằng Corel Draw',
        'Corel Draw',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_analysis_udpm',
        'MH27UDPM',
        'Phân tích & thiết kế hệ thống',
        'System Analysis & Design',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_linux_udpm',
        'MH28UDPM',
        'Hệ điều hành Linux',
        'Linux OS',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_webprog',
        'MH26UDPM',
        'Lập trình Web',
        'Web Programming',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_sec_info',
        'MH32UDPM',
        'An toàn & bảo mật thông tin',
        'Information Security',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_cms_web_udpm',
        'MH33UDPM',
        'Xây dựng Website bằng PMMNM',
        'CMS Web Development',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_sw_manage_udpm',
        'MH36UDPM',
        'Xây dựng phần mềm quản lý',
        'Management Software',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_install_pc_udpm',
        'MH12UDPM',
        'Cài đặt & bảo trì máy tính',
        'PC Installation & Maintenance',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_business_org',
        'MH35UDPM',
        'Tổ chức quản lý doanh nghiệp',
        'Business Organization',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_accounting',
        'MH30UDPM',
        'Kế toán đại cương',
        'General Accounting',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_presentation',
        'MH37UDPM',
        'Thiết kế trình diễn trên máy tính',
        'Presentation Design',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_softskill_udpm',
        'MH31UDPM',
        'Kỹ năng mềm',
        'Soft Skills',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_internship_udpm',
        'MH38UDPM',
        'Thực tập tốt nghiệp',
        'Internship',
        10,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_graduation_udpm',
        'MH39UDPM',
        'Đồ án/Thi tốt nghiệp',
        'Graduation Project',
        15,
        'PRACTICE',
        TRUE,
        false
    ),
    -- =================== NGÀNH THIẾT KẾ ĐỒ HỌA (TKĐH) ===================
    (
        'subj_basic_draw',
        'MH12TKĐH',
        'Hình họa cơ bản',
        'Basic Drawing',
        3,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_art_history',
        'MH13TKĐH',
        'Lịch sử mỹ thuật',
        'Art History',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_corel_tkdh',
        'MH14TKĐH',
        'Thiết kế đồ họa bằng Corel Draw',
        'Corel Draw',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_color_science',
        'MH15TKĐH',
        'Khoa học màu sắc và nghiên cứu thiên nhiên',
        'Color Science & Nature Study',
        3,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_db_tkdh',
        'MH17TKĐH',
        'Cơ sở dữ liệu',
        'Database',
        3,
        'THEORY',
        false,
        false
    ),
    (
        'subj_gd_basic',
        'MH18TKĐH',
        'Thiết kế đồ họa cơ bản',
        'Basic Graphic Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_applied_draw',
        'MH19TKĐH',
        'Hình họa ứng dụng',
        'Applied Drawing',
        3,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_corel_adv',
        'MH20TKĐH',
        'Corel Draw nâng cao',
        'Advanced Corel Draw',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_2d_shape',
        'MH21TKĐH',
        'Cơ sở tạo hình trên mặt phẳng',
        '2D Shape Fundamentals',
        3,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_illustrator',
        'MH22TKĐH',
        'Tạo hình 2D (Illustrator)',
        'Illustrator',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_webdesign_tkdh',
        'MH27TKĐH',
        'Thiết kế Website',
        'Web Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_imageproc_tkdh',
        'MH28TKĐH',
        'Xử lý ảnh',
        'Image Processing',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_3d_shape',
        'MH29TKĐH',
        'Cơ sở tạo hình khối không gian',
        '3D Shape Fundamentals',
        3,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_commercial_design',
        'MH25TKĐH',
        'Thiết kế đồ họa chuyên ngành công thương nghiệp',
        'Commercial Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_dtp',
        'MH26TKĐH',
        'Chế bản điện tử',
        'Electronic Publishing',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_gd_adv',
        'MH33TKĐH',
        'Thiết kế đồ họa tổng hợp',
        'Advanced Graphic Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_cultural_design',
        'MH36TKĐH',
        'Thiết kế đồ họa chuyên ngành Văn hóa',
        'Cultural Design',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_adv_image',
        'MH37TKĐH',
        'Xử lý ảnh nâng cao',
        'Advanced Image Processing',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_softskill_tkdh',
        'MH31TKĐH',
        'Kỹ năng mềm',
        'Soft Skills',
        2,
        'THEORY',
        false,
        false
    ),
    (
        'subj_peripheral',
        'MH32TKĐH',
        'Các thiết bị ngoại vi',
        'Peripheral Devices',
        2,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_video',
        'MH34TKĐH',
        'Dựng Video',
        'Video Editing',
        3,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_flash',
        'MH35TKĐH',
        'Flash',
        'Flash',
        2,
        'PRACTICE',
        TRUE,
        TRUE
    ),
    (
        'subj_internship_tkdh',
        'MH38TKĐH',
        'Thực tập tốt nghiệp',
        'Internship',
        10,
        'PRACTICE',
        TRUE,
        false
    ),
    (
        'subj_graduation_tkdh',
        'MH39TKĐH',
        'Đồ án/Thi tốt nghiệp',
        'Graduation Project',
        15,
        'PRACTICE',
        TRUE,
        false
    );

-- ============================================================================
-- 07. TEACHERS
-- Maps each teacher to their users row via userId (Prisma schema: no name/email on teachers)
-- ============================================================================
-- TRUNCATE TABLE teachers RESTART IDENTITY CASCADE;
INSERT INTO teachers (id, code, dept, "unavailableSlots", "userId")
VALUES (
        gen_random_uuid(),
        'GV001',
        'CNTT',
        '[]',
        (
            SELECT id
            FROM users
            WHERE email = 'nhuantt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV002', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'hungnv@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV003', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'ngocnt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV004', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'minhth@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV005', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'linhttk@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV006', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'tuannda@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV007', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'hainguyet@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV008', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'quangpv@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV009', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'hoabt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV010', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'dungnt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV011', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'thuytd@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV012', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'sonlh@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV013', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'vannt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV014', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'thanhnt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV015', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'phuclt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV016', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'hiennt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV017', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'cuongnm@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV018', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'trangtt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV019', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'ducpt@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    ), (
        gen_random_uuid(), 'GV020', 'CNTT', '[]', (
            SELECT id
            FROM users
            WHERE email = 'thulh@hactech.edu.vn'
                AND role = 'TEACHER'
            LIMIT 1
        )
    );

-- Link users.refId → teachers.id for TEACHER accounts
UPDATE users
SET "refId" = t.id
FROM teachers t
WHERE users.id = t."userId"
    AND users.role = 'TEACHER';

-- 08. CLASS GROUPS
-- ============================================================================
-- TRUNCATE TABLE class_groups RESTART IDENTITY CASCADE;
INSERT INTO class_groups (id, "majorId", "cohortId", code, "studentCount")
VALUES -- LTMT
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k15',
        'LTMT1-K15',
        72
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k15',
        'LTMT2-K15',
        70
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k16',
        'LTMT1-K16',
        74
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k16',
        'LTMT2-K16',
        71
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k17',
        'LTMT1-K17',
        73
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k17',
        'LTMT2-K17',
        73
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k18',
        'LTMT1-K18',
        68
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'cohort_k18',
        'LTMT2-K18',
        65
    ),
    -- QTM
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k15',
        'QTM1-K15',
        60
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k15',
        'QTM2-K15',
        58
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k16',
        'QTM1-K16',
        62
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k16',
        'QTM2-K16',
        60
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k17',
        'QTM1-K17',
        65
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k17',
        'QTM2-K17',
        63
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k18',
        'QTM1-K18',
        55
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'cohort_k18',
        'QTM2-K18',
        52
    ),
    -- UDPM
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k15',
        'UDPM1-K15',
        68
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k15',
        'UDPM2-K15',
        65
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k16',
        'UDPM1-K16',
        70
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k16',
        'UDPM2-K16',
        68
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k17',
        'UDPM1-K17',
        72
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k17',
        'UDPM2-K17',
        70
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k18',
        'UDPM1-K18',
        66
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'cohort_k18',
        'UDPM2-K18',
        64
    ),
    -- TKĐH
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k15',
        'TKĐH1-K15',
        40
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k15',
        'TKĐH2-K15',
        38
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k15',
        'TKĐH3-K15',
        39
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k15',
        'TKĐH4-K15',
        37
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k16',
        'TKĐH1-K16',
        42
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k16',
        'TKĐH2-K16',
        40
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k16',
        'TKĐH3-K16',
        41
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k16',
        'TKĐH4-K16',
        39
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k17',
        'TKĐH1-K17',
        45
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k17',
        'TKĐH2-K17',
        44
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k17',
        'TKĐH3-K17',
        43
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k17',
        'TKĐH4-K17',
        42
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k17',
        'TKĐH CLC-K17',
        30
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k18',
        'TKĐH1-K18',
        38
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k18',
        'TKĐH2-K18',
        36
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k18',
        'TKĐH3-K18',
        37
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'cohort_k18',
        'TKĐH4-K18',
        35
    );

-- ============================================================================
-- 09. CURRICULA
-- ============================================================================
-- TRUNCATE TABLE curricula RESTART IDENTITY CASCADE;
-- =================== NGÀNH QUẢN TRỊ MẠNG (QTM) ===================
-- Học kỳ 1 (tuần 1-15)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_politics',
        1,
        1,
        15,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_law',
        1,
        1,
        15,
        2
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_math',
        1,
        1,
        15,
        3
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_basic_it',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_eng1',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_defense',
        1,
        1,
        15,
        5
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_physed',
        1,
        1,
        15,
        4
    );

-- Học kỳ 2 (tuần 16-30)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_eng2',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_office',
        2,
        16,
        30,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_comarch',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_progbasic',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_install_pc',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_netintro',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_wireless',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_elec_tech',
        2,
        16,
        30,
        4
    );

-- Học kỳ 3 (tuần 31-45)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_esp1',
        3,
        31,
        45,
        2
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_db_qtm',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_oop_qtm',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_dsalg_qtm',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_webdesign_qtm',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_winadmin',
        3,
        31,
        45,
        6
    );

-- Học kỳ 4 (tuần 46-60)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_esp2',
        4,
        46,
        60,
        2
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_sqlserver_qtm',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_netprog',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_webmail_admin',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_analysis_qtm',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_linux',
        4,
        46,
        60,
        4
    );

-- Học kỳ 5 (tuần 61-75)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_firewall',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_softskill',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_cms_web',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_linuxadmin',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_netmain',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_netsec',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_lan_design',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_datacom',
        5,
        61,
        75,
        4
    );

-- Học kỳ 6 (tuần 76-90)
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_qtm',
        'subj_internship',
        6,
        76,
        90,
        0
    ),
    (
        gen_random_uuid(),
        'major_qtm',
        'subj_graduation',
        6,
        76,
        90,
        0
    );

-- =================== NGÀNH LẬP TRÌNH MÁY TÍNH (LTMT) ===================
-- Học kỳ 1
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_politics',
        1,
        1,
        15,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_law',
        1,
        1,
        15,
        2
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_math',
        1,
        1,
        15,
        3
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_basic_it',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_eng1',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_defense',
        1,
        1,
        15,
        5
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_physed',
        1,
        1,
        15,
        4
    );

-- Học kỳ 2
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_eng2',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_office',
        2,
        16,
        30,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_comarch',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_progbasic',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_install_pc',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_netintro',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_imageproc',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_db_ltmt',
        2,
        16,
        30,
        4
    );

-- Học kỳ 3
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_esp1',
        3,
        31,
        45,
        2
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_progtech',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_access',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_dsalg_ltmt',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_oop_ltmt',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_csharp',
        3,
        31,
        45,
        6
    );

-- Học kỳ 4
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_esp2',
        4,
        46,
        60,
        2
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_sqlserver_ltmt',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_service_prog',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_se_intro',
        4,
        46,
        60,
        2
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_analysis_ltmt',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_webdesign_ltmt',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_linux_ltmt',
        4,
        46,
        60,
        4
    );

-- Học kỳ 5
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_softskill',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_php_net',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_mobile',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_linux_ltmt',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_sw_manage_ltmt',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_xml',
        5,
        61,
        75,
        6
    );

-- Học kỳ 6
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_ltmt',
        'subj_internship_ltmt',
        6,
        76,
        90,
        0
    ),
    (
        gen_random_uuid(),
        'major_ltmt',
        'subj_graduation_ltmt',
        6,
        76,
        90,
        0
    );

-- =================== NGÀNH ỨNG DỤNG PHẦN MỀM (UDPM) ===================
-- Học kỳ 1
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_politics',
        1,
        1,
        15,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_law',
        1,
        1,
        15,
        2
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_math',
        1,
        1,
        15,
        3
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_basic_it',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_eng1',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_defense',
        1,
        1,
        15,
        5
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_physed',
        1,
        1,
        15,
        4
    );

-- Học kỳ 2
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_eng2',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_word',
        2,
        16,
        30,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_comarch',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_progbasic',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_install_pc_udpm',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_netintro',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_excel',
        2,
        16,
        30,
        6
    );

-- Học kỳ 3
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_esp1',
        3,
        31,
        45,
        2
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_db_udpm',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_winadmin_udpm',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_access_udpm',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_dsalg_udpm',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_webdesign_ltmt',
        3,
        31,
        45,
        6
    );

-- Học kỳ 4
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_esp2',
        4,
        46,
        60,
        2
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_imageproc',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_sqlserver_ltmt',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_corel_udpm',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_webprog',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_analysis_udpm',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_linux_udpm',
        4,
        46,
        60,
        4
    );

-- Học kỳ 5
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_accounting',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_softskill_udpm',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_sec_info',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_cms_web_udpm',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_business_org',
        5,
        61,
        75,
        2
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_sw_manage_udpm',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_presentation',
        5,
        61,
        75,
        4
    );

-- Học kỳ 6
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_udpm',
        'subj_internship_udpm',
        6,
        76,
        90,
        0
    ),
    (
        gen_random_uuid(),
        'major_udpm',
        'subj_graduation_udpm',
        6,
        76,
        90,
        0
    );

-- =================== NGÀNH THIẾT KẾ ĐỒ HỌA (TKĐH) ===================
-- Học kỳ 1
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_politics',
        1,
        1,
        15,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_law',
        1,
        1,
        15,
        2
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_math',
        1,
        1,
        15,
        3
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_basic_it',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_eng1',
        1,
        1,
        15,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_defense',
        1,
        1,
        15,
        5
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_physed',
        1,
        1,
        15,
        4
    );

-- Học kỳ 2
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_eng2',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_office',
        2,
        16,
        30,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_comarch',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_progbasic',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_basic_draw',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_art_history',
        2,
        16,
        30,
        2
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_corel_tkdh',
        2,
        16,
        30,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_color_science',
        2,
        16,
        30,
        6
    );

-- Học kỳ 3
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_esp1',
        3,
        31,
        45,
        2
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_db_tkdh',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_gd_basic',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_applied_draw',
        3,
        31,
        45,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_corel_adv',
        3,
        31,
        45,
        3
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_2d_shape',
        3,
        31,
        45,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_illustrator',
        3,
        31,
        45,
        6
    );

-- Học kỳ 4
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_esp2',
        4,
        46,
        60,
        2
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_commercial_design',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_dtp',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_webdesign_tkdh',
        4,
        46,
        60,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_imageproc_tkdh',
        4,
        46,
        60,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_3d_shape',
        4,
        46,
        60,
        4
    );

-- Học kỳ 5
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_softskill_tkdh',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_peripheral',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_gd_adv',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_video',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_flash',
        5,
        61,
        75,
        4
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_cultural_design',
        5,
        61,
        75,
        6
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_adv_image',
        5,
        61,
        75,
        3
    );

-- Học kỳ 6
INSERT INTO curricula (
        id,
        "majorId",
        "subjectId",
        "semesterNo",
        "weekStart",
        "weekEnd",
        "periodsPerWeek"
    )
VALUES (
        gen_random_uuid(),
        'major_tkdh',
        'subj_internship_tkdh',
        6,
        76,
        90,
        0
    ),
    (
        gen_random_uuid(),
        'major_tkdh',
        'subj_graduation_tkdh',
        6,
        76,
        90,
        0
    );

-- ============================================================================
-- 10. ASSIGNMENTS + TEACHING UNITS + SCHEDULES
-- SCHEMA FIX: weekNumber -> weekOfYear, academicYear="2024-2025" added
-- ============================================================================
-- TRUNCATE TABLE assignments RESTART IDENTITY CASCADE;
INSERT INTO assignments (id, "teacherId", "classGroupId")
VALUES (
        '0b406b11-5475-4d55-9b51-90b15746a455',
        (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K15'
            LIMIT 1
        )
    ), (
        '72473f12-f9db-48bb-a5a6-7faf1cd8b7f6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K15'
            LIMIT 1
        )
    ), (
        'fad76fa3-c296-450d-86f4-80b6ecc648da', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K15'
            LIMIT 1
        )
    ), (
        '1335a846-f7ef-46b2-bc2d-ee6474032047', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K15'
            LIMIT 1
        )
    ), (
        '8a18d42a-3005-4ce9-aa2b-81a4d5bd6ebf', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K15'
            LIMIT 1
        )
    ), (
        '7a076337-ea51-4884-a713-579197fa9e86', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K15'
            LIMIT 1
        )
    ), (
        'fd251813-debb-4f78-bc44-334429df37de', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K15'
            LIMIT 1
        )
    ), (
        'af86f89e-cc1a-4363-b0b9-e47ed163522e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K15'
            LIMIT 1
        )
    ), (
        '86015a2c-fca6-4394-a44c-02dc13c16a47', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K15'
            LIMIT 1
        )
    ), (
        'afda5fd0-736b-45eb-b825-b3c8666470d6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K15'
            LIMIT 1
        )
    ), (
        '8047e965-3b17-479e-a895-a3a5e0794850', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K16'
            LIMIT 1
        )
    ), (
        '518ba291-c283-43c8-ae99-81d07ffd2eeb', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K16'
            LIMIT 1
        )
    ), (
        'c51ee132-dc48-4c91-85cb-9794264ba26f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K16'
            LIMIT 1
        )
    ), (
        '48270b78-0a00-4c03-9b78-26f871210c0f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K16'
            LIMIT 1
        )
    ), (
        'a8935ac4-70fb-4a74-9516-b097bc813381', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K16'
            LIMIT 1
        )
    ), (
        '576eb389-e243-43c6-b0a2-eb236d65a002', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K16'
            LIMIT 1
        )
    ), (
        '17af8001-b2f1-4a5a-a407-414f44da6121', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K16'
            LIMIT 1
        )
    ), (
        '0a014e30-357b-4187-a109-6f86820ffab9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K16'
            LIMIT 1
        )
    ), (
        '60bb6c2c-54a2-4acd-b1af-b9cf7d439012', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K16'
            LIMIT 1
        )
    ), (
        '5011072d-e3df-4096-a1ea-ca4672e7556d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K16'
            LIMIT 1
        )
    ), (
        '1da88e0b-f187-49f0-87e8-bdcdd382ee3c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K17'
            LIMIT 1
        )
    ), (
        '1fb52561-b0b8-40c1-899b-307c309cca13', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K17'
            LIMIT 1
        )
    ), (
        'b6dc5f55-d6fd-4929-8a9d-a6366bab8ec3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K17'
            LIMIT 1
        )
    ), (
        'ca51ff66-1b2b-4276-a099-7a59d716e87b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K17'
            LIMIT 1
        )
    ), (
        '4657cff3-b497-4aae-99d2-ea02b6c1a1e6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K17'
            LIMIT 1
        )
    ), (
        'bc540c63-e6dc-4783-a884-d2eee75b60a1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K17'
            LIMIT 1
        )
    ), (
        'ebecc252-b3a9-4a9c-9d3b-eaebf4edbd04', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K17'
            LIMIT 1
        )
    ), (
        '38090d9e-bbd0-4668-83c8-06e84aeb313d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K17'
            LIMIT 1
        )
    ), (
        '8399385a-d8ae-4b93-a5de-b60b7bb66903', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K17'
            LIMIT 1
        )
    ), (
        '5113cac0-3620-475d-a7cc-abdf2629e2db', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K17'
            LIMIT 1
        )
    ), (
        'ce048288-4f47-4b0c-8348-f4611a5d886d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K18'
            LIMIT 1
        )
    ), (
        'dadd7cc6-8cb1-4e05-90ea-d57735b2dcf8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K18'
            LIMIT 1
        )
    ), (
        '75d61a7d-d9eb-46bd-9b00-c55593ea8234', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K18'
            LIMIT 1
        )
    ), (
        '5bce3d7f-bdf1-46f0-8be5-a963a86200d8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K18'
            LIMIT 1
        )
    ), (
        'df1be6e4-dfd3-43e3-8f52-1f17ca9a2010', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT1-K18'
            LIMIT 1
        )
    ), (
        '8bfd203c-fbd3-4fad-ac6c-c62bca334101', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hungnv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K18'
            LIMIT 1
        )
    ), (
        '7d80e189-d56b-4e88-8e55-1cc1079783a3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'quangpv@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K18'
            LIMIT 1
        )
    ), (
        'cf36ae7b-8ab0-4f16-a1b6-599499b4d6e2', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thulh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K18'
            LIMIT 1
        )
    ), (
        '922d3a00-876f-452d-8535-d74798f8592e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'dungnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K18'
            LIMIT 1
        )
    ), (
        '71b674c0-8a78-4475-8e4c-ef2e114691f6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hainguyet@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'LTMT2-K18'
            LIMIT 1
        )
    ), (
        '3145273f-51fa-4e25-bae5-0f305e4aa70f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K15'
            LIMIT 1
        )
    ), (
        'c82c0250-719a-4336-9c8b-331e912fb312', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K15'
            LIMIT 1
        )
    ), (
        'abeb134a-dfe5-4708-92fe-1c3ac559c4bb', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K15'
            LIMIT 1
        )
    ), (
        '8cb3f564-7cb1-408c-a12f-99bc0068240e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K15'
            LIMIT 1
        )
    ), (
        '5cfce350-df8f-44bd-afc0-08523ec33250', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K15'
            LIMIT 1
        )
    ), (
        '793a394a-c2a7-4f5a-b6e8-cb43da9fdd62', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K15'
            LIMIT 1
        )
    ), (
        '310a3ca4-f9ea-4630-ac81-63a73a602d20', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K15'
            LIMIT 1
        )
    ), (
        'aa16497e-bec3-43fc-9bee-b1e1e955adb5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K15'
            LIMIT 1
        )
    ), (
        '6321b929-21a9-4e53-95e1-9a8def6c9b51', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K15'
            LIMIT 1
        )
    ), (
        '8d1b864c-f376-40ce-bcab-76b7f2473678', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K15'
            LIMIT 1
        )
    ), (
        'f477b860-e0df-4765-80fc-dcda94e446c0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K16'
            LIMIT 1
        )
    ), (
        'd67cd03e-59d8-4e98-bac8-161a9d0c8a7d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K16'
            LIMIT 1
        )
    ), (
        'ec45b995-5948-4ecf-bc03-255c11386f82', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K16'
            LIMIT 1
        )
    ), (
        '30d9269f-e86b-48d8-b49a-357dfd08c496', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K16'
            LIMIT 1
        )
    ), (
        '67c9b97d-65ae-4cc5-a6d7-8b7175c20eab', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K16'
            LIMIT 1
        )
    ), (
        '97aff744-0f78-4a1e-bec4-c9d391cc0c0f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K16'
            LIMIT 1
        )
    ), (
        'c59b7b76-9f0c-47a9-a3e5-ad64889d8cd8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K16'
            LIMIT 1
        )
    ), (
        '2294362a-5cab-4f0d-ac39-83a5eee7d3d0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K16'
            LIMIT 1
        )
    ), (
        '9ba250f6-170c-4048-958b-2bb3f2846a8a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K16'
            LIMIT 1
        )
    ), (
        '6cd5ddb5-2244-445f-8201-56137f8eb95d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K16'
            LIMIT 1
        )
    ), (
        '04752c24-c762-4bfb-83c7-5b68e4ddd50c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K17'
            LIMIT 1
        )
    ), (
        '1fe1fc38-5074-4b9d-a335-673352f25d6c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K17'
            LIMIT 1
        )
    ), (
        '89f25815-64cd-4950-8068-cb02e1e88ac9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K17'
            LIMIT 1
        )
    ), (
        '39fb0792-2f93-4134-a5b8-2f4160df1063', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K17'
            LIMIT 1
        )
    ), (
        '4f8c4634-9b1c-4429-a8e7-4d8c21829f78', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K17'
            LIMIT 1
        )
    ), (
        'fd91f17f-936c-4807-a339-1af639647916', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K17'
            LIMIT 1
        )
    ), (
        'ee825299-271a-479b-b777-6719ce03f6c5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K17'
            LIMIT 1
        )
    ), (
        'a49cec8b-47b0-4aeb-928d-d5caa7388e1d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K17'
            LIMIT 1
        )
    ), (
        '31a805e4-e447-4f4e-b11b-12108a9132db', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K17'
            LIMIT 1
        )
    ), (
        '4194e34d-e710-453e-8beb-ad19de2487c0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K17'
            LIMIT 1
        )
    ), (
        '78da07f7-f9d7-47d1-abf3-e1639ed7fd08', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K18'
            LIMIT 1
        )
    ), (
        '151c4279-1475-4023-b526-460b0748ff7c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K18'
            LIMIT 1
        )
    ), (
        'ebf3575f-e730-4970-8b94-02584effa323', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K18'
            LIMIT 1
        )
    ), (
        '60c619d4-6cbb-479a-a6a4-8fddfec86a72', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K18'
            LIMIT 1
        )
    ), (
        'b5e8b1b5-c139-4753-912d-dcc146128d07', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM1-K18'
            LIMIT 1
        )
    ), (
        '0fa646cf-5902-4bc3-80e3-5ef2e4e6ab1a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'tuannda@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K18'
            LIMIT 1
        )
    ), (
        'cf5c30d1-2f1a-470e-89ca-013b8923a692', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thanhnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K18'
            LIMIT 1
        )
    ), (
        'd1fcfae6-7527-4334-be04-465bf1282921', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'vannt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K18'
            LIMIT 1
        )
    ), (
        '7309ff03-b9e7-4bfa-b576-a108fe6a2f02', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'sonlh@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K18'
            LIMIT 1
        )
    ), (
        'e9d40768-0572-4af9-95c9-0830ec978b99', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hoabt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'QTM2-K18'
            LIMIT 1
        )
    ), (
        'dcf665af-26ae-45ad-bd55-ef7f1b805a8c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K15'
            LIMIT 1
        )
    ), (
        '47f7ae0e-4b2c-46c3-b245-1ca8c33474e5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K15'
            LIMIT 1
        )
    ), (
        '07fde7e4-eeef-4f9d-8b00-0106722fa698', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K15'
            LIMIT 1
        )
    ), (
        '6926609e-7dd8-4596-923b-effec3611947', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K15'
            LIMIT 1
        )
    ), (
        '8a2bf447-e8f5-42bb-b474-1b0b1e7abc2e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K15'
            LIMIT 1
        )
    ), (
        'eb67d9a0-badd-4a6e-ada4-d3ab03b7bd19', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K15'
            LIMIT 1
        )
    ), (
        'a6b07ca2-f0aa-4d30-a7ec-e878a6d16e43', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K15'
            LIMIT 1
        )
    ), (
        'f6db0904-94c0-45f0-8a71-2cb7815497a3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K15'
            LIMIT 1
        )
    ), (
        '7183b5b1-ac15-427b-9a10-82f4cebf4051', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K15'
            LIMIT 1
        )
    ), (
        '50fff48b-3249-40ae-aa7c-7fc20a0d33f9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K15'
            LIMIT 1
        )
    ), (
        '6f69d706-13a2-4b50-8b15-0155eab50978', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K16'
            LIMIT 1
        )
    ), (
        '7eb448e7-fcd6-4752-813d-9ce70afe667d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K16'
            LIMIT 1
        )
    ), (
        '7bb3222e-199e-4729-b3b1-24cbb9c04e8e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K16'
            LIMIT 1
        )
    ), (
        '7395646d-97ea-49dd-9ccd-6058283d1b5a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K16'
            LIMIT 1
        )
    ), (
        '6f62a139-a8f5-4722-ab4f-3f68eabfdfe3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K16'
            LIMIT 1
        )
    ), (
        'bf9fb16a-7ace-48e1-b66e-a17ef63505b1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K16'
            LIMIT 1
        )
    ), (
        '76134468-f5ea-48d7-bc22-59707361d287', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K16'
            LIMIT 1
        )
    ), (
        '62135eb1-7bca-4376-a1bc-72b0730a2703', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K16'
            LIMIT 1
        )
    ), (
        'f0efd30e-a080-44ca-ae71-ab9fee8b6520', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K16'
            LIMIT 1
        )
    ), (
        '370b88f7-3274-479c-937a-364c4476fe6d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K16'
            LIMIT 1
        )
    ), (
        '9475bf9f-ae11-42e5-a10e-3398539a307e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K17'
            LIMIT 1
        )
    ), (
        'dfba5818-35e6-4949-be02-13f2e35994f0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K17'
            LIMIT 1
        )
    ), (
        'cf3d39c8-f8d3-4780-821a-e7d40a97d75f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K17'
            LIMIT 1
        )
    ), (
        '21d635bc-5d3d-43f5-b10d-f68bd3e46425', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K17'
            LIMIT 1
        )
    ), (
        '93256520-8a22-4789-b068-4c36eb697ee0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K17'
            LIMIT 1
        )
    ), (
        '0900e1aa-715d-47f7-974c-a1fd56ba2c48', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K17'
            LIMIT 1
        )
    ), (
        '8ee7fc2c-9728-466e-a85e-9e56b2bef6bb', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K17'
            LIMIT 1
        )
    ), (
        '831fb809-5a8d-4de0-bc51-f91a2792d000', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K17'
            LIMIT 1
        )
    ), (
        'c1d2f076-da74-4f08-a3ed-28f740a41171', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K17'
            LIMIT 1
        )
    ), (
        '23c7ca5f-f824-4eca-a479-5009c13569e9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K17'
            LIMIT 1
        )
    ), (
        'f546441b-b743-4653-9c01-2d25614af16a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K18'
            LIMIT 1
        )
    ), (
        '7cde639e-aeb8-434e-9cbf-2034adecce21', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K18'
            LIMIT 1
        )
    ), (
        'c470c4fe-be3b-4394-afa2-be9122edd5f3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K18'
            LIMIT 1
        )
    ), (
        '222105a1-1cbb-448d-ad7e-399467ed835f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K18'
            LIMIT 1
        )
    ), (
        '8d57e654-642b-4133-8663-31cf1c6f5555', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM1-K18'
            LIMIT 1
        )
    ), (
        'c023130b-32d5-4271-9394-1164483f05a6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ngocnt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K18'
            LIMIT 1
        )
    ), (
        'afb23bf3-e9e9-4848-8cb0-929f19f97f09', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'nhuantt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K18'
            LIMIT 1
        )
    ), (
        'd837950d-8c38-423b-958f-8a214a8038ad', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'phuclt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K18'
            LIMIT 1
        )
    ), (
        '0c56498a-414d-4892-a0d9-0b82fa7d48c3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'hiennt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K18'
            LIMIT 1
        )
    ), (
        '3721d5cd-3eb4-40ca-8b41-0554407fb7a1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'trangtt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'UDPM2-K18'
            LIMIT 1
        )
    ), (
        '8869cd1a-fc6d-4f0b-b417-a086c970b76f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K15'
            LIMIT 1
        )
    ), (
        '1a12538c-b318-4c81-9919-0b1184eba30d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K15'
            LIMIT 1
        )
    ), (
        '7efe7004-46dc-4c92-9c01-0a0517271a1b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K15'
            LIMIT 1
        )
    ), (
        '0af59263-b4e9-4410-b1a7-337401484c23', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K15'
            LIMIT 1
        )
    ), (
        '45cbac1f-d282-48bb-83da-11bb21425a15', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K15'
            LIMIT 1
        )
    ), (
        '13cd7d7f-4fa1-4424-b4f0-3b9225512927', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K15'
            LIMIT 1
        )
    ), (
        'c000167d-cb04-4c99-b49b-f1b14e1efcf4', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K15'
            LIMIT 1
        )
    ), (
        'b0fbbacf-e5d3-49ee-bfc9-f5c0f6ab6252', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K15'
            LIMIT 1
        )
    ), (
        '4e01d8ff-cebd-418c-b52d-b323a78e0a71', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K15'
            LIMIT 1
        )
    ), (
        'ec4509d8-b68b-4902-8ba0-b4712a58b784', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K15'
            LIMIT 1
        )
    ), (
        '27b070bc-5b53-4f00-a65a-1bba8c8b9daa', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K15'
            LIMIT 1
        )
    ), (
        'fdc6750c-c3a0-44e9-bd99-4c49526b0536', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K15'
            LIMIT 1
        )
    ), (
        '7f47f30f-3d6e-4633-bfbc-ccccc9678b3e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K15'
            LIMIT 1
        )
    ), (
        '46613d4f-bb42-46e4-8694-ddb5dd50ed8b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K15'
            LIMIT 1
        )
    ), (
        '9a74fff7-9553-413b-a301-942aeb6b09a5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K15'
            LIMIT 1
        )
    ), (
        '75d19b4d-1258-4cd0-b3c3-874491b79910', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K15'
            LIMIT 1
        )
    ), (
        'd5f50657-9f18-41cf-a90e-e01f9045571f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K15'
            LIMIT 1
        )
    ), (
        '69be186b-1db8-41f0-bc2b-b37747bbed4b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K15'
            LIMIT 1
        )
    ), (
        '6ff5a7a4-2432-47ae-bf91-026ba11da15b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K15'
            LIMIT 1
        )
    ), (
        'b35bf40c-c88f-4b53-8029-39938bcc411a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K15'
            LIMIT 1
        )
    ), (
        'fb246a25-3f97-41ce-99d5-aac89f588985', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K16'
            LIMIT 1
        )
    ), (
        'ee6d1f3a-18cd-4fa3-afe7-c22c7c643de6', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K16'
            LIMIT 1
        )
    ), (
        'b8ca6e6e-4f57-4f2e-950a-73e97e02fa93', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K16'
            LIMIT 1
        )
    ), (
        '70ed1759-d11a-42d5-bfca-547204877e18', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K16'
            LIMIT 1
        )
    ), (
        '9d1158a2-24d9-4dad-9606-d04d152d85c5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K16'
            LIMIT 1
        )
    ), (
        '2b5746b9-6be7-4a6d-beb8-0944ad0ecef1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K16'
            LIMIT 1
        )
    ), (
        '8fc64399-bc9a-48f4-a7f7-7baef3663cc5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K16'
            LIMIT 1
        )
    ), (
        '63d9a481-e795-4860-a445-096e71fa879b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K16'
            LIMIT 1
        )
    ), (
        '4b3f9592-c10e-4dd2-ae8e-2a12d8371cf3', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K16'
            LIMIT 1
        )
    ), (
        'be0abcff-978e-4978-9666-c54c3f2b1361', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K16'
            LIMIT 1
        )
    ), (
        '4942542a-e00c-468c-b241-d51e8be406c5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K16'
            LIMIT 1
        )
    ), (
        '6b5e708a-36c1-44c6-b3dd-80dee6901e58', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K16'
            LIMIT 1
        )
    ), (
        '11596f92-5a6d-461c-a713-870afcf38a0c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K16'
            LIMIT 1
        )
    ), (
        '005b89d3-3094-48dc-a8f1-0d2da058ef9e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K16'
            LIMIT 1
        )
    ), (
        'e4fd2059-b75c-44b9-a257-04c55aee2167', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K16'
            LIMIT 1
        )
    ), (
        '139c8f09-c434-4c02-94ed-62c26cdab6c1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K16'
            LIMIT 1
        )
    ), (
        '9b0bc61f-6e9c-4a0e-850c-419812bd52d5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K16'
            LIMIT 1
        )
    ), (
        '6ef108f8-6ce0-45fc-9bbd-375417243029', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K16'
            LIMIT 1
        )
    ), (
        'b1186ff1-02ae-4c17-a0f2-95b162942385', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K16'
            LIMIT 1
        )
    ), (
        'bd35084f-76ee-4bd0-a359-97a78c53651d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K16'
            LIMIT 1
        )
    ), (
        'db07b24a-0bdd-4b75-b58f-15f558e0bd34', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K17'
            LIMIT 1
        )
    ), (
        'e90f5388-9156-49d4-b9eb-489c6f156f2d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K17'
            LIMIT 1
        )
    ), (
        'a1fc7e5c-765f-4abe-999f-48f6a1a2544f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K17'
            LIMIT 1
        )
    ), (
        'bce27e98-ee18-4091-be9b-55070fd81f49', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K17'
            LIMIT 1
        )
    ), (
        '02075391-a62b-4e3e-9bb9-8465352c74e8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K17'
            LIMIT 1
        )
    ), (
        'c8778723-a19c-4dd2-b9d4-270d590bb8a9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K17'
            LIMIT 1
        )
    ), (
        'a5313bc5-9d2b-4a8b-90ca-0938733f5148', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K17'
            LIMIT 1
        )
    ), (
        'f682e265-41d8-4ebc-936f-6b4b7fe3380c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K17'
            LIMIT 1
        )
    ), (
        'db44a3e4-311a-4d68-9072-005141311dc1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K17'
            LIMIT 1
        )
    ), (
        '153d62bc-ba74-4753-a27d-7176ad07fc2e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K17'
            LIMIT 1
        )
    ), (
        'df4d22cf-6e45-44e0-946c-feec29a9b12a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K17'
            LIMIT 1
        )
    ), (
        '79bda837-d038-4a82-8a5a-ef45b1661894', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K17'
            LIMIT 1
        )
    ), (
        'dbeba542-d74b-46db-a46b-1860c29b1023', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K17'
            LIMIT 1
        )
    ), (
        '708ee5f7-69a8-4c6d-b4e8-e672f395a366', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K17'
            LIMIT 1
        )
    ), (
        '9200f908-c125-48b3-b169-145cd495f18b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K17'
            LIMIT 1
        )
    ), (
        'fe124097-4345-4776-baeb-ba5244dc6f13', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K17'
            LIMIT 1
        )
    ), (
        'd2cb1513-64e0-453d-b37e-a056e48f351b', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K17'
            LIMIT 1
        )
    ), (
        'eb435a6c-8ae4-405e-84f1-bd4d0c6a3037', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K17'
            LIMIT 1
        )
    ), (
        '3e20c187-fc39-4ff8-a7ee-6fe1ae12621a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K17'
            LIMIT 1
        )
    ), (
        '1f6e2eb2-f3db-463d-8f35-18e293666171', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K17'
            LIMIT 1
        )
    ), (
        '35b7628e-5648-4618-993c-a74149b84b0a', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH CLC-K17'
            LIMIT 1
        )
    ), (
        'cc384ceb-3646-4ecc-be82-bb10a9db9ed8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH CLC-K17'
            LIMIT 1
        )
    ), (
        '93e78003-c433-4d4c-8894-1866681f5f58', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH CLC-K17'
            LIMIT 1
        )
    ), (
        '8e278b34-a07a-4c39-b132-0312d8fdbbf8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH CLC-K17'
            LIMIT 1
        )
    ), (
        '73d44e4c-c083-4a83-bb6c-865e96462a10', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH CLC-K17'
            LIMIT 1
        )
    ), (
        'a291400a-a4c8-4a49-af8c-5b771f220f2e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K18'
            LIMIT 1
        )
    ), (
        'bba1f0a3-8d2d-42fd-b15a-5c3b5cce5c8d', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K18'
            LIMIT 1
        )
    ), (
        'e8416778-1750-40c3-9b0d-ff8f057a86a2', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K18'
            LIMIT 1
        )
    ), (
        '6029048e-65a7-4198-9baa-a1b7df3731a5', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K18'
            LIMIT 1
        )
    ), (
        'adaa9c0d-3c59-47aa-9714-c54f705f1e9c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH1-K18'
            LIMIT 1
        )
    ), (
        'edc02fff-6052-4833-a1fd-f6004e1d00a0', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K18'
            LIMIT 1
        )
    ), (
        'b53dd1d6-c36f-496b-b0f7-889788287094', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K18'
            LIMIT 1
        )
    ), (
        '5eeec9b6-4087-4d66-bce6-748761e2d489', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K18'
            LIMIT 1
        )
    ), (
        '0ac2f9d4-1245-43fd-bef1-b9f7b79229ad', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K18'
            LIMIT 1
        )
    ), (
        'ecb360f6-8ada-4307-ac63-b768be9604fd', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH2-K18'
            LIMIT 1
        )
    ), (
        'aba24975-626d-47a9-ba24-5a08444fe034', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K18'
            LIMIT 1
        )
    ), (
        '9576e7ae-a04a-47fc-b3ef-af7773e0d5da', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K18'
            LIMIT 1
        )
    ), (
        'd1652860-4a31-4956-841f-cbefa31a88c7', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K18'
            LIMIT 1
        )
    ), (
        '433da921-8d12-44c0-9775-4a3ac0c3b1c1', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K18'
            LIMIT 1
        )
    ), (
        '58c2e384-bebb-4ffe-8c69-c42e27fd0971', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH3-K18'
            LIMIT 1
        )
    ), (
        'd44f4ecb-dbb4-4f63-a7dd-1f3de82f7f9f', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'linhttk@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K18'
            LIMIT 1
        )
    ), (
        '041c9042-24d0-46cf-91c1-333b8745ea8e', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'ducpt@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K18'
            LIMIT 1
        )
    ), (
        'd63e0246-681f-4771-b571-8f13b3219cb8', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'thuytd@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K18'
            LIMIT 1
        )
    ), (
        'b3d2ca1b-46e6-4a2a-981b-bbd18d6c37b9', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'cuongnm@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K18'
            LIMIT 1
        )
    ), (
        '12ad91af-906a-4864-9575-80c03bee9f6c', (
            SELECT t.id
            FROM teachers t
                JOIN users u ON u.id = t."userId"
            WHERE u.email = 'minhth@hactech.edu.vn'
            LIMIT 1
        ), (
            SELECT id
            FROM class_groups
            WHERE code = 'TKĐH4-K18'
            LIMIT 1
        )
    );

-- ============================================================================
-- TABLE: teaching_units
-- ============================================================================
-- TRUNCATE TABLE teaching_units RESTART IDENTITY CASCADE;
INSERT INTO teaching_units (
        id,
        "subjectId",
        "assignmentId",
        TYPE,
        name,
        "conflictGroupId"
    )
VALUES (
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'subj_politics',
        '0b406b11-5475-4d55-9b51-90b15746a455',
        'THEORY',
        'Chính trị - LTMT1-K15',
        NULL
    ),
    (
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'subj_law',
        '72473f12-f9db-48bb-a5a6-7faf1cd8b7f6',
        'THEORY',
        'Pháp luật - LTMT1-K15',
        NULL
    ),
    (
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'subj_math',
        'fad76fa3-c296-450d-86f4-80b6ecc648da',
        'THEORY',
        'Toán cao cấp - LTMT1-K15',
        NULL
    ),
    (
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'subj_basic_it',
        '1335a846-f7ef-46b2-bc2d-ee6474032047',
        'PRACTICE',
        'Tin học căn bản - LTMT1-K15',
        NULL
    ),
    (
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'subj_eng1',
        '8a18d42a-3005-4ce9-aa2b-81a4d5bd6ebf',
        'THEORY',
        'Anh văn 1 - LTMT1-K15',
        NULL
    ),
    (
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'subj_politics',
        '7a076337-ea51-4884-a713-579197fa9e86',
        'THEORY',
        'Chính trị - LTMT2-K15',
        NULL
    ),
    (
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'subj_law',
        'fd251813-debb-4f78-bc44-334429df37de',
        'THEORY',
        'Pháp luật - LTMT2-K15',
        NULL
    ),
    (
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'subj_math',
        'af86f89e-cc1a-4363-b0b9-e47ed163522e',
        'THEORY',
        'Toán cao cấp - LTMT2-K15',
        NULL
    ),
    (
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'subj_basic_it',
        '86015a2c-fca6-4394-a44c-02dc13c16a47',
        'PRACTICE',
        'Tin học căn bản - LTMT2-K15',
        NULL
    ),
    (
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'subj_eng1',
        'afda5fd0-736b-45eb-b825-b3c8666470d6',
        'THEORY',
        'Anh văn 1 - LTMT2-K15',
        NULL
    ),
    (
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'subj_politics',
        '8047e965-3b17-479e-a895-a3a5e0794850',
        'THEORY',
        'Chính trị - LTMT1-K16',
        NULL
    ),
    (
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'subj_law',
        '518ba291-c283-43c8-ae99-81d07ffd2eeb',
        'THEORY',
        'Pháp luật - LTMT1-K16',
        NULL
    ),
    (
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'subj_math',
        'c51ee132-dc48-4c91-85cb-9794264ba26f',
        'THEORY',
        'Toán cao cấp - LTMT1-K16',
        NULL
    ),
    (
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'subj_basic_it',
        '48270b78-0a00-4c03-9b78-26f871210c0f',
        'PRACTICE',
        'Tin học căn bản - LTMT1-K16',
        NULL
    ),
    (
        '217f7515-852a-4003-b983-9fcbec219e91',
        'subj_eng1',
        'a8935ac4-70fb-4a74-9516-b097bc813381',
        'THEORY',
        'Anh văn 1 - LTMT1-K16',
        NULL
    ),
    (
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'subj_politics',
        '576eb389-e243-43c6-b0a2-eb236d65a002',
        'THEORY',
        'Chính trị - LTMT2-K16',
        NULL
    ),
    (
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'subj_law',
        '17af8001-b2f1-4a5a-a407-414f44da6121',
        'THEORY',
        'Pháp luật - LTMT2-K16',
        NULL
    ),
    (
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'subj_math',
        '0a014e30-357b-4187-a109-6f86820ffab9',
        'THEORY',
        'Toán cao cấp - LTMT2-K16',
        NULL
    ),
    (
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'subj_basic_it',
        '60bb6c2c-54a2-4acd-b1af-b9cf7d439012',
        'PRACTICE',
        'Tin học căn bản - LTMT2-K16',
        NULL
    ),
    (
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'subj_eng1',
        '5011072d-e3df-4096-a1ea-ca4672e7556d',
        'THEORY',
        'Anh văn 1 - LTMT2-K16',
        NULL
    ),
    (
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'subj_politics',
        '1da88e0b-f187-49f0-87e8-bdcdd382ee3c',
        'THEORY',
        'Chính trị - LTMT1-K17',
        NULL
    ),
    (
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'subj_law',
        '1fb52561-b0b8-40c1-899b-307c309cca13',
        'THEORY',
        'Pháp luật - LTMT1-K17',
        NULL
    ),
    (
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'subj_math',
        'b6dc5f55-d6fd-4929-8a9d-a6366bab8ec3',
        'THEORY',
        'Toán cao cấp - LTMT1-K17',
        NULL
    ),
    (
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'subj_basic_it',
        'ca51ff66-1b2b-4276-a099-7a59d716e87b',
        'PRACTICE',
        'Tin học căn bản - LTMT1-K17',
        NULL
    ),
    (
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'subj_eng1',
        '4657cff3-b497-4aae-99d2-ea02b6c1a1e6',
        'THEORY',
        'Anh văn 1 - LTMT1-K17',
        NULL
    ),
    (
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'subj_politics',
        'bc540c63-e6dc-4783-a884-d2eee75b60a1',
        'THEORY',
        'Chính trị - LTMT2-K17',
        NULL
    ),
    (
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'subj_law',
        'ebecc252-b3a9-4a9c-9d3b-eaebf4edbd04',
        'THEORY',
        'Pháp luật - LTMT2-K17',
        NULL
    ),
    (
        'dc6cba75-821b-4740-8525-d361278a9152',
        'subj_math',
        '38090d9e-bbd0-4668-83c8-06e84aeb313d',
        'THEORY',
        'Toán cao cấp - LTMT2-K17',
        NULL
    ),
    (
        '76911554-a934-4b4a-9865-423a85a55b51',
        'subj_basic_it',
        '8399385a-d8ae-4b93-a5de-b60b7bb66903',
        'PRACTICE',
        'Tin học căn bản - LTMT2-K17',
        NULL
    ),
    (
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'subj_eng1',
        '5113cac0-3620-475d-a7cc-abdf2629e2db',
        'THEORY',
        'Anh văn 1 - LTMT2-K17',
        NULL
    ),
    (
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'subj_politics',
        'ce048288-4f47-4b0c-8348-f4611a5d886d',
        'THEORY',
        'Chính trị - LTMT1-K18',
        NULL
    ),
    (
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'subj_law',
        'dadd7cc6-8cb1-4e05-90ea-d57735b2dcf8',
        'THEORY',
        'Pháp luật - LTMT1-K18',
        NULL
    ),
    (
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'subj_math',
        '75d61a7d-d9eb-46bd-9b00-c55593ea8234',
        'THEORY',
        'Toán cao cấp - LTMT1-K18',
        NULL
    ),
    (
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'subj_basic_it',
        '5bce3d7f-bdf1-46f0-8be5-a963a86200d8',
        'PRACTICE',
        'Tin học căn bản - LTMT1-K18',
        NULL
    ),
    (
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'subj_eng1',
        'df1be6e4-dfd3-43e3-8f52-1f17ca9a2010',
        'THEORY',
        'Anh văn 1 - LTMT1-K18',
        NULL
    ),
    (
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'subj_politics',
        '8bfd203c-fbd3-4fad-ac6c-c62bca334101',
        'THEORY',
        'Chính trị - LTMT2-K18',
        NULL
    ),
    (
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'subj_law',
        '7d80e189-d56b-4e88-8e55-1cc1079783a3',
        'THEORY',
        'Pháp luật - LTMT2-K18',
        NULL
    ),
    (
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'subj_math',
        'cf36ae7b-8ab0-4f16-a1b6-599499b4d6e2',
        'THEORY',
        'Toán cao cấp - LTMT2-K18',
        NULL
    ),
    (
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'subj_basic_it',
        '922d3a00-876f-452d-8535-d74798f8592e',
        'PRACTICE',
        'Tin học căn bản - LTMT2-K18',
        NULL
    ),
    (
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'subj_eng1',
        '71b674c0-8a78-4475-8e4c-ef2e114691f6',
        'THEORY',
        'Anh văn 1 - LTMT2-K18',
        NULL
    ),
    (
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'subj_politics',
        '3145273f-51fa-4e25-bae5-0f305e4aa70f',
        'THEORY',
        'Chính trị - QTM1-K15',
        NULL
    ),
    (
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'subj_law',
        'c82c0250-719a-4336-9c8b-331e912fb312',
        'THEORY',
        'Pháp luật - QTM1-K15',
        NULL
    ),
    (
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'subj_math',
        'abeb134a-dfe5-4708-92fe-1c3ac559c4bb',
        'THEORY',
        'Toán cao cấp - QTM1-K15',
        NULL
    ),
    (
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'subj_basic_it',
        '8cb3f564-7cb1-408c-a12f-99bc0068240e',
        'PRACTICE',
        'Tin học căn bản - QTM1-K15',
        NULL
    ),
    (
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'subj_eng1',
        '5cfce350-df8f-44bd-afc0-08523ec33250',
        'THEORY',
        'Anh văn 1 - QTM1-K15',
        NULL
    ),
    (
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'subj_politics',
        '793a394a-c2a7-4f5a-b6e8-cb43da9fdd62',
        'THEORY',
        'Chính trị - QTM2-K15',
        NULL
    ),
    (
        '2b69068f-7c56-47df-9182-c4f769639921',
        'subj_law',
        '310a3ca4-f9ea-4630-ac81-63a73a602d20',
        'THEORY',
        'Pháp luật - QTM2-K15',
        NULL
    ),
    (
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'subj_math',
        'aa16497e-bec3-43fc-9bee-b1e1e955adb5',
        'THEORY',
        'Toán cao cấp - QTM2-K15',
        NULL
    ),
    (
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'subj_basic_it',
        '6321b929-21a9-4e53-95e1-9a8def6c9b51',
        'PRACTICE',
        'Tin học căn bản - QTM2-K15',
        NULL
    ),
    (
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'subj_eng1',
        '8d1b864c-f376-40ce-bcab-76b7f2473678',
        'THEORY',
        'Anh văn 1 - QTM2-K15',
        NULL
    ),
    (
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'subj_politics',
        'f477b860-e0df-4765-80fc-dcda94e446c0',
        'THEORY',
        'Chính trị - QTM1-K16',
        NULL
    ),
    (
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'subj_law',
        'd67cd03e-59d8-4e98-bac8-161a9d0c8a7d',
        'THEORY',
        'Pháp luật - QTM1-K16',
        NULL
    ),
    (
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'subj_math',
        'ec45b995-5948-4ecf-bc03-255c11386f82',
        'THEORY',
        'Toán cao cấp - QTM1-K16',
        NULL
    ),
    (
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'subj_basic_it',
        '30d9269f-e86b-48d8-b49a-357dfd08c496',
        'PRACTICE',
        'Tin học căn bản - QTM1-K16',
        NULL
    ),
    (
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'subj_eng1',
        '67c9b97d-65ae-4cc5-a6d7-8b7175c20eab',
        'THEORY',
        'Anh văn 1 - QTM1-K16',
        NULL
    ),
    (
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'subj_politics',
        '97aff744-0f78-4a1e-bec4-c9d391cc0c0f',
        'THEORY',
        'Chính trị - QTM2-K16',
        NULL
    ),
    (
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'subj_law',
        'c59b7b76-9f0c-47a9-a3e5-ad64889d8cd8',
        'THEORY',
        'Pháp luật - QTM2-K16',
        NULL
    ),
    (
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'subj_math',
        '2294362a-5cab-4f0d-ac39-83a5eee7d3d0',
        'THEORY',
        'Toán cao cấp - QTM2-K16',
        NULL
    ),
    (
        '163dc358-f727-400c-b926-50bba4d4844e',
        'subj_basic_it',
        '9ba250f6-170c-4048-958b-2bb3f2846a8a',
        'PRACTICE',
        'Tin học căn bản - QTM2-K16',
        NULL
    ),
    (
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'subj_eng1',
        '6cd5ddb5-2244-445f-8201-56137f8eb95d',
        'THEORY',
        'Anh văn 1 - QTM2-K16',
        NULL
    ),
    (
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'subj_politics',
        '04752c24-c762-4bfb-83c7-5b68e4ddd50c',
        'THEORY',
        'Chính trị - QTM1-K17',
        NULL
    ),
    (
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'subj_law',
        '1fe1fc38-5074-4b9d-a335-673352f25d6c',
        'THEORY',
        'Pháp luật - QTM1-K17',
        NULL
    ),
    (
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'subj_math',
        '89f25815-64cd-4950-8068-cb02e1e88ac9',
        'THEORY',
        'Toán cao cấp - QTM1-K17',
        NULL
    ),
    (
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'subj_basic_it',
        '39fb0792-2f93-4134-a5b8-2f4160df1063',
        'PRACTICE',
        'Tin học căn bản - QTM1-K17',
        NULL
    ),
    (
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'subj_eng1',
        '4f8c4634-9b1c-4429-a8e7-4d8c21829f78',
        'THEORY',
        'Anh văn 1 - QTM1-K17',
        NULL
    ),
    (
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'subj_politics',
        'fd91f17f-936c-4807-a339-1af639647916',
        'THEORY',
        'Chính trị - QTM2-K17',
        NULL
    ),
    (
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'subj_law',
        'ee825299-271a-479b-b777-6719ce03f6c5',
        'THEORY',
        'Pháp luật - QTM2-K17',
        NULL
    ),
    (
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'subj_math',
        'a49cec8b-47b0-4aeb-928d-d5caa7388e1d',
        'THEORY',
        'Toán cao cấp - QTM2-K17',
        NULL
    ),
    (
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'subj_basic_it',
        '31a805e4-e447-4f4e-b11b-12108a9132db',
        'PRACTICE',
        'Tin học căn bản - QTM2-K17',
        NULL
    ),
    (
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'subj_eng1',
        '4194e34d-e710-453e-8beb-ad19de2487c0',
        'THEORY',
        'Anh văn 1 - QTM2-K17',
        NULL
    ),
    (
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'subj_politics',
        '78da07f7-f9d7-47d1-abf3-e1639ed7fd08',
        'THEORY',
        'Chính trị - QTM1-K18',
        NULL
    ),
    (
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'subj_law',
        '151c4279-1475-4023-b526-460b0748ff7c',
        'THEORY',
        'Pháp luật - QTM1-K18',
        NULL
    ),
    (
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'subj_math',
        'ebf3575f-e730-4970-8b94-02584effa323',
        'THEORY',
        'Toán cao cấp - QTM1-K18',
        NULL
    ),
    (
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'subj_basic_it',
        '60c619d4-6cbb-479a-a6a4-8fddfec86a72',
        'PRACTICE',
        'Tin học căn bản - QTM1-K18',
        NULL
    ),
    (
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'subj_eng1',
        'b5e8b1b5-c139-4753-912d-dcc146128d07',
        'THEORY',
        'Anh văn 1 - QTM1-K18',
        NULL
    ),
    (
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'subj_politics',
        '0fa646cf-5902-4bc3-80e3-5ef2e4e6ab1a',
        'THEORY',
        'Chính trị - QTM2-K18',
        NULL
    ),
    (
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'subj_law',
        'cf5c30d1-2f1a-470e-89ca-013b8923a692',
        'THEORY',
        'Pháp luật - QTM2-K18',
        NULL
    ),
    (
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'subj_math',
        'd1fcfae6-7527-4334-be04-465bf1282921',
        'THEORY',
        'Toán cao cấp - QTM2-K18',
        NULL
    ),
    (
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'subj_basic_it',
        '7309ff03-b9e7-4bfa-b576-a108fe6a2f02',
        'PRACTICE',
        'Tin học căn bản - QTM2-K18',
        NULL
    ),
    (
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'subj_eng1',
        'e9d40768-0572-4af9-95c9-0830ec978b99',
        'THEORY',
        'Anh văn 1 - QTM2-K18',
        NULL
    ),
    (
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'subj_politics',
        'dcf665af-26ae-45ad-bd55-ef7f1b805a8c',
        'THEORY',
        'Chính trị - UDPM1-K15',
        NULL
    ),
    (
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'subj_law',
        '47f7ae0e-4b2c-46c3-b245-1ca8c33474e5',
        'THEORY',
        'Pháp luật - UDPM1-K15',
        NULL
    ),
    (
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'subj_math',
        '07fde7e4-eeef-4f9d-8b00-0106722fa698',
        'THEORY',
        'Toán cao cấp - UDPM1-K15',
        NULL
    ),
    (
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'subj_basic_it',
        '6926609e-7dd8-4596-923b-effec3611947',
        'PRACTICE',
        'Tin học căn bản - UDPM1-K15',
        NULL
    ),
    (
        'f9e587b7-39a2-42ee-94ee-981988f4aaa3',
        'subj_eng1',
        '8a2bf447-e8f5-42bb-b474-1b0b1e7abc2e',
        'THEORY',
        'Anh văn 1 - UDPM1-K15',
        NULL
    ),
    (
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'subj_politics',
        'eb67d9a0-badd-4a6e-ada4-d3ab03b7bd19',
        'THEORY',
        'Chính trị - UDPM2-K15',
        NULL
    ),
    (
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'subj_law',
        'a6b07ca2-f0aa-4d30-a7ec-e878a6d16e43',
        'THEORY',
        'Pháp luật - UDPM2-K15',
        NULL
    ),
    (
        '7eec8ae3-81fc-4752-93f2-7df128590956',
        'subj_math',
        'f6db0904-94c0-45f0-8a71-2cb7815497a3',
        'THEORY',
        'Toán cao cấp - UDPM2-K15',
        NULL
    ),
    (
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'subj_basic_it',
        '7183b5b1-ac15-427b-9a10-82f4cebf4051',
        'PRACTICE',
        'Tin học căn bản - UDPM2-K15',
        NULL
    ),
    (
        'b9b9fbde-f323-4ae5-9434-193aeb97b845',
        'subj_eng1',
        '50fff48b-3249-40ae-aa7c-7fc20a0d33f9',
        'THEORY',
        'Anh văn 1 - UDPM2-K15',
        NULL
    ),
    (
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'subj_politics',
        '6f69d706-13a2-4b50-8b15-0155eab50978',
        'THEORY',
        'Chính trị - UDPM1-K16',
        NULL
    ),
    (
        '19d03026-dd8f-4c56-8190-aaaad23dade1',
        'subj_law',
        '7eb448e7-fcd6-4752-813d-9ce70afe667d',
        'THEORY',
        'Pháp luật - UDPM1-K16',
        NULL
    ),
    (
        '24767925-aa30-4507-b581-54e081ea5e11',
        'subj_math',
        '7bb3222e-199e-4729-b3b1-24cbb9c04e8e',
        'THEORY',
        'Toán cao cấp - UDPM1-K16',
        NULL
    ),
    (
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'subj_basic_it',
        '7395646d-97ea-49dd-9ccd-6058283d1b5a',
        'PRACTICE',
        'Tin học căn bản - UDPM1-K16',
        NULL
    ),
    (
        'ce73ef28-6c8e-4c92-8b2d-eb1f30c70ff8',
        'subj_eng1',
        '6f62a139-a8f5-4722-ab4f-3f68eabfdfe3',
        'THEORY',
        'Anh văn 1 - UDPM1-K16',
        NULL
    ),
    (
        '1c1d7c56-a725-4582-895a-8476a5fa508c',
        'subj_politics',
        'bf9fb16a-7ace-48e1-b66e-a17ef63505b1',
        'THEORY',
        'Chính trị - UDPM2-K16',
        NULL
    ),
    (
        'd84d5e54-8ec1-472f-8a75-63d46d52cd42',
        'subj_law',
        '76134468-f5ea-48d7-bc22-59707361d287',
        'THEORY',
        'Pháp luật - UDPM2-K16',
        NULL
    ),
    (
        '3e7114ef-2838-48a9-87fc-a48f41626d78',
        'subj_math',
        '62135eb1-7bca-4376-a1bc-72b0730a2703',
        'THEORY',
        'Toán cao cấp - UDPM2-K16',
        NULL
    ),
    (
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'subj_basic_it',
        'f0efd30e-a080-44ca-ae71-ab9fee8b6520',
        'PRACTICE',
        'Tin học căn bản - UDPM2-K16',
        NULL
    ),
    (
        '69d78986-ad46-4f73-a90c-e39cc6482bb0',
        'subj_eng1',
        '370b88f7-3274-479c-937a-364c4476fe6d',
        'THEORY',
        'Anh văn 1 - UDPM2-K16',
        NULL
    ),
    (
        '5c81eabe-b601-4930-b266-dcde77694d03',
        'subj_politics',
        '9475bf9f-ae11-42e5-a10e-3398539a307e',
        'THEORY',
        'Chính trị - UDPM1-K17',
        NULL
    ),
    (
        'a64212e4-fdd3-4068-b9dd-45651f930bab',
        'subj_law',
        'dfba5818-35e6-4949-be02-13f2e35994f0',
        'THEORY',
        'Pháp luật - UDPM1-K17',
        NULL
    ),
    (
        '29391582-c78d-4507-a26b-186fecfe983c',
        'subj_math',
        'cf3d39c8-f8d3-4780-821a-e7d40a97d75f',
        'THEORY',
        'Toán cao cấp - UDPM1-K17',
        NULL
    ),
    (
        '808b4991-8621-4dee-a255-558a8962e760',
        'subj_basic_it',
        '21d635bc-5d3d-43f5-b10d-f68bd3e46425',
        'PRACTICE',
        'Tin học căn bản - UDPM1-K17',
        NULL
    ),
    (
        'e8c7c43a-73ac-45f8-88f5-5cad56509178',
        'subj_eng1',
        '93256520-8a22-4789-b068-4c36eb697ee0',
        'THEORY',
        'Anh văn 1 - UDPM1-K17',
        NULL
    ),
    (
        '8925f464-904b-489d-9165-09af4344bed3',
        'subj_politics',
        '0900e1aa-715d-47f7-974c-a1fd56ba2c48',
        'THEORY',
        'Chính trị - UDPM2-K17',
        NULL
    ),
    (
        '03589fc6-5210-4833-8b67-2113b6f418b0',
        'subj_law',
        '8ee7fc2c-9728-466e-a85e-9e56b2bef6bb',
        'THEORY',
        'Pháp luật - UDPM2-K17',
        NULL
    ),
    (
        'aaabb907-6ab9-4ad7-aa1a-cce65da1db05',
        'subj_math',
        '831fb809-5a8d-4de0-bc51-f91a2792d000',
        'THEORY',
        'Toán cao cấp - UDPM2-K17',
        NULL
    ),
    (
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'subj_basic_it',
        'c1d2f076-da74-4f08-a3ed-28f740a41171',
        'PRACTICE',
        'Tin học căn bản - UDPM2-K17',
        NULL
    ),
    (
        '6667ee18-21e6-4aa7-9d4b-bc6f42ead489',
        'subj_eng1',
        '23c7ca5f-f824-4eca-a479-5009c13569e9',
        'THEORY',
        'Anh văn 1 - UDPM2-K17',
        NULL
    ),
    (
        '835f1ae4-45e3-4cbf-9190-5407ebf35319',
        'subj_politics',
        'f546441b-b743-4653-9c01-2d25614af16a',
        'THEORY',
        'Chính trị - UDPM1-K18',
        NULL
    ),
    (
        '967608ef-ba93-488b-b817-fd31dd5bbacc',
        'subj_law',
        '7cde639e-aeb8-434e-9cbf-2034adecce21',
        'THEORY',
        'Pháp luật - UDPM1-K18',
        NULL
    ),
    (
        '208ca8b1-45aa-4cc6-91a7-468b59b3aa49',
        'subj_math',
        'c470c4fe-be3b-4394-afa2-be9122edd5f3',
        'THEORY',
        'Toán cao cấp - UDPM1-K18',
        NULL
    ),
    (
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'subj_basic_it',
        '222105a1-1cbb-448d-ad7e-399467ed835f',
        'PRACTICE',
        'Tin học căn bản - UDPM1-K18',
        NULL
    ),
    (
        '75ef4388-48d5-4369-9e78-dac4a628fa50',
        'subj_eng1',
        '8d57e654-642b-4133-8663-31cf1c6f5555',
        'THEORY',
        'Anh văn 1 - UDPM1-K18',
        NULL
    ),
    (
        '2f37b916-af78-4b12-9485-e91a94ca0786',
        'subj_politics',
        'c023130b-32d5-4271-9394-1164483f05a6',
        'THEORY',
        'Chính trị - UDPM2-K18',
        NULL
    ),
    (
        '1750abf8-7493-47b7-aac7-d2c714f2d715',
        'subj_law',
        'afb23bf3-e9e9-4848-8cb0-929f19f97f09',
        'THEORY',
        'Pháp luật - UDPM2-K18',
        NULL
    ),
    (
        '711ca250-eeab-4754-b4aa-a0cff4ddb88d',
        'subj_math',
        'd837950d-8c38-423b-958f-8a214a8038ad',
        'THEORY',
        'Toán cao cấp - UDPM2-K18',
        NULL
    ),
    (
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'subj_basic_it',
        '0c56498a-414d-4892-a0d9-0b82fa7d48c3',
        'PRACTICE',
        'Tin học căn bản - UDPM2-K18',
        NULL
    ),
    (
        'ccf9cafa-e164-4747-951f-4020464fc68c',
        'subj_eng1',
        '3721d5cd-3eb4-40ca-8b41-0554407fb7a1',
        'THEORY',
        'Anh văn 1 - UDPM2-K18',
        NULL
    ),
    (
        'b1c13047-2b1e-432e-8663-1c50c59cb118',
        'subj_politics',
        '8869cd1a-fc6d-4f0b-b417-a086c970b76f',
        'THEORY',
        'Chính trị - TKĐH1-K15',
        NULL
    ),
    (
        'a9eb9fcc-122c-48e2-bbee-ccd0906a523b',
        'subj_law',
        '1a12538c-b318-4c81-9919-0b1184eba30d',
        'THEORY',
        'Pháp luật - TKĐH1-K15',
        NULL
    ),
    (
        '65afd68b-042d-413c-9143-f46bcd42299a',
        'subj_math',
        '7efe7004-46dc-4c92-9c01-0a0517271a1b',
        'THEORY',
        'Toán cao cấp - TKĐH1-K15',
        NULL
    ),
    (
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'subj_basic_it',
        '0af59263-b4e9-4410-b1a7-337401484c23',
        'PRACTICE',
        'Tin học căn bản - TKĐH1-K15',
        NULL
    ),
    (
        '974f6e03-b266-4cf9-95b4-e07e1f97b8ec',
        'subj_eng1',
        '45cbac1f-d282-48bb-83da-11bb21425a15',
        'THEORY',
        'Anh văn 1 - TKĐH1-K15',
        NULL
    ),
    (
        '6caace3e-448e-441c-813b-a8b7993957f8',
        'subj_politics',
        '13cd7d7f-4fa1-4424-b4f0-3b9225512927',
        'THEORY',
        'Chính trị - TKĐH2-K15',
        NULL
    ),
    (
        'f9d6d7c0-8cb0-46f8-97bf-73e858fedf26',
        'subj_law',
        'c000167d-cb04-4c99-b49b-f1b14e1efcf4',
        'THEORY',
        'Pháp luật - TKĐH2-K15',
        NULL
    ),
    (
        '1821b19a-780c-4739-91b6-b8d07c68bb3f',
        'subj_math',
        'b0fbbacf-e5d3-49ee-bfc9-f5c0f6ab6252',
        'THEORY',
        'Toán cao cấp - TKĐH2-K15',
        NULL
    ),
    (
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'subj_basic_it',
        '4e01d8ff-cebd-418c-b52d-b323a78e0a71',
        'PRACTICE',
        'Tin học căn bản - TKĐH2-K15',
        NULL
    ),
    (
        '4d24cf9d-4c57-40e7-9ad3-f2fd795a052e',
        'subj_eng1',
        'ec4509d8-b68b-4902-8ba0-b4712a58b784',
        'THEORY',
        'Anh văn 1 - TKĐH2-K15',
        NULL
    ),
    (
        '0cc6b7e1-6d5b-4383-9e80-bb0865f9b5de',
        'subj_politics',
        '27b070bc-5b53-4f00-a65a-1bba8c8b9daa',
        'THEORY',
        'Chính trị - TKĐH3-K15',
        NULL
    ),
    (
        '314b9f79-9ef7-45bd-a99b-dd8106d75c0c',
        'subj_law',
        'fdc6750c-c3a0-44e9-bd99-4c49526b0536',
        'THEORY',
        'Pháp luật - TKĐH3-K15',
        NULL
    ),
    (
        '47dcc44a-ace7-47f0-9ad6-82ee2640a94e',
        'subj_math',
        '7f47f30f-3d6e-4633-bfbc-ccccc9678b3e',
        'THEORY',
        'Toán cao cấp - TKĐH3-K15',
        NULL
    ),
    (
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'subj_basic_it',
        '46613d4f-bb42-46e4-8694-ddb5dd50ed8b',
        'PRACTICE',
        'Tin học căn bản - TKĐH3-K15',
        NULL
    ),
    (
        '2a97e1d2-503d-4d22-b2a7-f3fbcd1b4919',
        'subj_eng1',
        '9a74fff7-9553-413b-a301-942aeb6b09a5',
        'THEORY',
        'Anh văn 1 - TKĐH3-K15',
        NULL
    ),
    (
        '48384702-0ebc-4bc8-8691-32e1e0041c28',
        'subj_politics',
        '75d19b4d-1258-4cd0-b3c3-874491b79910',
        'THEORY',
        'Chính trị - TKĐH4-K15',
        NULL
    ),
    (
        '5f40b70f-a54c-4e3f-b192-06dcf784653c',
        'subj_law',
        'd5f50657-9f18-41cf-a90e-e01f9045571f',
        'THEORY',
        'Pháp luật - TKĐH4-K15',
        NULL
    ),
    (
        '3f5cbd39-1b5b-4e9e-a56f-842030bd483d',
        'subj_math',
        '69be186b-1db8-41f0-bc2b-b37747bbed4b',
        'THEORY',
        'Toán cao cấp - TKĐH4-K15',
        NULL
    ),
    (
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'subj_basic_it',
        '6ff5a7a4-2432-47ae-bf91-026ba11da15b',
        'PRACTICE',
        'Tin học căn bản - TKĐH4-K15',
        NULL
    ),
    (
        '23f73921-cc79-41e9-9a34-b39f5fdaee7e',
        'subj_eng1',
        'b35bf40c-c88f-4b53-8029-39938bcc411a',
        'THEORY',
        'Anh văn 1 - TKĐH4-K15',
        NULL
    ),
    (
        '98c2a04b-e6bd-4302-b76e-8805f526fae9',
        'subj_politics',
        'fb246a25-3f97-41ce-99d5-aac89f588985',
        'THEORY',
        'Chính trị - TKĐH1-K16',
        NULL
    ),
    (
        '6992a100-2d1a-4eef-9b84-38cd7c345325',
        'subj_law',
        'ee6d1f3a-18cd-4fa3-afe7-c22c7c643de6',
        'THEORY',
        'Pháp luật - TKĐH1-K16',
        NULL
    ),
    (
        '9596a6af-d7c1-4e88-91bb-1bc000c0a0e2',
        'subj_math',
        'b8ca6e6e-4f57-4f2e-950a-73e97e02fa93',
        'THEORY',
        'Toán cao cấp - TKĐH1-K16',
        NULL
    ),
    (
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'subj_basic_it',
        '70ed1759-d11a-42d5-bfca-547204877e18',
        'PRACTICE',
        'Tin học căn bản - TKĐH1-K16',
        NULL
    ),
    (
        '13fb58de-9b6f-4690-b48b-74460c1c8288',
        'subj_eng1',
        '9d1158a2-24d9-4dad-9606-d04d152d85c5',
        'THEORY',
        'Anh văn 1 - TKĐH1-K16',
        NULL
    ),
    (
        'a211a516-f2e2-46ad-a7bd-70d1beae3b55',
        'subj_politics',
        '2b5746b9-6be7-4a6d-beb8-0944ad0ecef1',
        'THEORY',
        'Chính trị - TKĐH2-K16',
        NULL
    ),
    (
        'd0e02dc6-644d-408c-8e18-936641f6bf1e',
        'subj_law',
        '8fc64399-bc9a-48f4-a7f7-7baef3663cc5',
        'THEORY',
        'Pháp luật - TKĐH2-K16',
        NULL
    ),
    (
        'b85b418b-fc0c-4f1b-9bd0-16bad1f39963',
        'subj_math',
        '63d9a481-e795-4860-a445-096e71fa879b',
        'THEORY',
        'Toán cao cấp - TKĐH2-K16',
        NULL
    ),
    (
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'subj_basic_it',
        '4b3f9592-c10e-4dd2-ae8e-2a12d8371cf3',
        'PRACTICE',
        'Tin học căn bản - TKĐH2-K16',
        NULL
    ),
    (
        'ee68b668-c3a6-4c91-bb01-04c9739599ac',
        'subj_eng1',
        'be0abcff-978e-4978-9666-c54c3f2b1361',
        'THEORY',
        'Anh văn 1 - TKĐH2-K16',
        NULL
    ),
    (
        '3a405e58-1da1-4767-b11e-5ab0bc6a7fc0',
        'subj_politics',
        '4942542a-e00c-468c-b241-d51e8be406c5',
        'THEORY',
        'Chính trị - TKĐH3-K16',
        NULL
    ),
    (
        '27890c95-ecf5-4c3e-bd6a-61fce09e1b14',
        'subj_law',
        '6b5e708a-36c1-44c6-b3dd-80dee6901e58',
        'THEORY',
        'Pháp luật - TKĐH3-K16',
        NULL
    ),
    (
        'b4204d51-eda7-4dbf-8652-1695409baffb',
        'subj_math',
        '11596f92-5a6d-461c-a713-870afcf38a0c',
        'THEORY',
        'Toán cao cấp - TKĐH3-K16',
        NULL
    ),
    (
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'subj_basic_it',
        '005b89d3-3094-48dc-a8f1-0d2da058ef9e',
        'PRACTICE',
        'Tin học căn bản - TKĐH3-K16',
        NULL
    ),
    (
        'b7a19f79-0838-4f46-87b7-1f6695a3d987',
        'subj_eng1',
        'e4fd2059-b75c-44b9-a257-04c55aee2167',
        'THEORY',
        'Anh văn 1 - TKĐH3-K16',
        NULL
    ),
    (
        '4829ebc4-e91c-44fa-a4d2-b8344f0eb5a9',
        'subj_politics',
        '139c8f09-c434-4c02-94ed-62c26cdab6c1',
        'THEORY',
        'Chính trị - TKĐH4-K16',
        NULL
    ),
    (
        '0c225e01-54c8-4f34-a212-6a9e00270266',
        'subj_law',
        '9b0bc61f-6e9c-4a0e-850c-419812bd52d5',
        'THEORY',
        'Pháp luật - TKĐH4-K16',
        NULL
    ),
    (
        'e38d4e30-61ab-487e-8bf2-98c434a6a4a0',
        'subj_math',
        '6ef108f8-6ce0-45fc-9bbd-375417243029',
        'THEORY',
        'Toán cao cấp - TKĐH4-K16',
        NULL
    ),
    (
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'subj_basic_it',
        'b1186ff1-02ae-4c17-a0f2-95b162942385',
        'PRACTICE',
        'Tin học căn bản - TKĐH4-K16',
        NULL
    ),
    (
        '90a7a311-c548-41d3-9b07-49f1810d8e7c',
        'subj_eng1',
        'bd35084f-76ee-4bd0-a359-97a78c53651d',
        'THEORY',
        'Anh văn 1 - TKĐH4-K16',
        NULL
    ),
    (
        'e42701e7-fd11-445c-b07a-6b0753f83b70',
        'subj_politics',
        'db07b24a-0bdd-4b75-b58f-15f558e0bd34',
        'THEORY',
        'Chính trị - TKĐH1-K17',
        NULL
    ),
    (
        '428f29b1-f5ca-4228-9a04-d514c5210bb1',
        'subj_law',
        'e90f5388-9156-49d4-b9eb-489c6f156f2d',
        'THEORY',
        'Pháp luật - TKĐH1-K17',
        NULL
    ),
    (
        '4bbb4506-d396-4f6c-ae8d-7aaa95e13a24',
        'subj_math',
        'a1fc7e5c-765f-4abe-999f-48f6a1a2544f',
        'THEORY',
        'Toán cao cấp - TKĐH1-K17',
        NULL
    ),
    (
        '1599d09e-25da-457e-9902-ce8015079da4',
        'subj_basic_it',
        'bce27e98-ee18-4091-be9b-55070fd81f49',
        'PRACTICE',
        'Tin học căn bản - TKĐH1-K17',
        NULL
    ),
    (
        'b3bede1e-9ee2-4a9f-a898-1d69539d1b0b',
        'subj_eng1',
        '02075391-a62b-4e3e-9bb9-8465352c74e8',
        'THEORY',
        'Anh văn 1 - TKĐH1-K17',
        NULL
    ),
    (
        '350f1131-76eb-47b3-937d-73795a8a1bb7',
        'subj_politics',
        'c8778723-a19c-4dd2-b9d4-270d590bb8a9',
        'THEORY',
        'Chính trị - TKĐH2-K17',
        NULL
    ),
    (
        '6e4d7cb3-7612-4e5f-b470-decafe976438',
        'subj_law',
        'a5313bc5-9d2b-4a8b-90ca-0938733f5148',
        'THEORY',
        'Pháp luật - TKĐH2-K17',
        NULL
    ),
    (
        'b5885d1b-1b43-4d31-b255-678be214624b',
        'subj_math',
        'f682e265-41d8-4ebc-936f-6b4b7fe3380c',
        'THEORY',
        'Toán cao cấp - TKĐH2-K17',
        NULL
    ),
    (
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'subj_basic_it',
        'db44a3e4-311a-4d68-9072-005141311dc1',
        'PRACTICE',
        'Tin học căn bản - TKĐH2-K17',
        NULL
    ),
    (
        '86475c4d-f518-44f7-8a19-4e65c8fb0a64',
        'subj_eng1',
        '153d62bc-ba74-4753-a27d-7176ad07fc2e',
        'THEORY',
        'Anh văn 1 - TKĐH2-K17',
        NULL
    ),
    (
        'a7b0e1f2-c165-4546-a0be-fd341629b137',
        'subj_politics',
        'df4d22cf-6e45-44e0-946c-feec29a9b12a',
        'THEORY',
        'Chính trị - TKĐH3-K17',
        NULL
    ),
    (
        'b0306a3a-f8bd-4d4d-8c0a-c4877ec2137d',
        'subj_law',
        '79bda837-d038-4a82-8a5a-ef45b1661894',
        'THEORY',
        'Pháp luật - TKĐH3-K17',
        NULL
    ),
    (
        '3cc5de63-bbf5-4d90-951c-2e8b073c093e',
        'subj_math',
        'dbeba542-d74b-46db-a46b-1860c29b1023',
        'THEORY',
        'Toán cao cấp - TKĐH3-K17',
        NULL
    ),
    (
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'subj_basic_it',
        '708ee5f7-69a8-4c6d-b4e8-e672f395a366',
        'PRACTICE',
        'Tin học căn bản - TKĐH3-K17',
        NULL
    ),
    (
        'c00304ac-be88-4164-9c50-2ecbcbcbe312',
        'subj_eng1',
        '9200f908-c125-48b3-b169-145cd495f18b',
        'THEORY',
        'Anh văn 1 - TKĐH3-K17',
        NULL
    ),
    (
        'c1f4e6b0-bf07-454d-9ca0-e6304726957c',
        'subj_politics',
        'fe124097-4345-4776-baeb-ba5244dc6f13',
        'THEORY',
        'Chính trị - TKĐH4-K17',
        NULL
    ),
    (
        '427889cb-e554-4374-b4c3-a9b9b2baa8eb',
        'subj_law',
        'd2cb1513-64e0-453d-b37e-a056e48f351b',
        'THEORY',
        'Pháp luật - TKĐH4-K17',
        NULL
    ),
    (
        '5acece48-7674-4027-98d7-e9bf7b0f48c2',
        'subj_math',
        'eb435a6c-8ae4-405e-84f1-bd4d0c6a3037',
        'THEORY',
        'Toán cao cấp - TKĐH4-K17',
        NULL
    ),
    (
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'subj_basic_it',
        '3e20c187-fc39-4ff8-a7ee-6fe1ae12621a',
        'PRACTICE',
        'Tin học căn bản - TKĐH4-K17',
        NULL
    ),
    (
        'ddcd5f6e-9f08-4ea0-a83b-2718ca54e141',
        'subj_eng1',
        '1f6e2eb2-f3db-463d-8f35-18e293666171',
        'THEORY',
        'Anh văn 1 - TKĐH4-K17',
        NULL
    ),
    (
        'cfd2f4bf-dc71-4fbf-ae3d-37ca7d566c04',
        'subj_politics',
        '35b7628e-5648-4618-993c-a74149b84b0a',
        'THEORY',
        'Chính trị - TKĐH CLC-K17',
        NULL
    ),
    (
        '1061579b-e6f5-45eb-bbf2-78f070050305',
        'subj_law',
        'cc384ceb-3646-4ecc-be82-bb10a9db9ed8',
        'THEORY',
        'Pháp luật - TKĐH CLC-K17',
        NULL
    ),
    (
        'd35adf66-19dd-4992-b7da-bfedfb3ec38c',
        'subj_math',
        '93e78003-c433-4d4c-8894-1866681f5f58',
        'THEORY',
        'Toán cao cấp - TKĐH CLC-K17',
        NULL
    ),
    (
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'subj_basic_it',
        '8e278b34-a07a-4c39-b132-0312d8fdbbf8',
        'PRACTICE',
        'Tin học căn bản - TKĐH CLC-K17',
        NULL
    ),
    (
        '24efa7a5-d77d-4fdb-949c-7294470f42fa',
        'subj_eng1',
        '73d44e4c-c083-4a83-bb6c-865e96462a10',
        'THEORY',
        'Anh văn 1 - TKĐH CLC-K17',
        NULL
    ),
    (
        '930b014f-133f-400a-85b3-8d4aa095d5b3',
        'subj_politics',
        'a291400a-a4c8-4a49-af8c-5b771f220f2e',
        'THEORY',
        'Chính trị - TKĐH1-K18',
        NULL
    ),
    (
        'cd60755c-fff7-4a50-b9ef-e5c83a699b47',
        'subj_law',
        'bba1f0a3-8d2d-42fd-b15a-5c3b5cce5c8d',
        'THEORY',
        'Pháp luật - TKĐH1-K18',
        NULL
    ),
    (
        'f643b401-e0d5-4d03-b003-813bb78bad96',
        'subj_math',
        'e8416778-1750-40c3-9b0d-ff8f057a86a2',
        'THEORY',
        'Toán cao cấp - TKĐH1-K18',
        NULL
    ),
    (
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'subj_basic_it',
        '6029048e-65a7-4198-9baa-a1b7df3731a5',
        'PRACTICE',
        'Tin học căn bản - TKĐH1-K18',
        NULL
    ),
    (
        'a51e37b8-af1e-4fc1-af4c-ec820c3f44d0',
        'subj_eng1',
        'adaa9c0d-3c59-47aa-9714-c54f705f1e9c',
        'THEORY',
        'Anh văn 1 - TKĐH1-K18',
        NULL
    ),
    (
        'fb2c352d-faaa-4657-acc5-b80af76c2be0',
        'subj_politics',
        'edc02fff-6052-4833-a1fd-f6004e1d00a0',
        'THEORY',
        'Chính trị - TKĐH2-K18',
        NULL
    ),
    (
        'a2946968-0bf3-4a88-8dcb-67a3a99779be',
        'subj_law',
        'b53dd1d6-c36f-496b-b0f7-889788287094',
        'THEORY',
        'Pháp luật - TKĐH2-K18',
        NULL
    ),
    (
        'adf42463-6e40-45ca-85d6-46701ae980b3',
        'subj_math',
        '5eeec9b6-4087-4d66-bce6-748761e2d489',
        'THEORY',
        'Toán cao cấp - TKĐH2-K18',
        NULL
    ),
    (
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'subj_basic_it',
        '0ac2f9d4-1245-43fd-bef1-b9f7b79229ad',
        'PRACTICE',
        'Tin học căn bản - TKĐH2-K18',
        NULL
    ),
    (
        'f14a1669-fc24-47be-adda-098d1899ca52',
        'subj_eng1',
        'ecb360f6-8ada-4307-ac63-b768be9604fd',
        'THEORY',
        'Anh văn 1 - TKĐH2-K18',
        NULL
    ),
    (
        '87204ca9-9fe6-43ad-81cd-dabdd7f0f857',
        'subj_politics',
        'aba24975-626d-47a9-ba24-5a08444fe034',
        'THEORY',
        'Chính trị - TKĐH3-K18',
        NULL
    ),
    (
        'b5f8a606-7735-4c4a-9a5c-38fbeabcd21d',
        'subj_law',
        '9576e7ae-a04a-47fc-b3ef-af7773e0d5da',
        'THEORY',
        'Pháp luật - TKĐH3-K18',
        NULL
    ),
    (
        '9f19cd60-125a-4663-9907-b88140bf3238',
        'subj_math',
        'd1652860-4a31-4956-841f-cbefa31a88c7',
        'THEORY',
        'Toán cao cấp - TKĐH3-K18',
        NULL
    ),
    (
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'subj_basic_it',
        '433da921-8d12-44c0-9775-4a3ac0c3b1c1',
        'PRACTICE',
        'Tin học căn bản - TKĐH3-K18',
        NULL
    ),
    (
        '82d4975c-3a49-4d33-baa9-2eba334739ce',
        'subj_eng1',
        '58c2e384-bebb-4ffe-8c69-c42e27fd0971',
        'THEORY',
        'Anh văn 1 - TKĐH3-K18',
        NULL
    ),
    (
        '13c8f910-5942-4add-80a1-dd93e42653f0',
        'subj_politics',
        'd44f4ecb-dbb4-4f63-a7dd-1f3de82f7f9f',
        'THEORY',
        'Chính trị - TKĐH4-K18',
        NULL
    ),
    (
        'cbbde0e4-9ad1-4c44-ac48-09d23f83916e',
        'subj_law',
        '041c9042-24d0-46cf-91c1-333b8745ea8e',
        'THEORY',
        'Pháp luật - TKĐH4-K18',
        NULL
    ),
    (
        'fa5c31e6-9a80-4dc6-8974-7c98d1e7f926',
        'subj_math',
        'd63e0246-681f-4771-b571-8f13b3219cb8',
        'THEORY',
        'Toán cao cấp - TKĐH4-K18',
        NULL
    ),
    (
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'subj_basic_it',
        'b3d2ca1b-46e6-4a2a-981b-bbd18d6c37b9',
        'PRACTICE',
        'Tin học căn bản - TKĐH4-K18',
        NULL
    ),
    (
        '4bead0cc-37c8-4bbe-a9aa-dff65a03a442',
        'subj_eng1',
        '12ad91af-906a-4864-9575-80c03bee9f6c',
        'THEORY',
        'Anh văn 1 - TKĐH4-K18',
        NULL
    );

-- ============================================================================
-- TABLE: schedules
-- ============================================================================
-- TRUNCATE TABLE schedules RESTART IDENTITY CASCADE;
INSERT INTO schedules (
        id,
        "teachingUnitId",
        "roomId",
        "dayOfWeek",
        "periodStart",
        "periodEnd",
        "academicYear",
        "weekOfYear",
        MODE
    )
VALUES (
        '1386b42d-a9f9-4611-bd86-7dd9d79792b4',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '820d84eb-38fe-41bd-96c8-23359da4b0f5',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '8f95908a-72a7-4c6c-b780-8480d821e31b',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '75c6f906-debf-4771-a495-351de59584f8',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '8044e804-d14f-406a-8a3b-85302d0f535e',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'ea09fe1b-2457-4cd3-ac4c-f4459ead40c0',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '013f3e5c-ecc6-4c4b-809d-5e336bdae779',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '3dd836fb-9b89-4043-8efe-31cf0b2ca8e1',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '11b7c32b-d4cb-4321-af86-8d5ee73c32e3',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'f22c8739-4d85-4048-b797-d940986a6f7e',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '5c0334f6-4af9-4d0f-8159-bc81820d884b',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'b1ca7fdd-23b3-4679-bee5-2da7c24a1877',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '5e284ad8-b194-4ea9-84ce-b6fcc4b8b72d',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c5cc58d0-0d4d-4176-8b77-88e3ccbbc745',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '0772a572-5b0f-4ff6-a25e-fe16d4f181dd',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'e3eff40e-768f-4292-aaf5-37a664030520',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ecc2e882-8bf8-47c3-95e9-01e5dd799938',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '171c2f08-9fc5-46e6-816b-4a718f3dc8c7',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'bf8027a7-884b-46a7-948b-afa0b7e2c87c',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5e0a186a-0991-4510-a0a6-8f1c985e50c3',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6a105735-d0b0-4593-a7e9-eece83b1ab11',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '0462898d-ca25-4961-8599-5e4cf7263168',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd8b3065a-d963-4963-b066-1daaea38cc2f',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '78a68759-8579-4a00-bbcb-3e63af39161a',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'dd77ad54-e68e-4930-821e-c5069f01ca7b',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '61a8b33e-505d-44c4-b5ac-6d039abf4472',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '40c320a7-4102-4ec4-92f0-8b3aa0c0bf6f',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f59058d2-6763-40a5-8e3b-220b2196fa94',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '4882a700-eb66-4b1a-ba91-082d7f8220ee',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        4,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'eb6fa308-4b0c-44bc-a154-87fb67e7d6da',
        '76015de8-636f-4b8d-85a8-71a27c35bb9a',
        'room_pm_304',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c95452a9-b36a-4732-b16e-e301bc9a6bc3',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '9d82127b-40cb-4838-9576-dc0f020a9668',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '81fd657d-4a10-4b2c-84ab-09bf5fa3a886',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'fbfb5109-cfae-4901-9a23-65506bcadc01',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4bd5a2b8-166b-43bf-b8ff-56c3b3ec9a7b',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '48142f36-9066-4203-a442-2e43aeb06190',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '432c4ea2-6453-423b-a232-deaea634986a',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'ac341903-0e87-45bb-8c8f-46af5bffdca7',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a707364d-af98-4cdf-b7eb-00d327defadd',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'a26ab97d-e6b0-4b22-87dc-829b80acf1ec',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5e8f652b-09d5-47a4-9be0-1461a85ad3d3',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '28965f82-77fd-469c-89f8-a554ffc52ce7',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '274f18ef-13d6-480a-9a9f-41e3faa4b48a',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1fb04836-90b6-4b94-a370-e2821f24b32b',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '884e76d5-54e9-4610-8dac-ba4b01cec5f8',
        '73ab0752-0fa0-4fc8-b2fe-70414f4ff2f7',
        'room_a17_405',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '01c8446b-4d89-4712-8789-9bee729b315e',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1b5299e0-0e09-4829-8c7b-c801bd45eb26',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'fcb15b28-a5e5-4660-b385-7d9454eae3e1',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd780e714-17f9-4909-b0b2-0bc31c821cae',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '61189c27-cf98-4075-b86b-01ee4d6e1b17',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'b5186213-6b5a-4d65-a11e-aa316c5aed58',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '424ae488-9c6e-41ef-83af-d16724c09a6d',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'd630a3e7-f3d4-44c9-96b2-69792324e726',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '2453e0be-64d0-45af-8669-cb5cd56b7ed4',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '27aeea64-9cbc-4bac-b8fa-9af11e146a2a',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '58dbc938-3d00-45a2-857c-7c33223919e4',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '4bf51696-6648-47ce-8c87-47daedad9eef',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4ffd5fb9-bd2f-4bf4-9a4e-162957e3b8ec',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '360a31e0-7a72-4a33-9e0c-897e5ba780dc',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '5265b6ee-b29d-4396-85f1-8cbca481897a',
        '8663d73b-5c24-4438-a2ba-a11357660c73',
        'room_a17_401',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '296ff12e-31de-4e45-af88-ecf448146658',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '188ab135-1925-473a-8caf-690feb6ea998',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c793349d-4d01-409e-b0eb-6db42ddde6ab',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b798bcf7-c8fe-4828-bc19-1c05df181c2b',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'eea56ab7-1bf2-45d2-bd95-85baac731ba6',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '9a53b5e2-6d90-4f01-ab4c-29d01aac39ea',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8ae40b36-bb42-49d0-8b78-9c01adfb1a68',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '26d67a28-f9c2-4814-bf2a-4580f471154c',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'f1a9f3d9-3ed4-4537-984f-ced4cb668735',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '82c99e18-0d3e-47a0-89f6-31bdcac1c752',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '07a277bd-7273-49b1-a781-a3be9daf07b7',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '000e5b6d-1cbc-49a7-9069-eeb1224d86b1',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2a82ecc5-de8c-4262-acac-044d943844d6',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '3a497643-98c1-429a-873a-c107d33cf14a',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ed26d35a-2302-4063-99e0-60f31ae8108c',
        '5dcc190a-94e8-4e5f-9784-cd2fab3ec97e',
        'room_a17_501a',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '88db1ccc-cdcf-4953-8379-057b93880bcc',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ae6c8dff-d73e-41c4-91f3-914ac5dffc8d',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'beca15fe-6630-4b91-8dce-dfbccc8e3c24',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '632adb50-b25f-4118-93b3-dd2137160c68',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '27a4b950-ad65-42c0-b0b1-8aee4609eee5',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '9a324395-e9b8-4f5c-8d12-da22f731eb2e',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '30d62cad-4e8c-4140-bc89-b00e729038fc',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'b7acfa6a-63ac-45ea-b99e-6f76bddbcb0f',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '9b49e105-803a-438e-9bc8-61bcf861e7fa',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'cb4abe95-525d-472a-adc2-7465cd8d3f83',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'f8fbf1c5-0a67-4330-8ef5-12e79bb11978',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '5cee550a-9929-46c6-b994-2e34364d2a87',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '08385a10-490a-4227-ae56-bd2e7150338b',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'b9f29867-64b3-457a-9195-b982c6e2118e',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '49cb67cf-9b80-44e4-bb6f-4605ac3efcad',
        '105a4453-38ef-42f7-8755-5862cc4deff0',
        'room_pm_406',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '8b2a4787-2f63-4e57-b065-9341514dba4d',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b78f0646-bae3-4ace-ac55-bfcdbb8fbd4d',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '96034e15-f64b-418e-8f8f-c520ea0de4b7',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '0cd81bc4-92e2-4365-9f8e-d60326011c24',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c35ead54-0750-4978-97f0-d378dee988d6',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'ae4149ac-5ba9-4491-8ee6-72a7a214b835',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '9aea571d-2ba7-4b6d-8bc0-3fa3bebb53cc',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f485549d-c45c-48fd-94f1-ade745c1f377',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'd4bb9aa6-ea49-4898-8543-dd85a0155fc1',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd1fc2941-f660-475f-89b6-b4ce3a3af3b4',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '4675882f-b6bd-4692-9397-b2e099d0731f',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'fdd8a6f3-d7ce-448d-8ebe-43d261e7d309',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '6d27f332-829b-4c97-a919-8e3f838e79b0',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e9d93c4d-ca06-4bc7-abdd-67b8c889d4ff',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '93cf0b5a-544f-4372-bf62-cf7942f564b4',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '65e9e1ce-dcbe-455d-8ecf-1e9664018c41',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '280ba0a2-e8ad-4e42-89cb-ae747d513dc1',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '275a2eea-7ac6-447c-8a2a-cc2e93d78986',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '0fa084aa-7f9a-4621-bde3-2d0978934dff',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5f576c6f-83ed-4a92-aa76-6bb0889521c7',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '366a8440-efe4-409c-bc55-a4022fd950c6',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'f735a4af-2ee3-41d9-bbd3-55cc1e3e2d53',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '1be6aba3-2fa8-4431-9632-1366e350745e',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'c3921b45-1259-48d2-9b53-8bdb2e79b1e4',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2a0b3609-afe8-4db9-ba3f-53c6d6aff450',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9e344ba9-588b-4b0d-bc60-8dc60eee7cdb',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'd61fdda4-7a9e-4b14-a463-1c44fb2e6128',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '5b301ff8-aa1b-493f-b510-50ecd5d0ee73',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '94cc16af-493f-4b93-bd4b-b2965c2ee075',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_a17_401',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '72f70cd5-5ba2-403f-aaf7-dd1a48fe539e',
        'cb22f145-93c9-4f0d-8f95-def26e947c83',
        'room_pm_407',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ca734807-3004-49d2-b3dd-296e4c2182d8',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'a9411b48-8c94-4b8c-ba92-b11efa74f726',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '50531b80-f18d-4451-83ca-32bd904539c5',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '2ca88d18-e88c-4982-9ec2-343eb21355f4',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '60cff9b8-1342-4b41-a6ef-12691cefc2a9',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'b6a06814-3963-4c1a-93a8-bb1a18a0a468',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '70303817-af91-494c-bc1d-744b869ee3fd',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '3f462ed0-f1c9-4fe8-a92c-883af4aa463e',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'b38b900d-9129-4884-b36b-44067c9046bc',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'f07f9e2b-62fc-40b8-b6b1-d7e66b766b28',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '17ea9b22-a132-4636-a477-90353cca68aa',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'bf2ab9ae-c57f-4444-af59-58bd9997e435',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'ce2ad034-da26-4e2f-a33f-4caf42687e2b',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '37a28736-67d1-4954-a216-a689fa6bb8c5',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '03094acb-183a-4adf-a431-552cfa2b0211',
        'acd98bb6-b0db-414e-8a22-27249031bb30',
        'room_pm_304',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1c48e0a0-4141-4ba5-ad6c-78bcc3c60df9',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5eb36246-5081-42d9-9e09-2a93d367d69b',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '156912ac-c194-47c6-9668-b96622a60713',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '8f76ae60-23cf-4e41-8a6b-efbb62cc89cb',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'eb23fa65-5c7c-41d5-93cb-e694c9fd92f5',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '16a625cb-3838-436e-86f9-7ac4d7b96cf4',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '1605a074-676f-4e1e-a462-71b77c666817',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6dccc201-7c5c-4f22-9389-b28be5dd5ad6',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c2b51910-9df6-4b23-8854-758b92af15f4',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'c4b123e2-d12c-4c29-825c-72e585af2eda',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '3fd4dc3f-019c-4fe1-8a84-4059f0c364c7',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '31f14104-fd3c-41be-b044-d0baca9e16f7',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '59f83ab6-b335-4153-95fd-2d273e1a82fd',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1be4defd-1903-4964-9436-b234a86e3eee',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd81f2fcd-9460-47b2-9040-4c9a00460557',
        'b5987d66-bcfe-48bb-8d0d-dcb178465214',
        'room_pm_408',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e88ad25b-a941-439a-a891-6b2fc541ab9d',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '7f372cf4-ad83-4702-b89b-20515fb8973e',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'ae9805fa-7f1d-4215-bd75-420944c1841e',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '89541b33-4d34-46f0-8ce8-0cb380557bb2',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '78417092-c62a-4066-9db9-912601647f36',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd1fed6c5-cd75-4d25-88c4-6dedd1f5f75a',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'e714633c-4d35-42ab-a391-b7407513129b',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '03430c1e-d749-494d-93c8-01f3ba040963',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '0dc2f017-7d74-42a3-8bef-a1438ab88630',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '2e54abdd-3c8c-4a30-ba5e-d782ca0441a1',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '081f37f8-58d6-4e92-9cc9-a9df6ec1a95e',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '528ad08c-c95a-453b-8872-c8f334fb90f8',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'c123ddd5-5549-4804-8f74-31d82fa69f44',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '7fbc45b0-bf22-415b-bf28-ce5c47386692',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '1c4dbe12-cd55-423d-9f5a-77fb4cea420c',
        '44aabfaf-02df-479c-a2b9-b0e2fca22ae5',
        'room_a17_502',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a719e976-93c0-4caf-83cb-78dceca677e2',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '36168120-4ea3-40fb-a613-e1c9c87a6d1a',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'b63bea7d-fe23-43c1-a5e0-92a90d51190a',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '955bbbd7-b510-4edf-90b7-1c09cd1664df',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e3d92847-38d6-4b56-b26a-cfc616465b4e',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '85f54467-d4dc-4826-9f30-3eda0282524f',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'c38ac3f6-161f-4819-a0d5-c5d74747098b',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '7813991c-42fa-4e8d-a304-3f8793c63f9b',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8dd42c7b-e647-4868-945c-18bba9c40087',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '28640ef9-9f78-40e8-a691-f33128d20a6f',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd82fd09e-0076-4a2c-8a1f-7203e6f4c250',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '14ae5444-a83a-451e-b97f-48e9b29c243e',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'dfb5e669-3882-4f92-8656-6fd7b78f54f5',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4e65e230-09f3-4322-b4d3-4a9a8e318ce1',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'a832f3bc-5b67-4e1d-9185-a4b390074e96',
        'cf01c9bd-0cd2-46df-ae9e-d109e445b9a8',
        'room_pm_304',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b38ab020-a709-4ce7-b4f8-1aa0ab4c6514',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '344bc8a1-b2a3-4969-87d6-4913dee5c4c3',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b0d0d887-5660-473c-b77f-8a17b76da071',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'b3c2cc61-fca9-4445-80d1-4574f00ca5d5',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '637db1d2-afd8-4e51-a1e8-85104ec0a1a7',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '487f0520-392d-4ab4-8de7-576114a5487d',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '9defca75-10b5-4951-a6fc-f77da5a6d6ba',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '1203d8ef-0254-4f72-ab1f-45b200c26b1e',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ecfad9e4-6090-4ec0-b470-b168bcb4c5d0',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '03acc063-6840-401b-b378-a2245b69dd34',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '4dc63d7e-322d-4625-a096-17b10f2b6b82',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '0627de68-4cfd-410a-aaa0-b3caa180d577',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'ce68662c-9f2f-46d2-b23f-b099a58e6196',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '356f49a9-0775-40d1-becb-e75c94dee187',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '07e23ba8-12c2-4024-82d1-ef078f5a8f2d',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '66678891-76a6-4905-8350-a5613c7c48a3',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ec15d93d-0751-45ef-97c4-5eec502abbc8',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '53ec3713-cf9e-4da0-93e5-b2555c3ea307',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '35953f2e-1e82-485c-8de3-1c1cb77f55b4',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '71b9d786-fc79-4942-a3ba-2051ec6e4d94',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'dd56a79f-1273-4d0a-8bff-3500f072c16d',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '702e7709-702b-40f9-ac77-72e65a454b74',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '1af3d20c-0321-4bee-8f81-9592afce0cd9',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'b18da0a3-2df2-4ddd-92c8-3f433c23a565',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4a37734d-eee9-4cf2-91f2-b7c54da31eda',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'a4832726-3183-49f0-8430-241f09f9f930',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1b2b8006-1b47-490c-b446-0c8b224a385e',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '7ecdcbb7-4f19-4f0b-b523-6b10de9322ac',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'b26f1577-1727-4c40-a460-356b145c51b9',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_403',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '60962787-f72d-4b8a-ad95-898ffb227a8e',
        '3225ad68-3a90-42c3-9fc9-b7f660b62fdc',
        'room_a17_402',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a2599484-9104-42a5-8b78-c8472e966ba9',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'd016e738-4d61-4216-a634-24bfb44dc37b',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'ef644ac4-caab-41fa-b61e-d325eececae9',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '4ea2ac96-f9ae-44d3-a396-5cf63e0f530a',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '620e2736-be07-4a21-bb56-72431f8cab63',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd1b0901d-22d0-48bd-b1de-489365a2c9a8',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '50ea209a-d0a1-4f89-a77c-57e05c722f34',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a23f2a39-1734-4406-af9e-09523fb21388',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '617ca47e-dbd5-40fd-b0b6-ac2daeb1e4db',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8f89da3d-6b4e-4135-950e-20a7f52719fe',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'f02a71e7-1b24-4066-ae37-574d4079253c',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'ef8b075a-d4f5-4b7a-8a77-af8febe7e9fe',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '41819b16-7ebf-4c92-bd37-f5a01973a31c',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4f3fa9bd-7bd7-4f5c-8b06-f43b7b9daf13',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '3f8bf68e-6fa8-41b9-9a75-827070ef703d',
        '9879256a-77ce-4c4b-a7de-aa8a01369245',
        'room_a17_405',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f8fffdf5-18c7-4d58-80f0-ed5e4ce353c7',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '0640932a-5349-4f8a-9aa1-9d98835e9a11',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '03e35644-81cc-4998-af1c-2a45762ba880',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '4648ca8c-02f8-4cb4-bd41-5e740bc10116',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '992679fe-6c94-48ca-94b7-8b8f7e193ddd',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'f328e825-7564-483f-8995-3d0941872096',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '25245f47-4067-44cf-bf15-8908aae82b87',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f060a4a8-55bb-4e0b-853d-870be3854e19',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '639a7b0e-f898-4773-a18a-dd7195b523d1',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '739d0628-fdbe-4233-b37d-6daba8f8978f',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'ec0eb5bd-a7c3-472e-bc14-066924f5a88b',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'f5732ee2-69a5-4d2c-ae02-f145257707c0',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '10632866-9050-4092-8c24-6c188c44fc39',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '6f104c2e-5132-425f-af07-a6ffd62dccc7',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '48942a18-e728-463c-b55e-8739b412e02a',
        '4af2579c-a428-42d7-b567-8fc6e29c5c8b',
        'room_pm_406',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1ed07383-f66c-4e9d-971b-cac37d88d96a',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '17914ee9-4ae9-4339-9849-5a67ac0565b6',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '84ed98cd-9ae3-4d2d-ba7d-34e170ffaa32',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '54220e4b-ceb3-4c6b-b9dd-c6ac415c9214',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'a506c473-4a8c-4a76-9020-1105b1ab1ae0',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '1e48cf4a-7dc2-4da4-81a3-3740edbb80d5',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'beba2ec8-4c92-4de4-9691-6ccb59865f76',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '58f39c7f-81dc-4a39-b8fd-30d48610a3f6',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'be3fa226-6c6a-41b0-b868-081ee89f0879',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '44ba7c52-0e70-4e4b-9787-9103d3fe66cd',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'fd44c7a9-dd63-4143-a3de-cbe9767e19f7',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'a58ba9d1-bfdc-4d61-9e8c-081eec76ae0f',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e0a6da2d-8a7b-4fda-9248-2dfccb567dcb',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '80984a8d-75af-4b05-b1cf-d2c332742700',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '19ce887a-9eb3-411e-854f-0b13f82a07de',
        'd2aa1b40-2bef-4d29-aaec-7024bdcd4440',
        'room_1a_102',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c71bbcf9-d3c8-4dc2-b2d3-bed27747d4bf',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '6fcc2a5d-3b28-4b35-84cb-f5a2d648b087',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '90e1a271-883d-46d7-b1ac-523f9893d2a9',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '7f6da052-6a90-4587-a9c1-f62ad4219f8f',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '31019d98-2e68-45cb-ab36-ef7cf3c192a0',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '47ca914b-9527-42b3-8e76-6b2c12c23dcb',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f75c49ef-852c-4558-99c3-42c1b266f059',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f4799755-18ac-4407-ac57-a07db8ed7b9e',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '1d83ba72-7000-4025-bec0-ab363b6ad066',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '1ee24d5d-517a-4d3c-99f0-8330837996f3',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '710db20d-ffe9-49df-8d45-042c8f11f61e',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '91ff1031-a416-45fd-ac30-51669d70d4c7',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'f8c9d568-52dd-4d3f-8390-d79f967255fb',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4945f3e8-959d-477e-9491-5a262afb470a',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '19700f3a-bb42-4e04-b7f9-1932d7ae3210',
        '217f7515-852a-4003-b983-9fcbec219e91',
        'room_a17_401',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '50600d58-0edb-4b7f-ac44-3d4c261f96a6',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '2dc520cd-1355-40e2-a756-6549680cbd26',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5c492b58-4bc1-49b5-855d-45d77ba1be74',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '8bc0f97d-193f-4e92-9c61-b43f5aea9a71',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '0c8e180e-ed04-48e7-af0d-2f74023b9150',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '0c9715d1-155d-48a3-bad6-9aea41d71b7c',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'df18b5db-807a-4cb3-99f3-15538414a3b0',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'aff7cba6-b43a-4fb5-ab13-19d3216669e7',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '9a1ad760-9d9b-4da2-94a2-01f097d122da',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bc634ebd-0a84-47e5-995b-968b507abe7b',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '3f9b723c-0851-4cf2-a2a5-603732c26a10',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'be3d3402-2e5d-4198-9a76-9ea1dcf31ad0',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '31cd5c45-1d4c-49c0-bc97-2a4b69453f7e',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a7c64735-4fe8-4749-bbbd-f25726ca2b0b',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '1fac7c9d-4006-4a20-bb51-42836ee97bd8',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd7013eec-2f1c-428d-84e5-4cd6379ea6d6',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '3523699d-ca4a-41b4-89f9-d8c79c811a3a',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd928d5e4-c51c-46c8-8853-d5b317043ad1',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '99a5f12f-bed1-4c25-8f99-557b886455ce',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '71693728-42dd-4e33-b0a7-ac26f106b706',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6f23d99d-c1be-491e-b3bb-f5d000688233',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '6cb0a1df-4d1a-4b4a-a084-23103fada9f7',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'f6e08e9e-5592-48d9-8e50-ca83c8572aee',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '23bdd920-d12c-4692-9114-49b4d99b7d22',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'f8440810-8f0b-4ac3-be95-7d2743ddc1a8',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '06ed7b06-20d9-4d96-9813-56e3b35f63e2',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8d365699-f651-4b91-873a-dcb2a80daf82',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '600083f3-368d-4091-b682-4229a8af6c80',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'b9b96ac1-fafb-4de6-b38f-514701432ec6',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_a17_402',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'dff55b64-183f-41d1-bea2-19f6a10193b8',
        '436d8ce3-72d9-4a7c-a0de-9fa8ff8fde1a',
        'room_pm_305',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e8138b03-4217-4b2b-b1f3-630dfe822f4b',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'dd42c274-d53a-47ca-94ea-bd2450104705',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'b1e3193f-f6e2-49bf-9e20-f18913ce4ccb',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '92cc0aed-6673-4075-8076-afbf65c42b76',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'a9536ad7-5ac4-4fa4-a2b5-e8980a143cfd',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '5d1d5698-a8ec-467a-8a5f-36601e7d7998',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '3cc9d1cf-7681-45c8-9f20-b21264ecc9d2',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '16c54e90-c49f-4f7c-b9af-f0747ce145e8',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c3a887e2-a0bc-4d42-84da-fe4a6dc126b1',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd67c3f82-9402-45f1-8182-7666373ae678',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '56a3044c-5f16-433c-bdfb-cb28004fcc11',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7b287848-f899-4aaf-a10b-19ea87ac6e25',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'b2a6637a-b456-4d1d-81cd-d4179fdbef57',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '7bf6c184-4c26-4c0f-b396-3108b758e672',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '14e3df62-c686-49f1-925b-1117253078b3',
        'ce136aeb-006e-4460-ad79-5229a3dc529a',
        'room_pm_305',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '4c938467-8610-466a-8d2a-35e486e69623',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c3847a12-4ac0-4027-933e-1210b9a6ae3c',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'd7e74acf-87b7-45ca-9c6e-37be0f529d8a',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f6f606ce-5f03-47ab-9a2a-1dc14192d904',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'fbeca007-950c-463f-ad92-0480148d89a6',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '0a3636ce-76b8-42a4-95ee-c2b02688a296',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '32ad061d-da30-4e76-b5de-6d7384f8fcbe',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '40524a2a-a97d-464f-99b8-bf6283220c43',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c45478c2-ebd9-4fe0-844e-a3edfa3871a5',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '03651441-8c98-44e7-9635-5e69b5e22df1',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '1fa33ef6-8f6d-4f5b-b3eb-6fb19ba519ec',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '575be843-a766-4133-9989-c958f2c01d5c',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'cc17b24f-a4ee-4c5a-b6f7-63c380066373',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '04990b25-7630-4cbe-ab5d-05a617e8903b',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '7eedb685-acad-40a3-9ffd-d7312897c199',
        '08e86f4f-1fbe-4fd2-8d20-d2c3df45d44e',
        'room_a17_401',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ea0e6bae-d0dd-4f41-b8e2-c4f9aa5dc077',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '80fabcef-7679-422b-aab5-24dbdda73aee',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '7fdd1083-c508-4787-8d3e-e7cdeee295db',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '20b0785a-fbfb-48fe-bdfd-e11f1e0fe0c5',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4f13be26-3ffe-4b08-8d44-8227cf1c81da',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'e105cd7e-dbb9-4cef-9d2d-e4f91f62bca5',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '7d787c96-6dd0-4488-8553-6ac13b1cd94d',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'da6252ca-d6f6-4956-9c29-37f69bc2ed78',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'eb159e2b-6692-4dab-8494-1a8074ae2584',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '16af1eb3-84a5-4fe9-8cc5-ada382f56101',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c125103a-1fb4-4c75-ad9b-e8c66774d1ad',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'eef43644-e9a4-408e-bf40-6576a1068b8d',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e0bf69d6-7593-4ba1-8ddd-50f5a992ac2e',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9760a2b0-d129-401a-b852-b481f68e30fb',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '1a428d4a-3285-4868-9155-bfd6dfa5056e',
        'c0bb25e9-a455-43a1-88b5-4a61701f20b0',
        'room_1a_draw1',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '904939e4-a0f7-4ea1-b6d3-0e3f4ce9edc3',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '7fdfc856-b43b-43eb-bcee-92807ff34924',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '62959f35-5f32-4c6a-859a-d540e5812545',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'a0195050-b796-47a7-8434-1966fcb3c044',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '79dae3bd-3526-46f5-901a-d224d2cf51ef',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '970c9fc5-db08-48ac-bf55-9cc3312b7104',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'fbc487ce-5184-4cd6-8e57-b3f808904c95',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '1840b9cb-f509-479d-bf90-1be0e018d67d',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '56551505-95e2-4f84-86c4-9152cb089868',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '58d89a3c-7f1f-4017-a51d-ebb02474c802',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'a722f9f1-f456-4c3f-bfa4-ce327821b92c',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9498a094-c724-48ec-8fc4-9f65987906ac',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2233cc0f-fe30-4678-b84d-1c099f89c9fc',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'de0bf89f-c90a-43a4-b56c-8622c35bebaf',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '31784e8e-ff3b-4b52-bdcd-f7716a36498c',
        '2c4e6fe7-fd58-46a5-8d36-06397ea92ed7',
        'room_pm_408',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'd7b54369-07e3-4eb9-8056-c4029a8b462f',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '862aed17-a8f5-478f-b781-f867ec24f07b',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '7a2b5bfc-f778-4a19-8ade-08379d59a0c3',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'de147a45-e2c8-4f83-8ef3-7fa2ce5225ad',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1df195f0-5af3-4b3f-92d8-260231f897d9',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'be693662-143f-4aa7-bd54-67df85e0781d',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '34edb396-d663-4088-b029-7d29ccdae6c0',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '22174165-cafc-4de9-9628-7f10b16807b0',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '26e483e8-001b-4053-98fb-9bb5a5345b41',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'dc2f9681-572b-4c00-a73f-26e30cd4605a',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '4538b885-ab63-4e25-be89-cba9238a173a',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '7b01aaf2-5b35-45a7-94e4-1cf24b881895',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '431dd4e3-3a89-42ae-8fbb-e6a3a2edb896',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '380f56b8-a2ef-45d8-bfe8-2cb433f548dd',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e0057955-cd93-45fe-acac-aae2ef7095f0',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'fae3c364-2189-42be-9b95-92a7d7eb07a0',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a297bbc9-3ad6-469c-86aa-c340be033b16',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'cf2a6d81-60ed-4220-b36c-2d4604693cc5',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '410ab973-1583-4396-b3d7-2d6119d5289b',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '494b94fb-e0a5-42f3-b33a-445ce1e3a91d',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e4f12536-ed80-441a-ba90-7da2afcee267',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '97186683-b3b3-466d-a7cb-a2d49d6d7714',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b0ed26ef-e46a-46cf-84e8-2f8fab28b167',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '1682fac3-c30e-4742-b6cf-700a05197eb6',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '65760cc2-c203-4475-8b5d-a6b6b55f46fc',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1c935113-ad02-48be-af61-8f6597ea7507',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '70341d10-f0e5-440b-8e76-7c813da730ca',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '2e0d4731-b2f9-417a-981a-eb1add733ab0',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'a3a3a7d5-67d4-4bc9-9840-2fe902ae81c6',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_403',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '4763ad98-d597-4891-aa9e-dc489238bb4a',
        '2ed26ea4-1fe1-406d-b4fc-6b4e2c31cb50',
        'room_a17_401',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '7ae0641b-8c87-4b9d-b5df-4f4b91e20cdd',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '2b7fb028-06f8-45f6-b7fd-e301e981f909',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1ee8f043-a771-49f3-b3f8-a7c8b81917a4',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd3b5a4e7-188e-4b99-868d-98d11095adff',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '013c986a-c304-45ba-ad60-b951c07f4005',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '8e2081c8-510c-4fb7-a2c8-9df0c74695a5',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '13f2a32c-8beb-4cb1-83d1-e5ff0856ddac',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '922070c5-0f1a-4898-8029-9e5062d17ff4',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ba567b15-3f36-459a-a848-e5e34c8cb129',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd9dd7c73-f125-4f18-8a40-ed8b0d455409',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '145e7ba7-b65d-4c63-a692-c0c9a59f4f6c',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9d6be15c-9f22-49ae-ba5b-4ccd7ed4400f',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e3dcde19-21af-43dd-8613-6737070e3029',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'ca413d4d-7d9c-4908-a1e5-273003453577',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '75aaabf1-4d6f-4eaf-b499-e54a9f74e384',
        '02d4f810-51ee-4cd5-8d98-42737a37c986',
        'room_a17_404',
        4,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1a7395ea-70dc-4da3-ae47-3c6a1845e24e',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e4f286e7-a108-43f5-a284-bca6003992f3',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'e6ef3afc-e4c2-42c7-bb57-67aab2538fca',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '9d5e5eef-b8c2-48a0-9147-feeddd4fd486',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '9d2d5606-507c-4438-bdc5-2f47cdac55f0',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '24bc2239-56be-4a3d-966b-a7430f3fead5',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '1159f2aa-6b88-40c7-874c-c5f0c51d8d6a',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'bd35fe97-3317-4170-8c26-5d4e05a49642',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '5e49cdf9-4417-4a95-be6a-d5e3d4fbf5a9',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '6bc509cf-dc34-4623-8636-c5804c8ea7db',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '05e0f214-f5ac-4da0-bcf0-27cc9902dc9a',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7191698e-5dba-4129-8341-807e5f40b0a5',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '65d3a69b-1e48-4e6e-b272-be4733a16953',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '77d7c168-43ea-4e64-aab0-5aa64412360f',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '319a511c-462b-4906-8afc-dbca3c28d37f',
        'c9efb1f9-44c2-4daf-915a-293b054cc46b',
        'room_pm_406',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a17e82ca-c94d-4cb1-9b69-a42b820f7e6c',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ff621219-21ae-4ba4-a37e-22ce29e67621',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '858156c1-4a5b-454c-b381-7682a80b28b4',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'e15af401-32f5-409d-9897-fdbc878076d1',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b2d174c4-025d-470e-972a-60d118380d48',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'a001825f-4174-47e1-8e05-b05ae533e386',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a679f4f2-1bce-4134-8f79-d40445ac84b8',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '196022a2-e8f0-4933-84e3-d89696e699d9',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'fdc1f61c-126b-4e98-a710-5e7cdcaa9023',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '3ffc2678-655e-48d7-b60b-783aa8259f2c',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'fe4d8d07-203f-446d-8390-cd681de71a60',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'da68efb9-7dfe-49d5-8b50-2e6a002e5ec4',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '836800e7-db8f-457e-afbf-9baacda14870',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'adafabfd-ffb9-45e0-9d3c-baeac61fc2f8',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'fd007653-2442-4c32-9f17-97f041b09b71',
        '6bec5455-92d0-4957-9791-e7d180ab7bb6',
        'room_1a_101',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1f854620-ac51-451b-8cc0-116cf85a54e5',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ec7abf1d-c870-4c64-a083-3283cabe4485',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '5ae303fe-94c9-4124-a042-e5dc0ff7d33a',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'daca8be2-39a7-4757-bbf0-2cd06c00dfb0',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '030104f4-bcd5-4a46-bc2c-fc67f8e5c4da',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '76615f6f-2cbe-446e-a6bd-b843535bf015',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '65589863-d885-422f-8d0b-e2afd32142de',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '2b72a03d-9999-4d63-941e-50db5dfea298',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '7015075e-830a-49f4-9497-abde4aa34924',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '61a2f582-7b53-468e-a1cf-2380fe08901d',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'aa3a1e5f-da5b-409a-adbc-02f6b739b534',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '04fc1b91-7fcd-4c0b-8c7a-a7f99f7c48fd',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '8b15ff06-163b-4021-839e-5fcf7e6cfc31',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8c254de7-2077-4271-9268-1c1a94dcee69',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ea672691-cd1a-4aa8-9f92-095f63e23064',
        '428c75fa-8bb3-4647-8431-b659bbc8605e',
        'room_a17_404',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '3324ec9c-c3b3-4c31-8426-092a74c17ee9',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b0687810-f54b-45df-b9e9-7493ce4837f1',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '90454fb8-b280-4cbd-ba2d-962344e5ac9a',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'ce71f44a-0b2d-45bb-a0d7-280e02e912b1',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1d0dca38-36cc-45da-b00b-bbf9de88f594',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f295a5c1-26ba-429d-bbfe-fce2711d582a',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b6706a68-8a1c-49ce-be2b-ece6d3345f89',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '70099644-4f42-4eb9-91a3-3d6ba0084c1a',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e1fee4ac-e83f-41f5-836f-20c80acf4358',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c80f1295-5f36-4e0d-ae5f-8b1dacce617d',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '43b5c3f4-375f-4fd6-8ee7-de6afed37cc5',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'db5b6f44-d952-4460-8134-3dc9ad78190c',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '7009e13a-02b9-4ea0-8ad2-aa80b2e691d2',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c6a8f746-9bcc-4db9-b308-bd0baeea9067',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6949da71-993a-48ec-821e-c148fbce10b0',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a86023cd-9606-4314-9706-a347638ef47e',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'dd8c4874-c9b0-41b9-b4ad-e0d7ea122344',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8917db3e-2b1d-4c74-94ea-e091d1a314c3',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '61e7af45-e26e-4488-9cb6-2ea28682a09b',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '23b53398-40dc-4379-894e-56ce3e2d99c6',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6d884aae-225f-4c50-a91a-4c693ba4ed0a',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7a000045-c25c-4458-8a4d-c5ed1d4486c2',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '11b2d458-3071-465b-8b21-4d12e9eedf81',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a13efc2a-93f2-4106-bee1-21a51a0e4257',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'd640a4fd-9135-4469-82a5-dd004aec8558',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f7082608-e84d-432d-aa04-d63202ffc826',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8086a62f-0d8b-4afd-8edf-24af4f349b3e',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'abf9c494-f2fd-47f1-9401-6870f88eca2d',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd8d0cab3-7730-47f5-b7ec-b616e04bec2d',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_408',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ee37c567-3faa-40eb-ad70-2f9a48d69904',
        '61ef192a-3ad7-4e63-9217-4ae7aa4ae8fe',
        'room_pm_305',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'cac82599-307a-4762-be04-1a919c330a18',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '47ba9cf8-772e-4434-8f4b-8881f1bba94b',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '5e61552e-37bd-48fe-b661-455ebf24bccc',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '897d07f7-2b29-436e-87be-cdedd99f8017',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '26a5aa9f-9de9-4099-8553-996570bb71cd',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '565424d7-8034-40e7-828f-cfc316d8e86c',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '0f8abb17-4b77-48fd-832d-f9ab6d4ee8a0',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'ece4c84b-28c8-42e3-93f9-523a1a1802d3',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '243fc82f-f137-44c0-ae36-17e337bd8a90',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '6695387d-4df4-4a69-9887-9a0a9471cd5c',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '1bbb744f-e185-431b-b3db-0c86ffac9278',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd7a26b64-2d88-485b-83fb-6e02530ffe39',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2d0d0727-c6d5-4fe2-b2a3-ea7dd1bbec3f',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'a6f53d26-3d72-4187-a7a0-05c261244a6b',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '45a60c93-c22a-4ef7-bdcf-65a727f3a18c',
        '3dd4ee74-20c4-4692-8a45-d70fc764a458',
        'room_a17_405',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f3ea9d1e-18c9-40b8-b8f8-4f434c09bbaa',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'fad74250-ec03-4cab-9064-664cac3b2b79',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '830616bc-ef3a-4c8f-9521-f455a3707676',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '11a9b61e-f092-4df3-9dad-4573337d87e1',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '156c603b-fa3d-46e0-a365-3de5a335d5da',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    );

INSERT INTO schedules (
        id,
        "teachingUnitId",
        "roomId",
        "dayOfWeek",
        "periodStart",
        "periodEnd",
        "academicYear",
        "weekOfYear",
        MODE
    )
VALUES (
        '637b9088-d42c-4477-ac19-dcc47c9b919b',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4518a385-b696-4e7a-bd1d-c91daba47161',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c18041d4-d28f-418e-bae1-d38d46ff2b87',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '6267acf2-7f5c-4e94-abb1-9dd874a0e668',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '04033f31-8478-432a-ae70-034ebaa6eb3a',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9783655c-d090-4758-8aab-d46e38e0e231',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '2f433fa6-0674-4550-af25-a6cc812eb353',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '711448d9-eaa6-454e-adb5-09f6b0cfefdf',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '6d6d27fe-8838-4f81-81fa-bb521ca92aa0',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '0377d940-23fe-4391-a9dc-632552c30ef0',
        'dc6cba75-821b-4740-8525-d361278a9152',
        'room_a17_401',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'bc0aa681-856b-4191-b4b6-15cf79fe7262',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b18d85a5-6e94-452b-8d0d-a73d397f34d5',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '8013f128-04dc-4eb5-8d93-8e0cc2b83b73',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b1011544-0046-4488-8bf0-e6f121203342',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ed041bc3-48ec-413e-9e1a-28144e424169',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '4b811203-3b47-411f-b7b0-383e43715109',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '78c1a0a6-2579-4d0a-8ae4-9b1e8b988f9a',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'fa2e6f64-ee46-42a7-9751-02ad51acf25c',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '549535a8-258e-489b-88aa-017e55094246',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '3414b3e1-a3dc-48c3-84a6-7e3fcb53c487',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '2d11651d-d8aa-453e-92c3-fca23f3e2bb0',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'fa170f95-8351-473d-b91f-5cddb5e26e89',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '3f721e35-0e9e-4661-9e08-aa117eab1c37',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1cd498d3-a849-47c4-8598-db1b8a5eab44',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ee24d2d2-61c2-4d63-b361-c0c0152d11ec',
        '76911554-a934-4b4a-9865-423a85a55b51',
        'room_a17_503',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5bac6f23-33b7-4fe7-8bc8-29822b6e6ed1',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '75eb5baf-03f6-49e3-8bf4-a34b3f64bbbb',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '41f4fce0-cc7a-4acf-a30a-6a7621320096',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '01f78aa9-a70f-4776-afba-1e5853abae8c',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e4b12850-4a2f-4745-9990-2c7f32a85a85',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'a2847ccb-b5e5-4578-892d-906857530a8b',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a763062a-99ff-42a7-9474-76521d06d9eb',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '1f74ea9b-2592-4f5a-bed1-c12b599660c7',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'dd298821-b63a-40b5-ae78-c4b9ce83616b',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '9f8837d1-d264-4563-b0f5-8757a642ca76',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '229b11ee-4fa4-4864-abdc-ce39424ded39',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '744a1f71-0bb3-4627-b774-483554bbf814',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4234b333-e859-416f-8e2a-41856e44af83',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f4dadc45-a13b-4e31-9167-19f6289000ed',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6ec96823-c4a8-4605-9f8d-96073b59cb21',
        '2e4a81cc-26fd-40e7-99d0-0740254b4298',
        'room_a17_402',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '302e7ff5-ea6e-4987-81ad-fe6cd5fbdbcb',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '6150cd1b-ce29-40d2-b4b6-b6f795eacb2d',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '830a9b91-7ce0-41b2-92b1-ba6d9319ac96',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '103fc2aa-8a68-4d54-b732-15f4ead931ba',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '0134899c-2b89-4dfd-be10-9a6e3aac30a3',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '9981ef85-4002-4116-bf0f-e77b991b39e0',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'acb14e47-8d00-4ea3-a3fe-8735b06ccbe0',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f967d2a1-a3e2-4a84-9f80-096907598ab6',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '8ea2027b-6a49-48b9-b64d-4a45b22f9641',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '6deb8cd8-56a3-4979-9bbd-ff2a40932d1a',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '0b809194-7881-4ea3-885f-5396b39d7f03',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '1b935e17-352e-4e5e-a83e-9a320500a117',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '0f599ba3-ee76-4518-9420-08741e09739d',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '9b4202cc-eda0-46f2-a1a1-1a34139b08c3',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'b8611808-794e-44b5-bf97-2664c60b2ed5',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '29906b36-fb49-452b-9efc-3917d5c3fe2e',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '9760f8e7-4168-4f6c-8ed3-d4e3cc6897fa',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'ba0f1902-885c-4568-a8cc-12a41f787991',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '6c87df61-0ee8-48e0-8478-24b1ab3ba903',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'efd97004-8f32-4c5a-9b2b-06b611cd36a7',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e82df8d7-a9df-4515-b7cb-024d7ae1a9ec',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'c476b981-09d0-44c7-bf39-ea5fc177232c',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '848420e7-00db-4f3a-b3e2-60b5e5ab0401',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'f44f6e64-7dbf-4d2f-8844-866af4205bec',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4cae0f22-69f4-423a-9d43-a340f1b97f41',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'b967fca3-4f16-4476-a2e3-ff1e5ef745cb',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '5ee50ebf-c62c-4188-8db0-b530c9e40201',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '749958ac-6a51-41df-b0b7-21fd08b39efe',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '13e6be45-5dcd-471a-ae24-a147d906e582',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_a17_401',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '60acb82d-e73e-4704-b69a-6521dbd0abe0',
        '39ddbdda-000b-459f-8bbe-fd01f2c17528',
        'room_pm_304',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b97620ad-5c34-4591-a674-bf1e3e03b720',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '30368ba4-7236-4a6d-b535-91fcb03aaada',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '820a606e-2020-4989-bf47-f09e01530ffd',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '4be73433-0caf-44cc-b0b3-3ba407d603af',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ca36733e-58b4-4b70-9cee-4b15bc802759',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'dbbf145c-7102-430e-be3d-c9d079e946f6',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'fb43db84-6ce0-4fa3-8605-0769e781dd14',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f156d9d1-75f0-4875-9385-a5e79efa8239',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '258aea2c-89bf-46ce-aabc-8c5dd6ace3ae',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '7b6132cd-daa4-4768-a084-57939a5f10f9',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd004f05b-f16f-4dd8-87d6-df66b6b4f66e',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e4056869-c962-4823-b7f2-e1d1aa0c2dea',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a2755205-b691-4953-83eb-84f0a490d8f1',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'd0410513-29fd-465f-9b81-b677dff046f2',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'b6192fea-28a5-479b-a8a1-0614110b0dd4',
        '30402af3-db07-4eb2-b07a-b67604ac50fa',
        'room_a17_404',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '28d9a186-5cc5-43f7-93fe-db349183c017',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '24094f49-18ab-41a5-9593-85ba584003dd',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '039d61ea-ff1e-4aca-926d-26bcbbbc5ac4',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'cf78bae6-c739-4978-8395-d91201c2c8eb',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'aa56e845-fe3e-4240-ae8e-f8ace15cbe23',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'a4394b02-6396-4362-911f-07b2fb4f4905',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'abdd6202-4227-4087-9473-ba4548cb6450',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c27dc4df-21fa-4274-9aff-11ccf58fecc7',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8810e35f-843f-43f3-83bb-21e8c9610609',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '814987f3-1456-4922-9782-0ea2de348a36',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '64cfe577-821f-4543-b218-54dfb68b4c00',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '02237ab8-5cd3-4cff-a95e-e4ca407d7565',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'fda80c06-e449-4680-a190-f28cd487ce3e',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9301e629-4a34-4035-89b4-731fbc236255',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '03915165-4f43-4162-8623-3f0cc7ddcbd0',
        '4bcbf5b8-5c4a-4e4f-b689-e582ff2304bd',
        'room_a17_402',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a4eb39ff-563b-4a67-abff-bd506a28ca4d',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'f5faeaec-56ef-47bf-b7cd-b425507f0206',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'd8c1be4f-f52a-4506-9849-c1f1f3d76f34',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'ab504688-0904-465b-8795-a75e74379ca1',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4aa68b62-938e-4213-9451-cd4e21f3c59e',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd11761dd-7858-4b37-a182-70fee73edc5c',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'b92f5c7e-6594-4a37-8ec8-dfd1126ba5d8',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'd3b8e9a8-20af-4e7f-8390-dc7097b36960',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '41c6c16f-c685-470a-9a5a-bd1ff1007116',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '561107d0-32cd-4685-adaf-08c2abc8e043',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'ac682f4e-ba97-4ee1-aca3-e8480e98da92',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'fc773ae9-f2d2-40bc-a8b0-d04f4680dec3',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '5405f807-c5d3-411c-a7f8-fcfb1c74eba5',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '74dbfea4-1604-4604-85e4-25671f947aca',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '33386c53-fab4-4123-8790-cabe4dfc7d76',
        'd4fd0437-8762-4ebe-a8fd-eeddf61d5086',
        'room_a17_501b',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1029fe7d-8a52-4a5c-af7e-f7c450b261ba',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e62885d6-9691-4fa7-b060-3af43125c988',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '6e1e0443-3750-4b2d-a2aa-36359ce78e65',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f2f0c2a5-7247-4c7b-b460-978eae6a151e',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b2484c44-7a94-4661-b0b4-41231630d603',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'ee4e91df-150f-40ed-bb25-466dcd78a48c',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '14d17c7c-7a26-4174-b738-b16c4273fc42',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '05836344-1618-4ee7-8088-20be76154fde',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8756505a-8a76-4a11-99ad-bfb54b5341fc',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'fa7f52c3-c344-48df-9b36-8563a3d47749',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '7cb72340-837c-4d81-8d7e-d86ea3ad7caf',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9393ec73-749b-4a3c-a894-e1eedf515719',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '0d42d17e-50e1-4528-9948-cba9004b736b',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f23ae965-6f35-4a76-928a-a7c68cf73934',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '0154585c-0fe6-4269-8b24-e96c07afa12f',
        'b21b59dd-1e46-45c6-ab16-be6739ea58f0',
        'room_pm_304',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e5a8bf22-d0be-4e80-9faf-ef6b043165c7',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '80a7f398-9bab-4cbb-8082-3fd13820a009',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '0d2597ef-e202-4373-9a20-f274535840e9',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '9c1a64e3-3fb1-4fce-bb28-aad87bb43a4c',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3d91227e-06dd-4067-ac99-e60794c2f90b',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '31bc2ebe-08b9-4526-b1ec-645ba43d829a',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '972f2947-e580-4e41-8eae-5c922ca22d64',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'c7abe316-2169-4e19-a917-4268ef3c559b',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '5925b00e-830c-4ae5-b234-22760efbd846',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c37eb360-5cf6-4a4e-8fd4-b6d270c875f0',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '600604d3-3b7d-4e0a-8d8d-5b7b4b0287e4',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8d88243e-622f-418b-9463-08b5ff2b8b03',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'fe0d30c1-502b-49dd-ae44-4165bb5ddd20',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e12d8e15-cbc7-4a17-ad81-a9fcb5fca1f0',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '0470c994-2ee2-496d-b8b3-2150a4fafce0',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '2ad0bf8e-d13c-4004-92f2-95fb5c4dcd0c',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'b3a0dca0-a6d8-4598-9924-391a5b2e70ac',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '50a09470-41c4-4fae-8cab-8312c4372dc0',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'e7a1cbd4-53a2-4a00-b882-855346296c86',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5f1235bd-6eab-44fd-adf0-a3975edf44be',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6715760d-e880-4027-b841-7cef02083092',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '88c51d19-3f5e-42be-9725-a15b36531082',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'aeffecd5-67c9-4747-94f3-3e382aef6e5c',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '1356a125-059d-4a6b-af0a-845388c099c4',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2268bba9-53bc-4393-bbf2-0b23f6ed7eb2',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9d890cb7-2d01-419f-9994-cbfdb9d12f80',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '728d7e7b-30ee-43a1-be9c-8ffd73463644',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd245cc4d-2712-4770-9554-c0ba82c9c381',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ae0d4371-4ecf-4ef1-82bf-610bd3069f8b',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_pm_407',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c25ff6fe-883c-4929-82d0-14aa0b4bf8d7',
        'c0a1b7af-8ceb-43e4-aa7d-0afa8a65e745',
        'room_a17_405',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f159bed5-f84d-4308-bbab-66095b499b2a',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'aa12e6e4-9a6b-4b06-bf52-c9ed6915f479',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '67c5fef6-aec1-45d2-8773-883f508ccc90',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '9b3928d2-32a1-4800-8e87-a3234b1ba659',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '42da2b58-b911-4461-a9a7-5ae20bb7d53b',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '355cd495-77fd-4d12-a085-31b8d0c997e9',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '295da25d-fe85-475f-973f-f2417b8e7118',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '1c60d078-bb73-4521-a93c-be6cd8fdd534',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'f1543271-b15b-4e84-9f87-bbef577548fb',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'f1b51f05-b0c1-4a96-adc3-b9bfac5a5856',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '926c768e-7af7-4fe0-a324-0853f4674285',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'c48a5477-40bc-4d43-a56f-48167b0e776e',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '95658009-619c-41bf-b1e3-df3369d95b88',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '3b485bcd-4b05-4430-902d-87de021d48d3',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e963b801-3bcf-43dd-a2a7-43bc1da0e3a5',
        '1f9bff50-41fe-47a6-bef3-d4fd1e2d3bc3',
        'room_a17_403',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '43b063b1-b751-46b0-85e0-be6157982ea6',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3661210f-9817-4cd5-9c4e-fc12e9cb5815',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '71932b14-32a8-434e-a060-2d0e7ef646a4',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd9045df0-bd14-444e-bf3f-af7c15398d5a',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '127077f9-22b2-45cc-803f-e67b9bfddc88',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bbe31ae5-c46e-4f28-9d3e-e758984af552',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd868445f-272d-48bd-9a3c-757da1cdaf9d',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a8a3478a-00ec-4b01-9903-89a9c5d724a2',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8058db55-2aac-47ca-a7f5-ed78a529a2be',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'e85e0204-95f0-41bd-80b2-730ab74da07e',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd95765d5-18af-4c66-9b59-59fdf0458423',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e759606d-20f3-467a-8459-68e29c99cf7c',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'bd0d5f93-f912-4aae-ac12-067c5ff0fd4c',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2e8c8b92-30c9-4b16-88cd-4ff5aa81d6eb',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '73a68f72-b972-4c5f-87c6-734ba280ad6f',
        '0deccce0-30a8-43f1-8487-74bbc6e1219b',
        'room_a17_404',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '07d13aa8-dc83-472d-aead-f2dd6dedf5d0',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '86272a00-75df-47e0-820c-20b1f2820841',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '28dd5992-29f4-46f4-ab1d-6b7238653539',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'bcf1f586-1b10-434b-b715-53c6ac27bbc5',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'fc6725cb-7018-4811-9b50-a824396037f5',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '053e16d1-4558-4555-a12d-e01c83d65ede',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '942f5de5-9745-4f67-8ed9-07e95bc5c6cf',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e3a7cb33-e182-42e8-95ff-b6f53befd82d',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c71b1f7c-d8f2-4329-8c04-9d03146f5b1a',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '63024495-8703-4689-9ea3-cca10ab0ba81',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '887aefc9-0dce-4eea-972b-65605585cbd9',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '24d54805-be42-439c-8718-f433a9161ade',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'cb4f8d33-628c-4d45-be71-eac14afce202',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '25970401-22c7-41fd-b4d9-22a9bbbf2ffd',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd2a1e89b-b4e4-476c-bb9c-f7422148b1ed',
        '4fa5bec7-f4df-424a-8c55-6086f5673f4a',
        'room_a17_501b',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5be43fdc-04a1-4489-8d8f-5f9f698ada0f',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b242d14e-1b3e-4e4c-84c7-4f4bdb7f6977',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c74136bf-eea8-428d-8bc2-c4bd13ac18db',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '96be20f5-319b-422b-93e0-aed56f6ad608',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '7e9d457e-3187-4f05-aab9-c6cf29868a0d',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'beaf5920-b3e4-4f78-97a7-32566c1d28b5',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '19b9df22-1274-45ef-b182-f4fbda3ec6e7',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '33d9a483-38d1-4fc7-99dd-41f0d9abf2a3',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '47a78b73-2cbb-4363-8def-9676c5b0ebd4',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'b5d589ca-d01d-48dd-bbce-7c2f3de47b64',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd94670d3-ca91-447a-ae78-9f9b3eafa4c4',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '25bca3f5-00c9-4c9f-bbda-62dfaa1a1798',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '15d93a16-388b-4dcf-a844-8f8c21e4926a',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1922cd38-1725-4020-84b8-81dc5827e1c7',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6994b1df-ae83-4f34-9768-6e1610f63b53',
        '61989c4e-4ded-4ca5-9733-81363116ab27',
        'room_pm_408',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5b719ab7-8d55-45a5-8410-e02f6b148ad7',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '75922f04-0931-428c-86b4-9e65196ca49b',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '234052b9-3378-40dc-a1c2-75dfc3fc3f56',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '291d28ff-4f59-4115-a4fd-fa93d8d8543f',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'f5578ab1-e322-4460-a923-1f41526a97da',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '3811489c-054e-471d-aced-a54b0a576bde',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'edaabb89-65eb-4d18-a66d-f1ac2e9cb983',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b7a4a32e-3b4f-4885-b211-7b86a3e96bbe',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b317add6-ae6c-4e41-adac-5666153b8129',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'cd4472d3-4594-47ef-8bfa-21d3a28cef47',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'b415aec6-a240-4e55-94e9-7d77c0a32b39',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '151c500a-f98c-441c-a2c1-9bda047296df',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '440a3dca-3526-4cde-a7e4-281a834bc732',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '421f9277-64e0-492b-b875-75d0e3131417',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '60b77a40-f0a5-4f80-8cf3-80457ad15f11',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '3dca3e0a-8115-4b61-917f-29a10ae12022',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c43fd5a9-fa74-43a2-b207-72fed9449af4',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '952b8e1e-3f6f-4785-b52a-b933618e6a2a',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '2aa9fe07-f4b2-4f6b-8fab-864f9365bfcd',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6a91f525-c421-487b-afb3-4f8b13a3eef9',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '4eda179e-48e4-4096-bece-e14309e9bb1b',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '6d775ce8-8581-49d9-a829-507c39870127',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '16d48428-b961-4951-b258-0a6d41aa6e32',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '8dd983f6-0e3b-4256-b812-fc0b91749f7e',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'c515e6b2-aeeb-42ac-8fc3-0ec18c36d73d',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '1e8561b2-1178-4aa8-866d-662a232b87c8',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '833c8bd8-1fcd-4259-bf25-014e206e7b85',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'c625e7c3-5976-461a-a724-b8752c85210f',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ec35507c-d24f-4532-a667-2886a8acb183',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_402',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '85c582be-3243-4f06-826b-2a9218279796',
        'afd10c9e-fb77-4206-88ef-d88ca372deeb',
        'room_a17_403',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '0bc31838-df3b-4d91-98e0-ccea1dad7f55',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '272ca18d-7339-413c-9a00-3b16a20bdc29',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'dea5c000-f726-413c-9231-03c9aad98beb',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '1667416f-f5e0-484f-a035-3767b6a05d55',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '68d0304f-c889-44f6-94d8-8aca446be01a',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '6c179725-a1df-452f-85b2-922dded371b7',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'e5bb2cfe-5efd-4487-b6c6-8cbb5d0b6fe9',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'baa3c756-c070-4c1a-8936-1728385ca36c',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '96814631-ee45-42db-a56d-cf2160f0a4f6',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'ca301ace-c517-4694-bbe7-dafcf0846a71',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9819c9e7-3822-4170-861b-26b51883f88b',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '741ab9fe-47f7-4845-bcbf-4c8ebd9a55fa',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e36c919b-4577-4ab0-99b9-e0fb77de62b0',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '63799212-3776-4185-9ce5-bca95ff758cc',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6513ac9e-ebb9-4277-bef9-67ff21fdd18a',
        '58afe86d-67b8-4ac8-b9f6-de9f26e03e7c',
        'room_a17_401',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1b8dc25d-178a-4f33-924f-031a7fc24b13',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e0dab9eb-c105-499a-9cf6-783399c46178',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'cce47a7c-ca2d-473d-a451-f919da84eb69',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '0d451bd2-f7dc-4927-9570-bcc3c5fb5bd7',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'defd87b1-6c29-4960-a484-a25a15b7fc34',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'ed2b9004-7c94-421e-a066-3352067eedb9',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '1dc4a239-1929-40ca-a2ce-1382ed057c9c',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c95e441a-2355-4c0a-8b15-62e83e960dfc',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '16903729-23d2-4924-8f7c-0030a647161d',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '0495d67c-b815-42ee-9f78-ce07cd84fb6a',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5ccf6c1d-1015-40ab-8e6e-563455648904',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '2c2bea0a-1478-44ea-addd-83cf13c42f9f',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'd98a0b7e-2e87-4fc9-9795-c6987d5fd7b0',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '90c99b51-16c7-4b35-8824-925632684bb4',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '82a7ff25-54cf-495f-ae99-e162f0c2714a',
        '08095500-84b9-4e91-a59f-525c94278a3b',
        'room_a17_404',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a000b167-a9cc-4bdb-a1a2-724ee1dc0ba1',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '4e34ff4e-fdfb-4222-8764-65f7079d6496',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'fd0373bb-c0a6-449c-862f-a8c9d24ddf0f',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'a8e7f80c-d964-48a1-a286-821168ca3034',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '0c5c530d-e6af-408f-b06a-5a96b4e3d066',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '79f44b70-0d72-4663-b2f0-c71c04b73beb',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '917f7199-05e2-4df0-9edf-bedc66a1d538',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '79b440b8-bf83-4dad-8629-49427f4cb480',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'cf226f98-722e-4cf3-b5dd-1bbcd4e0931f',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '63186d7c-f75e-4fb0-b5c9-d01160600f11',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e3e497c9-1b25-4712-b0f8-0287a0b724c5',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b4579db4-fbb1-4041-ab40-1b6837309ea9',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '6ba6cf71-153e-4a80-b8d6-5761896532bd',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2bf0ab62-30bb-4583-ae19-2143610d54b8',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '10803cc7-851c-4ca7-8fe6-ae7fadced8ef',
        '08ccb1c6-c0a5-4085-84fb-a72921d32965',
        'room_1a_draw3',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '9cc0d9b5-9447-4ad9-8fc2-4d047c7bdf5f',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3a8a9395-ff93-436e-8462-59aa4f92ebf1',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c04e42f2-e2b7-426c-8223-79100bbe6e67',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f8e3c46f-4298-4146-8360-6bd29fe8bbbb',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '37fab6ea-225e-428c-aa4a-9837435118a5',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '037c181b-f8ad-41e4-baa4-576ec6d231ba',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'e49f6600-5965-40b9-a86c-b16fda6c7ef6',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '23d3c3db-6782-4b02-a588-e1b73a7d847e',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '4574b363-a7d6-4a9d-bfec-34120a6bfd35',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '22848063-15f8-4c9a-b626-83cac80deb73',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6d67a89d-0ec3-4c8f-b6bc-48bdac0e2c91',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b5bcddfe-4d01-40ff-9f06-26ff9dc422a9',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'f307dba9-e2fe-498a-ae0c-d83d3c784c0d',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '5638fdb6-61ec-4145-863e-271ed6e4fc50',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd57cb4ba-46a4-4d99-acd3-bb9df347ed93',
        '510d1738-9f8a-4b75-9018-4878c07a25e7',
        'room_pm_305',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '7309f1dd-d6da-45cb-933c-20a9863eda0c',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c028c14b-151b-4754-9db0-6a106fbd9ada',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '808990ce-0046-40c5-9007-8d7b218a9783',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '02f1d469-80f1-4cd9-aedd-c8707288cf08',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'e0b783cd-b656-492c-8fbd-26396cf2923e',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'c781a62b-e7d7-4a41-8728-83971b2ecf8d',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '14e8ce6d-a2c1-4331-8058-e73b8302a5c4',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '689a8923-2c3f-48cc-b0f9-22bcfb0ef05f',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'd55a4795-0c59-4a81-ba65-f4fd81e30ccf',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '8754b69f-081d-4688-9c2d-27008e945b35',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c7011a7a-7704-490d-818a-4e9071ec7970',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a106cedd-f2b2-478e-a76d-b23a67d1d525',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '762826a7-22dd-45d3-ae5f-dffc3c286e38',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '835e3bfc-eb01-4572-bc58-ebc232217c9a',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '88a8ef6d-1dfe-479d-999d-d6a31a464571',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '7b86da34-d8c3-46dd-8ba2-75e276ae75ec',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '962ed98b-64e1-4080-8548-b1508284d98d',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'b1b26443-4256-422e-a449-ac600e4e0311',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '774469b2-d576-4361-84d6-c830abb3a6fb',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c301c7eb-3f24-4c0b-ba55-d25e395516b9',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '3dea6b7b-5967-4901-aadb-5d0c3a92d594',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'bb293d22-a568-47ba-ba8b-e06b75a2fa38',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b9d64e63-f02e-4a97-8fa0-3cf89e8f17b0',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '3c9e1368-ed6f-4227-ae89-f664dfc304da',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4452f81d-91dd-4889-bb1e-91e15240388a',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e0b8e3c6-b13e-4847-a0ba-8dfeeae7784e',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '6313cb39-3891-401c-b8f4-9dea3b8424cc',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f452c8a8-b157-40c1-8cfb-a3ebd9625f4c',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'fee18e77-10ed-4476-9947-2663796b8194',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_407',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a395e3aa-49e3-4bd2-ac47-8538840a5b4f',
        '7d1f0d0f-3292-470d-8568-ea367257d1f7',
        'room_pm_304',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ff3f63d5-5cdb-4c6a-8cc5-6886e9fbfeae',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'bc84a4fc-a0a7-4a3d-98a7-0308de80bc5d',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '4f0347aa-2b10-4fec-9418-90d2ea969a5e',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '3e57a15f-b1bb-4b3c-a2cc-e6fe25c0f5bc',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '459f172f-6e36-4ab5-bcb5-9a7a9ca5c8bc',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '9c8abc4e-26c2-48a2-9c30-0441ab61daf2',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '2f7dddd3-4666-42ac-a470-658843727c4b',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4aabaf7f-a793-45ae-9a81-0687a922e07a',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ae6a5398-b0cc-4aeb-a0b8-2aa3a1d906a8',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'dc7aa526-8249-48a4-acb1-bd26b8a27a5e',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'fdf3c49f-6ee4-4eea-a806-516e0de5e6bc',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'fe670c51-04a0-4c9b-80ca-2a27b776aa7a',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'cb838a5f-efe9-489b-abb4-9d1e73696846',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '71f8ba0f-87bb-42ff-8cfc-808f43d4bfaa',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '8b7a0759-3a1e-4218-bbee-b0f55b91222b',
        '2b69068f-7c56-47df-9182-c4f769639921',
        'room_pm_305',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'bdd2a388-e912-4f2d-907c-7870af3747ca',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '9b8b7079-3e4a-4221-81ee-614477174619',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1a8afa62-2e68-4dbf-b24a-4389231ba784',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '342145b1-57f6-4817-95c3-f46d049cc45c',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '576624f7-6dba-44f7-80b8-e295bcfdd341',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '98e02109-0e0e-4ff8-808d-d76ff5877ed0',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a7909984-2e06-462e-93ae-182922b111b2',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4af2eda4-32e3-4e0e-b888-57de8d8ac196',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd10d126f-2030-4bca-a0aa-0586f8ac2ede',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'b211b037-9061-4f32-8c8d-ad867ad113fa',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '966d5262-eae4-4b6c-9752-e83e5415aca4',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7acd3927-fe16-485d-894a-1713ed184094',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'ce484942-009c-4062-8804-80f49f41922a',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'af50b205-a243-4468-a0aa-7e9fab1a6c97',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'dd309c83-883f-47bc-b0e0-77f9b8b120cb',
        'd0828035-ca73-48c3-815b-6e3dc912170c',
        'room_a17_402',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '50d1e30d-f7a8-4cfa-86cf-7dd1dd091550',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ec4d833c-0aa2-425a-bc4d-ea2ae72c6d1c',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'bd54925e-2399-40bb-9eac-682e7c34b8a5',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '73bd79d8-92b6-4cab-af48-9ea5e5e88449',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '9e595e0d-d94e-4f0d-84e5-84d1c5b36241',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '7914e73f-8651-4774-95cd-0ed45f7b7d3a',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8f4e109c-6a32-4ebb-b829-d8b113f3334f',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f8075f82-516a-4a08-a77c-d3505636ab75',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '60ba385c-df5a-42ef-8de9-4fa63d284dcb',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8910c57c-f308-4f66-9bbc-97c93da09207',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'b4531b08-7017-4a47-8992-b6f50c0cf0d0',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7d8b6fd1-3202-48f1-9907-9aaab6526cc7',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '587b1a22-8edf-4a67-bf73-ee6502fbceb6',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '314633b8-b2d6-4a0e-8b92-b2a8e60d9979',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '602cf443-5974-4a52-9bef-f8888c6c6346',
        '137f4b42-6f86-4f1c-87b8-614545e776e7',
        'room_a17_502',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'cc5dbb8b-7b93-41ef-86ca-8676b5291017',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5499fb5d-4caf-47bb-be52-987aa64ef227',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'd150a453-8742-4a27-ab01-02d40dad5e86',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '147ef68b-336b-46dd-b164-6897e7fee044',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f00d6d3f-7f60-43dc-bc50-df91272bb219',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '2fabad7b-83df-4e8c-98b6-17e90b57be4b',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '49a95c31-3304-46a4-958b-faa907c00750',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '396c2152-0a1a-44e4-b240-c3afa037d8ab',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'e57d41c7-8ba1-464b-a56c-a67515f1cb03',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '81afa66f-c70e-4f8e-87f4-ab5cf7390117',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '7eb47d7f-778c-4293-af8a-d41f65f65450',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '84ddf67d-056f-4560-a06d-c313d95f4152',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'c7c6ce75-b26b-408f-bb25-0503e9a46aa9',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2d277b12-d382-4245-bfd4-33b0ce3cf7b6',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e9475a12-f66e-4196-8987-c2df41309518',
        '383bda2e-6f53-4f60-86f6-5afd658d800f',
        'room_pm_408',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e8662add-c4e9-467c-a407-4144b63c5f8f',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '00287cfd-72d1-4dd0-9e48-5cf02048c130',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1bd22693-0929-4ffd-b929-caef563f5faf',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '7b973789-2dd5-46d5-b36e-73629a344010',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1a194a1f-02aa-4571-9996-bdcb755dfd5d',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '3682c544-2c2f-4832-8498-7d6566a65bd5',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'edc9a3bb-4143-43dd-976d-4600715adcf3',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '0c7075a9-aa2f-453e-9cd6-e7d07d99aac2',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4d72dafd-f191-4ebc-a4d9-d2a15c98e1a0',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '3484fd92-fc1a-4173-a124-b46ce2ee94d2',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '591362b3-7537-4e90-9926-bdb8162b15d1',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f4f10afd-511c-46fc-8c83-d08aa91027d5',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '66c0ebb9-9843-46d5-8bc0-fecc572caba3',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'd35bf691-25f8-4e68-a57a-519afce70a3f',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e5ffa4c3-4562-4552-a7dd-3fe59023e2fa',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a8ea0261-4fc8-4bba-a5ac-852c0e565a18',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '21a92b29-84da-40db-8024-0a62a3dcc37d',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '2ecdae12-6060-43df-9646-d272f991e679',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '601b6e99-8a8d-4c6e-979b-d7e315a68804',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c41b1acc-26fc-41ce-b64f-5314cb141548',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '62207155-070a-4259-b17e-80891b2504ea',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '792a0497-593a-4058-b5f0-afddccae5e08',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '2eb336b7-a599-4093-8d36-e40c08c177b0',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '7abf5820-e356-43d2-9599-3fe9ca393e30',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'fa9180bb-8dfb-4069-b476-219672e6083e',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2416aaa6-0aae-4e29-b4ab-4e45aa2935cd',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '18f92a46-ad53-4d43-9165-128c5cac6d37',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f3a1bf09-7f34-4199-a545-58e6be83c3ef',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '993d2b5f-b932-46fc-8de7-17849bafa46a',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_304',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '788b943b-4dd4-498e-9a6f-4266470d07b1',
        'b1569b33-4c33-4d76-97c1-6ca599df3839',
        'room_pm_406',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '99663ab8-39bc-4f20-84ff-3acfa10a35bf',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c3a7e22b-cc1a-4580-a29a-6228c79e2fff',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '13adcb71-adf1-40ab-9f13-c7b2c52a482d',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '47e2116c-b586-417f-94fc-3122725fa655',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '5708b078-d864-4a2a-a8ea-e1d699767c08',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '1ac31417-580d-4593-9aee-5ce5d55824bb',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd8ac0059-93b5-4487-8ce1-7a75071e789b',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '123ca6ac-2cf9-4547-8357-0fb6a59c8270',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ca163e25-aa34-44d9-837a-c3a64d508722',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '50de4d1a-99bf-4cc7-928f-545cabcc5199',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e07e4e13-4c36-4eac-87c7-acc5174cd37c',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '6596eec5-4b96-4d25-af60-74c826586c0b',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '56399917-8818-461a-8541-7bebc52ab5b8',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'ed6812aa-ab58-4af6-865f-a46bfd846d9f',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '47cee778-278d-4ce4-ae00-5ba76a17b4e6',
        '3df86852-0887-4cd8-8765-8cb4dd866deb',
        'room_a17_405',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'cc517f80-c9d1-4718-bf9a-2c51c79f46ea',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'dc604557-cc95-4693-9f2e-92caef6a8eaa',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '60f3cbc0-dca4-44a5-9857-dc801d96da3c',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd9e72cca-3e8e-44bf-a7c8-e57ec3f7d806',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f91705b7-a1dc-4f77-b2cb-6f109b1728f8',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'fe646f7c-d2da-4dc8-afcb-ebeeb7c924a9',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'ca98b021-4e93-4cad-a3a3-f0900f665c01',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '8ecebaae-927a-40e3-a5db-bddad8da2e0b',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a837547e-7ce0-42c3-b3ef-bbe51695fb34',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd32572e7-f364-4833-9617-6d438a670980',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'a3fcd4f0-5139-4db7-9581-91cd3f6409f4',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b4137bad-a752-464a-a303-7619cc0043ab',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '746e082c-6daa-4793-9e32-a0d794297caa',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '90fed9c4-0179-46e6-a63c-45ca0a987948',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '069c16ae-b6bd-4e13-b6bc-6b6970bc317f',
        'e8de87d3-7b0b-4a77-94d4-5ddc4d37f5d4',
        'room_a17_405',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '67bcb933-dbc4-4909-8100-d5524c923f92',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'cac80cd7-35fa-4e23-b2b1-445ffc9e7cf9',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '443451da-3487-4ed2-a8cb-09346f7caac9',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '4a07042d-59ac-404b-ba7a-da120f2f44ba',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '255a99df-6b50-4a01-8bc9-4aa3e792a025',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '8737347d-be61-4557-896b-fb1fa93fd163',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '581158c7-5c61-4b05-bdad-6a3c59c9c53e',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '96b25bc6-35ab-4d77-b9a0-8a4faa51e3cd',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '55c374fe-e9aa-4a9f-836d-18bc1bf352c4',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'e1804344-eee0-4e87-85e1-2c9dc758ca37',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd2f524cf-204b-4029-9892-0e46e4d162d6',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b015948e-fb47-4674-b1b7-6c3774d3d945',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'd7f1ce23-1fd4-4c96-84d3-fac96e149f26',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'bdc1684e-d5df-4b34-be15-7bba9648d308',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '46e5fd61-d001-406d-ac6b-cb10802e20c0',
        '34a55295-2423-4afa-9e13-1b35fda57c8b',
        'room_1a_draw3',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2d1fd5e9-70bf-4cc7-9a92-d640e0176bb8',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ac09ae17-bab8-4651-b491-0a2d33815aa2',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '596c8fd4-a139-49f2-8766-f673c96aa9af',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b02ed339-d298-42f3-82c5-77d928663ec5',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '7d481b0a-6eb7-48a8-b84e-2248b2c5f45c',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd9bac7d3-4795-4303-844f-9722293e74ed',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4a23f706-424e-4161-b1ed-36f3395036c8',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'b2390b9b-b8af-4f2d-a639-f31664512e31',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '9ea9fc4c-7180-4a61-9dcd-b2f0784898ca',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '4f1a1ab9-69e1-4f68-a365-f20b4837296f',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5d38d87b-3369-48fe-8cdf-fc47e56d9f32',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd427f7c3-cc64-4a05-8c23-4b2b5e17b98f',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e3326b82-246c-46b3-bebf-691dacfedbb4',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'fd6b4e3e-f6ee-4160-b711-ad98d4b33d99',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '378c374a-8e37-4669-ba5a-b70b36f33a92',
        '6f6a68e2-ee25-43ec-b70f-2d3331bc8f75',
        'room_pm_305',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '13c97d87-fdec-4b50-9027-54579e55bd56',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '98a8d00b-48ae-46a9-b34e-3218ecb41108',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c721d513-5791-4529-a3c2-ec24d71cfb27',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '912c2168-9784-4d38-8829-ccd275fe8289',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '26d93afb-ab24-474d-a1c4-1776597e0ee9',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '47b6ee4e-d7cd-48ba-af46-b384cf2e2f36',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '6808b215-e3e1-4857-9033-73ccc495302b',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e8c0af1d-45d0-47ae-9523-00ba5f353bc2',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '74eb9c78-3391-469f-a202-91c7823e7b11',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '822f954a-bf61-4cff-aef2-6530a46df856',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    );

INSERT INTO schedules (
        id,
        "teachingUnitId",
        "roomId",
        "dayOfWeek",
        "periodStart",
        "periodEnd",
        "academicYear",
        "weekOfYear",
        MODE
    )
VALUES (
        '9524c90f-4981-4ec9-a6a4-b2d03430d4b2',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '24553125-940f-4773-8c0b-0fcc083bfcdd',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '44ceabb0-b76a-43e9-851e-86a0d7ad0e15',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c7e267ea-334d-4e0a-af3f-0b7c32bfd9b0',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e139f848-aa20-4c22-8fd7-9932a6c4b69c',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '372d0be7-291e-4893-8f1f-d77e60c69297',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'e55d47dc-5e7b-4abb-bb11-2d84e06f1a0a',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '2d8d3123-209f-4151-9380-dd4acfa624fb',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '33e4533b-371b-4053-9be3-51a6855687c1',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5e091558-2563-47db-a22e-e8986d49ea0e',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '2d25019b-de76-4070-b3d1-a9107b186d2f',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'dfbd1638-73bc-4571-b675-d336e5c982d5',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'aea1ccc2-7b2f-47d7-86d6-7a08dde06eaa',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '1be540a6-c2b6-4e0f-b89d-abe2c19f5281',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '5421ffb1-316c-413a-ad80-f96d2f056cce',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '7edc673c-56b9-4d09-9899-11acade3a477',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'c2e7390a-dd03-4621-b620-d5e682aef1bd',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6ad41cb0-abdf-458c-af18-024fe9342342',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6e8d5bf6-0590-4b5f-9cbf-fb2bfc26f0c7',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c21a7445-cda6-4fc3-bd0b-7c785dadec74',
        '4d1c3aa0-a1d2-4008-8f84-ca9f9f1d6560',
        'room_pm_407',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'd9bc465e-4ecc-4fe3-8a8b-60dec4cc861d',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '2a36666e-265a-42b6-8c68-0bd8a81b827b',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'a4929781-4bfc-4699-9248-7ee05b8a2e8e',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b5d1a450-0896-41a5-a9e3-693ea0cfe9a8',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '1d634863-702b-4b4a-8752-13e2ba980ca7',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '17d11197-efee-4b0b-9b88-09e4870b4622',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '125df6c0-ed05-4e5b-8b02-7b871cbeae4a',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4188c2d6-6f21-46af-8780-27e32bf3d1b2',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '7e66e1c2-b092-4d6b-88cb-e8c847030730',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '0d3b9bb7-a1f6-456a-a1d5-7d0b7c36b330',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd3915f7c-0d3d-4a63-981b-b4f7c8df44bf',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7fd9a84c-9e2b-4a0c-9ff8-afadf9e9cb6c',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4728e78f-6e6e-42d2-80cf-13edd50be45e',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e5ec6ed1-f67e-4e3c-9e32-fe9f01331511',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'c7638ff5-389c-4ea6-b61b-a0d8e5f0a1ad',
        'fe9a4d96-6f08-45ed-ae27-92662109a374',
        'room_a17_404',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '18c3146b-fee3-45c9-a086-f35175e6266f',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e113d20c-cd6a-42e8-9d5f-71d82eb80c16',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'bd59591e-90ee-4ed8-910f-7adc22ef3a44',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'aef9820c-0a12-4696-a666-7cd85e55b7cb',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ac2050cb-01d9-4133-b568-842af987990b',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '95fecba1-8567-4bc7-b635-3538e0aec11e',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '180ed4ee-741c-4ffa-a73a-157f69b54474',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '5c909d5c-b81f-42ac-a882-903c5b250794',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8a160e14-c61b-4259-83b8-027cebe7330c',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '5d1f543f-ae7c-48dd-b440-ab40bcb04d7c',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '8163207a-6e38-4379-b518-a813c6d3c1c6',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'ce190dd0-da97-4c0b-9557-8ac8e44fd1c7',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4efe71b3-0279-44e1-ab06-791787eeab84',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'ab9d0e00-4382-4a98-beec-4986e87e6506',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e1d89d8c-65c1-4a40-b2bf-f9f31e39e2e9',
        '7086e705-8312-45b2-bf4a-2ff283897a39',
        'room_pm_406',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '98295d4f-d327-438c-8b5d-ad5e1010995b',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '9c9bc3f7-7ba1-4ff6-ba30-2246a7899831',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '783de696-fb4e-4af3-808c-033b5f4cc63d',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '2aaa5e57-ba2f-49de-abe4-9574778a8b79',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '19cfffeb-437d-44cb-9dee-b78e8684944d',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '31c7ed6a-0622-430c-b5e6-684773c8ca3d',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'b3ded36b-3192-4e5c-a3fd-acc7a26d02ed',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '26260c73-1a1b-40a2-98c7-66a17e6fb519',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c372435c-8bc2-450e-9aff-aaa50ec15731',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '1de2161d-5ce6-4772-8fbd-27fe700a80a8',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '724052b5-3a62-4c80-8f03-a1d7efe1fe10',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '345d59b3-5a3f-4375-a439-8598ec7609bc',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e028729a-d800-4c9b-b993-6e170b06a114',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '68f0ffe7-d7f5-40d5-a50f-349a60201513',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '8ab85ff8-78d6-4c33-bce1-7e15f4fbf3cb',
        '163dc358-f727-400c-b926-50bba4d4844e',
        'room_1a_draw1',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '51e2c567-52e1-400c-beb8-5b664173115c',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '9bd3b695-a1c1-4a26-aa36-df6bd4321dbc',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '541eab47-b858-4945-8957-3bdeb323249b',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '472d11fb-0cc8-4bd5-a3c3-0cdf9733c286',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4d2601ea-5f13-431d-8c17-7864b3d7ac47',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '24e3ad8b-345c-47a0-8a1d-a366905133cb',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '7786d873-c025-4235-8388-1d7f4379f943',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a9af9755-7d52-4e6f-ab8e-5e37ae76557c',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd74415d4-1b49-4401-82a4-387cfe45aa7e',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '59b1d5ee-2a4a-42a4-9049-1747419c54e7',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9542fb61-1230-4269-88fe-90d363997962',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e86370c2-f951-4472-8b6d-ec8904b8c10e',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '0988a573-31fb-46be-8fd1-5f95b57dea48',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '75268676-895f-4eef-8eeb-70985f008350',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '0f599726-0f3d-44c8-82be-c996e34a09e9',
        '8e79313f-9377-42bb-80ed-1bda5332311b',
        'room_a17_402',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '63c9e889-0ac7-417b-855e-a9fdd14d3b54',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '52f892f8-f65c-4ccd-9d0b-af547ef2bdff',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '8a2fda7d-86d7-47cb-82b9-d045bce3dce2',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '8bafaa7e-9085-490d-aa33-85278a4f557b',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3b041980-9045-4092-bc81-7437accf2cde',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '1f15bdda-1c92-4420-acc5-f625955693a0',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd4f8a95d-a3b5-4fd7-bff2-0b4768b8aa3a',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'a6e0441f-bc34-4de1-9633-c2203464c780',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'd2613d1f-aed6-4fc5-8525-007bf5e6d1a8',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'ba25fb41-6575-47c8-b671-8b745499c366',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '3a0a8f61-0b91-4528-a2a6-80f6f53ac1cd',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4d436032-7a66-4dd0-81cd-a4f2c50f1645',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '39cdfdc8-0cb8-41b7-ac33-857cbac1215f',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '24e4798c-b00a-4d1b-be3f-0d3f0f22414b',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'cd112f66-5dcf-466f-ba9c-4b56e6d1fc41',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '401f854a-9b94-4e13-9a4a-d9499fe95ad1',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a8f83060-27f2-4d0c-b02c-8c3137723c67',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '853dd973-7918-42de-ab97-fb3293f70f28',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd9c861c5-9cdf-48c1-88f8-2533aea5f697',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e2e1322b-f541-4ae6-8ad4-ace7c8fd2b0f',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9ad0342f-7d5a-4d7e-82cb-141559c008c7',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9ce35329-ae9c-48a4-b3e0-3c8116c688f9',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd10284bc-c614-4d7c-897a-973e7dff586a',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '2e80b358-c39e-4b55-a4b2-ebfd1e237a28',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '265a9e64-c15f-43d3-bf67-487dce8053d8',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e1a74129-bbe7-4e7a-8a40-e1498567261c',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'cc721413-3bc2-4d39-8de5-272412c1733e',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '736c9769-9805-44cf-a36d-2752e2da7a09',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '89003ff5-638b-4fd0-8133-43dbecad7d00',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_pm_406',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b3fc18d5-9a88-4ef6-a096-23905c9125e4',
        'e8d99ca9-66a3-417d-87f3-9fd12b4cc9af',
        'room_a17_404',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '3930d180-3c98-4139-b1ec-b0309ceb76e5',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5a6541ce-fb78-4707-8bf6-66dbd42b6883',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'db98110a-99f4-49ab-8cfb-68b5203e4830',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'bb390fc8-3226-43a7-bfc6-a66f8bfddc86',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '1c9141a4-652c-4692-a9f3-a4b93e0a799e',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '9380d62b-4716-427b-bec6-3a983b39e8eb',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '433bcb18-9fb9-402a-b78e-980ab7fa3d4c',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '01ac87f7-bea4-474d-812e-09a38e5c8a1a',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '85d38c21-8d9e-48f0-8b66-5f2a77b5a3be',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'c7d1103d-fe62-440a-9b78-bdd44eae089b',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6b4daa81-0f1b-4f4f-9dfa-c1b6c9a93bc0',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'c155fbea-2b78-4040-aab7-3a535376b027',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'dc70cecb-1207-41d5-bcd6-745d5a22ce9f',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '629c9a79-7114-4c19-abf8-1831bc0483a2',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '92e45141-4191-459e-9b8d-fd2d75f5bfe0',
        '17a90000-ce45-4fd8-91c5-87ab244e228d',
        'room_a17_403',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2dae3a8c-99e6-4334-8244-a16af8439e87',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '42693e8b-d4bb-40d0-b7cb-718799dd275c',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '9d516ee9-ffc6-4593-87b9-66dd60510d1c',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'c1fc315c-da54-4f2c-bca2-4b5dc181f381',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f7e3245d-3f7a-4f71-8c94-0592c089023b',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '230b4235-7a95-4984-8876-63573f2449f2',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '9bdda47e-459a-423b-982b-3314fe405df0',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'b5a88f8b-166a-4aa0-8db8-29906fd0151f',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '0693866c-4825-4467-ac29-a4b3ac4dce21',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '07048a09-7688-486e-9917-f322ba38ce45',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '2648e757-602e-4dc8-b7bc-642feb8d3dbc',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'a4a3e1b1-14b3-482f-a4b6-318d21d3f7f5',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '3fb36637-ccca-4b39-9413-42d892558612',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '7dbe001f-5939-4ebe-95e6-2f7d69087574',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd1b27ce9-972b-43f0-9608-98f03c6386b8',
        '3aa443c9-3faf-4cf1-beca-4fc3ffd0d1e2',
        'room_pm_407',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '630b06bf-8e70-406d-ae0a-7ca511c7d622',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'fd16b4be-3d4a-4de8-bce7-c54907118984',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '928b80c2-c6d4-437b-9aea-be4463a85f66',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'eee1d205-dfc2-44b5-a9af-1fe0027a1ec2',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'f48476db-2dc3-487f-ac15-d9171fad17cb',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '992c62b0-7e9b-415c-9dd3-ec01f40c552f',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '468607c3-1175-4cb2-a753-b604238a35da',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '74874839-3c1a-448a-bbdc-7768ce96f1be',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '558e1538-4bc9-4ef0-98b2-0bb51a7bf50d',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '66fc7cc6-ede8-4e88-959d-5ec4a912dd78',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '70c9765d-8ca6-44a0-8bef-0993a01aacf4',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7c9a7d8a-366a-445d-84a0-a1c12ee1730a',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '65bedf2b-443c-49e9-9613-494febee9250',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2032c895-2107-4599-b956-7b2e1c0bd6b8',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '0cce7aea-d12b-4cdf-b7f5-b88090864878',
        'bedd7d3b-8791-4c22-ba9b-48477ae6790e',
        'room_a17_501a',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '884e98ca-41dc-427c-8b92-cf6cfe1a156c',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '8cd17ff4-3b54-44ba-be56-fb202fd4a940',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '795d628c-88d9-40e1-87c6-46366464f2b4',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'eb11bce1-bff0-466f-82a5-a13e6a2b46fe',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b20c112c-6623-45b4-a57e-28e063028430',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'df911544-0b91-423e-a202-222985442381',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4d7e9f4f-40d9-4460-a300-dfba70be4934',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6d1d1253-978f-4ffe-b486-e3ce2ad4020d',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '06191d40-f9b9-4ee0-877c-a55e54bf4b0b',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'f911687d-6f12-46a0-bce8-8a565ead214c',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6ae00287-4578-40e7-a6a1-87129a15e0e1',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '35b166a4-3d2a-429b-9bd6-0d3d5ab075fe',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '969d59cd-2cb5-4100-ba0e-cb18b1770b61',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '58af0e7c-6e5d-4285-afd0-275f21f14cff',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '7389f8ea-7681-4220-aeda-c0960258b389',
        '3359b769-8d97-4ab4-94c3-801ca0f3a748',
        'room_a17_403',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2f47dc5f-9401-4449-90a7-93a2d1d8620a',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1b88e266-002d-458d-98d5-ff1a14f2eb78',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1005dad3-c625-49c4-a33b-10031d9f2554',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c8430e17-04ab-4c56-83df-6d9c0778a0b4',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '544e8c59-5e2a-4d7d-9535-59f28b8cabfa',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '333098ad-6e56-43c1-9c2d-8e1ea488ddf8',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'caccafaf-a841-4923-994e-e081ece09220',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e1e6582a-b4c9-447e-98dc-a80304e42050',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'd2bcdbe3-c185-4e7a-b6e8-ef90e031c6bf',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'ca5af79a-39a7-4d7d-8918-837eb9515395',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '12d2596e-e690-405f-88fd-82f9e72cb1d1',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '3f1ff673-78cd-42f0-88dd-d02c3a2a42e0',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '3a128023-1c67-49ec-9780-8c80612904a6',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '1cc9d8db-7a88-4934-a970-95577b572d97',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c5af4302-fbee-42f3-a00c-a1687892f67f',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8f02b4ef-df55-43cf-9d23-25282418c317',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c159b00a-4ef6-4a77-b50d-cad463768ab7',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'c8aa8852-850c-419d-93b4-447a1f389e3e',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '71e80430-98f3-4690-b7c8-d53537a42992',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '92360215-3cac-46bb-a9c9-428afd12eb05',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '59f3ea71-0b37-4a60-ba41-7b0bdfe9ffc0',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '6afc1589-de90-496b-bd0c-7e3801cfc6d2',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '05abdd32-9453-4c07-bafc-1df213a6592f',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'dd1c74e3-ee9d-4467-a6d9-95fada7bd2c1',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '8fc34e1c-1947-4289-bec8-cf40e88b49b0',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '0950f7e5-0543-4867-ae07-964ffc11c76e',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '11af3868-c817-4dd6-9d4a-e9b2a27b1252',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '52f0614e-894d-4576-ae8f-42c315bbf4d3',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '3a92287a-a58a-4d95-a720-88d475a557cf',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_a17_403',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'de08f6ba-d26a-4554-b4c1-1aeb6a658fef',
        'eeb47c63-6601-4b63-b773-efdfe412e40c',
        'room_pm_408',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e091e5b3-7ea2-4e16-94db-fc021b631dd2',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3f59c145-3b9a-4109-962f-32296ecb6dd2',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '1361732d-c6f1-4818-976b-ea33ee33a171',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '7beffd5e-ea21-4c36-8bed-bf824b8cf4d2',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '6430cac0-db77-456c-9219-b370b24d3039',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'a9b16185-c6c7-41fd-923f-2aa57b83738b',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f3e6cb4d-0b96-49bd-942c-6e7eaacbd848',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'fef81da7-5a32-41ed-8e20-9f29249b4c0f',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '9fbee7ff-64f6-45de-aa0f-8955bc6439f8',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '3c75a0f2-0319-49f2-a990-f07a756d1b70',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '8dcf836f-9a3f-4514-ad2c-4d9792edd83f',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'af88bc1c-d713-415e-801a-7ad3bce6b859',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '7e92cfc9-5d65-4900-a296-42b5bcf461b8',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f5f2f407-aa16-44a5-bbbf-cb82d78db076',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd34060f6-6ab3-4699-8cd4-a1499e8d8e8a',
        '97377bed-8d9f-4d2b-a461-c2f5ccabedd7',
        'room_pm_408',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5a6e9b86-c9c0-42bc-bda6-529474172612',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'd2b085d2-ab30-4d2f-8fed-09ae1b7c3ddf',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'e138581c-2732-4a39-a401-8f2d723d7116',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '6aded107-2119-472c-86b8-b064271b060d',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '50c7b85a-35e1-4ecc-9661-3a79e4285793',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '40251808-e149-4732-ac25-3697706968a7',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'b1b2927c-2262-4d6f-8995-9e1175d89ae6',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f5ad1089-87be-4e1a-b1d5-c94fc95e84c5',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '5b1ae492-6007-4674-bf1c-7b277b709783',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '31911e18-abb5-46df-9c52-589dfe9cfe1f',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c8a7a66e-e509-45f7-a64e-bb72b7cea15c',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'db4f6ec2-e894-41e2-80bf-aa0ab717ad18',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '91cc2c9e-a372-4a7c-b46e-0635ef59e85d',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9f28cb4e-a2e6-448e-a127-f1e63e2ff6cb',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'd06f3b56-0472-47a0-8659-7490f8cef5e6',
        '2dbe0393-5d54-4af9-b512-dd52d201eab7',
        'room_pm_406',
        4,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ea25d548-6700-4266-8090-b826f1cc0ce9',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '32aa2e2f-4b91-4f89-b303-ab4b60861408',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '456fede0-e709-4a9f-8f0e-d0f890327d05',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd4be3322-6727-4e0d-8688-fd47dd391c2f',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ce51f35e-6194-4026-8d10-e1670abe2dfb',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '976928c1-19a1-4479-8dec-372e47ab4cc4',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '2781717b-052f-472b-bd99-49c3c21467e4',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'd523f45d-0452-431c-91a2-70b331bdbdb0',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '7385e52c-bec2-4dc9-9b48-028ce7dc53cf',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '37801d47-9446-455d-9d86-c8d66d206785',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c86f0c7a-482d-4f40-8482-4aebc5ab9b7d',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '774df3fb-7af8-4e60-8a57-c0679ec8e246',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '09dd9023-58f2-490c-8852-6703808c16bf',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2e25f7d8-2547-4da6-8fab-1cd4966ff3f3',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '507095c0-6767-48db-bc7e-8a6f17138cf8',
        '8784c63b-31ee-4b72-ba3f-89b619f24ee1',
        'room_1a_draw2',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b2390a29-730f-49a3-86fc-08b7d56abdf9',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'd5fe4ac3-1116-4889-bb5f-71fd0860146d',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'd3d9f26a-c047-4caf-93ea-8a0b7b8053ab',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '98f745ef-b7a4-4b83-bbd5-84d09a18b979',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '9f158342-b040-4325-b4e4-32a8076ca0e5',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'ffede203-bd9d-4763-9783-c58ace0f62ff',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'ffcd0b20-7993-4b33-aa38-2e4043d6696d',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4bc7a4fe-c37e-4af0-90a5-7f91d6d53735',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '4d914acf-8abc-4edc-b481-faa443ce33bf',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '53eb3e1d-40b8-47d1-afaf-df7217c21df3',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5da12f3f-352a-48ad-a179-34ad2abd7880',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'fe4da750-4530-492e-afb8-611e9e753d5e',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '62e40e64-ff7f-44bf-a5a4-8125cafa30af',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f4224785-8bd8-45f2-aae2-4adf38adac2c',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '4b6cc3f7-acaa-4ed4-986c-7723c2b375d3',
        '3f25321a-ea0f-4be7-95d9-f7bba5b1f577',
        'room_a17_402',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'e73291cd-1487-4adf-855d-1e8a6f9166b9',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'bcbbc7c3-0009-42bb-82bc-d9fd43c7e2b7',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '43a8eb21-11bb-472f-bcdd-0d88600e224a',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '225c93ea-92b5-446e-8642-12a5dd516c38',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3581db6b-331e-4c14-a944-f6dc512130ee',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '2119d2fb-dd3f-4088-8fd2-88821697ad9d',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '80cfc4c2-c7ff-459c-9546-f0250bf1fdbd',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e4a4b19a-0c0e-4ab0-ad4a-1f7fd9c3eedb',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '2050101f-b5b7-41ea-bf32-fec166b93309',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '75fe0c84-a598-4475-99e6-e9f057b3823b',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '5090ea2e-07a3-44f3-be80-ef37384866db',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f709041a-c780-4180-8540-169750bd5855',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '666a7fe7-2ca7-4a8a-9031-715b478fa52e',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '0feaf714-1213-4898-b843-9704e67259b2',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c5ba96b2-536d-4ae5-836c-213221b65f88',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '93e94f33-b8a1-43b3-af53-e13fd8c84339',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '2a27055f-aff1-4802-90c1-d879e9642b90',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '14af637c-853d-4d99-acf2-0dd1e72d0d4b',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'f2d5a87a-b744-410f-b1ef-5ac99243fb29',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '1771744a-5625-4b67-9669-fc2ae8ca32ee',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'f0dfe5e8-ef7f-40a5-9e65-a18dab8f6964',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '181bbaa4-1dfc-401b-a253-07900a7436d7',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '8b79408b-b25d-4359-a9bd-ed6116eec16f',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'fb587ded-1d51-4851-bf94-a454625c14a4',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '4269f337-3988-4ac2-8f20-bd50e1670e68',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '94de0fd6-9126-4374-8912-dd574bd41b3b',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e3d9a199-300d-439c-a575-7df6a418e0ea',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '13aa9043-b2ad-4a35-86ec-768dd452dac1',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6d077a4e-6db4-4419-a0bd-c47f18db53fe',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_408',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '161252c5-350e-4d3f-b99d-adf9fdaf693e',
        'dc9f15a7-418e-45ce-84dd-2c39b9713977',
        'room_pm_406',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'd7e3a771-39e8-4f73-b766-c183ada74f18',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b82b9826-e973-4c30-9563-77d97b95960e',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '20caae63-4b62-43ed-9854-1d38914b20a4',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '22327258-097d-4ce9-aaf4-ab55df647a78',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b08309c0-58a6-40e0-9835-d1ba1bfa88ef',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '03d0da34-6f83-4104-948e-f5ed882ca714',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '10cbdc82-c974-47e4-a616-6c7d456575d1',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '843416c7-1f0e-4669-bcfe-252fa78a5990',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'fa15df5c-c2a4-4d8b-9c15-b6b487131e0f',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '39920823-7a65-48b9-a77f-b2c22a34021e',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'a79ca6bb-76fe-41e1-b141-d3ffa62a1bdc',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '413f1cd1-3c09-40fe-81f4-5bdc30443afd',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'ef689765-5764-4680-b0b4-b82471c51e0b',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '74606b77-2a32-4441-a24f-9aba79bd35fd',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '648abcb0-14b7-4196-b98a-f13d6f093e0b',
        '452e2994-1aaa-4ef3-9093-e22cb5ab5572',
        'room_a17_404',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b4cea6c9-7646-4a90-8b9c-024edf5782fb',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5990928a-7708-4448-9628-05249279fffe',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '557f52ee-4b93-4362-a9f2-ffe26f482bb3',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '3569e50d-6b67-4ab3-b8e6-665158802ce6',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '5b392fc3-598b-4b3e-acc1-370147bf7b50',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bd9a4cfb-4fd1-4e74-a24c-81c1f04c49d7',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd35a116e-64c7-4638-8d5d-0a30612e0332',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '5909c1fe-7126-4db3-95c3-74f27699c2f3',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'f1185d10-7de1-4a21-af9f-35b58bc743a2',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8328abe6-f60a-4215-8df6-dff3b8c49ece',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5a892ff9-9b1c-4072-9f64-5a83045cc410',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b381aeb8-ab82-452b-baee-c18132bfb25e',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '566215d7-0110-42c9-afc2-a5b0f13ecad9',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'cc39dbd8-f623-4db8-83f2-ac9649a62cbe',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '47738205-3ef2-4785-966e-43d615c5a77a',
        '2d2faf02-6b7e-417c-b80a-a2bf6eed2c1d',
        'room_a17_405',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '78a94c86-c9fc-49d4-abc6-16f9b5a0a948',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'dc1c9751-37b3-4d1d-aa94-3c79e716887e',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'ab8bb3f2-c1ef-4e77-982d-b1ba6dc5b725',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '917bc79c-3979-4b66-ae1f-c804098e9d58',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '34def456-637c-4652-9a4e-4c82601521f0',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '066a77a3-5d80-4b1e-9441-8b275371e278',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '039cea85-7a72-4e0d-b1f1-dfcb9f3ada5c',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a27165e2-26c5-467e-9aaf-bb40d670a9dc',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '7f6bbc8e-0274-4a05-aebe-81e32acbc683',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '555613d1-9777-4d19-917b-08c37b3dca23',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '0625fc70-fad4-4c58-92a2-c06afa564672',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '5639c3f6-4371-42f6-b332-e0d598fa6464',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '783ac0ff-8755-44f4-bbd9-5d490f5c2e23',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'a9802edf-7ada-4b2c-9478-28bdc13d2e87',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'cd10209f-c300-43fd-882a-ea5b340c4210',
        '3b59be5f-d3fc-4c80-af21-21b2ffd8dc72',
        'room_1a_draw2',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '7f2a54a3-6dfa-439a-9901-de3b1c2a6fea',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3e0c9d94-4522-4c60-80a7-c909eef3702c',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '15d25de6-ee0c-4e5e-aa78-9bcebcfbcf40',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '10860231-15ef-4425-94c9-a5363ae2989f',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'fd8f4fae-129a-4a1e-9634-64177065bf53',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'd42dd6dc-7f9f-4f71-b468-68465132d376',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '081cca82-9ed8-41cd-831e-0364a55f61f9',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '15b4e827-1138-444c-88aa-10a939b1f05b',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '717ad6a8-2121-4d53-8b35-a05a3f24d4f2',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'ed53a380-4042-46af-af5e-64a17bad4718',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9a34bbfa-c543-45aa-bc05-ef650cbef20c',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '1d34b8ee-ef73-44a0-804f-e3679979e38e',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'cf862ba1-7f7f-460e-ba42-23c253de4d1a',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '261d0706-c3ac-49ff-8e69-020fc418cbf8',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '5bd35e93-284b-49d0-85d8-4cdba0895515',
        '9c825d27-bd57-4601-bd22-5be81e492d3f',
        'room_pm_305',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2e1fbf7b-67a1-4192-b968-90c284047cfb',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'bca2b195-9da1-4a5e-b5f9-b52942f03ed6',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '57119866-7b3d-469b-9c09-cbd8f9fc3886',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '65b96ba8-69e1-4b52-9cd5-399d202acf71',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '144e522b-698e-4a9e-83b2-f7cb282db855',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '45412115-4d2f-4b14-99d9-1095c9cd75c1',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '3e79f3ff-3881-48c8-9db9-395514b50f3a',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '532fa49a-db77-477b-9b2a-4924ced5a4fc',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '2ee867d9-b189-4862-9028-ad08f03893a2',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bdbefc4c-916e-44f8-abb0-1f63235ff3ec',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c20aa30d-e741-4547-b2c8-c0e116c0bbd4',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'af145fcb-2a3b-476d-9c06-9eff37d95f9b',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '89792135-bdc8-4742-a601-e1ff7cf7e834',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '18f9d2e7-0cf9-4666-b206-341175616020',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'fdaa1ce7-d04d-4d68-bc3a-d59b6b7fbce6',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '0050478b-51fe-4499-9cf5-62fa8422b3d0',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '1017230f-ce19-4976-89a5-6371797157bc',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '63af52f9-aba4-49ff-9fb7-b2f925a8c957',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '99783812-377c-4cc2-88e0-4c3084f26793',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '46f29452-483a-4493-a119-c275b1866ddc',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '6c6a72d8-9c02-4ff4-b3c8-5e9d375723e8',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '5c5404a4-b266-49c0-b33f-d64ed39e1211',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'bda06107-65b8-4362-b522-f2cd4dfb2c08',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'de796555-eddd-4750-a4cf-114ed3a5c486',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '1db33ceb-e821-461d-9067-095e4dcaae02',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '68d90c51-8e3e-4910-834a-ffaace2ccaa8',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '78e9c877-fb41-4ad5-aac3-ddb55f4b22b0',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '154f836d-8578-41e5-ba92-9caccff11f1f',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '0aec577b-01b6-4e3c-9b70-2a69e6642518',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_401',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'aada1645-00f1-4dd4-90df-49ef6e715557',
        '01aaa9ab-3dcc-4b55-ae0e-c3dd0987f377',
        'room_a17_403',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1ef8838c-a8a9-4242-be0c-20c765b509c0',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e7cc686a-197a-41a4-b501-1a23a3fa7a10',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'f8b663d3-60d4-4f57-a95b-3578427cc42f',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '875b9d20-2583-4237-b944-48383767c539',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b03283f2-0c41-44c4-aa52-50a09466a13a',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '1ccf8ff0-a9c6-4865-b876-98642bc8fde2',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'b0576e63-bbde-455e-a50f-4c2f268db78f',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'e1d50c06-df31-49c0-a255-ff13782309f1',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'eb564181-bfb1-404b-9169-713b20261d92',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '625a6049-3c89-4480-8dc5-3234fe77a24f',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '3311cf8d-bc21-4f87-818c-6674c1832f8d',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'edbaa262-7bb2-43cb-9dec-531546832d46',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '3638368f-a890-4730-99ff-89d4e6de3eae',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'be5f8f1e-2f52-48f6-b4a8-b57d5a40bca6',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'c9de92e0-4df8-471c-8e72-9e10566b2ebb',
        'e48b7680-c45d-4f85-840a-f50a800d4baa',
        'room_pm_408',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '077d3563-556e-4689-81a4-d55ab948d519',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '514adf53-5c0a-4505-90c3-32ad1bb275e4',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'bb50854c-7e79-4f21-9447-877210097d3f',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'ee8baf9c-e5a2-4377-a96a-18f0547b47c7',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '83010b1d-c55a-4da6-b13e-1dbf5ed77f23',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '52d082e4-e3d6-488f-be3f-fbae162d567a',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f9a1a9ad-052b-4b02-af60-9c34f55daa88',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4970214a-8fbc-46c8-bb30-6486933f3621',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '29cf4410-386e-4519-ae9f-a44ae514a0d9',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'da5f474b-11c9-4759-9aad-da7e6e4fe580',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '0a16f9bb-5121-41b2-975e-48dc8453f021',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '2f1083b9-0f45-453c-800a-7f3bc673df58',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '92e6bfc5-991a-496c-bfb1-b0f51457cc0d',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e49f7823-43b2-4a49-8887-a7ae948a82e8',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e568b6ba-84ff-4596-b0d5-718952b28b4e',
        '4c9afdaf-afd8-4e85-983a-63c85d5913e1',
        'room_a17_401',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '35640b9a-31cd-4190-80e1-87aff24b4fd6',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'a96a3542-f88b-410e-b097-9cd426700289',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '67e296fc-3e82-4394-a364-8241352c2043',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '1f89786d-ffdb-46d6-b8a4-b7cba1d57dae',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'df978feb-61b3-43d9-9050-114efcf0c660',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bd1ad759-2b4b-4863-aef9-f3005db8b4eb',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '1795a89d-e780-4262-9267-06ef6ec4accd',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '9ffeaeea-4c13-4cb1-828b-8b5214b4c4c2',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c5b9d7b8-288c-41da-beb1-b6c83c01e563',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd7094b9f-a33a-46fc-b88a-10d9c76aac4d',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5d8e59c6-e291-4c33-a913-7cdd3c222988',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'feae6adc-43b2-4e80-85e9-b42111893383',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '742fdd7d-88ff-4b98-b80b-1fbfcc8cce42',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '31507b36-512d-4132-81ef-be0b807b6e7d',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '68b8ec58-c5b0-44cf-b2d1-ffc6d30e4175',
        '8ed75ca9-2834-4d97-8852-15735b4d372f',
        'room_a17_501b',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'add99297-a451-4513-927e-4e84a1e0c52c',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'a001973a-163a-4174-90ec-b87b698fbcf7',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '142f5282-6085-4a7f-b893-64ded2e45567',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b034b106-f6d0-48ab-8439-287cc1c75ba1',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '30f37bd3-ba4d-4a08-aa14-019873f6834f',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c0bc6099-33ae-42c8-b451-2bb58169154c',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'c2fe4dc2-5a4a-4171-b6bd-86cf64a4673c',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f3badc80-528f-4144-8e25-b65891b9d516',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'b0581697-fb09-4c68-806c-b86b4ba57b10',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8bdcce53-d447-4bb0-97dd-cbfe5002de06',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'b6ea8efd-915a-4aed-8128-03929fb6d0fb',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e920957c-d6b6-4dc0-8b6b-c78f292ceb2d',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'ce2d00d4-0fcb-4098-b826-3ec7ee671d4d',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '32691a3e-9593-4718-9f14-093eb8fd65d3',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e533bd70-effe-4170-97a6-0f66253f344e',
        '52ac4626-f46a-489c-9181-1a9c1a0c3d64',
        'room_a17_404',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '8547ee3b-4fb5-41f4-9fe3-187f4e2dea90',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c6a50300-431e-448e-81d8-7ce8113e9083',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1dd4067d-9e99-4f26-b747-0a68ab996a73',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '5eacfe3d-0c02-4f3c-a45e-f6fa872218b3',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '2ee9ddb9-cdd9-4b45-8e3f-0ab196be37bb',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '791ad25c-7569-4bb1-bb73-8597e130c857',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '6db4f7ed-b281-4330-a120-e153f02f5b3c',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b4b8b76b-9700-49a0-9ce8-b81e09b57707',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'bb770d35-dc0f-4b3a-b15c-b3d4a6ef0d55',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '39b13b58-66fe-41ae-adf9-5b812e4f40ed',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'de0c0fb4-2558-43bb-aaaa-a09674e137a9',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '74cb3203-13f5-4716-a15c-ba6e6f1faaea',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '89882233-926a-4d24-8503-510bd49a2931',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'ade7dec1-60cb-4ee1-a06e-ec6e231f06e2',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '5b5e0034-142e-4046-80a9-d7f3b2b55535',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '4e9cdb8f-9679-4644-b614-27e30eafdd24',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a2f65cb9-fb3b-432d-8bad-0a51a9ac575f',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '420ed1fe-b15b-4671-ab4e-d3da170c6a81',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '7f97306a-0828-4d63-bb1a-69e45ab17c88',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'a9ef1b6d-3165-402d-9362-be1c0e3313e6',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '154347f9-bb30-4762-bd4c-37a4b2e1814e',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b2e9a013-6015-44d1-89d7-1cc6b2b1c45d',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '87c2a24b-aca7-4ed7-b24a-b274e9319a67',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '66f90322-11bd-4bc3-a7f0-2a819f7493c0',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '6b77cdca-aefd-4a46-9832-25ab941f5f34',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '46bb41d8-a178-4ee1-8cbd-21ad705dbda5',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '2e142cf2-2359-431c-9734-4e08ddc83a7a',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '5c272e38-0488-490a-9e16-0c73a9164cc4',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '1c51748d-8e2e-4c06-81b0-c65232a7cee0',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_pm_406',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a0c7f2b0-131c-4291-a4eb-8f438e8c0a29',
        '92ec52ee-7810-46c4-b9ad-739f09924a38',
        'room_a17_403',
        4,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '818ab092-d951-4810-9707-b07fdc2542df',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '08bf7bb8-f9c8-4ebc-ab4a-b63eeebf1450',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'af86dc6e-10e3-4168-919e-4244e42bc19f',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '2c6543fc-6884-4bc0-8091-9eeb47275d7f',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e2ea0c20-b960-4761-85f3-53cfad03be36',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'f4ad8c9a-06a7-444f-8073-1ba6ac2e0701',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8977844a-928a-476a-90b1-6bb6861f69ff',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '87c28afe-d8df-4509-bb74-2ba0f87a7091',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'b7e2567f-8645-4b40-bc1e-fc6f58719ff3',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '25a78279-9656-463a-b070-4baea6a92e07',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '8113ba51-ad3e-4149-bb22-3d84ae375d4e',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '145c8317-982b-45a1-93ff-b47264e33c77',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '438b58d8-a488-4e3b-a8fd-2174f310a4c5',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '57e0c129-29ee-40a9-9302-7b8474f26a7b',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '33691188-6e4e-4ecc-a0bb-9e44304a0c1a',
        '328f519c-9de7-46dd-8ff9-1763259d6949',
        'room_pm_406',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ac12d211-4706-4fad-8a67-e4b2e509c149',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ab0bdc6f-c580-45a2-9f5c-0daf2c35daec',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3ecc7b41-74fe-4129-8d36-0b518046ff78',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'c697ce46-eaf1-4c3b-91b6-c1016760e6f4',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '0cf478fd-50c8-42ef-acad-8a63d57a6143',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '308c026b-c984-4473-b9c5-d7d2aacf429f',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd5877472-555c-40b2-ba6a-af62251ad4aa',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '21de0938-b4cd-4fd6-b70b-cc55baf19e20',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'cc213bb9-c8eb-47f2-aa21-dda9a747c2fe',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '5598aea9-598b-42c6-873a-2304febef755',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '7e55edbc-79cb-4998-8f48-3d505b7e1954',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '15e28203-49ac-470e-97dd-f80113ce0a47',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '8435947a-7099-4ca9-98d9-deb180331456',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'bcf8670f-9081-49c6-a05c-6a796da5f538',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '729e44a2-6d15-4d9b-8ecb-5e9d3a17b76e',
        '34592d73-5653-4d16-989f-425bd6951e6b',
        'room_a17_402',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    );

INSERT INTO schedules (
        id,
        "teachingUnitId",
        "roomId",
        "dayOfWeek",
        "periodStart",
        "periodEnd",
        "academicYear",
        "weekOfYear",
        MODE
    )
VALUES (
        '0cf8bd39-afaa-4700-a373-d85e881e292e',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3cbabd9e-e447-462c-be70-0457ae18c588',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '102cd10d-fef1-47d0-bfc5-6839de5df534',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'a308304b-2ef8-4969-94fa-c876a615b887',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '526d2835-b231-42c7-9232-c4be0ab97938',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'a9a6cccf-e861-4306-91f7-4ae7acfb05c7',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd3b653ec-52fa-46fa-a66f-708785f43b43',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6cc90806-05d7-4983-83a2-de367a5abdf7',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '5cca6f8a-321c-43ee-bbb1-e6489214a010',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'bf0ef0af-509c-451c-80bb-145997862dec',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '0fb493f9-a28c-41ae-9504-90f973ac7c6a',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '264e9465-350a-463b-9236-ae5103f51ddf',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a12f3758-da69-4ab9-b12b-77a8cf26818b',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'eafaf11f-18d6-435b-8af9-105fd497b8e6',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '782a1692-7211-47af-8156-8c561fdd5758',
        '1b0d9b5a-d203-44a7-9f8b-dae03e233282',
        'room_1a_102',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b0bb358a-c72d-4772-b91f-7b9bebad4385',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c0b6081f-c2d2-4d52-890b-4687902fd75a',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '1600d450-7ce8-4e31-88c1-3a2bb674361a',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'dc773baa-ae90-4274-b9b1-2ebafe2435c3',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'ee737560-990c-42e9-a998-9de16ef4b831',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '75a85e3f-4465-46f4-8703-d47e12e406e0',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '0e4206d7-5158-4044-95d8-70956417b05c',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '8aa4e4cb-e555-478c-852b-bb68c8a8575f',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '04d77506-bf7c-4211-b868-3c8b3e5b1ec2',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'c3b59d20-0810-4445-9d01-0912ff0d8d1c',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '77b7f53d-042f-45e5-a23c-cfdb53041305',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a1b827ff-d305-425b-bf21-a9eaa5970344',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '19c365c5-6398-4714-8659-b40c7f5d04e5',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'c1378da0-2c87-4057-a42e-1f5abd99554b',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'bb959dd6-9432-4ea2-ac8c-798965168cdd',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '3e74f719-bcd0-43fd-a263-6d4f1a2a4624',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '8f6e4076-17c0-41b5-8565-203b13aa3429',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '061617a7-021c-4226-a606-566f1fee9f95',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'd9f0e7f0-787a-46b8-b051-1ec71aa7944b',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'b8f3dbf9-8814-4b84-87a2-7db67f2d0b4c',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '14a13fb5-09c7-43ac-bf73-42a98bb02e26',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9376d7fb-2b9c-467c-8f68-b92505d0051c',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '9010bdef-dfa3-40c6-85ac-a837facd128d',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a23a6a02-ba1b-43f2-8550-75958ec0d05e',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '52052b4d-1a99-49f4-a525-b3603987ae36',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'dad47ad7-b2c7-4501-b4b8-87b248e686f6',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '549f3436-8205-4d05-a465-00999dbcf02d',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '87fb4bbd-e063-45f6-831e-1b491a9ed0a1',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e260a6eb-f4df-491a-961e-5c9d967820e1',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f46d9a0d-32de-4d9b-a589-c9ee52a541ca',
        'b43d00a2-8858-42b7-8a69-138f876fe819',
        'room_a17_404',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'd4f7e802-a29a-4c46-bec9-3649011ca378',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '10e17638-8918-4921-9947-1675473140be',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '24a4ec9f-af2e-446e-98fd-328e94134a04',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'd584feb4-12f4-4a84-9fc7-af1c4c8d4827',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '32671811-66f4-4715-a07b-6657c7fb2d23',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '0dfb8568-90e5-4784-830d-00556bf45fe5',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4dfecd73-30dc-49c1-9835-b93dbfcc5fdf',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'a227d360-e515-48de-a191-c6f06ef6b5f5',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd79dca9c-7b76-494c-9f77-4d3ea53f48c7',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '7a72de95-0bcc-40b9-9e9e-0a59bd669612',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd73fe4df-2231-4749-b316-94fe7fcc580c',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '7d99485d-9b08-4058-b0cf-f678635e1273',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '50fe476a-c939-446d-9858-e5d3ec488a47',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4edfd40e-1e6a-4d23-96bc-91c5a36f8cbc',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '2e9e638f-692f-4946-89fd-5c176971d0d6',
        '4bc37fa4-1563-4002-ae31-cada0a0a4da8',
        'room_pm_304',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5e9b0325-42fd-472f-94ed-2a0a802bdefc',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '5b79cb55-e256-4a90-a682-455d449236f0',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '5ffc115c-ebed-4699-a115-8354f5bfcfb2',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '08d9fa74-819c-433a-a073-6f22e97bec5a',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'd92af376-7043-45be-8e56-5aaa79ab4c07',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'fb87d4ad-636c-46ab-9b44-55c28477362e',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '2c96cd71-6f29-43d7-8e5e-c35551e535cf',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6656f98b-4278-4d9b-8875-0a69cd5cb731',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd6f8a2bf-6370-4978-b114-3544c1cf7a09',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'bac319bc-5a04-41aa-89f2-f1e43cbcadbb',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '409e6a60-f7ae-4e1d-8257-fdf46179cb91',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'ab402435-4c06-4b23-a287-d8af59300efd',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '9b7e3926-844c-4b21-8efb-e099f7c055de',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '98c03e05-8966-4860-ab47-468a4c5dff49',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '49daa946-063a-4689-8c81-44e785998626',
        '1061ca6c-1143-4af9-a13e-f511347796ab',
        'room_a17_502',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ef738e8b-4dfd-4213-b585-c90e17379d2e',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'f3d795e6-d38b-4c94-adec-f82b6388dbaa',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c1cf6dd1-04da-43ba-a3c6-c51da20fb13f',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '583923e5-e437-47a5-a875-da3e0263e77d',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '92a95b92-fc68-4567-8aa9-66be46f3de30',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '226ab8bc-ba12-46ad-b7fa-085c4c3814dd',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '5023051f-cdc1-4016-b5ab-27b7d1aff84d',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '3624e5b8-7829-40c1-a571-087cd6256300',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '5c8c5e76-4fb5-4675-a2b5-863ec73b302f',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '8f7c44d7-7758-4781-acda-af80eee7e2ad',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '00579535-49d9-4342-9014-f7979bc2f0bb',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '3c49be8b-eb15-4b89-9d30-265c4aa7704e',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '135f7682-45a6-464f-a80c-390b53865acb',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8b2d55d3-ae94-44ea-82d0-861cabafe109',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '3fbe46c3-3502-47dd-bd20-b3eb31addbf6',
        '442c1f0b-8e1e-4f0e-a436-cec5b0b3de59',
        'room_pm_406',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a135a497-0818-4b97-9507-da4740617283',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '53fd0881-99d1-4bd2-bcfd-6921f61fa3ec',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3ed693db-ec84-4366-b0b7-54fd4fa89f24',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f9f60649-bba7-4049-addc-e7048cbc2b69',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '985985e8-1fbe-4594-8ec0-b9d0dedc4501',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '57fa9a26-cbec-43ed-8d8d-305d2695a782',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'f18dd86a-e69c-4c93-bc13-b04f8c2a1eb2',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'db4f99dd-6227-41e7-b351-4d1ed37d1b3f',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'f9376675-10ab-4aa5-ac7a-11d0c3c44209',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '64604228-ed69-46e2-bf61-bb36655fae66',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '9a51cd18-1838-441a-9096-84bd6dee25d0',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'b4daecfd-d97f-468b-8396-3a77a782f33b',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '7376610f-8a46-43ff-9798-36cf4c2fbd95',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '6008e356-823e-425f-996a-86867ac4c443',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'eb8b5661-838a-4b64-b95c-8789165a9070',
        'd15e398c-2c45-41b9-aaa3-e56db466c2fe',
        'room_a17_502',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'bf0dbdc4-1216-466a-971b-2692d55a12ba',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '344ba112-4fc2-468e-8cb3-d46fbb215011',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c54fbc08-5eb1-4d21-85f0-4b784da0e632',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '58d3fbca-d112-4025-8f43-a40e2e6f6bdb',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '0ffd18b6-c572-49a7-aabe-818078913f06',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '81db69b6-7a43-41f3-9b3c-6ba929d7890d',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '3c785723-7368-4e44-b2ce-63af89e7ebe3',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'df24186b-0999-401d-9a5e-7d2666c936d0',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '381d1d87-0bf9-47e5-b95a-edfb127f0757',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '3c27a608-6127-46e7-8492-9ac9fa68dc15',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '29a636f6-21a9-4b25-9ebc-b41648f1b3ea',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'eab28a7e-82de-4c25-99c7-e860605062b6',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '503209dc-6670-4fdd-8bb1-1dbabeed1bb6',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '5888faeb-dee6-4cf4-a3a7-62c596c975d8',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f0f08903-11fe-4ca3-8320-e3d2c4480509',
        '2970dd08-eb89-48e8-9084-3efdb949d1cc',
        'room_a17_501b',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1ecc20b6-a6ee-4060-b6e4-2af773219df7',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ebd9585e-39cd-4e97-b708-da2a846eba08',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '7bf06fb0-17da-4201-96b1-4a3118ed183e',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '2dc6fd90-5b27-455d-ae74-bf042346e484',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '2261e67d-606d-4d4d-bbbf-3c9002caaf31',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '9eb42aa1-1749-43e9-b8e0-e4c541835fdf',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '418b38ba-4e74-47c3-8826-cb3e23a146b6',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'be1e4006-1a6a-49fd-845d-ad946fda6a99',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '69a1b89d-0bdf-4e1b-b920-cead1d78ef5b',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '9c283fbd-1418-43b2-9b14-b0bddfa3d692',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '7ddb001d-05b1-4964-b23c-3b01c1a6994e',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e9e498d2-efed-47e9-9029-98958fe74b3a',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '961f379b-3e55-4042-bd92-1d61b4035302',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8fa561eb-d3bd-4aa9-b56d-eeeedeb10cb9',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '31c7f4ae-902d-4195-8f94-741764ca3628',
        '808b4991-8621-4dee-a255-558a8962e760',
        'room_a17_502',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '1dc5066a-a9fa-41a3-bd80-ccfa6b223b38',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'e6a71e2c-76e4-45d2-aefc-e7d49137d62c',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '95b112ec-f911-44ff-86f7-26fca45284bf',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '18fca781-0005-4e73-bb8e-f4ee23c8ea16',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'e99a8701-82e4-4ec9-995b-ecacb3f1017d',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'faa1d768-21a0-4b2f-ab4d-0fdf9de459f6',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'a72cba87-e5c6-41d1-a4e4-ccae423e9e4f',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '0c1ddfe3-d779-4a15-b9a6-acdb460eaa78',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ed5942cb-9e16-4ba2-8d6a-82afb0099dbe',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '9925df7e-bafa-4e35-8330-f4d7add417c6',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5f1b4c52-b831-46f7-a3e2-c6d62825448c',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '8ea4440d-5b72-4319-9984-025e64252c80',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '018f6481-5129-4d61-a7c4-d29b5fcd997a',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '9d30d9ee-f9f0-464c-b4f4-f04700c09737',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '303c6128-562d-4398-96e1-fc41d4040a25',
        '09287916-4b3d-4694-bb1c-11f6dad2e215',
        'room_1a_draw2',
        2,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c9773acb-fe9b-4c5f-b2b8-107bf370d686',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3d913e37-08b5-4916-8895-de73bcdb0f4e',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c6782e80-4bf0-4b1f-8b2c-d9449d11d0e8',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '0a5570ae-15d8-4465-b234-8d2396deaa29',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '1c11b60f-e9c2-41db-9279-a0fc2d604383',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'b80c4136-1439-40b1-a652-d94d1bb9cccc',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd0dee36e-4b81-4177-869b-9395d08c3e12',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '8a7c4980-5a49-41df-92b0-da10bdfa9ecb',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '05e6d2c4-8c07-4826-a8e3-5d1b51155317',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '6a4b4aee-7bfe-46e9-85e1-c7c4fbf2a4d5',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5801807f-78a5-4892-bd1e-984d801f969e',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'ed3fbc70-59d1-43aa-a112-47a82dc05f2e',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '19200f1b-2b27-4f4e-ad33-c067bc458ec3',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '14079f4a-0fc6-4583-ab6c-092b34dba935',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'adc81b3a-a4e3-4334-a3c0-8e27a58ea6d9',
        'b2b2bbd1-ec71-4f69-a565-00ce754e43c6',
        'room_1a_101',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'c29bcc83-1b2b-4222-83d3-831e9e183e35',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '595fa501-3291-4377-bc0b-cfa09ee18106',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '695e5950-0e3d-44dc-9894-8b12b330611d',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '852c5eb4-b2d6-4b0b-92a7-34518513e44c',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '4e69afe1-1e67-4ff0-8c6e-4e3a14e8b568',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'aa36d8cd-10b4-409b-816e-65d69516f3bd',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '255058fc-ddcc-4485-9af8-43f820851e94',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '324ff374-d121-4c06-9a6a-1a036f14d83e',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '74724419-4ccb-4cce-b8a7-509a6b9bedf0',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '224b937f-f6df-4957-b4aa-3cb27e28d8e2',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'b952898c-2c08-41cd-aa1c-f01e4015b16d',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '44760b0c-9416-4d8a-9525-368503f2f5de',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '75507c10-08f7-4ade-9ecf-e3e46757bddf',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4661f157-7504-4158-a0db-3b20b43fe326',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'a2c011a7-b1ab-45a4-a620-5b5071ed8915',
        '0f23221f-1370-46ea-9245-b2ae4c3ab5f3',
        'room_1a_draw2',
        5,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '3b361e25-a9be-4730-806c-40917983d523',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'f9f66a6b-db01-4a6a-80d3-376bfd52cfa2',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '7c2589a5-8b5e-45db-b9f4-596f50a093fd',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'f664aa57-b481-4184-8987-5202b338a330',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '5312c758-e969-48fc-bd87-30b6c39b008e',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '1a944c48-b451-49fc-9e5d-3ab6f3002ba1',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'd1574bbe-1f04-4aa7-ad66-304ce86858c7',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '6d808697-026b-41f2-b840-9b8aff968bb1',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '0328e3aa-a334-46ec-995b-6242988eec42',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'de417934-f5f3-410e-b49b-5b547a65f11d',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '66bc9f1c-68c1-44a8-a9c0-b8cdcf89549d',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd8a581c8-286e-446c-ad08-943a908501be',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'f843efb5-9a1c-4d2e-8af3-c563e3cd3921',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '39a8df66-d4b0-4889-965e-cc636363b7dc',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '640fca09-6fc5-471f-be45-6fb9649936e1',
        '3887e67e-7ebc-4424-b79c-6f9ba8faa667',
        'room_a17_503',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '88db0276-b0ee-4358-8e51-c2a2650922fd',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '22467bd2-aca7-4e08-bdd4-da147e1ec779',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'fcc40373-9d57-4c48-8bea-07ab5d069cee',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '8b9dbe06-b2a2-452f-8c1f-4cac9068b2e6',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'a5cf521f-fd88-4758-8f4d-ece467d50d9f',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '65095d1d-6990-47f2-ad17-da2e98fefca7',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '0d7be61c-2861-48b2-b1e9-1ddda75d98f1',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '10d98059-9efc-4db2-8a1e-4ce45d843e23',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c9df1725-f63b-4299-a71e-1a4c05d49d7d',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'b20684f4-81d5-4ae2-b3f4-6666b092b794',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '139e13ad-5553-494e-b68d-2678ce023e5d',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'ecc04838-cd23-45e9-a121-ecdc786260e4',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'fb224b5c-3417-4a52-84ce-e3f392a535c1',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '4de26c75-f56c-458e-8d6f-8e43a687a95b',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '9a471db4-aba5-473c-9aed-364af5ce352d',
        '31ef2ba3-9fa9-49a3-8125-c9f86edbb410',
        'room_a17_501a',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2a8d7a3b-5089-4c85-b8b2-ed7bbf7cb706',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '23e5e62f-b02f-4691-b9e3-2f99195b2d92',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '77ec37f2-2d30-4883-8d61-2ed1a841ec09',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '79d07eae-2f8b-48e5-8bae-b36eee6a81f3',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '3b173714-cf2c-44d2-9d3e-be69bbe4ebf0',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '83ad6b7e-f03b-4fed-9d7f-40f38a7f5884',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '6f519ebf-70a1-4057-bbda-bf467fe77b8b',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4d64bd3f-1a9f-4321-8926-696d35c8e315',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '57e1b42a-d86a-4197-990f-0f8bf8eca9eb',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '7bc85988-46ef-4446-9509-eb71164e4247',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c0829fc0-78b2-4514-9157-7a6752029241',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '999cd5ab-6189-4456-b876-202b880bd799',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '52e21d3f-bfe3-43c1-b803-8d55b6f19637',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '3cfc2e93-d0e2-463e-9f73-8297d6eaebf3',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '5398880e-1ac5-491d-84c5-4ad4d49df7a7',
        'bab825cf-2af7-4797-a8c4-cf6f651cc8d7',
        'room_1a_101',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '3c5f1d85-5d2d-42a2-a5d1-fd0d86815205',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ea3dd40a-e299-4990-bb38-1b63c72ed9e4',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '729b8229-2c32-4838-a844-32fcb2c1ee38',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b0d65def-804b-422c-8f36-b30183624149',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '60e28875-90b7-4d2f-928d-7b7ebba7f2f7',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '5199df81-6723-41e2-918b-96af1c8c5764',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '363f720a-6669-4786-924a-b9123a264bb0',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '27f8d229-2aea-40df-825a-bf608a813f1b',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '6a704f40-bc78-4a63-bf39-eea5dcfe16b0',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'c22b8a59-60fd-4571-9667-456e0c944a16',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'f9742c22-e408-4b77-8dcb-ba5fbb7b8629',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'bd3b26b6-15d3-4d80-86ec-f1d288370601',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '426f1023-ddf6-4b6a-b532-68343334cbe4',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e6fbca0e-6b3e-431c-be73-43f2f4328ff5',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '349338a1-ae89-4007-874e-375b34833921',
        '41be25ee-1ad9-486f-aaeb-f8a303b3c60b',
        'room_1a_draw1',
        6,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '7baa2cd9-aee5-447d-b190-07f391ce0568',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'cf06cd74-4e9f-4adc-a2d7-964aeb51a8db',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '94ba4e7a-4818-41d2-ad14-bc878dca58fb',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '6136c615-a74b-4140-b5fa-912b6a4b1784',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '8ccbeb44-a836-4325-b027-87796c1c3b1d',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '1eb09173-57f2-4037-9d37-dde7107c4ef8',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '04ae46f4-70c1-421e-a082-50dd6b7f77ab',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'b9de9e1e-e1ce-44ec-80ea-41be215a54e2',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'd658d78b-cb8a-4a5d-ae26-ba6cc05c7f12',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '49805f8a-24f6-45ed-ba4b-48ae90f46f63',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e2652799-2bb7-45de-9792-dd81a3ee5eb8',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'fd7d6f4f-b088-4652-802b-1df4924cc99b',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '447bb067-de61-41b9-bb0d-a75be4cdedc0',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f66967cd-094c-418b-8ccc-6d634baf08fd',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '8316feed-a991-4b6a-a48f-aba6a2f9fd31',
        'e8872cc5-5613-4ea9-b241-d0cde647aad8',
        'room_1a_102',
        7,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f411f153-086c-402e-a243-4e7346999f35',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3f23b7cc-77c9-462b-9025-c8dda712924e',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'b5b9751c-9562-45cd-b344-ec4e6bd7ac7e',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '46237afb-6e87-4b9c-ad63-70721731b7f1',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '5cfd8e8d-0a92-4472-9d8f-5eb4f0394adc',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'eef06c62-4995-49a2-bd25-20b57c73c54f',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'de9b0ddc-6350-4342-9357-c813b8aab0ce',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '447c23a5-b6c5-4c03-9f53-b13cf0da25aa',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a2ef6ec7-7f02-474b-bd80-4b96bb9ca281',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'de31461d-c90b-4f8d-835c-6c99dad8bf68',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '5f009d1a-4137-4f17-9fb3-4f9ccef2c905',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '4b59d2c0-11d3-4b1d-bc36-e66fa77028d9',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'eb1d66d1-17cd-40aa-90f1-5745c42a563d',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '74b921f4-e182-4713-8029-e09c2c63d453',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f75b6408-e3a5-4c9a-9840-322bb9fefe00',
        '35a87cf5-fc37-4c91-8500-628b6cc3f6dd',
        'room_1a_draw1',
        3,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'b32e8377-cd3f-47ac-a99c-24b47ba07502',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'feb8f40f-9ec4-49a3-9d9a-12b8be9c2b60',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '3daf78c8-1e8e-493a-ac94-65686610e511',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '061e070a-f912-4bb7-8e58-e1698e9fb073',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'cbaf9155-834b-4d0b-8ba2-f08d00e72793',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '36528e3c-df6c-4ee5-aca1-bd11abb2a647',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4f411ed8-81e7-406f-82bf-aae2e739745e',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'ebd53970-e63e-4841-ac62-e29073035227',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '67690775-c501-48fc-a0a2-66ad2259430e',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '4b121cf1-4429-4294-a860-a003e2270441',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '15b2ab9c-eedb-45c7-8699-c209a1595ccc',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'bcc555e9-cb94-4a55-affb-b200c5d0a490',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a5f5cd63-9413-4b2a-8ee8-a3da853ac7e2',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'd02309bb-7eb8-4594-85b6-1388af6e49ca',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'e46557e8-427a-4411-b431-74cf75e3d532',
        '25c9102e-131b-4478-b4ae-924e884fe5f8',
        'room_1a_101',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'dc3f6aa6-70a4-4202-9066-0fbc4f13e4f2',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '3bf7a67d-d1ef-4600-8d50-734c9069ef0e',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '24c26976-29f2-4507-91ce-ab30eac14ef7',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '70562d41-e310-4980-813f-0822b600a50d',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '2c4302d7-4d1e-4351-8236-620a1f7ede06',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'b45c3d6e-183d-4764-a911-4efa29341a5d',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8b27e9d5-4579-48c1-8f55-3d175b6567e1',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '4d795c46-8166-4ec4-8c32-50cb3c3f0f80',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'a8b0bb2f-67d2-4743-a25a-ea074269735e',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '66b4a111-a5e2-4049-8a74-9bbc52e44799',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'd07a94a1-5078-44f9-a6d7-48491da4ddb7',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '1b851755-e083-4dcb-a2f7-9201a4f976ac',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '7c32a5be-ebed-4e22-b6f6-baa18a4cdb25',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'dbe5357c-1f2a-4b97-9a2b-07ae6c75a7fb',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '9fe89db3-bbd3-4c2c-bf53-9b5d887a50a6',
        '9a88ee4a-440e-40d5-9461-e063d45fbe9c',
        'room_1a_102',
        4,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'ceb8dada-c779-4aa8-a7f6-f658ca14dfa2',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '9fc7f846-96a6-4abb-83f3-ebf1bac05561',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '935044a5-3bb3-41dc-aa2c-63ccf22b5f06',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'fe3c7215-dc2f-4dfc-8006-bde81baf2266',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '12a3a0a4-84b2-48c0-8cd1-d0b1ec2de7de',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '666e77d6-73d2-4298-b632-ce347e1f1aaf',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '2b0afc51-d829-4765-9774-d7cea5506768',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'eebb7ae0-4ed1-4949-b1de-2212df7da1ee',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '5b0f65ef-af58-4a84-82b4-506bf10016f4',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '05ae57be-aa9b-4c12-9fcc-ee1c2a6c6e16',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '33b803c0-0f7c-4b37-ba1b-420445c1c34c',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'd21734ea-0a18-4362-8a42-9f94fb3edde2',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '51f5f8c5-fc8b-4b70-8c26-0082f8616266',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '0ef94620-da9d-48c7-87e0-c5a6d2af8b76',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f0fb71af-4f61-4f61-bdee-0a5a1597b3e4',
        '1599d09e-25da-457e-9902-ce8015079da4',
        'room_a17_501a',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '2b9e40d6-260c-46d2-8a87-2f091a60b3ab',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'c80a977d-e32b-409a-ad1e-8a17b01d2395',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'e711decf-adfe-416b-b997-847297cedf4f',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'a3cf217c-b2da-4d60-936a-35aedf798c88',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '6dd38b6c-16c2-47d2-8fa9-02b9880ce4d3',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        'bf9cae9e-69de-4b49-843b-0add3f501768',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '80d2da0c-6804-40c2-a67b-d28715adaf2d',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'af656bd9-7fd6-438d-b872-2247b2a54893',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '500385e3-5710-4ce0-8ae8-2e67eaf5e92e',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '383c94ab-d411-42e0-998c-7f07526aab48',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '116c3e89-c9e1-4380-a986-5db0dfe3fce7',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '2eaafebe-1535-41ae-afc7-d20de23b5d03',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e1d152a6-78d6-46b2-9a58-c4f1e63b33ba',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'e4e0b464-2a01-4254-9dc1-12dfedffb993',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'b958b959-649a-40ac-a43a-040ddc0193cd',
        '29217bae-82a7-4035-86f0-185dcd1a2c4f',
        'room_a17_503',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'f5980f4a-a09b-48fe-a982-de7fb4b17b1a',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ca2bfa8f-5ba5-4f7e-b2f2-0aa4f75c91a6',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '918192e8-684f-4a10-83d8-6d1f48333760',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'e66cb3d6-399d-4531-a74f-ea51e1130996',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'c3dc0b76-fd9e-454f-8f1f-359eca549873',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '85fe538e-3ab0-410b-8757-10fe527cee84',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '345ce0bb-70ca-4612-b80d-473aefd362b9',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '98bc4ece-f528-4baa-b204-a7741668d7cf',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '38fe9d72-e2ce-4ec6-af86-a4b4d3f43249',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '649ff393-43f2-4466-9d2d-b166b140b3c8',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'c2cb299d-ce97-43f4-8842-4aae3f92c077',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '8f4d4af2-6ee7-4a24-a1a7-774daa69ec35',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '496df888-cca3-4747-a606-3f189397c1bf',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'a18c5306-83d1-45f0-9e61-96329fda81cb',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'f54f9df7-501d-4d79-93bb-ea48ac2222ba',
        '6cf2409e-c7ed-440e-9b53-2f8bcb0f374e',
        'room_a17_503',
        3,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '77da7171-b53f-45f1-8ddc-d32fb074f1b1',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'ad46fd24-376a-40c8-9b9f-118cb7f1986e',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'fe869e45-7234-4bd8-9d3a-55b262d1acd2',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b7543140-470a-4a9d-b767-1dc55a0157e7',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'b9aa9020-7016-45e6-900d-fdc16357032f',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '941de334-1613-4cdc-aa12-4ebbd05b74e5',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '4fc43ed9-726d-4d41-8818-6f9090bda30e',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f9fb0289-ffa6-48fc-ab48-abe74da006ae',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'afa6262a-79fc-4757-9f1a-92b1fda14f77',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '0f17f79f-f6ba-49ca-a778-03fb683cee8e',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '09067e94-1a8d-4ae0-a3cc-a7200d424ddf',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e02fd973-96da-42df-a0b7-c1470f267b5f',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '6531e375-d6f5-4ed1-a381-98e4c50e3eb1',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'faca3319-0631-4f72-a2d3-14fc4fe0bb90',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '9462baa8-567f-4430-991a-11b0e16793d6',
        'ed538f9a-75ba-4ef0-b5c6-2a38866095b1',
        'room_a17_504',
        2,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '6fd01a58-3616-4874-83fe-d8e42bcbcb1d',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '62a41641-216a-45ae-9181-a647c216f834',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'f59f56d4-07c1-4c6c-9da5-4aced5a60068',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'b59a5281-e547-424b-9fcc-68ff42329801',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'ac8b86ca-6a76-4114-9085-1454fbff078f',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '7e6dc66d-4267-4586-bde6-db1b34dd407a',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        'c37b63d7-868a-4e8d-be6d-b0784d50625b',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'ce470ce5-30ae-42c6-a068-ee03a87de738',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'ed274fa5-3c27-4d37-b47e-fa1880cfd26c',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'a946b13d-521b-48fa-b12b-dda2aa392b99',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '911e327b-acec-422f-85df-dc339848541c',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e3a97757-45e9-4c98-bbc0-19bc5bf2b1fa',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '1283642a-33d1-4c34-b8d4-fe1e29e8e01c',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'ca9b6e4e-a7e9-4d6a-8e43-5a2c1d7e9c9b',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '6d69e829-8c6c-449a-9ab2-758993871c55',
        '6e3d3766-798e-406d-a2d0-0c8f4e2fc2e2',
        'room_a17_502',
        4,
        1,
        3,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'a72d950e-e806-4c88-a8ea-ef3cadc3bb66',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '951868a3-63c4-48af-b3cb-65b855c5ba85',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '43f51de1-d7bf-47a9-9307-ebeedf5198a9',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'c78a260c-7a37-47bd-82ee-02f15713a3cd',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        'df4a4c76-31f9-4c4f-b04c-3e9884c65725',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '89d0d3f6-8da6-4973-80af-676cce993143',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '511bcc79-8a57-4a80-8a09-9a9c3b776dc2',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '5b53ac2b-dd2c-4c98-8c00-c4c4b518d10d',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '387c085d-6f24-46b5-a88b-dcc4a693bb18',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '4bf8d14c-7cdd-458e-a7de-5a00b8182154',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'aca90465-4527-4599-a503-82ed2081c28e',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '0ab997cf-9ff0-477f-afa9-c4f212ceef31',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'c064652c-e4e4-4824-96a2-4ecd94a6568c',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '8d1b6d5e-0832-46f0-895c-e7ca18056509',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'fbe7b41c-c387-4638-8477-c31d2c8e5003',
        'e94798ca-4c0f-4e31-8d24-7bbf9dd5a61a',
        'room_a17_501b',
        5,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '346fe3d6-8b8c-46d5-a333-686f69a0043e',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '14d441a8-4aa1-4ca5-b210-532fd689224e',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c2acb69e-b985-4340-a5de-59d87afcf04e',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        'fce27027-9210-4d02-b51b-bbd9fe05c12b',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '50bafb6f-593d-4df5-a71b-116dfc461751',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '3717dce6-877e-4771-a0bc-431c0d40ddd7',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '04345c1c-1e5e-474f-be21-395db402716d',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '20101d02-a10b-4a6d-a875-ba87f5255644',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '647010f9-1ef1-48f5-849a-f80e5729cd98',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        '2d0bfacb-90b1-4fff-98a6-bc136f33a1ee',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        'e0ce23d6-cf88-41f2-b777-332170f7f451',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        '68f70f51-1e46-4114-8ec7-e426014845ba',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        '7ad1f619-f7c6-4e6a-ae91-5cd9c3e46f6e',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        'f02a5f42-927d-491b-86e9-a0e748147083',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        'ca248b3d-4f5b-4817-987c-4f23922a028a',
        'a3a8c94a-dd72-437c-af3e-9d9ebff81578',
        'room_a17_503',
        6,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        '5f986b84-30f5-426d-a5ea-d06910a71f5b',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        'b1376a6c-c402-49b2-96b7-08519c68faaa',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        '653b08f7-2512-4906-a604-12fcfdb760de',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '1ff33f72-a120-4d91-8831-d8fc2027de4b',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '37affc83-bc9a-436c-b50c-3d7db01f4403',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '80339145-9be5-43e1-91fe-d61b6c7cca49',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '8b246cef-913f-401c-a2d9-fdbbf1ff406f',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        '24f6132e-9825-48e5-88ba-e30f2ce78bdb',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        'c4e391e3-70d0-4249-ad77-942b5a3872b1',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'dfcba6ff-a5cb-43a0-86b6-d2c7c8565379',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '0d2611fc-151b-4fe1-9a44-42f598434839',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'e95df42d-eb56-4c65-bd8e-446b9d4442b1',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'e10ac823-91a5-4ac0-a09e-1a1f1655f3ac',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '752b2ad9-c8de-4e12-9592-4df6a127457f',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '15329190-d92e-4abe-b874-8c0d9a0e9057',
        '2f048b5c-1c5a-40b0-982b-97252ea96871',
        'room_a17_502',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    ),
    (
        'd222bd32-3275-494e-adeb-4717911ccd24',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        1,
        'OFFLINE'
    ),
    (
        '30a268a4-45a6-4f37-bce6-4c633dd39634',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        2,
        'OFFLINE'
    ),
    (
        'c946b8d6-a9d7-4587-bef5-e6f4c4dfef8c',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        3,
        'OFFLINE'
    ),
    (
        '304e096d-548b-4b07-a40a-049f0d66acd2',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        4,
        'OFFLINE'
    ),
    (
        '3ceceb39-6a69-4d01-8271-3c16fbe827ee',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        5,
        'OFFLINE'
    ),
    (
        '08205a16-526e-467f-bd0a-c30461909efb',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        6,
        'OFFLINE'
    ),
    (
        '76b232cb-b945-4f88-afb2-31cb79a16dea',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        7,
        'OFFLINE'
    ),
    (
        'f320774c-0edc-46cf-a1a9-617c683c665b',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        8,
        'OFFLINE'
    ),
    (
        '61aa016c-9ceb-4bb2-9158-db1d022a3444',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        9,
        'OFFLINE'
    ),
    (
        'fb69570d-7526-4dbb-a2d4-e1803945e8fc',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        10,
        'OFFLINE'
    ),
    (
        '4492ad53-703e-4b0e-b20d-7c1f48804162',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        11,
        'OFFLINE'
    ),
    (
        'df6ed599-166a-4adc-84f9-b1c0a5b9a235',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        12,
        'OFFLINE'
    ),
    (
        'a290b176-005b-41c9-b7a2-2fc221e8b670',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        13,
        'OFFLINE'
    ),
    (
        '82658d57-765f-48b2-a29a-d2fcfd22b726',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        14,
        'OFFLINE'
    ),
    (
        '1caae252-c50b-4176-8f90-8e1196e375a9',
        '99f8226d-0662-4336-a9d4-8ce201fc71a1',
        'room_1a_draw2',
        7,
        6,
        8,
        '2024-2025',
        15,
        'OFFLINE'
    );

-- ============================================================================
-- Insert: mỗi sinh viên được gán ngẫu nhiên 1 lớp đúng ngành + đúng khóa
-- ============================================================================
INSERT INTO students (id, "userId", "classGroupId", "studentCode")
SELECT gen_random_uuid() AS id,
    u.id AS "userId",
    (
        -- Lấy ngẫu nhiên 1 lớp thuộc đúng cohort + đúng ngành
        SELECT cg.id
        FROM class_groups cg
            JOIN cohorts co ON co.id = cg."cohortId"
            JOIN majors ma ON ma.id = cg."majorId"
        WHERE co.year = (2000 + year_num)
            AND ma.code = major_code
        ORDER BY random()
        LIMIT 1
    ) AS "classGroupId",
    -- studentCode = phần số trong email, giữ nguyên chữ hoa: CD230101
    upper(
        regexp_replace(
            split_part(u.email, '@', 1),
            '^[a-zA-Z]+',
            ''
        )
    ) AS "studentCode"
FROM (
        SELECT u.*,
            -- Tách 2 số năm: CD23xxxx → 23
            substring(
                regexp_replace(split_part(u.email, '@', 1), '^[a-zA-Z]+', ''),
                1,
                2
            )::int AS year_num,
            -- Tách mã ngành: CDxx01xx → 01
            CASE
                substring(
                    regexp_replace(split_part(u.email, '@', 1), '^[a-zA-Z]+', ''),
                    3,
                    2
                )
                WHEN '01' THEN 'LTMT'
                WHEN '02' THEN 'QTM'
                WHEN '03' THEN 'UDPM'
                WHEN '04' THEN 'TKĐH'
                ELSE NULL
            END AS major_code
        FROM users u
        WHERE u.role = 'STUDENT'
    ) u
WHERE major_code IS NOT NULL -- Bỏ qua nếu không tìm được lớp phù hợp
    AND EXISTS (
        SELECT 1
        FROM class_groups cg
            JOIN cohorts co ON co.id = cg."cohortId"
            JOIN majors ma ON ma.id = cg."majorId"
        WHERE co.year = (2000 + year_num)
            AND ma.code = major_code
    ) ON CONFLICT ("userId") DO NOTHING;

-- ============================================================================
-- Cập nhật refId trong bảng users
-- ============================================================================
UPDATE users
SET "refId" = s.id
FROM students s
WHERE users.id = s."userId"
    AND users.role = 'STUDENT';

-- ============================================================================
-- Cập nhật studentCount trong class_groups
-- ============================================================================
UPDATE class_groups cg
SET "studentCount" = (
        SELECT COUNT(*)
        FROM students s
        WHERE s."classGroupId" = cg.id
    );

-- ============================================================================
-- Kiểm tra kết quả
-- ============================================================================
SELECT cg.code,
    co.code AS cohort,
    ma.code AS major,
    cg."studentCount",
    COUNT(s.id) AS actual_count
FROM class_groups cg
    JOIN cohorts co ON co.id = cg."cohortId"
    JOIN majors ma ON ma.id = cg."majorId"
    LEFT JOIN students s ON s."classGroupId" = cg.id
GROUP BY cg.id,
    cg.code,
    co.code,
    ma.code,
    cg."studentCount"
ORDER BY co.code,
    ma.code,
    cg.code;

-- Tổng số sinh viên đã insert
SELECT COUNT(*) AS total_students
FROM students;

-- ============================================================================
-- Re-enable FK checks
-- ============================================================================
SET session_replication_role = 'origin';

-- ============================================================================
-- Verification queries (optional — comment out in production)
-- ============================================================================
-- SELECT 'users'         AS tbl, COUNT(*) AS cnt FROM users
-- UNION ALL SELECT 'teachers',      COUNT(*) FROM teachers
-- UNION ALL SELECT 'class_groups',  COUNT(*) FROM class_groups
-- UNION ALL SELECT 'subjects',      COUNT(*) FROM subjects
-- UNION ALL SELECT 'curricula',     COUNT(*) FROM curricula
-- UNION ALL SELECT 'assignments',   COUNT(*) FROM assignments
-- UNION ALL SELECT 'teaching_units',COUNT(*) FROM teaching_units
-- UNION ALL SELECT 'schedules',     COUNT(*) FROM schedules
-- UNION ALL SELECT 'students',      COUNT(*) FROM students;
UPDATE schedules
SET "academicYear" = (
        split_part("academicYear", '-', 1)::int + (("weekOfYear" - 1) / 40)
    )::text || '-' || (
        split_part("academicYear", '-', 1)::int + (("weekOfYear" - 1) / 40) + 1
    )::text,
    "weekOfYear" = (("weekOfYear" - 1) % 40) + 1
WHERE "weekOfYear" > 40;

SELECT "academicYear",
    "weekOfYear",
    COUNT(*)
FROM schedules
GROUP BY 1,
    2
ORDER BY 1,
    2;