/**
 * seed_curricula.js
 * Tạo đầy đủ Subject + Curriculum cho 4 ngành CNTT:
 *   - QTM  : Quản trị mạng máy tính
 *   - LTMT : Lập trình máy tính
 *   - UDPM : Ứng dụng phần mềm
 *   - TKĐH : Thiết kế đồ họa
 *
 * Dữ liệu dựa trên "Chương trình, kế hoạch đào tạo hệ Cao đẳng"
 * của Trường CĐN Bách Khoa Hà Nội (HACTECH)
 *
 * Curriculum.weekStart / weekEnd = vị trí trong học kỳ (1-based, tối đa 20 tuần/HK)
 * periodsPerWeek = tổng giờ / 15 tuần thực học, làm tròn
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// ─── Mapping major code → major DB id ────────────────────────────────────────
// Các major này đã tồn tại từ seed_bulk.js
const MAJOR_IDS = {
  QTM:   'major_qtm',
  LTMT:  'major_ltmt',
  UDPM:  'major_udpm',
  'TKĐH': 'major_tkdh',
};

// ─── Định nghĩa môn học ───────────────────────────────────────────────────────
// Mỗi môn: { id, code, name, credits, roomType, isPractice }
// roomType: THEORY | PRACTICE | HALL
// HALL cho các môn chính trị/pháp luật/giáo dục QP (lớp lớn)
// PRACTICE cho thực tập / thực hành phòng máy

const SUBJECTS = [
  // ── Môn học chung (dùng chung tất cả ngành) ──────────────────────────────
  { id: 'sub_mh01', code: 'MH01', name: 'Chính trị',                        credits: 90/30, roomType: 'HALL',     isPractice: false },
  { id: 'sub_mh02', code: 'MH02', name: 'Pháp luật',                         credits: 30/30, roomType: 'HALL',     isPractice: false },
  { id: 'sub_mh03', code: 'MH03', name: 'Toán cao cấp',                      credits: 45/30, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh04', code: 'MH04', name: 'Tin học căn bản',                   credits: 60/30, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh05', code: 'MH05', name: 'Anh văn 1',                         credits: 60/30, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh06', code: 'MH06', name: 'Giáo dục Quốc phòng',               credits: 75/30, roomType: 'HALL',     isPractice: false },
  { id: 'sub_mh07', code: 'MH07', name: 'Giáo dục thể chất',                 credits: 60/30, roomType: 'HALL',     isPractice: false },
  { id: 'sub_mh08', code: 'MH08', name: 'Anh văn 2',                         credits: 60/30, roomType: 'THEORY',   isPractice: false },

  // ── Kỹ thuật cơ sở CNTT (QTM / LTMT) ────────────────────────────────────
  { id: 'sub_mh09', code: 'MH09', name: 'Tin học văn phòng',                  credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh10', code: 'MH10', name: 'Cấu trúc máy tính',                  credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh11', code: 'MH11', name: 'Lập trình căn bản',                  credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh12', code: 'MH12', name: 'Cài đặt & bảo trì máy tính',         credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh13', code: 'MH13', name: 'Nhập môn mạng máy tính',             credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh14', code: 'MH14', name: 'Công nghệ mạng không dây',           credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh15', code: 'MH15', name: 'Kỹ thuật điện tử',                   credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh16', code: 'MH16', name: 'Anh văn chuyên ngành 1',             credits: 1, roomType: 'THEORY',   isPractice: false },

  // ── Chuyên môn nghề QTM ───────────────────────────────────────────────────
  { id: 'sub_mh17', code: 'MH17', name: 'Cơ sở dữ liệu',                      credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh18', code: 'MH18', name: 'Lập trình hướng đối tượng',          credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh19', code: 'MH19', name: 'Cấu trúc dữ liệu & giải thuật',      credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh20', code: 'MH20', name: 'Thiết kế Website',                   credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh21', code: 'MH21', name: 'Quản trị mạng Windows',              credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh22', code: 'MH22', name: 'Thực tập nhận thức',                 credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh23', code: 'MH23', name: 'Anh văn chuyên ngành 2',             credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh24', code: 'MH24', name: 'Hệ quản trị CSDL SQL Server',        credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh25', code: 'MH25', name: 'Lập trình mạng',                     credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh26', code: 'MH26', name: 'Quản trị hệ thống WebServer & MailServer', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_mh27', code: 'MH27', name: 'Phân tích thiết kế hệ thống',        credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh28', code: 'MH28', name: 'Hệ điều hành Linux',                 credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh29', code: 'MH29', name: 'Thực tập nghề nghiệp',               credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh30', code: 'MH30', name: 'Hệ thống tường lửa',                 credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh31', code: 'MH31', name: 'Kỹ năng mềm',                        credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh32', code: 'MH32', name: 'Xây dựng Website bằng PMMNM',        credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh33', code: 'MH33', name: 'Quản trị mạng Linux',                credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh34', code: 'MH34', name: 'Bảo trì hệ thống mạng',              credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh35', code: 'MH35', name: 'An toàn mạng',                       credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh36', code: 'MH36', name: 'Thiết kế xây dựng mạng LAN',        credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh37', code: 'MH37', name: 'Kỹ thuật truyền số liệu',            credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_mh38', code: 'MH38', name: 'Thực tập tốt nghiệp',                credits: 7, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_mh39', code: 'MH39', name: 'Đồ án / Thi tốt nghiệp',            credits: 12, roomType: 'PRACTICE', isPractice: true  },

  // ── Chuyên môn LTMT (mã riêng khác QTM) ─────────────────────────────────
  { id: 'sub_lt_mh15', code: 'LT-MH15', name: 'Cơ sở dữ liệu (LTMT)',            credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh17', code: 'LT-MH17', name: 'Kỹ thuật lập trình',              credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh18', code: 'LT-MH18', name: 'Hệ quản trị CSDL M.Access',       credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh19', code: 'LT-MH19', name: 'Cấu trúc dữ liệu và giải thuật', credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh20', code: 'LT-MH20', name: 'Lập trình hướng đối tượng',       credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh21', code: 'LT-MH21', name: 'Lập trình C#',                    credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh22', code: 'LT-MH22', name: 'Thực tập nhận thức (LTMT)',       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh23', code: 'LT-MH23', name: 'Anh văn chuyên ngành 2 (LTMT)',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh24', code: 'LT-MH24', name: 'Hệ quản trị CSDL SQL Server',     credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh25', code: 'LT-MH25', name: 'Lập trình Service',               credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh26', code: 'LT-MH26', name: 'Nhập môn công nghệ phần mềm',     credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh27', code: 'LT-MH27', name: 'Phân tích & thiết kế hệ thống',   credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh28', code: 'LT-MH28', name: 'Thiết kế Website (LTMT)',          credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh29', code: 'LT-MH29', name: 'Hệ điều hành Linux (LTMT)',       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh30', code: 'LT-MH30', name: 'Thực tập nghề nghiệp (LTMT)',     credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh31', code: 'LT-MH31', name: 'Kỹ năng mềm (LTMT)',             credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_lt_mh32', code: 'LT-MH32', name: 'Lập trình PHP.NET',               credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh33', code: 'LT-MH33', name: 'Lập trình thiết bị di động',      credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh34', code: 'LT-MH34', name: 'Lập trình Linux',                 credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh35', code: 'LT-MH35', name: 'Xây dựng phần mềm quản lý',      credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh36', code: 'LT-MH36', name: 'Lập trình XML',                   credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh37', code: 'LT-MH37', name: 'Thực tập tốt nghiệp (LTMT)',      credits: 7, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_lt_mh38', code: 'LT-MH38', name: 'Đồ án tốt nghiệp (LTMT)',        credits: 12, roomType: 'PRACTICE', isPractice: true  },

  // ── Chuyên môn UDPM ───────────────────────────────────────────────────────
  { id: 'sub_ud_mh09', code: 'UD-MH09', name: 'Soạn thảo văn bản',               credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh14', code: 'UD-MH14', name: 'Bảng tính Excel',                 credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh15', code: 'UD-MH15', name: 'Anh văn chuyên ngành 1 (UDPM)',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh16', code: 'UD-MH16', name: 'Cơ sở dữ liệu (UDPM)',            credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh17', code: 'UD-MH17', name: 'Quản trị mạng Windows (UDPM)',    credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh18', code: 'UD-MH18', name: 'Hệ quản trị CSDL M.Access (UDPM)', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_ud_mh19', code: 'UD-MH19', name: 'Cấu trúc dữ liệu và giải thuật (UDPM)', credits: 2, roomType: 'THEORY', isPractice: false },
  { id: 'sub_ud_mh20', code: 'UD-MH20', name: 'Xây dựng WebSite bằng HTML5',     credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh21', code: 'UD-MH21', name: 'Thực tập nhận thức (UDPM)',       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh22', code: 'UD-MH22', name: 'Anh văn chuyên ngành 2 (UDPM)',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh23', code: 'UD-MH23', name: 'Xử lý ảnh',                       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh24', code: 'UD-MH24', name: 'Hệ quản trị CSDL SQL Server (UDPM)', credits: 2, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_ud_mh25', code: 'UD-MH25', name: 'Thiết kế đồ họa bằng Corel Draw', credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh26', code: 'UD-MH26', name: 'Lập trình Web',                   credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh27', code: 'UD-MH27', name: 'Phân tích & thiết kế hệ thống (UDPM)', credits: 2, roomType: 'THEORY', isPractice: false },
  { id: 'sub_ud_mh28', code: 'UD-MH28', name: 'Hệ điều hành LINUX (UDPM)',       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh29', code: 'UD-MH29', name: 'Thực tập nghề nghiệp (UDPM)',     credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh30', code: 'UD-MH30', name: 'Kế toán đại cương',               credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh31', code: 'UD-MH31', name: 'Kỹ năng mềm (UDPM)',             credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh32', code: 'UD-MH32', name: 'An toàn và bảo mật thông tin',   credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh33', code: 'UD-MH33', name: 'Xây dựng Website bằng PMMNM (UDPM)', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_ud_mh34', code: 'UD-MH34', name: 'Quản lý dự án công nghệ thông tin', credits: 2, roomType: 'THEORY', isPractice: false },
  { id: 'sub_ud_mh35', code: 'UD-MH35', name: 'Tổ chức quản lý doanh nghiệp',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_ud_mh36', code: 'UD-MH36', name: 'Xây dựng phần mềm quản lý (UDPM)', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_ud_mh37', code: 'UD-MH37', name: 'Thiết kế trình diễn trên máy tính', credits: 2, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_ud_mh38', code: 'UD-MH38', name: 'Thực tập tốt nghiệp (UDPM)',      credits: 7, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_ud_mh39', code: 'UD-MH39', name: 'Đồ án / Thi tốt nghiệp (UDPM)', credits: 12, roomType: 'PRACTICE', isPractice: true  },

  // ── Chuyên môn TKĐH ──────────────────────────────────────────────────────
  { id: 'sub_tk_mh09', code: 'TK-MH09', name: 'Tin học văn phòng (TKĐH)',         credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh10', code: 'TK-MH10', name: 'Cấu trúc máy tính (TKĐH)',         credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh11', code: 'TK-MH11', name: 'Lập trình căn bản (TKĐH)',         credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh12', code: 'TK-MH12', name: 'Hình họa cơ bản',                  credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh13', code: 'TK-MH13', name: 'Lịch sử mỹ thuật',                credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh14', code: 'TK-MH14', name: 'Thiết kế đồ họa bằng Corel Draw', credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh15', code: 'TK-MH15', name: 'Khoa học màu sắc và nghiên cứu thiên nhiên', credits: 3, roomType: 'THEORY', isPractice: false },
  { id: 'sub_tk_mh16', code: 'TK-MH16', name: 'Anh văn chuyên ngành 1 (TKĐH)',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh17', code: 'TK-MH17', name: 'Cơ sở dữ liệu (TKĐH)',            credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh18', code: 'TK-MH18', name: 'Thiết kế đồ họa cơ bản',          credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh19', code: 'TK-MH19', name: 'Hình họa ứng dụng',               credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh20', code: 'TK-MH20', name: 'Corel Draw nâng cao',              credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh21', code: 'TK-MH21', name: 'Cơ sở tạo hình trên mặt phẳng',  credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh22', code: 'TK-MH22', name: 'Tạo hình 2D (Illustrator)',        credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh23', code: 'TK-MH23', name: 'Thực tập nhận thức (TKĐH)',       credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh24', code: 'TK-MH24', name: 'Anh văn chuyên ngành 2 (TKĐH)',   credits: 1, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh25', code: 'TK-MH25', name: 'Thiết kế đồ họa chuyên ngành công thương nghiệp', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_tk_mh26', code: 'TK-MH26', name: 'Chế bản điện tử',                 credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh27', code: 'TK-MH27', name: 'Thiết kế Website (TKĐH)',          credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh28', code: 'TK-MH28', name: 'Xử lý ảnh (TKĐH)',               credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh29', code: 'TK-MH29', name: 'Cơ sở tạo hình khối không gian',  credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh30', code: 'TK-MH30', name: 'Thực tập nghề nghiệp (TKĐH)',     credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh31', code: 'TK-MH31', name: 'Kỹ năng mềm (TKĐH)',             credits: 2, roomType: 'THEORY',   isPractice: false },
  { id: 'sub_tk_mh32', code: 'TK-MH32', name: 'Các thiết bị ngoại vi',           credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh33', code: 'TK-MH33', name: 'Thiết kế đồ họa tổng hợp',       credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh34', code: 'TK-MH34', name: 'Dựng Video',                       credits: 3, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh35', code: 'TK-MH35', name: 'Flash',                            credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh36', code: 'TK-MH36', name: 'Thiết kế đồ họa chuyên ngành văn hóa', credits: 3, roomType: 'PRACTICE', isPractice: true },
  { id: 'sub_tk_mh37', code: 'TK-MH37', name: 'Xử lý ảnh nâng cao',              credits: 2, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh38', code: 'TK-MH38', name: 'Thực tập tốt nghiệp (TKĐH)',      credits: 7, roomType: 'PRACTICE', isPractice: true  },
  { id: 'sub_tk_mh39', code: 'TK-MH39', name: 'Đồ án / Thi tốt nghiệp (TKĐH)', credits: 12, roomType: 'PRACTICE', isPractice: true  },
];

// ─── Kế hoạch học tập → Curriculum entries ────────────────────────────────────
// Mỗi entry: { id, majorKey, subjectId, semesterNo, weekStart, weekEnd, periodsPerWeek }
// weekStart/weekEnd: 1-20 trong một học kỳ (20 tuần thực học/HK)
// periodsPerWeek = tổng giờ / 15 tuần thực học, làm tròn về 1 decimal → làm tròn lên

function pw(totalHours) {
  // periodsPerWeek ≈ tổng tiết / 15 tuần (1 tiết = 1 giờ học)
  return Math.max(1, Math.round(totalHours / 15));
}

// QTM — Quản trị mạng máy tính
// Từ tài liệu: HK1 (MH01-MH07), HK2 (MH08-MH15), HK3 (MH16-MH22),
//              HK4 (MH23-MH29), HK5 (MH30-MH36+MH37), HK6 (MH38+MH39)
const CURRICULA_QTM = [
  // HK1
  { subId: 'sub_mh01', sem: 1, h: 90 }, { subId: 'sub_mh02', sem: 1, h: 30 },
  { subId: 'sub_mh03', sem: 1, h: 45 }, { subId: 'sub_mh04', sem: 1, h: 60 },
  { subId: 'sub_mh05', sem: 1, h: 60 }, { subId: 'sub_mh06', sem: 1, h: 75 },
  { subId: 'sub_mh07', sem: 1, h: 60 },
  // HK2
  { subId: 'sub_mh08', sem: 2, h: 60 }, { subId: 'sub_mh09', sem: 2, h: 90 },
  { subId: 'sub_mh10', sem: 2, h: 60 }, { subId: 'sub_mh11', sem: 2, h: 60 },
  { subId: 'sub_mh12', sem: 2, h: 60 }, { subId: 'sub_mh13', sem: 2, h: 60 },
  { subId: 'sub_mh14', sem: 2, h: 60 }, { subId: 'sub_mh15', sem: 2, h: 60 },
  // HK3
  { subId: 'sub_mh16', sem: 3, h: 30 }, { subId: 'sub_mh17', sem: 3, h: 60 },
  { subId: 'sub_mh18', sem: 3, h: 90 }, { subId: 'sub_mh19', sem: 3, h: 60 },
  { subId: 'sub_mh20', sem: 3, h: 90 }, { subId: 'sub_mh21', sem: 3, h: 90 },
  { subId: 'sub_mh22', sem: 3, h: 60 },
  // HK4
  { subId: 'sub_mh23', sem: 4, h: 30 }, { subId: 'sub_mh24', sem: 4, h: 90 },
  { subId: 'sub_mh25', sem: 4, h: 90 }, { subId: 'sub_mh26', sem: 4, h: 90 },
  { subId: 'sub_mh27', sem: 4, h: 60 }, { subId: 'sub_mh28', sem: 4, h: 60 },
  { subId: 'sub_mh29', sem: 4, h: 60 },
  // HK5
  { subId: 'sub_mh30', sem: 5, h: 60 }, { subId: 'sub_mh31', sem: 5, h: 60 },
  { subId: 'sub_mh32', sem: 5, h: 90 }, { subId: 'sub_mh33', sem: 5, h: 60 },
  { subId: 'sub_mh34', sem: 5, h: 60 }, { subId: 'sub_mh35', sem: 5, h: 60 },
  { subId: 'sub_mh36', sem: 5, h: 60 }, { subId: 'sub_mh37', sem: 5, h: 60 },
  // HK6
  { subId: 'sub_mh38', sem: 6, h: 210 }, { subId: 'sub_mh39', sem: 6, h: 375 },
];

// LTMT — Lập trình máy tính
const CURRICULA_LTMT = [
  // HK1 (MH01-MH07 dùng chung)
  { subId: 'sub_mh01', sem: 1, h: 90 }, { subId: 'sub_mh02', sem: 1, h: 30 },
  { subId: 'sub_mh03', sem: 1, h: 45 }, { subId: 'sub_mh04', sem: 1, h: 60 },
  { subId: 'sub_mh05', sem: 1, h: 60 }, { subId: 'sub_mh06', sem: 1, h: 75 },
  { subId: 'sub_mh07', sem: 1, h: 60 },
  // HK2
  { subId: 'sub_mh08', sem: 2, h: 60 }, { subId: 'sub_mh09', sem: 2, h: 90 },
  { subId: 'sub_mh10', sem: 2, h: 60 }, { subId: 'sub_mh11', sem: 2, h: 60 },
  { subId: 'sub_mh12', sem: 2, h: 60 }, { subId: 'sub_mh13', sem: 2, h: 60 },
  { subId: 'sub_mh14', sem: 2, h: 60 }, { subId: 'sub_lt_mh15', sem: 2, h: 60 },
  // HK3
  { subId: 'sub_mh16', sem: 3, h: 30 }, { subId: 'sub_lt_mh17', sem: 3, h: 60 },
  { subId: 'sub_lt_mh18', sem: 3, h: 90 }, { subId: 'sub_lt_mh19', sem: 3, h: 60 },
  { subId: 'sub_lt_mh20', sem: 3, h: 90 }, { subId: 'sub_lt_mh21', sem: 3, h: 90 },
  { subId: 'sub_lt_mh22', sem: 3, h: 60 },
  // HK4
  { subId: 'sub_lt_mh23', sem: 4, h: 30 }, { subId: 'sub_lt_mh24', sem: 4, h: 60 },
  { subId: 'sub_lt_mh25', sem: 4, h: 90 }, { subId: 'sub_lt_mh26', sem: 4, h: 30 },
  { subId: 'sub_lt_mh27', sem: 4, h: 60 }, { subId: 'sub_lt_mh28', sem: 4, h: 90 },
  { subId: 'sub_lt_mh29', sem: 4, h: 60 }, { subId: 'sub_lt_mh30', sem: 4, h: 60 },
  // HK5
  { subId: 'sub_lt_mh31', sem: 5, h: 60 }, { subId: 'sub_lt_mh32', sem: 5, h: 90 },
  { subId: 'sub_lt_mh33', sem: 5, h: 90 }, { subId: 'sub_lt_mh34', sem: 5, h: 60 },
  { subId: 'sub_lt_mh35', sem: 5, h: 90 }, { subId: 'sub_lt_mh36', sem: 5, h: 90 },
  // HK6
  { subId: 'sub_lt_mh37', sem: 6, h: 210 }, { subId: 'sub_lt_mh38', sem: 6, h: 375 },
];

// UDPM — Ứng dụng phần mềm
const CURRICULA_UDPM = [
  // HK1 (MH01-MH07 dùng chung)
  { subId: 'sub_mh01', sem: 1, h: 90 }, { subId: 'sub_mh02', sem: 1, h: 30 },
  { subId: 'sub_mh03', sem: 1, h: 45 }, { subId: 'sub_mh04', sem: 1, h: 60 },
  { subId: 'sub_mh05', sem: 1, h: 60 }, { subId: 'sub_mh06', sem: 1, h: 75 },
  { subId: 'sub_mh07', sem: 1, h: 60 },
  // HK2
  { subId: 'sub_mh08', sem: 2, h: 60 }, { subId: 'sub_ud_mh09', sem: 2, h: 90 },
  { subId: 'sub_mh10', sem: 2, h: 60 }, { subId: 'sub_mh11', sem: 2, h: 60 },
  { subId: 'sub_mh12', sem: 2, h: 60 }, { subId: 'sub_mh13', sem: 2, h: 60 },
  { subId: 'sub_ud_mh14', sem: 2, h: 90 },
  // HK3
  { subId: 'sub_ud_mh15', sem: 3, h: 30 }, { subId: 'sub_ud_mh16', sem: 3, h: 60 },
  { subId: 'sub_ud_mh17', sem: 3, h: 90 }, { subId: 'sub_ud_mh18', sem: 3, h: 90 },
  { subId: 'sub_ud_mh19', sem: 3, h: 60 }, { subId: 'sub_ud_mh20', sem: 3, h: 90 },
  { subId: 'sub_ud_mh21', sem: 3, h: 60 },
  // HK4
  { subId: 'sub_ud_mh22', sem: 4, h: 30 }, { subId: 'sub_ud_mh23', sem: 4, h: 60 },
  { subId: 'sub_ud_mh24', sem: 4, h: 60 }, { subId: 'sub_ud_mh25', sem: 4, h: 60 },
  { subId: 'sub_ud_mh26', sem: 4, h: 90 }, { subId: 'sub_ud_mh27', sem: 4, h: 60 },
  { subId: 'sub_ud_mh28', sem: 4, h: 60 }, { subId: 'sub_ud_mh29', sem: 4, h: 60 },
  // HK5
  { subId: 'sub_ud_mh30', sem: 5, h: 60 }, { subId: 'sub_ud_mh31', sem: 5, h: 60 },
  { subId: 'sub_ud_mh32', sem: 5, h: 60 }, { subId: 'sub_ud_mh33', sem: 5, h: 90 },
  { subId: 'sub_ud_mh34', sem: 5, h: 45 }, { subId: 'sub_ud_mh35', sem: 5, h: 30 },
  { subId: 'sub_ud_mh36', sem: 5, h: 90 }, { subId: 'sub_ud_mh37', sem: 5, h: 60 },
  // HK6
  { subId: 'sub_ud_mh38', sem: 6, h: 210 }, { subId: 'sub_ud_mh39', sem: 6, h: 375 },
];

// TKĐH — Thiết kế đồ họa
const CURRICULA_TKDH = [
  // HK1 (MH01-MH07 dùng chung)
  { subId: 'sub_mh01', sem: 1, h: 90 }, { subId: 'sub_mh02', sem: 1, h: 30 },
  { subId: 'sub_mh03', sem: 1, h: 45 }, { subId: 'sub_mh04', sem: 1, h: 60 },
  { subId: 'sub_mh05', sem: 1, h: 60 }, { subId: 'sub_mh06', sem: 1, h: 75 },
  { subId: 'sub_mh07', sem: 1, h: 60 },
  // HK2
  { subId: 'sub_mh08', sem: 2, h: 60 }, { subId: 'sub_tk_mh09', sem: 2, h: 90 },
  { subId: 'sub_tk_mh10', sem: 2, h: 60 }, { subId: 'sub_tk_mh11', sem: 2, h: 60 },
  { subId: 'sub_tk_mh12', sem: 2, h: 60 }, { subId: 'sub_tk_mh13', sem: 2, h: 30 },
  { subId: 'sub_tk_mh14', sem: 2, h: 60 }, { subId: 'sub_tk_mh15', sem: 2, h: 90 },
  // HK3
  { subId: 'sub_tk_mh16', sem: 3, h: 30 }, { subId: 'sub_tk_mh17', sem: 3, h: 60 },
  { subId: 'sub_tk_mh18', sem: 3, h: 60 }, { subId: 'sub_tk_mh19', sem: 3, h: 90 },
  { subId: 'sub_tk_mh20', sem: 3, h: 45 }, { subId: 'sub_tk_mh21', sem: 3, h: 60 },
  { subId: 'sub_tk_mh22', sem: 3, h: 90 }, { subId: 'sub_tk_mh23', sem: 3, h: 60 },
  // HK4
  { subId: 'sub_tk_mh24', sem: 4, h: 30 }, { subId: 'sub_tk_mh25', sem: 4, h: 90 },
  { subId: 'sub_tk_mh26', sem: 4, h: 60 }, { subId: 'sub_tk_mh27', sem: 4, h: 90 },
  { subId: 'sub_tk_mh28', sem: 4, h: 60 }, { subId: 'sub_tk_mh29', sem: 4, h: 60 },
  { subId: 'sub_tk_mh30', sem: 4, h: 60 },
  // HK5
  { subId: 'sub_tk_mh31', sem: 5, h: 60 }, { subId: 'sub_tk_mh32', sem: 5, h: 60 },
  { subId: 'sub_tk_mh33', sem: 5, h: 60 }, { subId: 'sub_tk_mh34', sem: 5, h: 90 },
  { subId: 'sub_tk_mh35', sem: 5, h: 60 }, { subId: 'sub_tk_mh36', sem: 5, h: 90 },
  { subId: 'sub_tk_mh37', sem: 5, h: 45 },
  // HK6
  { subId: 'sub_tk_mh38', sem: 6, h: 210 }, { subId: 'sub_tk_mh39', sem: 6, h: 375 },
];

const ALL_CURRICULA = [
  { majorKey: 'QTM',   list: CURRICULA_QTM  },
  { majorKey: 'LTMT',  list: CURRICULA_LTMT },
  { majorKey: 'UDPM',  list: CURRICULA_UDPM },
  { majorKey: 'TKĐH',  list: CURRICULA_TKDH },
];

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🚀 Bắt đầu seed curricula...\n');

  // 1. Upsert tất cả subjects
  console.log(`📚 Upsert ${SUBJECTS.length} môn học...`);
  let subCreated = 0, subUpdated = 0;
  for (const s of SUBJECTS) {
    const credits = Math.max(1, Math.round(s.credits));
    const existing = await prisma.subject.findUnique({ where: { id: s.id } });
    if (existing) {
      await prisma.subject.update({
        where: { id: s.id },
        data: { code: s.code, name: s.name, credits, roomType: s.roomType, isPractice: s.isPractice },
      });
      subUpdated++;
    } else {
      // Check by code
      const byCode = await prisma.subject.findUnique({ where: { code: s.code } });
      if (byCode) {
        await prisma.subject.update({
          where: { code: s.code },
          data: { name: s.name, credits, roomType: s.roomType, isPractice: s.isPractice },
        });
        subUpdated++;
      } else {
        await prisma.subject.create({
          data: { id: s.id, code: s.code, name: s.name, credits, roomType: s.roomType, isPractice: s.isPractice },
        });
        subCreated++;
      }
    }
  }
  console.log(`  ✅ Tạo mới: ${subCreated}, Cập nhật: ${subUpdated}\n`);

  // 2. Lấy major IDs
  const majors = await prisma.major.findMany({ select: { id: true, code: true } });
  const majorByCode = Object.fromEntries(majors.map(m => [m.code, m.id]));

  // 3. Upsert curricula
  let curCreated = 0, curSkipped = 0;
  for (const { majorKey, list } of ALL_CURRICULA) {
    const majorId = majorByCode[majorKey];
    if (!majorId) {
      console.warn(`  ⚠️  Không tìm thấy major: ${majorKey}, bỏ qua`);
      continue;
    }
    console.log(`📋 ${majorKey}: ${list.length} curriculum entries...`);

    for (const entry of list) {
      const curId = `cur_${majorKey.toLowerCase()}_${entry.subId}_hk${entry.sem}`;
      const weekEnd = entry.sem === 6 ? 20 : 17; // HK6 có thực tập/đồ án đến cuối kỳ
      const periodsPerWeek = pw(entry.h);

      const existing = await prisma.curriculum.findUnique({ where: { id: curId } });
      if (existing) {
        await prisma.curriculum.update({
          where: { id: curId },
          data: { semesterNo: entry.sem, weekStart: 1, weekEnd, periodsPerWeek },
        });
      } else {
        // Kiểm tra xem đã có entry cho major+subject+sem chưa
        const dup = await prisma.curriculum.findFirst({
          where: { majorId, subjectId: entry.subId, semesterNo: entry.sem },
        });
        if (dup) {
          curSkipped++;
          continue;
        }
        await prisma.curriculum.create({
          data: {
            id: curId,
            majorId,
            subjectId: entry.subId,
            semesterNo: entry.sem,
            weekStart: 1,
            weekEnd,
            periodsPerWeek,
          },
        });
        curCreated++;
      }
    }
  }

  console.log(`\n✅ Curriculum — Tạo mới: ${curCreated}, Bỏ qua (đã tồn tại): ${curSkipped}`);
  console.log('\n🎉 Hoàn thành!');
}

main()
  .catch(e => { console.error('❌ Lỗi:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
