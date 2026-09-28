# Nguyên tắc kiến trúc

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Kiến trúc](ARCHITECTURE.md), [Mục lục ADR](../adr/README.md), [Yêu cầu phi chức năng](../product/nfr.md)

<!--
Tầng T3: dùng khi dự án đủ lớn để các quyết định nhỏ hằng ngày cần một chuẩn chung.
Nguyên tắc là quy tắc NGẮN, KIỂM ĐƯỢC, áp cho mọi thay đổi; mỗi nguyên tắc có nguồn gốc (ADR, sự cố, yêu cầu)
và cách kiểm (lint, test, checklist review). Nguyên tắc không kiểm được thì chỉ là khẩu hiệu: bỏ.
Thêm, sửa hoặc bỏ một nguyên tắc cần ADR.
Các dòng trong bảng là VÍ DỤ thường gặp: giữ cái hợp, sửa cho cụ thể, xoá cái không dùng.
-->

## 1. Danh sách

| # | Nguyên tắc | Áp dụng cụ thể | Nguồn | Kiểm bằng |
|---|---|---|---|---|
| P1 | *Ví dụ:* **Hỏng thì đóng, và hỏng ồn ào** | Thiếu cấu hình là lỗi khởi động; không có tiến độ giả; lỗi luôn hiện cho người dùng và có cảnh báo | <ADR, sự cố> | Test khởi động với cấu hình thiếu |
| P2 | *Ví dụ:* **Quyền tối thiểu** | Tiến trình không chạy bằng root; mỗi token chỉ có quyền cần dùng | <…> | Review cấu hình deploy |
| P3 | *Ví dụ:* **Một nguồn sự thật** | Mỗi loại thông tin (schema, cấu hình, trạng thái dự án) có đúng một nơi gốc; nơi khác chỉ link | <…> | Review tài liệu |
| P4 | *Ví dụ:* **Môi trường có tên riêng** | Không dựa vào tên hay giá trị mặc định cho project, thư mục, cơ sở dữ liệu | <sự cố ghi đè môi trường> | Test script chỉ chạy trong thư mục tạm |
| P5 | *Ví dụ:* **Thứ không cần thì không có** | Không mở endpoint, cổng, quyền "để sau dùng" | <…> | Rà bảo mật trước phát hành |
| P6 | <…> | <…> | <…> | <…> |

## 2. Khi các nguyên tắc xung đột

<!-- Thứ tự ưu tiên khi hai nguyên tắc kéo ngược nhau, ví dụ: an toàn dữ liệu > sẵn sàng > tốc độ phát triển. -->

1. <nguyên tắc ưu tiên cao nhất>
2. <…>

## 3. Ngoại lệ đã chấp nhận

| Nguyên tắc | Ngoại lệ | Vì sao | ADR | Xem lại khi |
|---|---|---|---|---|
| <…> | <…> | <…> | NNNN | <…> |
