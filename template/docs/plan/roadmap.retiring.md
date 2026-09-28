# Kế hoạch ngừng <Tên dự án>

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [README](../../README.md), [AGENTS.md](../../AGENTS.md)

<!--
Ở hồ sơ retiring, file này thay cho lộ trình: không còn mốc tính năng, chỉ còn các bước ngừng R0…R5.
Nó trả lời năm câu: khi nào ngừng, gỡ những gì, dữ liệu và bản sao lưu đi đâu, báo cho ai, khi nào dừng lại hoặc lùi.
Quy tắc cứng: không xoá dữ liệu hay tài nguyên nào trước khi bản sao lưu cuối đã được khôi phục thử thành công.
Làm các bước theo thứ tự; bỏ bước nào thì ghi lý do ở mục "Nhật ký quyết định".
Tài liệu dự án đã có (triển khai, runbook, cấu hình, ADR) giữ nguyên: nhắc tới chúng bằng đường dẫn dạng `code`,
chỉ đổi thành link khi file có thật trong repo này.
-->

## 1. Tóm tắt

| Câu hỏi | Trả lời |
|---|---|
| Hệ thống làm gì | <một câu> |
| Vì sao ngừng | <một câu>; quyết định ghi ở <biên bản, issue, hoặc ADR nếu dự án có `docs/adr/`> |
| Thay bằng gì | <hệ thống thay thế và đường dẫn, hoặc "không thay"> |
| Người phụ trách | <tên hoặc vai trò>; người chốt quyết định: <tên hoặc vai trò> |
| Người dùng còn lại | <ai, bao nhiêu; nguồn số liệu, tính tới YYYY-MM-DD> |
| Tiến độ | Mục [8. Theo dõi](#8-theo-dõi) |

## 2. Khi nào

<!-- Ngày cụ thể, không ghi "khoảng quý 3". Đổi ngày thì sửa bảng này, banner README và ghi lý do ở mục 9. Khoảng cách giữa các mốc chỉnh theo số người dùng và mức rủi ro. -->

| Mốc | Ngày | Ý nghĩa | Bước |
|---|---|---|---|
| Thông báo và đóng băng | YYYY-MM-DD | Mọi bên ở mục 5 nhận thông báo lần 1; chỉ còn sửa lỗi ảnh hưởng người dùng | R0 |
| Sao lưu cuối | YYYY-MM-DD | Bản sao lưu cuối tạo xong và khôi phục thử đạt | R1 |
| Chuyển hướng | YYYY-MM-DD | Người dùng và lưu lượng sang hệ thống thay thế hoặc trang thông báo | R2 |
| Dừng dịch vụ | YYYY-MM-DD | Tắt nhưng còn bật lại được; *ví dụ:* ít nhất 30 ngày sau thông báo | R3 |
| Gỡ hẳn | YYYY-MM-DD | Xoá tài nguyên, thu hồi bí mật; *ví dụ:* ít nhất 14 ngày sau dừng dịch vụ | R4 |
| Lưu trữ hồ sơ | YYYY-MM-DD | Tài liệu chuyển "Lưu trữ", repo chỉ đọc | R5 |
| Xoá bản sao lưu cuối | YYYY-MM-DD | Hết hạn giữ ở mục 4 | |

## 3. Gỡ những gì

<!-- Kiểm kê MỌI thứ hệ thống dùng hoặc tạo ra. Thứ hay bị quên: cron, DNS, chứng chỉ, bí mật trong CI, webhook, monitor, tài khoản dịch vụ ngoài, bucket lưu trữ, khoá SSH, hệ thống khác gọi vào. Nguồn đối chiếu, nếu dự án có: `docs/architecture/ARCHITECTURE.md`, `docs/dev/configuration.md`, `docs/ops/deployment.md`, cài đặt CI. -->

| # | Thành phần | Loại | Ở đâu | Ai hoặc gì phụ thuộc | Xử lý | Bước | Trạng thái |
|---|---|---|---|---|---|---|---|
| K1 | *Ví dụ:* dịch vụ web | service | <nơi chạy, mô tả chung> | người dùng | dừng, giữ image 30 ngày rồi xoá | R3, R4 | còn chạy |
| K2 | *Ví dụ:* cơ sở dữ liệu | dữ liệu | <nơi chạy> | ứng dụng, tác vụ sao lưu | sao lưu cuối, khôi phục thử, rồi xoá | R1, R4 | còn chạy |
| K3 | *Ví dụ:* bí mật deploy trong CI | bí mật | <nơi giữ> | workflow deploy | thu hồi ở phía cấp phát | R4 | còn dùng |
| K4 | *Ví dụ:* monitor uptime | giám sát | <dịch vụ> | người trực | tắt ngay sau khi dừng dịch vụ | R3 | bật |
| K5 | *Ví dụ:* tên miền | DNS | <nhà đăng ký> | người dùng, liên kết cũ | trỏ về trang thông báo, giữ tới YYYY-MM-DD | R2 | trỏ vào dịch vụ |
| K6 | <…> | cron / webhook / tài khoản / khoá / chứng chỉ | <…> | <…> | <…> | <…> | <…> |

Mỗi dòng kết thúc bằng một trong hai trạng thái: **đã gỡ** (kèm ngày) hoặc **giữ lại** (kèm lý do và giữ tới ngày nào).

## 4. Dữ liệu và bản sao lưu đi đâu

<!-- Mô tả vị trí ở mức chung (loại lưu trữ, ai có quyền đọc). Không ghi bí mật, URL có token, IP hay hostname nội bộ. -->

| Dữ liệu | Đi đâu | Định dạng | Ai nhận hoặc đọc được | Giữ tới | Khôi phục thử |
|---|---|---|---|---|---|
| *Ví dụ:* dữ liệu người dùng mang theo | xuất cho người dùng hoặc hệ thống thay thế | CSV, JSON | chính người dùng | ngày gỡ hẳn | không cần; người nhận xác nhận đủ |
| *Ví dụ:* bản sao lưu cuối toàn bộ cơ sở dữ liệu | <nơi lưu trữ lâu dài, mô tả chung> | dump kèm checksum | <vai trò> | YYYY-MM-DD (*ví dụ:* 12 tháng) | YYYY-MM-DD, `<lệnh>`, số bản ghi khớp |
| *Ví dụ:* log truy cập | xoá khi gỡ hẳn | | | ngày gỡ hẳn | không cần |

Bản sao lưu cuối chỉ tính là xong khi đã khôi phục thử thành công vào một môi trường tạm và ghi bằng chứng ở cột cuối.

## 5. Báo cho ai

| Ai | Vì sao cần biết | Kênh | Lần 1 (thông báo) | Lần 2 (nhắc trước khi dừng) | Người báo | Đã báo |
|---|---|---|---|---|---|---|
| *Ví dụ:* người dùng đang hoạt động | mất quyền truy cập, cần xuất dữ liệu | email, banner trong ứng dụng | YYYY-MM-DD | YYYY-MM-DD | <vai trò> | |
| *Ví dụ:* nhóm có hệ thống gọi vào API | tích hợp sẽ lỗi | issue, chat | YYYY-MM-DD | YYYY-MM-DD | <vai trò> | |
| *Ví dụ:* người trực vận hành | cảnh báo sẽ tắt, lịch thay đổi | chat nội bộ | YYYY-MM-DD | | <vai trò> | |
| <…> | <…> | <…> | | | | |

Nội dung tối thiểu của mỗi thông báo: ngày dừng dịch vụ, ngày gỡ hẳn, hệ thống thay thế, cách lấy dữ liệu, người liên hệ.

## 6. Các bước

Mỗi bước có điều kiện xong kiểm được và cách lùi. Chỉ sang bước sau khi bước trước xong.

### R0 Thông báo và đóng băng

- Việc: gửi thông báo lần 1 theo mục 5; bật banner ở README; nhánh chính chỉ nhận sửa lỗi và thay đổi phục vụ việc gỡ.
- Xong khi:
  - [ ] Mọi dòng của mục 5 có ngày báo lần 1.
  - [ ] Banner README có ngày ngừng hẳn và hệ thống thay thế.
- Lùi lại: gửi thông báo huỷ, gỡ banner.

### R1 Xuất dữ liệu và sao lưu cuối

- Việc: xuất dữ liệu người dùng cần mang theo; tạo bản sao lưu cuối; **khôi phục thử** vào môi trường tạm; ghi checksum.
- Xong khi:
  - [ ] Bản sao lưu cuối nằm ở nơi giữ lâu dài, có checksum (mục 4).
  - [ ] Khôi phục thử thành công: ghi lệnh, thời gian, số bản ghi khớp.
  - [ ] Người nhận dữ liệu xuất xác nhận đã nhận đủ.
- Lùi lại: không cần (chỉ đọc).

### R2 Chuyển hướng

- Việc: chuyển người dùng và lưu lượng sang hệ thống thay thế hoặc trang thông báo; URL cũ trả mã phù hợp (301 tới nơi mới, hoặc 410 nếu không thay); gửi thông báo lần 2.
- Xong khi:
  - [ ] Kiểm từ bên ngoài: URL chính trả đúng mã mới (ghi lệnh kiểm và kết quả).
  - [ ] Lưu lượng vào hệ thống cũ giảm về gần 0 trong <số> ngày.
- Lùi lại: bỏ chuyển hướng.

### R3 Dừng dịch vụ (còn bật lại được)

- Việc: dừng tiến trình, tắt tác vụ định kỳ và monitor; **giữ** dữ liệu, image, cấu hình để bật lại trong thời gian chờ.
- Xong khi:
  - [ ] Không còn tiến trình nào của hệ thống chạy; không còn cảnh báo từ monitor.
  - [ ] Đã thử bật lại một lần theo cách deploy sẵn có (hoặc ghi rõ vì sao không thử).
- Lùi lại: bật lại (nếu dự án có: `docs/ops/deployment.md`). Thời gian chờ trước R4: <số> ngày.

### R4 Gỡ và thu hồi

- Việc: xoá tài nguyên theo cột "Xử lý" ở mục 3; thu hồi bí mật, khoá, token, tài khoản dịch vụ ngoài; xoá bản ghi DNS không dùng.
- Trước khi làm: người chốt quyết định đồng ý bằng văn bản, ghi ở mục 9.
- Xong khi:
  - [ ] Mọi dòng của mục 3 ở trạng thái "đã gỡ" hoặc "giữ lại", kèm ngày.
  - [ ] Mọi bí mật đã thu hồi ở phía cấp phát (không chỉ xoá khỏi máy).
- Lùi lại: chỉ bằng bản sao lưu cuối (R1). Sau bước này không còn đường lùi nhanh.

### R5 Lưu trữ hồ sơ

- Việc: làm theo mục 10; ghi bài học vào mục 9.
- Xong khi:
  - [ ] Banner README đổi thành "Đã ngừng".
  - [ ] Mọi tài liệu có trạng thái Lưu trữ; repo ở chế độ chỉ đọc.
  - [ ] Đã hẹn ngày xoá bản sao lưu cuối (nếu có hạn giữ).

## 7. Khi nào dừng lại hoặc lùi

<!-- Viết trước khi bắt đầu R0, khi chưa có áp lực thời gian. Mỗi dòng: tín hiệu quan sát được, không phải cảm giác. -->

| Tín hiệu | Ở bước | Làm gì |
|---|---|---|
| Khôi phục thử bản sao lưu cuối lỗi hoặc thiếu dữ liệu | R1 | Dừng; không sang R4 cho tới khi khôi phục thử đạt |
| Hệ thống thay thế chưa sẵn sàng hoặc thiếu chức năng người dùng cần | R0–R2 | Hoãn: dời ngày ở mục 2 và banner README, báo lại các bên ở mục 5 |
| Lưu lượng vào hệ thống cũ không giảm sau <số> ngày chuyển hướng | R2 | Dừng; tìm bên phụ thuộc chưa biết qua log truy cập, báo họ, dời ngày dừng dịch vụ |
| Có bên phụ thuộc quan trọng lộ ra sau khi dừng dịch vụ | R3 | Lùi: bật lại dịch vụ, dời ngày gỡ hẳn |
| Người chốt đổi quyết định (giữ lại một phần, huỷ ngừng) | bất kỳ | Dừng; ghi ở mục 9; cập nhật banner README và AGENTS.md |

Sau R4 không còn đường lùi nhanh: chỉ dựng lại được từ bản sao lưu cuối.

## 8. Theo dõi

| Bước | Bắt đầu | Xong | Bằng chứng (lệnh, log, commit) | Ghi chú |
|---|---|---|---|---|
| R0 | | | | |
| R1 | | | | |
| R2 | | | | |
| R3 | | | | |
| R4 | | | | |
| R5 | | | | |

## 9. Nhật ký quyết định

<!-- Quyết định trong lúc ngừng (hoãn ngày, giữ lại một phần, bỏ một bước) ghi ở đây thay vì viết tài liệu mới. Dự án đã có ADR thì quyết định lớn vẫn viết thành ADR và ghi số ADR ở đây. -->

| Ngày | Quyết định | Ai chốt | Lý do |
|---|---|---|---|
| YYYY-MM-DD | *Ví dụ:* ngừng hệ thống, thay bằng <hệ thống thay thế> | <vai trò> | <một câu> |

## 10. Sau khi gỡ xong

1. README: banner đổi thành "Đã ngừng ngày YYYY-MM-DD"; ghi nơi giữ bản sao lưu cuối (mô tả chung) và ngày xoá.
2. File này và mọi tài liệu cũ chuyển trạng thái **Lưu trữ**.
3. Repo chuyển sang chỉ đọc (archive), không xoá, để lịch sử quyết định còn tra được.

## 11. Câu hỏi mở

- [CẦN XÁC NHẬN: <câu hỏi>]
