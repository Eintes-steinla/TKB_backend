/**
 * reset_teachers_and_rebuild.js
 *
 * 1. Xóa toàn bộ: schedules, teachingUnits, assignments, users[TEACHER], teachers
 * 2. Tạo 50 giảng viên mới với UUID chuẩn (CNTT×30, TKĐH×12, DC×4, TA×4)
 * 3. Tạo user accounts cho 50 GV (email@hactech.edu.vn, mật khẩu Teacher@123)
 * 4. Rebuild assignments + teachingUnits + schedules
 * 5. Flush Redis cache
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const Redis = require('ioredis');

const prisma = new PrismaClient();

// ─── Helpers ────────────────────────────────────────────────────────────────
function rng(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[rng(0, arr.length - 1)]; }
function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = rng(0, i);
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
function removeDiacritics(str) {
  const map = {
    'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ằ':'a','ắ':'a','ẳ':'a','ẵ':'a','ặ':'a',
    'â':'a','ầ':'a','ấ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d',
    'è':'e','é':'e','ẻ':'e','ẽ':'e','ẹ':'e','ê':'e','ề':'e','ế':'e','ể':'e','ễ':'e','ệ':'e',
    'ì':'i','í':'i','ỉ':'i','ĩ':'i','ị':'i',
    'ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ồ':'o','ố':'o','ổ':'o','ỗ':'o','ộ':'o',
    'ơ':'o','ờ':'o','ớ':'o','ở':'o','ỡ':'o','ợ':'o',
    'ù':'u','ú':'u','ủ':'u','ũ':'u','ụ':'u','ư':'u','ừ':'u','ứ':'u','ử':'u','ữ':'u','ự':'u',
    'ỳ':'y','ý':'y','ỷ':'y','ỹ':'y','ỵ':'y',
  };
  return str.split('').map(c => map[c.toLowerCase()] || c.toLowerCase()).join('');
}
function nameToLocal(fullName) {
  const parts = fullName.trim().split(/\s+/);
  return removeDiacritics(parts[parts.length - 1]);
}

// ─── 50 giảng viên cố định ───────────────────────────────────────────────────
// CNTT: 30 | TKĐH: 12 | DC: 4 | TA: 4
const TEACHERS_DATA = [
  // ── CNTT (30) ──
  { name: 'Nguyễn Văn Cường',     code: 'GV001', dept: 'CNTT' },
  { name: 'Trần Thị Bích',        code: 'GV002', dept: 'CNTT' },
  { name: 'Phạm Thị Hân',         code: 'GV003', dept: 'CNTT' },
  { name: 'Lê Thị Mười Phương',   code: 'GV004', dept: 'CNTT' },
  { name: 'Nguyễn Văn Trung',     code: 'GV005', dept: 'CNTT' },
  { name: 'Hoàng Công Tùng',      code: 'GV006', dept: 'CNTT' },
  { name: 'Nguyễn Anh Tùng',      code: 'GV007', dept: 'CNTT' },
  { name: 'Vũ Thị Hoa',           code: 'GV008', dept: 'CNTT' },
  { name: 'Đặng Văn Uy',          code: 'GV009', dept: 'CNTT' },
  { name: 'Bùi Quốc Toàn',        code: 'GV010', dept: 'CNTT' },
  { name: 'Trương Văn Lợi',       code: 'GV011', dept: 'CNTT' },
  { name: 'Lý Quốc Tuấn',         code: 'GV012', dept: 'CNTT' },
  { name: 'Hồ Minh Tùng',         code: 'GV013', dept: 'CNTT' },
  { name: 'Phan Thị Vân',         code: 'GV014', dept: 'CNTT' },
  { name: 'Ngô Thị Linh',         code: 'GV015', dept: 'CNTT' },
  { name: 'Đinh Thanh Tùng',      code: 'GV016', dept: 'CNTT' },
  { name: 'Đỗ Minh Quốc',         code: 'GV017', dept: 'CNTT' },
  { name: 'Nguyễn Thị Phương',    code: 'GV018', dept: 'CNTT' },
  { name: 'Trần Văn Đức',         code: 'GV019', dept: 'CNTT' },
  { name: 'Lê Hoài Nam',          code: 'GV020', dept: 'CNTT' },
  { name: 'Phạm Thị Linh',        code: 'GV021', dept: 'CNTT' },
  { name: 'Vũ Minh Khoa',         code: 'GV022', dept: 'CNTT' },
  { name: 'Hoàng Anh Tuấn',       code: 'GV023', dept: 'CNTT' },
  { name: 'Đặng Quốc Hưng',       code: 'GV024', dept: 'CNTT' },
  { name: 'Ngô Văn Sơn',          code: 'GV025', dept: 'CNTT' },
  { name: 'Lý Thanh Bảo',         code: 'GV026', dept: 'CNTT' },
  { name: 'Trần Thị Mai',         code: 'GV027', dept: 'CNTT' },
  { name: 'Bùi Công Tùng',        code: 'GV028', dept: 'CNTT' },
  { name: 'Đinh Thị Hương',       code: 'GV029', dept: 'CNTT' },
  { name: 'Nguyễn Trọng Đạt',     code: 'GV030', dept: 'CNTT' },
  // ── TKĐH (12) ──
  { name: 'Hoàng Thị Lan',        code: 'GV031', dept: 'TKĐH' },
  { name: 'Phạm Thu Thảo',        code: 'GV032', dept: 'TKĐH' },
  { name: 'Vũ Đức Cường',         code: 'GV033', dept: 'TKĐH' },
  { name: 'Lê Thị Hiền',          code: 'GV034', dept: 'TKĐH' },
  { name: 'Nguyễn Thị Oanh',      code: 'GV035', dept: 'TKĐH' },
  { name: 'Trần Minh Thành',      code: 'GV036', dept: 'TKĐH' },
  { name: 'Nguyễn Thị Ánh',       code: 'GV037', dept: 'TKĐH' },
  { name: 'Hoàng Thị Nhung',      code: 'GV038', dept: 'TKĐH' },
  { name: 'Vũ Thị Trang',         code: 'GV039', dept: 'TKĐH' },
  { name: 'Đặng Minh Quang',      code: 'GV040', dept: 'TKĐH' },
  { name: 'Trần Văn Thành',       code: 'GV041', dept: 'TKĐH' },
  { name: 'Bùi Đức Lợi',          code: 'GV042', dept: 'TKĐH' },
  // ── DC — Đại cương (4) ──
  { name: 'Lê Văn Tâm',           code: 'GV043', dept: 'DC' },
  { name: 'Nguyễn Thị Xuân',      code: 'GV044', dept: 'DC' },
  { name: 'Trần Đức Hải',         code: 'GV045', dept: 'DC' },
  { name: 'Phạm Ngọc Dung',       code: 'GV046', dept: 'DC' },
  // ── TA — Tiếng Anh (4) ──
  { name: 'Trần Thị Huyền',       code: 'GV047', dept: 'TA' },
  { name: 'Lê Ninh Hà',           code: 'GV048', dept: 'TA' },
  { name: 'Phạm Quỳnh Anh',       code: 'GV049', dept: 'TA' },
  { name: 'Ngô Thị Bảo Châu',     code: 'GV050', dept: 'TA' },
];

// ─── Môn học (copy từ cleanup_and_rebuild.js) ────────────────────────────────
const SUBJECTS = [
  { id:'sub_ct',    code:'LMH01', name:'Chính trị',                     credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_pl',    code:'LMH02', name:'Pháp luật',                     credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_toan',  code:'LMH03', name:'Toán cao cấp',                  credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_knm',   code:'LMH04', name:'Kỹ năng mềm',                   credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ctmt',  code:'LMH05', name:'Cấu trúc máy tính',             credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ctxh',  code:'LMH06', name:'Cơ sở văn hóa Việt Nam',        credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_av1',   code:'LMH07', name:'Anh văn 1',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_av2',   code:'LMH08', name:'Anh văn 2',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_av3',   code:'LMH09', name:'Anh văn 3',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_gdtc',  code:'MH00007', name:'Giáo dục thể chất',           credits:0, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  // CNTT cơ sở
  { id:'sub_lmtcan',code:'IT101', name:'Lập trình căn bản',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_nmmt',  code:'IT102', name:'Nhập môn mạng máy tính',         credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ctmt2', code:'IT103', name:'Cấu trúc máy tính (thực hành)', credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_sql',   code:'IT104', name:'HQT cơ sở dữ liệu SQL Server',   credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dhua',  code:'IT105', name:'Đồ họa ứng dụng',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_xdweb', code:'IT106', name:'Xây dựng Website',               credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  // LTMT
  { id:'sub_laptC',    code:'LT201', name:'Lập trình C/C++',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lphuong',  code:'LT202', name:'Lập trình hướng đối tượng (Java)', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapCsharp',code:'LT203', name:'Lập trình C#',                     credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapPHP',   code:'LT204', name:'Lập trình PHP',                    credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapPython',code:'LT205', name:'Lập trình Python',                 credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_csdl',     code:'LT206', name:'Cơ sở dữ liệu',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_pttkht',   code:'LT207', name:'Phân tích thiết kế hệ thống',     credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_xdpm',     code:'LT208', name:'Xây dựng phần mềm quản lý',       credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_ltdidong', code:'LT209', name:'Lập trình thiết bị di động',       credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lpservice',code:'LT210', name:'Lập trình Web Service',            credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ctdlgt',   code:'LT211', name:'Cấu trúc dữ liệu & giải thuật',   credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_cnpm',     code:'LT212', name:'Công nghệ phần mềm',               credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_qldacntt', code:'LT213', name:'Quản lý dự án CNTT',               credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_antoabm',  code:'LT214', name:'An toàn & bảo mật thông tin',      credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_udai',     code:'LT215', name:'Ứng dụng AI trong lập trình',      credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtwebfw',  code:'LT216', name:'Quản trị website với Framework',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_thuctapcs',code:'LT217', name:'Thực tập cơ sở',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_dotancs',  code:'LT218', name:'Đồ án tốt nghiệp',                 credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  // QTM
  { id:'sub_hdlinux',   code:'QT201', name:'Hệ điều hành Linux',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtmangwin', code:'QT202', name:'Quản trị mạng Windows Server',          credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtmanglin', code:'QT203', name:'Quản trị mạng Linux',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_anninh',    code:'QT204', name:'An ninh mạng',                          credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_lpmangg',   code:'QT205', name:'Lập trình mạng',                        credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_cnkhong',   code:'QT206', name:'Công nghệ mạng không dây',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkxdmang',  code:'QT207', name:'Thiết kế & xây dựng mạng LAN',         credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_baotrimt',  code:'QT208', name:'Bảo trì hệ thống máy tính',            credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_iot',       code:'QT209', name:'Internet vạn vật (IoT)',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_laptnguon', code:'QT210', name:'Lắp đặt thiết bị mạng',               credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dieuhanh',  code:'QT211', name:'Hệ điều hành Windows',                 credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_aotoanbm',  code:'QT212', name:'An toàn bảo mật hệ thống',             credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_qtcloudfw', code:'QT213', name:'Quản trị Cloud & Firewall',             credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_xdwebpmm',  code:'QT214', name:'XD Website bằng phần mềm mã nguồn mở', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  // UDPM
  { id:'sub_ud_csdl',    code:'UD201', name:'Cơ sở dữ liệu nâng cao',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_pttkht',  code:'UD202', name:'Phân tích thiết kế phần mềm',          credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_csharp',  code:'UD203', name:'Lập trình C# ứng dụng',               credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_java',    code:'UD204', name:'Lập trình Java Web',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_php',     code:'UD205', name:'Lập trình PHP nâng cao',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_xdweb',   code:'UD206', name:'Xây dựng Website nâng cao',            credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_mobile',  code:'UD207', name:'Lập trình ứng dụng di động',           credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_qlda',    code:'UD208', name:'Quản lý dự án phần mềm',               credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_test',    code:'UD209', name:'Kiểm thử phần mềm',                    credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_atbm',    code:'UD210', name:'An toàn bảo mật ứng dụng',             credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_ai',      code:'UD211', name:'Trí tuệ nhân tạo ứng dụng',            credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_dotantn', code:'UD212', name:'Đồ án tốt nghiệp',                     credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  // TKĐH
  { id:'sub_hinhhoaco',  code:'TK201', name:'Hình họa cơ bản',                      credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_cstaohinh',  code:'TK202', name:'Cơ sở tạo hình',                      credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tahinh2d',   code:'TK203', name:'Tạo hình 2D',                          credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_coreldraw',  code:'TK204', name:'Corel Draw',                            credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_pshop',      code:'TK205', name:'Photoshop / Xử lý ảnh',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_illustrator',code:'TK206', name:'Illustrator',                           credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dhoahn',     code:'TK207', name:'Đồ họa hình động (Flash/Animate)',     credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dh3d',       code:'TK208', name:'Đồ họa 3D (3ds Max)',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkgdweb',    code:'TK209', name:'Thiết kế giao diện Website (UI/UX)',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkbapbi',    code:'TK210', name:'Thiết kế nhãn mác bao bì sản phẩm',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkqbsp',     code:'TK211', name:'Thiết kế đồ họa quảng bá sản phẩm',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dungvideo',  code:'TK212', name:'Dựng Video (Premiere/After Effects)',  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_tkdantrang', code:'TK213', name:'Thiết kế dàn trang ấn phẩm',           credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkthieuhi',  code:'TK214', name:'Thiết kế nhận diện thương hiệu',       credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ktchanh',    code:'TK215', name:'Kỹ thuật chụp ảnh',                    credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tk_ai',      code:'TK216', name:'Ứng dụng AI trong thiết kế đồ họa',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tk_dotantn', code:'TK217', name:'Đồ án tốt nghiệp',                     credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
];

// ─── Chương trình đào tạo ────────────────────────────────────────────────────
const CTDT = {
  LTMT: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_laptC','sub_ctxh','sub_nmmt','sub_dhua','sub_sql'],
    3: ['sub_lphuong','sub_lapCsharp','sub_csdl','sub_pttkht','sub_xdweb','sub_av3'],
    4: ['sub_lapPHP','sub_lapPython','sub_ltdidong','sub_ctdlgt','sub_cnpm','sub_qtwebfw'],
    5: ['sub_xdpm','sub_lpservice','sub_udai','sub_qldacntt','sub_antoabm','sub_thuctapcs'],
    6: ['sub_dotancs'],
  },
  QTM: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_nmmt','sub_sql','sub_dieuhanh','sub_baotrimt'],
    3: ['sub_hdlinux','sub_qtmangwin','sub_lapCsharp','sub_pttkht','sub_av3','sub_xdweb'],
    4: ['sub_qtmanglin','sub_anninh','sub_lpmangg','sub_cnkhong','sub_tkxdmang','sub_laptnguon'],
    5: ['sub_iot','sub_qtcloudfw','sub_aotoanbm','sub_xdwebpmm','sub_qldacntt','sub_antoabm'],
    6: ['sub_dotancs'],
  },
  UDPM: {
    1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_nmmt','sub_sql','sub_dhua','sub_xdweb'],
    3: ['sub_ud_csdl','sub_ud_csharp','sub_ud_pttkht','sub_lapPHP','sub_av3','sub_ctdlgt'],
    4: ['sub_ud_java','sub_ud_php','sub_ud_xdweb','sub_ud_mobile','sub_cnpm','sub_ud_qlda'],
    5: ['sub_ud_test','sub_ud_atbm','sub_ud_ai','sub_xdpm','sub_qldacntt','sub_qtwebfw'],
    6: ['sub_ud_dotantn'],
  },
  'TKĐH': {
    1: ['sub_ct','sub_pl','sub_av1','sub_hinhhoaco','sub_cstaohinh','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_tahinh2d','sub_coreldraw','sub_pshop'],
    3: ['sub_illustrator','sub_dhoahn','sub_dh3d','sub_tkgdweb','sub_av3','sub_toan'],
    4: ['sub_tkbapbi','sub_tkqbsp','sub_dungvideo','sub_ktchanh','sub_cnpm','sub_dhua'],
    5: ['sub_tkdantrang','sub_tkthieuhi','sub_tk_ai','sub_qldacntt','sub_xdweb','sub_antoabm'],
    6: ['sub_tk_dotantn'],
  },
};

// ─── Lớp học ─────────────────────────────────────────────────────────────────
const CLASS_DEFS = {
  major_ltmt: {
    K15: [
      { id:'cls_ltmt1', code:'LTMT1-K15', cnt:38 }, { id:'cls_ltmt2', code:'LTMT2-K15', cnt:38 },
      { id:'cls_ltmt3', code:'LTMT3-K15', cnt:36 }, { id:'cls_ltmt4', code:'LTMT4-K15', cnt:36 },
      { id:'cls_ltmt5', code:'LTMT5-K15', cnt:35 }, { id:'cls_ltmt6', code:'LTMT6-K15', cnt:35 },
    ],
    K16: [
      { id:'cls_ltmt1_k16', code:'LTMT1-K16', cnt:42 }, { id:'cls_ltmt2_k16', code:'LTMT2-K16', cnt:40 },
      { id:'cls_ltmt3_k16', code:'LTMT3-K16', cnt:40 }, { id:'cls_ltmt4_k16', code:'LTMT4-K16', cnt:38 },
    ],
    K17: [
      { id:'cls_ltmt1_k17', code:'LTMT1-K17', cnt:45 }, { id:'cls_ltmt2_k17', code:'LTMT2-K17', cnt:43 },
      { id:'cls_ltmt3_k17', code:'LTMT3-K17', cnt:42 }, { id:'cls_ltmt4_k17', code:'LTMT4-K17', cnt:40 },
      { id:'cls_ltmt5_k17', code:'LTMT5-K17', cnt:38 },
    ],
  },
  major_qtm: {
    K15: [
      { id:'cls_qtm1', code:'QTM1-K15', cnt:40 }, { id:'cls_qtm2', code:'QTM2-K15', cnt:38 },
    ],
    K16: [
      { id:'cls_qtm1_k16', code:'QTM1-K16', cnt:42 }, { id:'cls_qtm2_k16', code:'QTM2-K16', cnt:40 },
    ],
    K17: [
      { id:'cls_qtm1_k17', code:'QTM1-K17', cnt:45 }, { id:'cls_qtm2_k17', code:'QTM2-K17', cnt:43 },
      { id:'cls_qtm3_k17', code:'QTM3-K17', cnt:40 },
    ],
  },
  major_udpm: {
    K15: [
      { id:'cls_udpm1', code:'UDPM1-K15', cnt:38 }, { id:'cls_udpm2', code:'UDPM2-K15', cnt:38 },
    ],
    K16: [
      { id:'cls_udpm1_k16', code:'UDPM1-K16', cnt:40 }, { id:'cls_udpm2_k16', code:'UDPM2-K16', cnt:38 },
    ],
    K17: [
      { id:'cls_udpm1_k17', code:'UDPM1-K17', cnt:43 }, { id:'cls_udpm2_k17', code:'UDPM2-K17', cnt:41 },
      { id:'cls_udpm3_k17', code:'UDPM3-K17', cnt:40 },
    ],
  },
  major_tkdh: {
    K15: [
      { id:'cls_tkdh1', code:'TKĐH1-K15', cnt:36 },    { id:'cls_tkdh2', code:'TKĐH2-K15', cnt:36 },
      { id:'cls_tkdh3', code:'TKĐH3-K15', cnt:35 },    { id:'cls_tkdh4', code:'TKĐH4-K15', cnt:35 },
      { id:'cls_tkdh5', code:'TKĐH5-K15', cnt:34 },    { id:'cls_tkdh6', code:'TKĐH6-K15', cnt:34 },
      { id:'cls_tkdh7', code:'TKĐH7-K15', cnt:33 },    { id:'cls_tkdh_clc', code:'TKĐH CLC-K15', cnt:30 },
    ],
    K16: [
      { id:'cls_tkdh1_k16', code:'TKĐH1-K16', cnt:45 }, { id:'cls_tkdh2_k16', code:'TKĐH2-K16', cnt:45 },
      { id:'cls_tkdh3_k16', code:'TKĐH3-K16', cnt:42 }, { id:'cls_tkdh4_k16', code:'TKĐH4-K16', cnt:42 },
      { id:'cls_tkdh5_k16', code:'TKĐH5-K16', cnt:40 }, { id:'cls_tkdh6_k16', code:'TKĐH6-K16', cnt:40 },
    ],
    K17: [
      { id:'cls_tkdh1_k17', code:'TKĐH1-K17', cnt:48 }, { id:'cls_tkdh2_k17', code:'TKĐH2-K17', cnt:47 },
      { id:'cls_tkdh3_k17', code:'TKĐH3-K17', cnt:46 }, { id:'cls_tkdh4_k17', code:'TKĐH4-K17', cnt:45 },
      { id:'cls_tkdh5_k17', code:'TKĐH5-K17', cnt:44 }, { id:'cls_tkdh6_k17', code:'TKĐH6-K17', cnt:43 },
      { id:'cls_tkdh7_k17', code:'TKĐH7-K17', cnt:42 },
    ],
  },
};

// Tuần theo học kỳ — liên tục, không khoảng trống, mỗi HK đúng 20 tuần.
// Anchor: K15 nhập học 2023-09-18 = tuần tuyệt đối 1.
// Offset: K15=0, K16=40, K17=80. DB trải tới tuần 200.
//   K15: HK1=1-20,    HK2=21-40,   HK3=41-60,   HK4=61-80,   HK5=81-100,  HK6=101-120
//   K16: HK1=41-60,   HK2=61-80,   HK3=81-100,  HK4=101-120, HK5=121-140, HK6=141-160
//   K17: HK1=81-100,  HK2=101-120, HK3=121-140, HK4=141-160, HK5=161-180, HK6=181-200
const SEM_WEEKS = {
  K15: { 1:[1,20],   2:[21,40],   3:[41,60],   4:[61,80],   5:[81,100],  6:[101,120] },
  K16: { 1:[41,60],  2:[61,80],   3:[81,100],  4:[101,120], 5:[121,140], 6:[141,160] },
  K17: { 1:[81,100], 2:[101,120], 3:[121,140], 4:[141,160], 5:[161,180], 6:[181,200] },
};

// Phòng học
const THEORY_ROOMS   = ['room_a17_401','room_a17_402','room_a17_403','room_a17_404','room_a17_405',
                        'room_a17_406','room_a17_407','room_a17_408','room_a17_409',
                        'room_a17_501a','room_a17_501b','room_a17_502','room_a17_504',
                        'room_c4b_1','room_c4b_2','room_c4b_3','room_c4b_4','room_c4b_5','room_c4b_6'];
const PRACTICE_ROOMS = ['room_pm_301','room_pm_302','room_pm_303','room_pm_304','room_pm_305',
                        'room_pm_306','room_pm_401','room_pm_402','room_pm_403','room_pm_404',
                        'room_pm_405','room_pm_406','room_pm_407','room_pm_408','room_pm_409',
                        'room_b4_301','room_d_303'];

// Slot booking — key: day-periodStart-roomId (unique per room per day)
const usedSlots = new Map();
function bookSlot(week, day, ps, roomId) {
  const k = `${day}-${ps}-${roomId}`;
  if (!usedSlots.has(week)) usedSlots.set(week, new Set());
  usedSlots.get(week).add(k);
}
function slotFree(week, day, ps, roomId) {
  return !usedSlots.has(week) || !usedSlots.get(week).has(`${day}-${ps}-${roomId}`);
}
// All 7 days (2=Mon … 8=Sun), 4 time blocks per day (tiết 1-3, 4-6, 7-9, 10-12)
const ALL_DAYS = [2, 3, 4, 5, 6, 7, 8];
const SLOTS = [[1,3],[4,6],[7,9],[10,12]];
function findSlot(week, roomId, excludeDay) {
  const days = shuffle(ALL_DAYS.filter(d => d !== excludeDay));
  const slots = shuffle(SLOTS);
  for (const day of days) {
    for (const [ps, pe] of slots) {
      if (slotFree(week, day, ps, roomId)) {
        bookSlot(week, day, ps, roomId);
        return { day, ps, pe };
      }
    }
  }
  return null;
}

// ─── MAIN ────────────────────────────────────────────────────────────────────
async function main() {
  // ── Bước 1: Xóa dữ liệu cũ ─────────────────────────────────────────────────
  console.log('Bước 1: Xóa dữ liệu cũ...');
  await prisma.constraintViolationLog.deleteMany();
  const delSched = await prisma.schedule.deleteMany();
  const delTU    = await prisma.teachingUnit.deleteMany();
  const delAsn   = await prisma.assignment.deleteMany();
  const delUsr   = await prisma.user.deleteMany({ where: { role: 'TEACHER' } });
  const delTch   = await prisma.teacher.deleteMany();
  console.log(`  Xóa: ${delSched.count} schedules, ${delTU.count} TUs, ${delAsn.count} assignments, ${delUsr.count} users, ${delTch.count} teachers`);

  // ── Bước 2: Tạo 50 teachers ─────────────────────────────────────────────────
  console.log('\nBước 2: Tạo 50 giảng viên...');
  const usedEmails = new Set();
  for (const t of TEACHERS_DATA) {
    let local = nameToLocal(t.name);
    let email = `${local}@hactech.edu.vn`;
    let n = 1;
    while (usedEmails.has(email)) { email = `${local}${n++}@hactech.edu.vn`; }
    usedEmails.add(email);
    t.email = email;
  }
  // Insert all teachers (Prisma auto-generates UUID)
  for (const t of TEACHERS_DATA) {
    await prisma.teacher.create({ data: { name: t.name, code: t.code, email: t.email, dept: t.dept } });
  }
  // Fetch back with real UUIDs
  const teachers = await prisma.teacher.findMany();
  const teacherByCode = new Map(teachers.map(t => [t.code, t]));
  console.log(`  Tạo ${teachers.length} giảng viên`);

  // ── Bước 3: Tạo user accounts ───────────────────────────────────────────────
  console.log('\nBước 3: Tạo user accounts...');
  const hash = await bcrypt.hash('Teacher@123', 12);
  for (const t of teachers) {
    await prisma.user.create({
      data: { email: t.email, passwordHash: hash, role: 'TEACHER', refId: t.id, name: t.name },
    });
  }
  console.log(`  Tạo ${teachers.length} user accounts`);

  // ── Bước 4: Đồng bộ môn học ─────────────────────────────────────────────────
  console.log('\nBước 4: Đồng bộ môn học...');
  await prisma.curriculum.deleteMany();
  await prisma.subject.deleteMany();
  await prisma.subject.createMany({ data: SUBJECTS, skipDuplicates: true });
  const subjectMap = Object.fromEntries(SUBJECTS.map(s => [s.id, s]));
  console.log(`  ${SUBJECTS.length} môn học`);

  // ── Bước 5: Đồng bộ lớp học ─────────────────────────────────────────────────
  console.log('\nBước 5: Đồng bộ lớp học...');
  const cohortMap = { K15: 'cohort_k15', K16: 'cohort_k16', K17: 'cohort_k17' };
  for (const [majorId, cohorts] of Object.entries(CLASS_DEFS)) {
    for (const [cohortCode, classes] of Object.entries(cohorts)) {
      for (const cls of classes) {
        await prisma.classGroup.upsert({
          where: { id: cls.id },
          update: { code: cls.code, majorId, cohortId: cohortMap[cohortCode], studentCount: cls.cnt },
          create: { id: cls.id, code: cls.code, majorId, cohortId: cohortMap[cohortCode], studentCount: cls.cnt },
        });
      }
    }
  }
  // Xóa lớp thừa
  const keepClassIds = new Set(Object.values(CLASS_DEFS).flatMap(c => Object.values(c).flat().map(x => x.id)));
  const allExisting = await prisma.classGroup.findMany({ select: { id: true } });
  const toDelete = allExisting.filter(c => !keepClassIds.has(c.id)).map(c => c.id);
  if (toDelete.length > 0) {
    await prisma.user.deleteMany({ where: { refId: { in: toDelete } } });
    await prisma.classGroup.deleteMany({ where: { id: { in: toDelete } } });
    console.log(`  Xóa ${toDelete.length} lớp thừa`);
  }
  const allClasses = await prisma.classGroup.findMany({ include: { major: true, cohort: true } });
  console.log(`  ${allClasses.length} lớp học`);

  // ── Bước 6: Rebuild assignments + TU + schedules ─────────────────────────────
  console.log('\nBước 6: Tạo lịch học...');

  // Teacher pools by dept (use real UUIDs from DB)
  const tvCNTT = teachers.filter(t => t.dept === 'CNTT').map(t => t.id);
  const tvTKDH = teachers.filter(t => t.dept === 'TKĐH').map(t => t.id);
  const tvTA   = teachers.filter(t => t.dept === 'TA').map(t => t.id);
  const tvDC   = teachers.filter(t => t.dept === 'DC').map(t => t.id);

  function getTeachersForSubject(subId) {
    if (['sub_av1','sub_av2','sub_av3'].includes(subId)) return tvTA;
    if (['sub_toan','sub_pl','sub_ct','sub_ctxh','sub_knm','sub_gdtc'].includes(subId)) return tvDC.length > 0 ? tvDC : tvCNTT;
    if (subId.startsWith('sub_hinhhoaco') || subId.startsWith('sub_cstaohinh') ||
        subId.startsWith('sub_tahinh2d')  || subId.startsWith('sub_coreldraw')  ||
        subId.startsWith('sub_pshop')     || subId.startsWith('sub_illustrator')||
        subId.startsWith('sub_dhoahn')    || subId.startsWith('sub_dh3d')       ||
        subId.startsWith('sub_tkgdweb')   || subId.startsWith('sub_tkbapbi')    ||
        subId.startsWith('sub_tkqbsp')    || subId.startsWith('sub_dungvideo')  ||
        subId.startsWith('sub_tkdantrang')|| subId.startsWith('sub_tkthieuhi')  ||
        subId.startsWith('sub_ktchanh')   || subId.startsWith('sub_tk_')) return tvTKDH;
    return tvCNTT;
  }

  const MAJOR_CODE_MAP = { major_ltmt:'LTMT', major_qtm:'QTM', major_udpm:'UDPM', major_tkdh:'TKĐH' };
  let totalSched = 0;

  for (const cls of allClasses) {
    const cohortCode = cls.cohort.code;
    const majorCode  = MAJOR_CODE_MAP[cls.majorId];
    const semPlan    = SEM_WEEKS[cohortCode];
    const ctdt       = CTDT[majorCode];
    const shortId    = cls.id.replace('cls_', '');

    for (const [semNoStr, [wStart, wEnd]] of Object.entries(semPlan)) {
      const semNo = parseInt(semNoStr);
      const subIds = ctdt[semNo] || [];
      if (subIds.length === 0) continue;

      const asnRows = [], tuRows = [], schRows = [];

      for (const subId of subIds) {
        const sub = subjectMap[subId];
        if (!sub) continue;

        const pool = getTeachersForSubject(subId);
        const teacherId = pick(pool);
        const asnId = `asn_${subId.replace('sub_','')}_${shortId}_hk${semNo}`;
        const tuId  = `tu_${subId.replace('sub_','')}_${shortId}_hk${semNo}`;

        asnRows.push({ id: asnId, teacherId, classGroupId: cls.id });
        tuRows.push({
          id: tuId,
          subjectId: subId,
          assignmentId: asnId,
          type: sub.isPractice ? 'PRACTICE' : 'THEORY',
          name: `${sub.code}-${cls.code}-HK${semNo}`,
        });

        const rooms = sub.isPractice ? PRACTICE_ROOMS : THEORY_ROOMS;
        for (let w = wStart; w <= wEnd; w++) {
          // Buổi 1
          const roomId1 = pick(rooms);
          const slot1 = findSlot(w, roomId1, null);
          if (slot1) {
            schRows.push({
              id: `sch_${subId.replace('sub_','')}_${shortId}_w${w}_a`,
              teachingUnitId: tuId,
              roomId: roomId1,
              dayOfWeek: slot1.day,
              periodStart: slot1.ps,
              periodEnd: slot1.pe,
              weekNumber: w,
              mode: 'OFFLINE',
            });
          }
          // Buổi 2 — ngày khác buổi 1
          const roomId2 = pick(rooms);
          const slot2 = findSlot(w, roomId2, slot1?.day ?? null);
          if (slot2) {
            schRows.push({
              id: `sch_${subId.replace('sub_','')}_${shortId}_w${w}_b`,
              teachingUnitId: tuId,
              roomId: roomId2,
              dayOfWeek: slot2.day,
              periodStart: slot2.ps,
              periodEnd: slot2.pe,
              weekNumber: w,
              mode: 'OFFLINE',
            });
          }
        }
      }

      if (asnRows.length) await prisma.assignment.createMany({ data: asnRows, skipDuplicates: true });
      if (tuRows.length)  await prisma.teachingUnit.createMany({ data: tuRows, skipDuplicates: true });
      if (schRows.length) {
        await prisma.schedule.createMany({ data: schRows, skipDuplicates: true });
        totalSched += schRows.length;
      }
    }
    process.stdout.write('.');
  }
  console.log(`\n  ${totalSched} schedules`);

  // ── Bước 7: Seed subject nameEn ─────────────────────────────────────────────
  console.log('\nBước 7: Seed subject nameEn...');
  const nameEnMap = {
    'LMH01':'Political Science','LMH02':'Law','LMH03':'Advanced Mathematics','LMH04':'Soft Skills',
    'LMH05':'Computer Architecture','LMH06':'Fundamentals of Vietnamese Culture',
    'LMH07':'English 1','LMH08':'English 2','LMH09':'English 3','MH00007':'Physical Education',
    'IT101':'Basic Programming','IT102':'Introduction to Computer Networks',
    'IT103':'Computer Architecture (Lab)','IT104':'Database Management with SQL Server',
    'IT105':'Applied Graphics','IT106':'Website Development',
    'LT201':'C/C++ Programming','LT202':'Object-Oriented Programming (Java)','LT203':'C# Programming',
    'LT204':'PHP Programming','LT205':'Python Programming','LT206':'Database',
    'LT207':'Systems Analysis & Design','LT208':'Management Software Development',
    'LT209':'Mobile Application Development','LT210':'Web Service Programming',
    'LT211':'Data Structures & Algorithms','LT212':'Software Engineering',
    'LT213':'IT Project Management','LT214':'Information Security',
    'LT215':'AI Applications in Programming','LT216':'Website Administration with Frameworks',
    'LT217':'Foundation Internship','LT218':'Graduation Project',
    'QT201':'Linux Operating System','QT202':'Windows Server Network Administration',
    'QT203':'Linux Network Administration','QT204':'Network Security','QT205':'Network Programming',
    'QT206':'Wireless Network Technology','QT207':'LAN Design & Implementation',
    'QT208':'Computer System Maintenance','QT209':'Internet of Things (IoT)',
    'QT210':'Network Device Installation','QT211':'Windows Operating System',
    'QT212':'System Security','QT213':'Cloud & Firewall Administration',
    'QT214':'Website Development with Open Source Software',
    'UD201':'Advanced Database','UD202':'Software Analysis & Design',
    'UD203':'C# Application Programming','UD204':'Java Web Programming',
    'UD205':'Advanced PHP Programming','UD206':'Advanced Website Development',
    'UD207':'Mobile Application Programming','UD208':'Software Project Management',
    'UD209':'Software Testing','UD210':'Application Security',
    'UD211':'Applied Artificial Intelligence','UD212':'Graduation Project',
    'TK201':'Basic Drawing','TK202':'Fundamentals of Composition','TK203':'2D Modeling',
    'TK204':'Corel Draw','TK205':'Photoshop / Image Processing','TK206':'Illustrator',
    'TK207':'Motion Graphics (Flash/Animate)','TK208':'3D Graphics (3ds Max)',
    'TK209':'Website UI/UX Design','TK210':'Product Label & Packaging Design',
    'TK211':'Advertising Graphic Design','TK212':'Video Production (Premiere/After Effects)',
    'TK213':'Print Layout Design','TK214':'Brand Identity Design',
    'TK215':'Photography Techniques','TK216':'AI Applications in Graphic Design',
    'TK217':'Graduation Project',
  };
  let seededEn = 0;
  for (const [code, nameEn] of Object.entries(nameEnMap)) {
    const r = await prisma.subject.updateMany({ where: { code }, data: { nameEn } });
    seededEn += r.count;
  }
  console.log(`  ${seededEn} subjects updated with nameEn`);

  // ── Bước 8: Flush Redis cache ────────────────────────────────────────────────
  console.log('\nBước 8: Flush Redis cache...');
  try {
    const redis = new Redis({ host: 'localhost', port: 6379 });
    const keys = await redis.keys('tkb:cache:*');
    if (keys.length > 0) { await redis.del(...keys); console.log(`  Xóa ${keys.length} cache keys`); }
    else console.log('  Cache trống');
    await redis.quit();
  } catch (e) {
    console.log('  Redis không kết nối được (bỏ qua):', e.message);
  }

  // ── Tổng kết ─────────────────────────────────────────────────────────────────
  const [tchCount, usrCount, asnCount, tuCount, schCount] = await Promise.all([
    prisma.teacher.count(),
    prisma.user.count({ where: { role: 'TEACHER' } }),
    prisma.assignment.count(),
    prisma.teachingUnit.count(),
    prisma.schedule.count(),
  ]);
  const wks = await prisma.schedule.findMany({ select:{ weekNumber:true }, distinct:['weekNumber'], orderBy:{ weekNumber:'asc' } });
  const wNums = wks.map(w => w.weekNumber);
  console.log('\n═══════════════════════════════════════════════');
  console.log('KẾT QUẢ:');
  console.log(`  Giảng viên:     ${tchCount}  (CNTT:30 | TKĐH:12 | DC:4 | TA:4)`);
  console.log(`  Users[TEACHER]: ${usrCount}`);
  console.log(`  Assignments:    ${asnCount}`);
  console.log(`  Teaching Units: ${tuCount}`);
  console.log(`  Lịch học:       ${schCount}`);
  console.log(`  Tuần bao phủ:   ${wNums[0]} → ${wNums[wNums.length-1]}  (${wNums.length} tuần)`);
  console.log('═══════════════════════════════════════════════');
}

main().catch(e => { console.error('Lỗi:', e); process.exit(1); }).finally(() => prisma.$disconnect());
