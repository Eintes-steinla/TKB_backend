/**
 * seed_bulk.js — Sinh dữ liệu lớn đến hết 2026
 *
 * Thêm:
 *  - K16 (nhập 2023): lớp đầy đủ cho tất cả 15 ngành
 *  - K17 (nhập 2024): lớp đầy đủ cho tất cả 15 ngành
 *  - ~40-50 sinh viên / lớp (tên thật, mã SV CD23xxxx / CD24xxxx)
 *  - User account cho mỗi sinh viên
 *  - Assignment + TeachingUnit cho K16/K17 (dùng giảng viên hiện có)
 *  - Schedule trải đều: HK1-2025 (tuần 27-46), HK1-2026 (tuần 53-72)
 *    và các tuần còn thiếu cho K15 HK5 (tuần 7-25)
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
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

// Tên tiếng Việt thật
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

function nameToLogin(fullName) {
  // "Nguyễn Văn Minh" → "minh"
  const parts = fullName.split(' ');
  return removeDiacritics(parts[parts.length - 1]).toLowerCase();
}

function removeDiacritics(str) {
  const map = {
    'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ằ':'a','ắ':'a','ẳ':'a','ẵ':'a','ặ':'a',
    'â':'a','ầ':'a','ấ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d','è':'e','é':'e','ẻ':'e','ẽ':'e',
    'ẹ':'e','ê':'e','ề':'e','ế':'e','ể':'e','ễ':'e','ệ':'e','ì':'i','í':'i','ỉ':'i','ĩ':'i',
    'ị':'i','ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ồ':'o','ố':'o','ổ':'o','ỗ':'o',
    'ộ':'o','ơ':'o','ờ':'o','ớ':'o','ở':'o','ỡ':'o','ợ':'o','ù':'u','ú':'u','ủ':'u','ũ':'u',
    'ụ':'u','ư':'u','ừ':'u','ứ':'u','ử':'u','ữ':'u','ự':'u','ỳ':'y','ý':'y','ỷ':'y','ỹ':'y',
    'ỵ':'y',
    'À':'A','Á':'A','Ả':'A','Ã':'A','Ạ':'A','Ă':'A','Ằ':'A','Ắ':'A','Ẳ':'A','Ẵ':'A','Ặ':'A',
    'Â':'A','Ầ':'A','Ấ':'A','Ẩ':'A','Ẫ':'A','Ậ':'A','Đ':'D',
  };
  return str.split('').map(c => map[c] || c).join('');
}

// Sinh mã SV: CD + năm nhập học (2 chữ số) + 4 số ngẫu nhiên
const usedCodes = new Set();
function genStudentCode(yearPrefix) {
  let code;
  do {
    const num = rng(1000, 9999);
    code = `CD${yearPrefix}${num}`;
  } while (usedCodes.has(code));
  usedCodes.add(code);
  return code;
}

// ─── Cấu trúc học kỳ / tuần ─────────────────────────────────────────────────
// Tuần trường dùng (rolling, tính từ đầu năm học 2022-2023 = tuần 1):
// HK1 2022-2023: tuần  1–20  (K15 năm 1 HK1)
// HK2 2022-2023: tuần 21–40  (K15 năm 1 HK2)
// HK1 2023-2024: tuần 41–60  (K15 năm 2 HK3 / K16 năm 1 HK1)
// HK2 2023-2024: tuần 61–80  (K15 năm 2 HK4 / K16 năm 1 HK2)
// HK1 2024-2025: tuần 81–100 (K15 năm 3 HK5 / K16 năm 2 HK3 / K17 năm 1 HK1)
// HK2 2024-2025: tuần 101–120(K15 năm 3 HK6 / K16 năm 2 HK4 / K17 năm 1 HK2)
// HK1 2025-2026: tuần 121–140(K16 năm 3 HK5 / K17 năm 2 HK3)
// HK2 2025-2026: tuần 141–160(K16 năm 3 HK6 / K17 năm 2 HK4)
// → Kéo dài đến hết 2026 = đến tuần ~160

// Seed cũ đang dùng tuần 4-25 (tương đương HK năm 1). Ta giữ nguyên và thêm:
// Tuần 27-46   → HK2 2024-2025  (K15 HK6, K16 HK4, K17 HK2)  — khoảng Feb-Jun 2025
// Tuần 53-72   → HK1 2025-2026  (K16 HK5, K17 HK3)            — khoảng Sep-Jan 2026
// Tuần 79-98   → HK2 2025-2026  (K16 HK6, K17 HK4)            — khoảng Feb-Jun 2026
// + Thêm K15 HK5 đầy đủ: tuần 7-25 (bổ sung tuần 7-15 chưa có)
// + K15 HK6 (tuần 27-46) — K15 năm cuối hoàn thành

const SEMESTERS = {
  // [semKey]: { weeks: [start, end], forCohorts: ['K15'|'K16'|'K17'] }
  'hk5_k15_27':  { weeks: [27, 46], cohorts: ['K15'], semNo: 5, label: 'HK5-K15-2025B' },
  'hk3_k16_27':  { weeks: [27, 46], cohorts: ['K16'], semNo: 3, label: 'HK3-K16-2025B' },
  'hk2_k17_27':  { weeks: [27, 46], cohorts: ['K17'], semNo: 2, label: 'HK2-K17-2025B' },
  'hk5_k16_53':  { weeks: [53, 72], cohorts: ['K16'], semNo: 5, label: 'HK5-K16-2025A' },
  'hk3_k17_53':  { weeks: [53, 72], cohorts: ['K17'], semNo: 3, label: 'HK3-K17-2025A' },
  'hk6_k16_79':  { weeks: [79, 98], cohorts: ['K16'], semNo: 6, label: 'HK6-K16-2026' },
  'hk4_k17_79':  { weeks: [79, 98], cohorts: ['K17'], semNo: 4, label: 'HK4-K17-2026' },
};

// ─── Môn học theo ngành / học kỳ ─────────────────────────────────────────────
// CNTT (LTMT, QTM, UDPM)
const CURRICULUM_CNTT = {
  1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_lmtcan','sub_ctmt'],
  2: ['sub_av2','sub_knm','sub_nmmt','sub_csdl','sub_lphuong','sub_dhua'],
  3: ['sub_laptC','sub_lapCsharp','sub_sql','sub_pttkht','sub_xdweb','sub_gdtc'],
  4: ['sub_lapPHP','sub_ltdidong','sub_cnpm','sub_qldacntt','sub_antoabm','sub_xdweb'],
  5: ['sub_xdpm','sub_hdlinux','sub_lpservice','sub_ctdlgt','sub_anninh','sub_qtwebfw'],
  6: ['sub_qtmangwin','sub_qtmanglin','sub_lpmangg','sub_cnkhong','sub_tkxdmang','sub_xdwebpmm'],
};
// TKĐH
const CURRICULUM_TKDH = {
  1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_hinhhoaco','sub_ctmt'],
  2: ['sub_av2','sub_knm','sub_tahinh2d','sub_coreldraw','sub_pshop','sub_gdtc'],
  3: ['sub_dhoahn','sub_dh3d','sub_tkgdweb','sub_cnpm','sub_tkbapbi','sub_laptC'],
  4: ['sub_tkqbsp','sub_dungvideo','sub_tkdantrang','sub_qldacntt','sub_tkthieuhi','sub_ktchanh'],
  5: ['sub_xdpm','sub_xdweb','sub_sql','sub_pttkht','sub_lapCsharp','sub_antoabm'],
  6: ['sub_ltdidong','sub_qtwebfw','sub_xdwebpmm','sub_lapPHP','sub_cnkhong','sub_cnpm'],
};
// Kỹ thuật (OTO, CĐT, ĐCN, TĐH, ĐTCN, CNCTM, KTML, ĐDD)
const CURRICULUM_KT = {
  1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_ctmt','sub_gdtc'],
  2: ['sub_av2','sub_knm','sub_nmmt','sub_lmtcan','sub_csdl','sub_dhua'],
  3: ['sub_laptC','sub_sql','sub_lapCsharp','sub_pttkht','sub_cnpm','sub_xdweb'],
  4: ['sub_lapPHP','sub_ltdidong','sub_qldacntt','sub_antoabm','sub_xdweb','sub_lmtcan'],
  5: ['sub_xdpm','sub_hdlinux','sub_lpservice','sub_ctdlgt','sub_anninh','sub_sql'],
  6: ['sub_qtmangwin','sub_lpmangg','sub_tkxdmang','sub_cnkhong','sub_xdwebpmm','sub_qtwebfw'],
};
// Kinh tế (TMĐT, QTDN, KTDN)
const CURRICULUM_KTE = {
  1: ['sub_ct','sub_pl','sub_toan','sub_av1','sub_knm','sub_ctmt'],
  2: ['sub_av2','sub_lmtcan','sub_sql','sub_dhua','sub_nmmt','sub_gdtc'],
  3: ['sub_csdl','sub_xdweb','sub_lapPHP','sub_cnpm','sub_pttkht','sub_laptC'],
  4: ['sub_xdpm','sub_qldacntt','sub_antoabm','sub_ltdidong','sub_lapCsharp','sub_sql'],
  5: ['sub_qtwebfw','sub_xdwebpmm','sub_cnkhong','sub_lpmangg','sub_tkxdmang','sub_cnpm'],
  6: ['sub_qtmangwin','sub_qtmanglin','sub_anninh','sub_hdlinux','sub_cnpm','sub_lapPHP'],
};

function getCurriculum(majorCode) {
  if (['LTMT','QTM','UDPM'].includes(majorCode)) return CURRICULUM_CNTT;
  if (majorCode === 'TKĐH') return CURRICULUM_TKDH;
  if (['TMĐT','QTDN','KTDN'].includes(majorCode)) return CURRICULUM_KTE;
  return CURRICULUM_KT; // OTO, CĐT, ĐCN, TĐH, ĐTCN, CNCTM, KTML, ĐDD
}

// ─── Phân công giảng viên theo khoa ─────────────────────────────────────────
const TEACHER_BY_DEPT = {
  CNTT:  ['gv_cuong','gv_binh_cuong','gv_han','gv_muoi','gv_trung','gv_tung_ct',
           'gv_tung_ng','gv_hoa','gv_uy','gv_toan','gv_loi_lt','gv_quoc_tuan',
           'gv_ho_tung','gv_van_pt','gv_linh_cq','gv_thanh_tung','gv_quoc'],
  ĐTCN:  ['gv_phuong_dt','gv_tien_dt','gv_huong_dt','gv_long_dt','gv_thinh','gv_duc_md'],
  ĐCN:   ['gv_liên_dcn','gv_long_dcn','gv_sang','gv_mui','gv_sy','gv_tuyen','gv_cuong_tg'],
  OTO:   ['gv_huong_ck','gv_lam','gv_tien_dung','gv_thang','gv_binh_oto'],
  DC:    ['gv_thanh_ct','gv_ngoc','gv_lan_ct','gv_dung_toan','gv_sam','gv_thao'],
  TA:    ['gv_huyen','gv_ninh_ha','gv_quynh_anh'],
  TKĐH:  ['gv_anh_tkdh','gv_nhung','gv_trang','gv_quang_tkdh','gv_thanh_tkdh','gv_loi_tkdh'],
};

function getTeachersForMajor(majorCode) {
  const techDept = ['OTO','CĐT','ĐCN','TĐH','ĐTCN','CNCTM','KTML','ĐDD'];
  if (techDept.includes(majorCode)) return [...TEACHER_BY_DEPT.CNTT, ...TEACHER_BY_DEPT.ĐCN, ...TEACHER_BY_DEPT.ĐTCN];
  if (majorCode === 'TKĐH') return TEACHER_BY_DEPT.TKĐH;
  if (['TMĐT','QTDN','KTDN'].includes(majorCode)) return [...TEACHER_BY_DEPT.CNTT, ...TEACHER_BY_DEPT.DC];
  return TEACHER_BY_DEPT.CNTT; // LTMT, QTM, UDPM
}

// ─── Lớp cần tạo cho K16 + K17 ─────────────────────────────────────────────
const K16_CLASSES = [
  // CNTT
  { id: 'cls_ltmt1_k16', code: 'LTMT1-K16', majorId: 'major_ltmt', count: 42 },
  { id: 'cls_ltmt2_k16', code: 'LTMT2-K16', majorId: 'major_ltmt', count: 40 },
  { id: 'cls_ltmt3_k16', code: 'LTMT3-K16', majorId: 'major_ltmt', count: 40 },
  { id: 'cls_qtm1_k16',  code: 'QTM1-K16',  majorId: 'major_qtm',  count: 42 },
  { id: 'cls_qtm2_k16',  code: 'QTM2-K16',  majorId: 'major_qtm',  count: 40 },
  { id: 'cls_udpm1_k16', code: 'UDPM1-K16', majorId: 'major_udpm', count: 40 },
  { id: 'cls_udpm2_k16', code: 'UDPM2-K16', majorId: 'major_udpm', count: 38 },
  { id: 'cls_tkdh1_k16', code: 'TKĐH1-K16', majorId: 'major_tkdh', count: 45 },
  { id: 'cls_tkdh2_k16', code: 'TKĐH2-K16', majorId: 'major_tkdh', count: 45 },
  { id: 'cls_tkdh3_k16', code: 'TKĐH3-K16', majorId: 'major_tkdh', count: 42 },
  { id: 'cls_tkdh4_k16', code: 'TKĐH4-K16', majorId: 'major_tkdh', count: 42 },
  { id: 'cls_tkdh5_k16', code: 'TKĐH5-K16', majorId: 'major_tkdh', count: 40 },
  { id: 'cls_tkdh6_k16', code: 'TKĐH6-K16', majorId: 'major_tkdh', count: 40 },
  { id: 'cls_oto1_k16',  code: 'OTO1-K16',  majorId: 'major_oto',  count: 40 },
  { id: 'cls_oto2_k16',  code: 'OTO2-K16',  majorId: 'major_oto',  count: 40 },
  { id: 'cls_oto3_k16',  code: 'OTO3-K16',  majorId: 'major_oto',  count: 38 },
  { id: 'cls_oto4_k16',  code: 'OTO4-K16',  majorId: 'major_oto',  count: 38 },
  { id: 'cls_oto5_k16',  code: 'OTO5-K16',  majorId: 'major_oto',  count: 36 },
  { id: 'cls_cdt1_k16',  code: 'CĐT1-K16',  majorId: 'major_cdt',  count: 40 },
  { id: 'cls_cdt2_k16',  code: 'CĐT2-K16',  majorId: 'major_cdt',  count: 38 },
  { id: 'cls_dcn1_k16',  code: 'ĐCN1-K16',  majorId: 'major_dcn',  count: 40 },
  { id: 'cls_dcn2_k16',  code: 'ĐCN2-K16',  majorId: 'major_dcn',  count: 40 },
  { id: 'cls_tdh1_k16',  code: 'TĐH1-K16',  majorId: 'major_tdh',  count: 40 },
  { id: 'cls_dtcn1_k16', code: 'ĐTCN1-K16', majorId: 'major_dtcn', count: 38 },
  { id: 'cls_dtcn2_k16', code: 'ĐTCN2-K16', majorId: 'major_dtcn', count: 36 },
  { id: 'cls_cnctm_k16', code: 'CNCTM-K16', majorId: 'major_cnctm',count: 36 },
  { id: 'cls_ktml1_k16', code: 'KTML1-K16', majorId: 'major_ktml', count: 38 },
  { id: 'cls_ktml2_k16', code: 'KTML2-K16', majorId: 'major_ktml', count: 36 },
  { id: 'cls_ddd_k16',   code: 'ĐDD-K16',   majorId: 'major_ddd',  count: 36 },
  { id: 'cls_tmdt1_k16', code: 'TMĐT1-K16', majorId: 'major_tmdt', count: 42 },
  { id: 'cls_tmdt2_k16', code: 'TMĐT2-K16', majorId: 'major_tmdt', count: 40 },
  { id: 'cls_qtdn_k16',  code: 'QTDN-K16',  majorId: 'major_qtdn', count: 42 },
  { id: 'cls_ktdn_k16',  code: 'KTDN-K16',  majorId: 'major_ktdn', count: 40 },
];

const K17_CLASSES = [
  { id: 'cls_ltmt1_k17', code: 'LTMT1-K17', majorId: 'major_ltmt', count: 45 },
  { id: 'cls_ltmt2_k17', code: 'LTMT2-K17', majorId: 'major_ltmt', count: 43 },
  { id: 'cls_ltmt3_k17', code: 'LTMT3-K17', majorId: 'major_ltmt', count: 42 },
  { id: 'cls_ltmt4_k17', code: 'LTMT4-K17', majorId: 'major_ltmt', count: 40 },
  { id: 'cls_qtm1_k17',  code: 'QTM1-K17',  majorId: 'major_qtm',  count: 45 },
  { id: 'cls_qtm2_k17',  code: 'QTM2-K17',  majorId: 'major_qtm',  count: 43 },
  { id: 'cls_udpm1_k17', code: 'UDPM1-K17', majorId: 'major_udpm', count: 43 },
  { id: 'cls_udpm2_k17', code: 'UDPM2-K17', majorId: 'major_udpm', count: 41 },
  { id: 'cls_tkdh1_k17', code: 'TKĐH1-K17', majorId: 'major_tkdh', count: 48 },
  { id: 'cls_tkdh2_k17', code: 'TKĐH2-K17', majorId: 'major_tkdh', count: 47 },
  { id: 'cls_tkdh3_k17', code: 'TKĐH3-K17', majorId: 'major_tkdh', count: 46 },
  { id: 'cls_tkdh4_k17', code: 'TKĐH4-K17', majorId: 'major_tkdh', count: 45 },
  { id: 'cls_tkdh5_k17', code: 'TKĐH5-K17', majorId: 'major_tkdh', count: 44 },
  { id: 'cls_tkdh6_k17', code: 'TKĐH6-K17', majorId: 'major_tkdh', count: 43 },
  { id: 'cls_tkdh7_k17', code: 'TKĐH7-K17', majorId: 'major_tkdh', count: 42 },
  { id: 'cls_oto1_k17',  code: 'OTO1-K17',  majorId: 'major_oto',  count: 43 },
  { id: 'cls_oto2_k17',  code: 'OTO2-K17',  majorId: 'major_oto',  count: 42 },
  { id: 'cls_oto3_k17',  code: 'OTO3-K17',  majorId: 'major_oto',  count: 41 },
  { id: 'cls_oto4_k17',  code: 'OTO4-K17',  majorId: 'major_oto',  count: 40 },
  { id: 'cls_oto5_k17',  code: 'OTO5-K17',  majorId: 'major_oto',  count: 40 },
  { id: 'cls_oto6_k17',  code: 'OTO6-K17',  majorId: 'major_oto',  count: 38 },
  { id: 'cls_cdt1_k17',  code: 'CĐT1-K17',  majorId: 'major_cdt',  count: 42 },
  { id: 'cls_cdt2_k17',  code: 'CĐT2-K17',  majorId: 'major_cdt',  count: 40 },
  { id: 'cls_cdt3_k17',  code: 'CĐT3-K17',  majorId: 'major_cdt',  count: 38 },
  { id: 'cls_dcn1_k17',  code: 'ĐCN1-K17',  majorId: 'major_dcn',  count: 43 },
  { id: 'cls_dcn2_k17',  code: 'ĐCN2-K17',  majorId: 'major_dcn',  count: 42 },
  { id: 'cls_dcn3_k17',  code: 'ĐCN3-K17',  majorId: 'major_dcn',  count: 40 },
  { id: 'cls_tdh1_k17',  code: 'TĐH1-K17',  majorId: 'major_tdh',  count: 42 },
  { id: 'cls_tdh2_k17',  code: 'TĐH2-K17',  majorId: 'major_tdh',  count: 40 },
  { id: 'cls_dtcn1_k17', code: 'ĐTCN1-K17', majorId: 'major_dtcn', count: 42 },
  { id: 'cls_dtcn2_k17', code: 'ĐTCN2-K17', majorId: 'major_dtcn', count: 40 },
  { id: 'cls_cnctm_k17', code: 'CNCTM-K17', majorId: 'major_cnctm',count: 40 },
  { id: 'cls_ktml1_k17', code: 'KTML1-K17', majorId: 'major_ktml', count: 42 },
  { id: 'cls_ktml2_k17', code: 'KTML2-K17', majorId: 'major_ktml', count: 40 },
  { id: 'cls_ddd_k17',   code: 'ĐDD-K17',   majorId: 'major_ddd',  count: 38 },
  { id: 'cls_tmdt1_k17', code: 'TMĐT1-K17', majorId: 'major_tmdt', count: 46 },
  { id: 'cls_tmdt2_k17', code: 'TMĐT2-K17', majorId: 'major_tmdt', count: 44 },
  { id: 'cls_qtdn_k17',  code: 'QTDN-K17',  majorId: 'major_qtdn', count: 45 },
  { id: 'cls_ktdn_k17',  code: 'KTDN-K17',  majorId: 'major_ktdn', count: 43 },
];

// Phòng THEORY và PRACTICE
const THEORY_ROOMS = ['room_a17_401','room_a17_402','room_a17_403','room_a17_404','room_a17_405',
                      'room_a17_406','room_a17_407','room_a17_408','room_a17_409',
                      'room_a17_501a','room_a17_501b','room_a17_502','room_a17_504',
                      'room_c4b_1','room_c4b_2','room_c4b_3','room_c4b_4','room_c4b_5','room_c4b_6'];
const PRACTICE_ROOMS = ['room_pm_301','room_pm_302','room_pm_303','room_pm_304','room_pm_305',
                        'room_pm_306','room_pm_401','room_pm_402','room_pm_403','room_pm_404',
                        'room_pm_405','room_pm_406','room_pm_407','room_pm_408','room_pm_409',
                        'room_b4_301','room_d_303'];

// ─── Slot generator (không trùng nhau trong cùng tuần/ngày/tiết) ─────────────
// Mỗi lớp/môn: 1 buổi / tuần, 3 tiết liên tiếp
// Kíp sáng: tiết 1-3, 2-4, 4-6 | Kíp chiều: tiết 7-9, 8-10, 10-12
const MORNING_SLOTS = [[1,3],[2,4],[4,6]];
const AFTERNOON_SLOTS = [[7,9],[8,10],[10,12]];
const ALL_SLOTS = [...MORNING_SLOTS, ...AFTERNOON_SLOTS];

// Theo dõi slot đã dùng: key = "week-day-periodStart-roomId"
const usedSlots = new Map(); // tuần → Set<"day-pStart-roomId">

function bookSlot(week, day, pStart, roomId) {
  const key = `${day}-${pStart}-${roomId}`;
  if (!usedSlots.has(week)) usedSlots.set(week, new Set());
  usedSlots.get(week).add(key);
}
function isSlotFree(week, day, pStart, roomId) {
  if (!usedSlots.has(week)) return true;
  return !usedSlots.get(week).has(`${day}-${pStart}-${roomId}`);
}

function findFreeSlot(week, roomId) {
  const days = shuffle([2,3,4,5,6,7]);
  const slots = shuffle(ALL_SLOTS);
  for (const day of days) {
    for (const [ps, pe] of slots) {
      if (isSlotFree(week, day, ps, roomId)) {
        bookSlot(week, day, ps, roomId);
        return { day, periodStart: ps, periodEnd: pe };
      }
    }
  }
  return null; // phòng full (hiếm)
}

// ─── Main ────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🚀 Bắt đầu seed dữ liệu lớn...\n');

  // 1. Pre-load existing data dùng cho phân công
  const existingMajors = await prisma.major.findMany();
  const majorMap = Object.fromEntries(existingMajors.map(m => [m.id, m]));

  // 2. Tạo class groups cho K16 (bỏ qua cls_tdh1_k16 đã có)
  console.log('📚 Tạo lớp K16...');
  const existingClasses = await prisma.classGroup.findMany({ select: { id: true } });
  const existingClassIds = new Set(existingClasses.map(c => c.id));

  let newClassCount = 0;
  for (const cls of K16_CLASSES) {
    if (existingClassIds.has(cls.id)) continue;
    await prisma.classGroup.create({
      data: { id: cls.id, code: cls.code, majorId: cls.majorId, cohortId: 'cohort_k16', studentCount: cls.count },
    });
    newClassCount++;
  }
  console.log(`  Tạo ${newClassCount} lớp K16 mới`);

  console.log('📚 Tạo lớp K17...');
  newClassCount = 0;
  for (const cls of K17_CLASSES) {
    if (existingClassIds.has(cls.id)) continue;
    await prisma.classGroup.create({
      data: { id: cls.id, code: cls.code, majorId: cls.majorId, cohortId: 'cohort_k17', studentCount: cls.count },
    });
    newClassCount++;
  }
  console.log(`  Tạo ${newClassCount} lớp K17 mới`);

  // 3. Sinh sinh viên cho từng lớp
  // Lấy users hiện có để tránh trùng email
  const existingUsers = await prisma.user.findMany({ select: { email: true } });
  const existingEmails = new Set(existingUsers.map(u => u.email));

  // Hash mặc định cho sinh viên (cost 10)
  console.log('\n🔑 Tạo hash mặc định cho sinh viên...');
  const studentHash = await bcrypt.hash('Student@123', 10);

  const allNewClasses = [...K16_CLASSES, ...K17_CLASSES];
  let totalStudents = 0;
  let totalUsers = 0;

  for (const cls of allNewClasses) {
    const cohortYear = cls.id.includes('_k16') ? '23' : '24';
    const count = cls.count;

    console.log(`  👥 ${cls.code}: ${count} sinh viên...`);

    const students = [];
    const usersToCreate = [];

    for (let i = 0; i < count; i++) {
      const name = randomViName();
      const svCode = genStudentCode(cohortYear);
      const loginName = nameToLogin(name);
      let email = `${loginName}.${svCode.replace('CD','')}@student.hactech.edu.vn`;
      // Đảm bảo email không trùng
      let suffix = 1;
      while (existingEmails.has(email)) {
        email = `${loginName}${suffix}.${svCode.replace('CD','')}@student.hactech.edu.vn`;
        suffix++;
      }
      existingEmails.add(email);

      const userId = `usr_sv_${svCode.toLowerCase()}`;
      students.push({ svCode, name, email, userId });

      usersToCreate.push({
        id: userId,
        email,
        passwordHash: studentHash,
        role: 'STUDENT',
        refId: cls.id,
        name,
      });
    }

    // Bulk insert users
    await prisma.user.createMany({ data: usersToCreate, skipDuplicates: true });
    totalStudents += count;
    totalUsers += usersToCreate.length;
  }
  console.log(`\n  ✅ Tổng cộng: ${totalStudents} sinh viên, ${totalUsers} tài khoản user\n`);

  // 4. Tạo Assignment + TeachingUnit + Schedule
  console.log('📅 Tạo lịch học...');

  // Load subjects
  const subjects = await prisma.subject.findMany();
  const subjectMap = Object.fromEntries(subjects.map(s => [s.id, s]));

  // Tải slots đã dùng từ DB hiện có
  console.log('  Đang load slots hiện có...');
  const existingSchedules = await prisma.schedule.findMany({
    select: { weekNumber: true, dayOfWeek: true, periodStart: true, roomId: true },
  });
  for (const s of existingSchedules) {
    if (s.roomId) bookSlot(s.weekNumber, s.dayOfWeek, s.periodStart, s.roomId);
  }

  // Tạo assignments và schedules theo từng học kỳ
  // Mỗi học kỳ: mỗi lớp học 5-6 môn, mỗi môn 1 buổi/tuần
  // Tổng: K15 (52 lớp) + K16 (33 lớp) + K17 (39 lớp) = 124 lớp

  const allClasses = await prisma.classGroup.findMany({ include: { cohort: true, major: true } });
  const classMap = Object.fromEntries(allClasses.map(c => [c.id, c]));

  // Phân lớp theo khóa
  const k15Classes = allClasses.filter(c => c.cohort.code === 'K15');
  const k16Classes = allClasses.filter(c => c.cohort.code === 'K16');
  const k17Classes = allClasses.filter(c => c.cohort.code === 'K17');

  // Check assignments đã tồn tại
  const existingAsgn = await prisma.assignment.findMany({ select: { id: true } });
  const existingAsgnIds = new Set(existingAsgn.map(a => a.id));
  const existingTU = await prisma.teachingUnit.findMany({ select: { id: true } });
  const existingTUIds = new Set(existingTU.map(t => t.id));

  let totalSched = 0;

  // Helper: tạo schedule cho một lớp trong một học kỳ
  async function seedClassSemester(classId, majorCode, cohortCode, semNo, weekStart, weekEnd) {
    const curriculum = getCurriculum(majorCode);
    const subIds = curriculum[semNo] || curriculum[1];
    const teachers = getTeachersForMajor(majorCode);

    const weekList = [];
    for (let w = weekStart; w <= weekEnd; w++) weekList.push(w);

    const scheduleRows = [];
    const asnToCreate = [];
    const tuToCreate = [];

    for (let si = 0; si < subIds.length; si++) {
      const subId = subIds[si];
      const sub = subjectMap[subId];
      if (!sub) continue;

      const shortCls = classId.replace('cls_','').replace('_k15','').replace('_k16','').replace('_k17','');
      const asnId = `asn_${subId.replace('sub_','')}_${shortCls}_hk${semNo}`;
      const tuId  = `tu_${subId.replace('sub_','')}_${shortCls}_hk${semNo}`;

      const teacherId = pick(teachers);

      if (!existingAsgnIds.has(asnId)) {
        asnToCreate.push({ id: asnId, teacherId, classGroupId: classId });
        existingAsgnIds.add(asnId);
      }
      if (!existingTUIds.has(tuId)) {
        tuToCreate.push({ id: tuId, subjectId: subId, assignmentId: asnId, type: sub.isPractice ? 'PRACTICE' : 'THEORY', name: `${sub.code}-${shortCls}-HK${semNo}` });
        existingTUIds.add(tuId);
      }

      const roomPool = sub.isPractice ? PRACTICE_ROOMS : THEORY_ROOMS;

      for (const week of weekList) {
        const roomId = pick(roomPool);
        const slot = findFreeSlot(week, roomId);
        if (!slot) continue;

        const schId = `sch_${subId.replace('sub_','')}_${shortCls}_w${week}`;
        scheduleRows.push({
          id: schId,
          teachingUnitId: tuId,
          roomId,
          dayOfWeek: slot.day,
          periodStart: slot.periodStart,
          periodEnd: slot.periodEnd,
          weekNumber: week,
          mode: 'OFFLINE',
        });
      }
    }

    // Bulk insert
    if (asnToCreate.length > 0) {
      await prisma.assignment.createMany({ data: asnToCreate, skipDuplicates: true });
    }
    if (tuToCreate.length > 0) {
      await prisma.teachingUnit.createMany({ data: tuToCreate, skipDuplicates: true });
    }
    if (scheduleRows.length > 0) {
      await prisma.schedule.createMany({ data: scheduleRows, skipDuplicates: true });
      totalSched += scheduleRows.length;
    }
  }

  // ── K15: HK5 bổ sung tuần 7-25 (đã có 4,5,6,23,24,25 → thêm 7-22)
  //         HK6 tuần 27-46
  console.log('  K15: Bổ sung HK5 + HK6...');
  const k15Subset = k15Classes.slice(0, 20); // chỉ lấy 20 lớp CNTT+TKĐH để không quá nặng
  for (const cls of k15Subset) {
    await seedClassSemester(cls.id, cls.major.code, 'K15', 5, 7, 22);
    await seedClassSemester(cls.id, cls.major.code, 'K15', 6, 27, 46);
    process.stdout.write('.');
  }
  console.log();

  // ── K16: HK3 tuần 27-46, HK5 tuần 53-72, HK6 tuần 79-98
  console.log('  K16: HK3 + HK5 + HK6...');
  for (const cls of k16Classes) {
    await seedClassSemester(cls.id, cls.major.code, 'K16', 3, 27, 46);
    await seedClassSemester(cls.id, cls.major.code, 'K16', 5, 53, 72);
    await seedClassSemester(cls.id, cls.major.code, 'K16', 6, 79, 98);
    process.stdout.write('.');
  }
  console.log();

  // ── K17: HK2 tuần 27-46, HK3 tuần 53-72, HK4 tuần 79-98
  console.log('  K17: HK2 + HK3 + HK4...');
  for (const cls of k17Classes) {
    await seedClassSemester(cls.id, cls.major.code, 'K17', 2, 27, 46);
    await seedClassSemester(cls.id, cls.major.code, 'K17', 3, 53, 72);
    await seedClassSemester(cls.id, cls.major.code, 'K17', 4, 79, 98);
    process.stdout.write('.');
  }
  console.log();

  console.log(`\n  ✅ Tổng lịch học mới: ${totalSched} bản ghi\n`);

  // 5. Kiểm tra tổng kết
  const [totalClasses, totalUsers2, totalSchedules] = await Promise.all([
    prisma.classGroup.count(),
    prisma.user.count(),
    prisma.schedule.count(),
  ]);

  console.log('═══════════════════════════════════════');
  console.log('📊 KẾT QUẢ CUỐI:');
  console.log(`  Lớp học:    ${totalClasses}`);
  console.log(`  Tài khoản:  ${totalUsers2}`);
  console.log(`  Lịch học:   ${totalSchedules}`);
  console.log('═══════════════════════════════════════');

  await prisma.$disconnect();
}

main().catch(e => {
  console.error('❌ Lỗi:', e.message);
  prisma.$disconnect();
  process.exit(1);
});
