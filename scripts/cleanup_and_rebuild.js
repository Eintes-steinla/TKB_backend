/**
 * cleanup_and_rebuild.js
 *
 * 1. Xóa tất cả dữ liệu không thuộc 4 ngành CNTT: LTMT, QTM, UDPM, TKĐH
 *    - Ngành / lớp / sinh viên / user / schedule / assignment / teaching_unit / curricula
 * 2. Xóa giảng viên không thuộc khoa CNTT / TKĐH / TA
 * 3. Thêm môn học mới theo đúng CTĐT thực tế 4 ngành
 * 4. Xây dựng lại curriculum + assignment + teaching_unit + schedule
 *    cho K15 (HK5/HK6), K16 (HK1→HK6), K17 (HK1→HK4) đến hết 2026
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

// ─── Giữ lại ────────────────────────────────────────────────────────────────
const KEEP_MAJOR_IDS  = ['major_ltmt','major_qtm','major_udpm','major_tkdh'];
const KEEP_DEPT       = ['CNTT','TKĐH','TA'];  // giảng viên cần giữ lại
const KEEP_TEACHER_IDS = [
  // CNTT
  'gv_cuong','gv_binh_cuong','gv_han','gv_muoi','gv_trung','gv_tung_ct',
  'gv_tung_ng','gv_hoa','gv_uy','gv_toan','gv_loi_lt','gv_quoc_tuan',
  'gv_ho_tung','gv_van_pt','gv_linh_cq','gv_thanh_tung','gv_quoc',
  // TKĐH
  'gv_anh_tkdh','gv_nhung','gv_trang','gv_quang_tkdh','gv_thanh_tkdh','gv_loi_tkdh',
  // TA (Anh văn)
  'gv_huyen','gv_ninh_ha','gv_quynh_anh',
];

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

// ─── Tên tiếng Việt ─────────────────────────────────────────────────────────
const HO = ['Nguyễn','Trần','Lê','Phạm','Hoàng','Huỳnh','Phan','Vũ','Võ','Đặng',
            'Bùi','Đỗ','Hồ','Ngô','Dương','Lý','Đinh','Tô','Trương','Đoàn'];
const TEN_NAM = ['Minh','Hùng','Tuấn','Dũng','Đức','Long','Thành','Nam','Quân','Hải',
                 'Khoa','Phúc','Bảo','Tâm','Thiện','Nhân','Khánh','Hiếu','Quang','Trung',
                 'Vũ','Đạt','Lâm','Sơn','Tài','Tín','Vinh','Cường','Hưng','Phong'];
const TEN_NU  = ['Linh','Hương','Trang','Lan','Mai','Ngọc','Thảo','Hà','Yến','Ánh',
                 'Nhung','Oanh','Diệu','Trinh','Châu','Quỳnh','Nhi','Thy','Phương','Trâm',
                 'Hân','Ngân','Tiên','Vân','Dung','Thùy','Khánh','Bích','Thư','Xuân'];
const DEM_NAM = ['Văn','Đức','Xuân','Công','Minh','Thanh','Quốc','Hữu','Bá','Gia'];
const DEM_NU  = ['Thị','Ngọc','Minh','Thu','Thanh','Bích','Hoài','Diễm','Như','Phương'];

function randomViName() {
  const isFemale = Math.random() < 0.45;
  const ho = pick(HO);
  const dem = isFemale ? pick(DEM_NU) : pick(DEM_NAM);
  const ten = isFemale ? pick(TEN_NU) : pick(TEN_NAM);
  return `${ho} ${dem} ${ten}`;
}
function removeDiacritics(str) {
  const map = {'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ằ':'a','ắ':'a','ẳ':'a','ẵ':'a','ặ':'a','â':'a','ầ':'a','ấ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d','è':'e','é':'e','ẻ':'e','ẽ':'e','ẹ':'e','ê':'e','ề':'e','ế':'e','ể':'e','ễ':'e','ệ':'e','ì':'i','í':'i','ỉ':'i','ĩ':'i','ị':'i','ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ồ':'o','ố':'o','ổ':'o','ỗ':'o','ộ':'o','ơ':'o','ờ':'o','ớ':'o','ở':'o','ỡ':'o','ợ':'o','ù':'u','ú':'u','ủ':'u','ũ':'u','ụ':'u','ư':'u','ừ':'u','ứ':'u','ử':'u','ữ':'u','ự':'u','ỳ':'y','ý':'y','ỷ':'y','ỹ':'y','ỵ':'y'};
  return str.split('').map(c => map[c] || c).join('');
}
function nameToLogin(fullName) {
  const parts = fullName.split(' ');
  return removeDiacritics(parts[parts.length - 1]).toLowerCase();
}
const usedCodes = new Set();
function genStudentCode(yr) {
  let code;
  do { code = `CD${yr}${rng(1000,9999)}`; } while (usedCodes.has(code));
  usedCodes.add(code); return code;
}

// ─── Môn học đầy đủ theo CTĐT ────────────────────────────────────────────────
// Format: { id, code, name, credits, roomType, isPractice, requiresConsecutive }
const SUBJECTS_NEW = [
  // === MÔN CHUNG (áp dụng cho tất cả ngành) ===
  { id:'sub_ct',    code:'LMH01', name:'Chính trị',                     credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_pl',    code:'LMH02', name:'Pháp luật',                     credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_toan',  code:'LMH03', name:'Toán cao cấp',                  credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_knm',   code:'LMH04', name:'Kỹ năng mềm',                   credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ctmt',  code:'LMH05', name:'Cấu trúc máy tính',             credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_gdtc',  code:'MH00007', name:'Giáo dục thể chất',           credits:0, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_av1',   code:'LMH07', name:'Anh văn 1',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_av2',   code:'LMH08', name:'Anh văn 2',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_av3',   code:'LMH09', name:'Anh văn 3',                     credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ctxh',  code:'LMH06', name:'Cơ sở văn hóa Việt Nam',        credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  // === MÔN CNTT CƠ SỞ ===
  { id:'sub_lmtcan',code:'IT101', name:'Lập trình căn bản',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_nmmt',  code:'IT102', name:'Nhập môn mạng máy tính',         credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ctmt2', code:'IT103', name:'Cấu trúc máy tính (thực hành)',  credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_sql',   code:'IT104', name:'HQT cơ sở dữ liệu SQL Server',   credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dhua',  code:'IT105', name:'Đồ họa ứng dụng',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_xdweb', code:'IT106', name:'Xây dựng Website',               credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  // === LTMT — Lập trình máy tính ===
  { id:'sub_laptC',    code:'LT201', name:'Lập trình C/C++',                 credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lphuong',  code:'LT202', name:'Lập trình hướng đối tượng (Java)',credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapCsharp',code:'LT203', name:'Lập trình C#',                    credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapPHP',   code:'LT204', name:'Lập trình PHP',                   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lapPython',code:'LT205', name:'Lập trình Python',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_csdl',     code:'LT206', name:'Cơ sở dữ liệu',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_pttkht',   code:'LT207', name:'Phân tích thiết kế hệ thống',    credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_xdpm',     code:'LT208', name:'Xây dựng phần mềm quản lý',      credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_ltdidong', code:'LT209', name:'Lập trình thiết bị di động',      credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_lpservice',code:'LT210', name:'Lập trình Web Service',           credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ctdlgt',   code:'LT211', name:'Cấu trúc dữ liệu & giải thuật',  credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_cnpm',     code:'LT212', name:'Công nghệ phần mềm',              credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_qldacntt', code:'LT213', name:'Quản lý dự án CNTT',              credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_antoabm',  code:'LT214', name:'An toàn & bảo mật thông tin',     credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_udai',     code:'LT215', name:'Ứng dụng AI trong lập trình',     credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtwebfw',  code:'LT216', name:'Quản trị website với Framework',  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_thuctapcs',code:'LT217', name:'Thực tập cơ sở',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_dotancs',  code:'LT218', name:'Đồ án tốt nghiệp',                credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  // === QTM — Quản trị mạng ===
  { id:'sub_hdlinux',   code:'QT201', name:'Hệ điều hành Linux',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtmangwin', code:'QT202', name:'Quản trị mạng Windows Server',         credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_qtmanglin', code:'QT203', name:'Quản trị mạng Linux',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_anninh',    code:'QT204', name:'An ninh mạng',                         credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_lpmangg',   code:'QT205', name:'Lập trình mạng',                       credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_cnkhong',   code:'QT206', name:'Công nghệ mạng không dây',             credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkxdmang',  code:'QT207', name:'Thiết kế & xây dựng mạng LAN',        credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_baotrimt',  code:'QT208', name:'Bảo trì hệ thống máy tính',           credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_iot',       code:'QT209', name:'Internet vạn vật (IoT)',               credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_laptnguon',  code:'QT210', name:'Lắp đặt thiết bị mạng',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dieuhanh',  code:'QT211', name:'Hệ điều hành Windows',                credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_aotoanbm',  code:'QT212', name:'An toàn bảo mật hệ thống',            credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_qtcloudfw', code:'QT213', name:'Quản trị Cloud & Firewall',            credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_xdwebpmm',  code:'QT214', name:'XD Website bằng phần mềm mã nguồn mở',credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  // === UDPM — Ứng dụng phần mềm ===
  { id:'sub_ud_csdl',   code:'UD201', name:'Cơ sở dữ liệu nâng cao',             credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_pttkht', code:'UD202', name:'Phân tích thiết kế phần mềm',         credits:3, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_csharp', code:'UD203', name:'Lập trình C# ứng dụng',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_java',   code:'UD204', name:'Lập trình Java Web',                  credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_php',    code:'UD205', name:'Lập trình PHP nâng cao',             credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_xdweb',  code:'UD206', name:'Xây dựng Website nâng cao',           credits:4, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_mobile', code:'UD207', name:'Lập trình ứng dụng di động',          credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_qlda',   code:'UD208', name:'Quản lý dự án phần mềm',              credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_test',   code:'UD209', name:'Kiểm thử phần mềm',                   credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_atbm',   code:'UD210', name:'An toàn bảo mật ứng dụng',            credits:2, roomType:'THEORY',   isPractice:false, requiresConsecutive:false },
  { id:'sub_ud_ai',     code:'UD211', name:'Trí tuệ nhân tạo ứng dụng',           credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ud_dotantn',code:'UD212', name:'Đồ án tốt nghiệp',                    credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  // === TKĐH — Thiết kế đồ họa ===
  { id:'sub_hinhhoaco',  code:'TK201', name:'Hình họa cơ bản',                    credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_cstaohinh',  code:'TK202', name:'Cơ sở tạo hình',                    credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tahinh2d',   code:'TK203', name:'Tạo hình 2D',                        credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_coreldraw',  code:'TK204', name:'Corel Draw',                          credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_pshop',      code:'TK205', name:'Photoshop / Xử lý ảnh',              credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_illustrator',code:'TK206', name:'Illustrator',                         credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dhoahn',     code:'TK207', name:'Đồ họa hình động (Flash/Animate)',   credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dh3d',       code:'TK208', name:'Đồ họa 3D (3ds Max)',                credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkgdweb',    code:'TK209', name:'Thiết kế giao diện Website (UI/UX)', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkbapbi',    code:'TK210', name:'Thiết kế nhãn mác bao bì sản phẩm', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkqbsp',     code:'TK211', name:'Thiết kế đồ họa quảng bá sản phẩm', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_dungvideo',  code:'TK212', name:'Dựng Video (Premiere/After Effects)',credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
  { id:'sub_tkdantrang', code:'TK213', name:'Thiết kế dàn trang ấn phẩm',         credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tkthieuhi',  code:'TK214', name:'Thiết kế nhận diện thương hiệu',     credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_ktchanh',    code:'TK215', name:'Kỹ thuật chụp ảnh',                  credits:2, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tk_ai',      code:'TK216', name:'Ứng dụng AI trong thiết kế đồ họa', credits:3, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:false },
  { id:'sub_tk_dotantn', code:'TK217', name:'Đồ án tốt nghiệp',                   credits:6, roomType:'PRACTICE', isPractice:true,  requiresConsecutive:true  },
];

// ─── Chương trình đào tạo theo học kỳ ────────────────────────────────────────
// Mỗi phần tử: [subjectId, periodsPerWeek]
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
  TKĐH: {
    1: ['sub_ct','sub_pl','sub_av1','sub_hinhhoaco','sub_cstaohinh','sub_gdtc'],
    2: ['sub_av2','sub_knm','sub_ctxh','sub_tahinh2d','sub_coreldraw','sub_pshop'],
    3: ['sub_illustrator','sub_dhoahn','sub_dh3d','sub_tkgdweb','sub_av3','sub_toan'],
    4: ['sub_tkbapbi','sub_tkqbsp','sub_dungvideo','sub_ktchanh','sub_cnpm','sub_dhua'],
    5: ['sub_tkdantrang','sub_tkthieuhi','sub_tk_ai','sub_qldacntt','sub_xdweb','sub_antoabm'],
    6: ['sub_tk_dotantn'],
  },
};

// ─── Lớp theo từng ngành ─────────────────────────────────────────────────────
const CLASS_DEFS = {
  major_ltmt: {
    K15: [
      { id:'cls_ltmt1',  code:'LTMT1-K15',  cnt:38 },
      { id:'cls_ltmt2',  code:'LTMT2-K15',  cnt:38 },
      { id:'cls_ltmt3',  code:'LTMT3-K15',  cnt:36 },
      { id:'cls_ltmt4',  code:'LTMT4-K15',  cnt:36 },
      { id:'cls_ltmt5',  code:'LTMT5-K15',  cnt:35 },
      { id:'cls_ltmt6',  code:'LTMT6-K15',  cnt:35 },
    ],
    K16: [
      { id:'cls_ltmt1_k16', code:'LTMT1-K16', cnt:42 },
      { id:'cls_ltmt2_k16', code:'LTMT2-K16', cnt:40 },
      { id:'cls_ltmt3_k16', code:'LTMT3-K16', cnt:40 },
      { id:'cls_ltmt4_k16', code:'LTMT4-K16', cnt:38 },
    ],
    K17: [
      { id:'cls_ltmt1_k17', code:'LTMT1-K17', cnt:45 },
      { id:'cls_ltmt2_k17', code:'LTMT2-K17', cnt:43 },
      { id:'cls_ltmt3_k17', code:'LTMT3-K17', cnt:42 },
      { id:'cls_ltmt4_k17', code:'LTMT4-K17', cnt:40 },
      { id:'cls_ltmt5_k17', code:'LTMT5-K17', cnt:38 },
    ],
  },
  major_qtm: {
    K15: [
      { id:'cls_qtm1', code:'QTM1-K15', cnt:40 },
      { id:'cls_qtm2', code:'QTM2-K15', cnt:38 },
    ],
    K16: [
      { id:'cls_qtm1_k16', code:'QTM1-K16', cnt:42 },
      { id:'cls_qtm2_k16', code:'QTM2-K16', cnt:40 },
    ],
    K17: [
      { id:'cls_qtm1_k17', code:'QTM1-K17', cnt:45 },
      { id:'cls_qtm2_k17', code:'QTM2-K17', cnt:43 },
      { id:'cls_qtm3_k17', code:'QTM3-K17', cnt:40 },
    ],
  },
  major_udpm: {
    K15: [
      { id:'cls_udpm1', code:'UDPM1-K15', cnt:38 },
      { id:'cls_udpm2', code:'UDPM2-K15', cnt:38 },
    ],
    K16: [
      { id:'cls_udpm1_k16', code:'UDPM1-K16', cnt:40 },
      { id:'cls_udpm2_k16', code:'UDPM2-K16', cnt:38 },
    ],
    K17: [
      { id:'cls_udpm1_k17', code:'UDPM1-K17', cnt:43 },
      { id:'cls_udpm2_k17', code:'UDPM2-K17', cnt:41 },
      { id:'cls_udpm3_k17', code:'UDPM3-K17', cnt:40 },
    ],
  },
  major_tkdh: {
    K15: [
      { id:'cls_tkdh1',    code:'TKĐH1-K15',    cnt:36 },
      { id:'cls_tkdh2',    code:'TKĐH2-K15',    cnt:36 },
      { id:'cls_tkdh3',    code:'TKĐH3-K15',    cnt:35 },
      { id:'cls_tkdh4',    code:'TKĐH4-K15',    cnt:35 },
      { id:'cls_tkdh5',    code:'TKĐH5-K15',    cnt:34 },
      { id:'cls_tkdh6',    code:'TKĐH6-K15',    cnt:34 },
      { id:'cls_tkdh7',    code:'TKĐH7-K15',    cnt:33 },
      { id:'cls_tkdh_clc', code:'TKĐH CLC-K15', cnt:30 },
    ],
    K16: [
      { id:'cls_tkdh1_k16', code:'TKĐH1-K16', cnt:45 },
      { id:'cls_tkdh2_k16', code:'TKĐH2-K16', cnt:45 },
      { id:'cls_tkdh3_k16', code:'TKĐH3-K16', cnt:42 },
      { id:'cls_tkdh4_k16', code:'TKĐH4-K16', cnt:42 },
      { id:'cls_tkdh5_k16', code:'TKĐH5-K16', cnt:40 },
      { id:'cls_tkdh6_k16', code:'TKĐH6-K16', cnt:40 },
    ],
    K17: [
      { id:'cls_tkdh1_k17', code:'TKĐH1-K17', cnt:48 },
      { id:'cls_tkdh2_k17', code:'TKĐH2-K17', cnt:47 },
      { id:'cls_tkdh3_k17', code:'TKĐH3-K17', cnt:46 },
      { id:'cls_tkdh4_k17', code:'TKĐH4-K17', cnt:45 },
      { id:'cls_tkdh5_k17', code:'TKĐH5-K17', cnt:44 },
      { id:'cls_tkdh6_k17', code:'TKĐH6-K17', cnt:43 },
      { id:'cls_tkdh7_k17', code:'TKĐH7-K17', cnt:42 },
    ],
  },
};

// Học kỳ → tuần
// K15: HK5=tuần4-25, HK6=tuần27-46
// K16: HK1=tuần4-25, HK2=tuần27-46, HK3=tuần53-72, HK4=tuần79-98
//      HK5=tuần100-119, HK6=tuần120-139  (kéo dài 2026)
// K17: HK1=tuần4-25, HK2=tuần27-46, HK3=tuần53-72, HK4=tuần79-98
const SEM_WEEKS = {
  K15: { 5:[4,25], 6:[27,46] },
  K16: { 1:[4,25], 2:[27,46], 3:[53,72], 4:[79,98], 5:[100,119], 6:[120,139] },
  K17: { 1:[4,25], 2:[27,46], 3:[53,72], 4:[79,98] },
};

// Giảng viên theo nhóm
const TV_CNTT  = KEEP_TEACHER_IDS.filter(id => !id.startsWith('gv_a') && !id.includes('tkdh') && !id.includes('huyen') && !id.includes('ninh') && !id.includes('quynh'));
const TV_TKDH  = ['gv_anh_tkdh','gv_nhung','gv_trang','gv_quang_tkdh','gv_thanh_tkdh','gv_loi_tkdh'];
const TV_TA    = ['gv_huyen','gv_ninh_ha','gv_quynh_anh'];

function getTeachersForSubject(subId) {
  if (['sub_av1','sub_av2','sub_av3'].includes(subId)) return TV_TA;
  if (subId.startsWith('sub_hinhhoaco')||subId.startsWith('sub_cstaohinh')||
      subId.startsWith('sub_tahinh2d')||subId.startsWith('sub_coreldraw')||
      subId.startsWith('sub_pshop')||subId.startsWith('sub_illustrator')||
      subId.startsWith('sub_dhoahn')||subId.startsWith('sub_dh3d')||
      subId.startsWith('sub_tkgdweb')||subId.startsWith('sub_tkbapbi')||
      subId.startsWith('sub_tkqbsp')||subId.startsWith('sub_dungvideo')||
      subId.startsWith('sub_tkdantrang')||subId.startsWith('sub_tkthieuhi')||
      subId.startsWith('sub_ktchanh')||subId.startsWith('sub_tk_')) return TV_TKDH;
  return TV_CNTT;
}

// Phòng
const THEORY_ROOMS   = ['room_a17_401','room_a17_402','room_a17_403','room_a17_404','room_a17_405',
                        'room_a17_406','room_a17_407','room_a17_408','room_a17_409',
                        'room_a17_501a','room_a17_501b','room_a17_502','room_a17_504',
                        'room_c4b_1','room_c4b_2','room_c4b_3','room_c4b_4','room_c4b_5','room_c4b_6'];
const PRACTICE_ROOMS = ['room_pm_301','room_pm_302','room_pm_303','room_pm_304','room_pm_305',
                        'room_pm_306','room_pm_401','room_pm_402','room_pm_403','room_pm_404',
                        'room_pm_405','room_pm_406','room_pm_407','room_pm_408','room_pm_409',
                        'room_b4_301','room_d_303'];

// Slot booking
const usedSlots = new Map();
function bookSlot(week, day, ps, roomId) {
  const k = `${day}-${ps}-${roomId}`;
  if (!usedSlots.has(week)) usedSlots.set(week, new Set());
  usedSlots.get(week).add(k);
}
function slotFree(week, day, ps, roomId) {
  if (!usedSlots.has(week)) return true;
  return !usedSlots.get(week).has(`${day}-${ps}-${roomId}`);
}
const SLOTS = [[1,3],[2,4],[4,6],[7,9],[8,10],[10,12]];
function findSlot(week, roomId) {
  const days = shuffle([2,3,4,5,6,7]);
  const slots = shuffle(SLOTS);
  for (const day of days) {
    for (const [ps,pe] of slots) {
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
  console.log('🗑️  Bước 1: Xóa dữ liệu các ngành không thuộc CNTT...\n');

  // Tìm các major cần xóa
  const deleteMajors = await prisma.major.findMany({
    where: { id: { notIn: KEEP_MAJOR_IDS } },
  });
  const deleteMajorIds = deleteMajors.map(m => m.id);
  console.log(`  Ngành cần xóa (${deleteMajors.length}):`, deleteMajors.map(m=>m.code).join(', '));

  // Tìm lớp thuộc ngành xóa
  const delClasses = await prisma.classGroup.findMany({
    where: { majorId: { in: deleteMajorIds } },
    select: { id: true, code: true },
  });
  const delClassIds = delClasses.map(c => c.id);
  console.log(`  Lớp cần xóa: ${delClasses.length}`);

  // Xóa theo thứ tự FK: schedule → teaching_unit → assignment → user(student) → class_group → major
  if (delClassIds.length > 0) {
    // Tìm assignments thuộc lớp xóa
    const delAsgn = await prisma.assignment.findMany({ where: { classGroupId: { in: delClassIds } }, select: { id: true } });
    const delAsgnIds = delAsgn.map(a => a.id);

    // Teaching units
    const delTU = await prisma.teachingUnit.findMany({ where: { assignmentId: { in: delAsgnIds } }, select: { id: true } });
    const delTUIDs = delTU.map(t => t.id);

    // Schedules
    const delSched = await prisma.schedule.deleteMany({ where: { teachingUnitId: { in: delTUIDs } } });
    console.log(`  Xóa ${delSched.count} schedules`);

    // Violations
    await prisma.constraintViolationLog.deleteMany({ where: { schedule: { teachingUnitId: { in: delTUIDs } } } });

    await prisma.teachingUnit.deleteMany({ where: { id: { in: delTUIDs } } });
    console.log(`  Xóa ${delTUIDs.length} teaching_units`);

    await prisma.assignment.deleteMany({ where: { id: { in: delAsgnIds } } });
    console.log(`  Xóa ${delAsgnIds.length} assignments`);

    // Curricula
    await prisma.curriculum.deleteMany({ where: { majorId: { in: deleteMajorIds } } });

    // Users có refId là lớp bị xóa
    const delUsers = await prisma.user.deleteMany({ where: { refId: { in: delClassIds } } });
    console.log(`  Xóa ${delUsers.count} user sinh viên`);

    await prisma.classGroup.deleteMany({ where: { id: { in: delClassIds } } });
    console.log(`  Xóa ${delClasses.length} lớp`);

    await prisma.major.deleteMany({ where: { id: { in: deleteMajorIds } } });
    console.log(`  Xóa ${deleteMajors.length} ngành`);
  }

  // Xóa giảng viên không phải CNTT
  const delTeachers = await prisma.teacher.findMany({ where: { id: { notIn: KEEP_TEACHER_IDS } } });
  console.log(`\n  Giảng viên cần xóa (${delTeachers.length}):`, delTeachers.map(t=>t.code).join(', '));
  const delTeacherIds = delTeachers.map(t => t.id);
  // Phải xóa teaching_unit trước (FK → assignment), rồi mới xóa assignment
  const delAsgnByTeacher = await prisma.assignment.findMany({ where: { teacherId: { in: delTeacherIds } }, select: { id: true } });
  const delAsgnByTeacherIds = delAsgnByTeacher.map(a => a.id);
  if (delAsgnByTeacherIds.length > 0) {
    const delSchedByTeacher = await prisma.schedule.deleteMany({ where: { teachingUnit: { assignmentId: { in: delAsgnByTeacherIds } } } });
    console.log(`  Xóa thêm ${delSchedByTeacher.count} schedules của GV bị xóa`);
    await prisma.teachingUnit.deleteMany({ where: { assignmentId: { in: delAsgnByTeacherIds } } });
    await prisma.assignment.deleteMany({ where: { id: { in: delAsgnByTeacherIds } } });
  }
  await prisma.teacher.deleteMany({ where: { id: { in: delTeacherIds } } });

  // Xóa lớp K15 cũ nằm ngoài định nghĩa mới (cls_qtdn, cls_qtdn2, etc. đã bị xóa cùng ngành)
  // Xóa thêm: cls_clc_dcn thuộc major_dtcn đã xóa rồi
  // Xóa lớp K16/K17 còn sót thuộc ngành bị xóa (đã xóa ở trên)
  // Xóa lớp K16 'TĐH 1-K16' (cls_tdh1_k16) đã bị xóa cùng major_tdh

  // Xóa lớp K15 QTM2 chưa trong định nghĩa cũ
  // (cls_qtm1 còn đó, còn cls_qtm2 - kiểm tra)
  const existQ2 = await prisma.classGroup.findUnique({ where: { id: 'cls_qtm2' } });
  if (!existQ2) {
    await prisma.classGroup.create({
      data: { id: 'cls_qtm2', code: 'QTM2-K15', majorId: 'major_qtm', cohortId: 'cohort_k15', studentCount: 38 },
    });
    console.log('  Tạo thêm lớp QTM2-K15');
  }

  console.log('\n✅ Bước 1 hoàn thành\n');

  // ─── Bước 2: Xóa & rebuild môn học ─────────────────────────────────────────
  console.log('📖 Bước 2: Xóa môn học cũ, thêm môn học đúng theo CTĐT...');
  // Xóa TU + schedule + assignments liên quan môn cũ cần bỏ
  await prisma.schedule.deleteMany({});
  await prisma.constraintViolationLog.deleteMany({});
  await prisma.teachingUnit.deleteMany({});
  await prisma.assignment.deleteMany({});
  await prisma.curriculum.deleteMany({});
  await prisma.subject.deleteMany({});
  console.log('  Đã xóa toàn bộ schedules, TU, assignments, curricula, subjects cũ');

  // Thêm môn học mới
  await prisma.subject.createMany({ data: SUBJECTS_NEW, skipDuplicates: true });
  console.log(`  Thêm ${SUBJECTS_NEW.length} môn học mới`);

  const subjectMap = Object.fromEntries(SUBJECTS_NEW.map(s => [s.id, s]));

  // ─── Bước 3: Đảm bảo lớp đúng cấu trúc ─────────────────────────────────────
  console.log('\n🏫 Bước 3: Đồng bộ lớp học...');
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

  // Xóa lớp K15 không còn trong danh sách định nghĩa
  const keepClassIds = new Set(
    Object.values(CLASS_DEFS).flatMap(cohorts => Object.values(cohorts).flat().map(c => c.id))
  );
  const existingClasses = await prisma.classGroup.findMany({ select: { id: true } });
  const toDeleteClasses = existingClasses.filter(c => !keepClassIds.has(c.id)).map(c => c.id);
  if (toDeleteClasses.length > 0) {
    await prisma.user.deleteMany({ where: { refId: { in: toDeleteClasses } } });
    await prisma.classGroup.deleteMany({ where: { id: { in: toDeleteClasses } } });
    console.log(`  Xóa ${toDeleteClasses.length} lớp thừa`);
  }

  const allClasses = await prisma.classGroup.findMany({ include: { major: true, cohort: true } });
  console.log(`  Tổng lớp học: ${allClasses.length}`);

  // ─── Bước 4: Sinh viên ─────────────────────────────────────────────────────
  console.log('\n👥 Bước 4: Sinh viên...');
  // Xóa user sinh viên cũ (sẽ tạo lại)
  await prisma.user.deleteMany({ where: { role: 'STUDENT' } });
  console.log('  Đã xóa sinh viên cũ');

  const studentHash = await bcrypt.hash('Student@123', 10);
  const existingEmails = new Set(
    (await prisma.user.findMany({ select: { email: true } })).map(u => u.email)
  );

  let totalStudents = 0;
  for (const cls of allClasses) {
    const cohortYr = cls.cohort.code === 'K15' ? '22' : cls.cohort.code === 'K16' ? '23' : '24';
    const batch = [];
    for (let i = 0; i < cls.studentCount; i++) {
      const name = randomViName();
      const svCode = genStudentCode(cohortYr);
      const login = nameToLogin(name);
      let email = `${login}.${svCode.replace('CD','')}@student.hactech.edu.vn`;
      let suffix = 1;
      while (existingEmails.has(email)) {
        email = `${login}${suffix}.${svCode.replace('CD','')}@student.hactech.edu.vn`;
        suffix++;
      }
      existingEmails.add(email);
      batch.push({ id: `usr_sv_${svCode.toLowerCase()}`, email, passwordHash: studentHash, role: 'STUDENT', refId: cls.id, name });
    }
    await prisma.user.createMany({ data: batch, skipDuplicates: true });
    totalStudents += cls.studentCount;
    process.stdout.write('.');
  }
  console.log(`\n  ✅ Tạo ${totalStudents} sinh viên`);

  // ─── Bước 5: Assignment + TeachingUnit + Schedule ──────────────────────────
  console.log('\n📅 Bước 5: Tạo lịch học...');

  let totalSched = 0;
  const MAJOR_CODE_MAP = { major_ltmt:'LTMT', major_qtm:'QTM', major_udpm:'UDPM', major_tkdh:'TKĐH' };

  for (const cls of allClasses) {
    const cohortCode = cls.cohort.code;         // K15/K16/K17
    const majorCode  = MAJOR_CODE_MAP[cls.majorId];
    const semPlan    = SEM_WEEKS[cohortCode];   // { semNo: [wStart, wEnd] }
    const ctdt       = CTDT[majorCode];
    const shortId    = cls.id.replace('cls_','');

    for (const [semNoStr, [wStart, wEnd]] of Object.entries(semPlan)) {
      const semNo = parseInt(semNoStr);
      const subIds = ctdt[semNo] || [];
      if (subIds.length === 0) continue;

      const asnRows = [], tuRows = [], schRows = [];

      for (const subId of subIds) {
        const sub = subjectMap[subId];
        if (!sub) continue;

        const teacherId = pick(getTeachersForSubject(subId));
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
          const roomId = pick(rooms);
          const slot = findSlot(w, roomId);
          if (!slot) continue;
          schRows.push({
            id: `sch_${subId.replace('sub_','')}_${shortId}_w${w}`,
            teachingUnitId: tuId,
            roomId,
            dayOfWeek: slot.day,
            periodStart: slot.ps,
            periodEnd: slot.pe,
            weekNumber: w,
            mode: 'OFFLINE',
          });
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
  console.log(`\n  ✅ Tổng lịch học: ${totalSched} bản ghi\n`);

  // ─── Tổng kết ─────────────────────────────────────────────────────────────
  const [majors, classes, users, students, teachers, subjects, assignments, tu, schedules] = await Promise.all([
    prisma.major.count(),
    prisma.classGroup.count(),
    prisma.user.count(),
    prisma.user.count({ where: { role: 'STUDENT' } }),
    prisma.teacher.count(),
    prisma.subject.count(),
    prisma.assignment.count(),
    prisma.teachingUnit.count(),
    prisma.schedule.count(),
  ]);

  const wks = await prisma.schedule.findMany({ select:{ weekNumber:true }, distinct:['weekNumber'], orderBy:{ weekNumber:'asc' } });
  const wNums = wks.map(w => w.weekNumber);

  console.log('═══════════════════════════════════════════════');
  console.log('📊 KẾT QUẢ CUỐI CÙNG:');
  console.log(`  Ngành:          ${majors}  (LTMT, QTM, UDPM, TKĐH)`);
  console.log(`  Lớp học:        ${classes}`);
  console.log(`  Giảng viên:     ${teachers}`);
  console.log(`  Môn học:        ${subjects}`);
  console.log(`  Sinh viên:      ${students}`);
  console.log(`  Tổng tài khoản: ${users}`);
  console.log(`  Assignments:    ${assignments}`);
  console.log(`  Teaching Units: ${tu}`);
  console.log(`  Lịch học:       ${schedules}`);
  console.log(`  Tuần bao phủ:   ${wNums[0]} → ${wNums[wNums.length-1]}  (${wNums.length} tuần)`);
  console.log('═══════════════════════════════════════════════');

  await prisma.$disconnect();
}

main().catch(e => {
  console.error('❌ Lỗi:', e);
  prisma.$disconnect();
  process.exit(1);
});
