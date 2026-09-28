# Kế hoạch ngừng <Tên dự án>

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Tài liệu](../README.md), [Triển khai](../ops/deployment.md), [Cấu hình](../dev/configuration.md), [Runbook](../ops/runbooks/README.md), [Mục lục ADR](../adr/README.md)

<!--
Đây là "lộ trình" của một hệ thống sắp gỡ: các giai đoạn R0…R5, mỗi giai đoạn có điều kiện xong kiểm được và cách lùi lại.
Quy tắc cứng: không xoá dữ liệu hay tài nguyên nào trước khi bản sao lưu cuối đã được khôi phục thử thành công.
Làm theo thứ tự; bỏ giai đoạn nào thì ghi lý do.
-->

## 1. Quyết định và phạm vi

- Quyết định ngừng: ADR NNNN, viết từ [mẫu ADR](../adr/0000-template.md) và thêm vào [mục lục](../adr/README.md).
- Lý do một câu: <…>
- Thay bằng: <hệ thống thay thế, hoặc "không thay">.

| Ngừng | Giữ lại (và giữ tới khi nào) |
|---|---|
| *Ví dụ:* ứng dụng web và cơ sở dữ liệu | *Ví dụ:* bản sao lưu cuối, giữ 12 tháng |
| <…> | *Ví dụ:* tên miền, trỏ về trang thông báo, giữ tới YYYY-MM-DD |

## 2. Kiểm kê

<!-- Liệt kê MỌI thứ hệ thống dùng hoặc tạo ra. Thứ bị quên thường là: cron, DNS, chứng chỉ, bí mật trong CI, webhook, monitor, tài khoản dịch vụ ngoài, bucket lưu trữ, khoá SSH, người dùng còn phụ thuộc. -->

| # | Thành phần | Loại | Ở đâu | Ai hoặc gì phụ thuộc vào nó | Xử lý | Giai đoạn |
|---|---|---|---|---|---|---|
| K1 | *Ví dụ:* dịch vụ web | service | <nơi chạy> | người dùng | dừng, giữ image 30 ngày | R3 |
| K2 | *Ví dụ:* cơ sở dữ liệu | dữ liệu | <nơi chạy> | ứng dụng, tác vụ sao lưu | dump cuối, khôi phục thử, rồi xoá | R1, R4 |
| K3 | *Ví dụ:* biến bí mật trong CI | bí mật | <nơi giữ> | workflow deploy | thu hồi | R4 |
| K4 | *Ví dụ:* monitor uptime | giám sát | <dịch vụ> | người trực | tắt sau khi dừng dịch vụ | R3 |
| K5 | <…> | DNS / cron / webhook / tài khoản / khoá | <…> | <…> | <…> | <…> |

## 3. Các giai đoạn

### R0 Thông báo và đóng băng

- Việc: báo người dùng và hệ thống phụ thuộc (ngày dừng, thay bằng gì); ngừng nhận tính năng mới; khoá nhánh chính chỉ cho sửa lỗi.
- Xong khi:
  - [ ] Mọi bên trong cột "Ai hoặc gì phụ thuộc" ở mục 2 đã được báo (ghi ngày, kênh).
  - [ ] Nhánh chính chỉ nhận sửa lỗi và thay đổi phục vụ việc gỡ.
- Lùi lại: huỷ thông báo, mở lại nhánh.

### R1 Xuất dữ liệu và sao lưu cuối

- Việc: xuất dữ liệu người dùng cần mang theo; tạo bản sao lưu cuối; **khôi phục thử** vào môi trường tạm; ghi checksum.
- Xong khi:
  - [ ] Bản sao lưu cuối tồn tại ở nơi giữ lâu dài, có checksum.
  - [ ] Đã khôi phục thử thành công (ghi lệnh, thời gian, số bản ghi khớp).
  - [ ] Dữ liệu xuất cho người dùng hoặc hệ thống thay thế đã được xác nhận nhận đủ.
- Lùi lại: không cần (chỉ đọc).

### R2 Chuyển hướng

- Việc: chuyển người dùng và lưu lượng sang hệ thống thay thế hoặc trang thông báo; giữ URL cũ trả mã phù hợp (301 tới nơi mới, hoặc 410 nếu không thay).
- Xong khi:
  - [ ] Kiểm từ bên ngoài: URL chính trả đúng mã mới (ghi lệnh kiểm và kết quả).
  - [ ] Lưu lượng vào hệ thống cũ giảm về gần 0 trong <số> ngày.
- Lùi lại: bỏ chuyển hướng.

### R3 Dừng dịch vụ (vẫn bật lại được)

- Việc: dừng tiến trình, tắt tác vụ định kỳ và monitor; **giữ** dữ liệu, image, cấu hình để bật lại trong thời gian chờ.
- Xong khi:
  - [ ] Không còn tiến trình nào của hệ thống chạy; không còn cảnh báo giả từ monitor.
  - [ ] Đã thử bật lại một lần theo [runbook](../ops/runbooks/README.md) (hoặc ghi rõ vì sao không thử).
- Lùi lại: bật lại theo [triển khai](../ops/deployment.md). Thời gian chờ trước R4: <số> ngày.

### R4 Gỡ và thu hồi

- Việc: xoá tài nguyên theo cột "Xử lý" ở mục 2; thu hồi bí mật, khoá, token, tài khoản dịch vụ ngoài ([cấu hình](../dev/configuration.md)); xoá bản ghi DNS không dùng.
- Xong khi:
  - [ ] Mọi dòng của mục 2 có trạng thái "đã gỡ" hoặc "giữ lại" kèm ngày.
  - [ ] Mọi bí mật đã thu hồi ở phía cấp phát (không chỉ xoá khỏi máy).
- Lùi lại: chỉ bằng bản sao lưu cuối (R1). Sau bước này không còn đường lùi nhanh.

### R5 Lưu trữ hồ sơ

- Việc: tài liệu chuyển sang "Lưu trữ" theo mục "Sau khi gỡ xong" của [docs/README.md](../README.md); repo chuyển chỉ đọc; ghi bài học.
- Xong khi:
  - [ ] Mọi file trong docs/ có trạng thái Lưu trữ.
  - [ ] Repo ở chế độ chỉ đọc.
  - [ ] Đã hẹn ngày xoá bản sao lưu cuối (nếu có hạn giữ).

## 4. Rủi ro

| Rủi ro | Dấu hiệu | Giảm thiểu |
|---|---|---|
| Còn người dùng hoặc hệ thống phụ thuộc chưa biết | Lưu lượng không giảm sau R2 | Giữ R3 lâu hơn; đọc log truy cập trước R4 |
| Bản sao lưu không khôi phục được | R1 khôi phục thử lỗi | Không qua R4 cho tới khi khôi phục thử đạt |
| Bí mật bị bỏ sót | Kiểm kê thiếu dòng | Đối chiếu mục 2 với [cấu hình](../dev/configuration.md) và cài đặt CI |
| <…> | <…> | <…> |

## 5. Theo dõi

| Giai đoạn | Bắt đầu | Xong | Bằng chứng (lệnh, log, commit) | Ghi chú |
|---|---|---|---|---|
| R0 | | | | |
| R1 | | | | |
| R2 | | | | |
| R3 | | | | |
| R4 | | | | |
| R5 | | | | |

## 6. Câu hỏi mở

- [CẦN XÁC NHẬN: <câu hỏi>]
