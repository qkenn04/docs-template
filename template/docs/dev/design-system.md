# Hệ thống thiết kế

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Yêu cầu phi chức năng](../product/nfr.md), [Kiến trúc](../architecture/ARCHITECTURE.md), [Cấu trúc front-end](frontend.md), [Kiểm thử](testing.md)

<!--
Chỉ cần khi dự án có giao diện người dùng.
File này trả lời: dùng màu, chữ, khoảng cách, component nào, và quy tắc tiếp cận nào mọi màn phải giữ.
Nguồn sự thật của giá trị token là file token trong code; ở đây giải thích ý nghĩa, cách dùng, và kết quả kiểm tương phản.
Giá trị trong bảng là ví dụ.
-->

## 1. Phạm vi

<Giao diện nào dùng hệ thống này (ứng dụng quản trị, trang công khai, ...). File token nằm ở `<đường dẫn>`.>

## 2. Quy tắc tiếp cận (WCAG 2.1 AA)

- Tương phản chữ thường ≥ 4,5:1, chữ lớn và thành phần phi văn bản ≥ 3:1, ở cả giao diện sáng và tối.
- Mọi thao tác làm được bằng bàn phím; vòng focus luôn nhìn thấy.
- Trạng thái không chỉ truyền đạt bằng màu (có chữ hoặc biểu tượng đi kèm).
- Tôn trọng `prefers-reduced-motion`.
- Kích thước vùng bấm tối thiểu <số> px trên màn hình cảm ứng.

## 3. Màu

| Token | Sáng | Tối | Dùng cho | Tương phản trên nền |
|---|---|---|---|---|
| `--color-bg` | `#ffffff` | `#111418` | Nền trang | — |
| `--color-text` | `#1b1f24` | `#e6e8eb` | Chữ chính | *Ví dụ:* 16,1:1 / 14,9:1 |
| `--color-accent` | <…> | <…> | Liên kết, nút chính | <…> |
| `--color-danger` | <…> | <…> | Lỗi, thao tác phá huỷ | <…> |

## 4. Chữ

| Token | Font | Cỡ / dòng | Độ đậm | Dùng cho |
|---|---|---|---|---|
| `--font-body` | <…> | 16 / 24 | 400 | Văn bản |
| `--font-heading` | <…> | <…> | 600 | Tiêu đề |
| `--font-mono` | <…> | 14 / 20 | 400 | Code |

Cách tải font: <tự host hay dịch vụ ngoài; tập ký tự cần cho tiếng Việt; ngân sách dung lượng ở yêu cầu phi chức năng>.

## 5. Khoảng cách, bo góc, bóng

| Token | Giá trị | Dùng cho |
|---|---|---|
| `--space-1` … `--space-8` | 4 px × n | Khoảng cách |
| `--radius-sm`, `--radius-md` | <…> | Bo góc |

## 6. Bố cục và điểm ngắt

| Điểm ngắt | Chiều rộng | Bố cục |
|---|---|---|
| Di động | < 640 px | Một cột |
| Máy tính | ≥ 1024 px | <…> |

## 7. Component

| Component | Trạng thái | Biến thể | Ghi chú tiếp cận |
|---|---|---|---|
| *Ví dụ:* Button | Có | primary, secondary, danger | `<button>` thật; nhãn rõ; trạng thái đang xử lý có chữ |
| <…> | Chưa có / Có / Cần sửa | <…> | <…> |

## 8. Chuyển động và biểu tượng

- Thời lượng chuyển động: <…>; tắt khi `prefers-reduced-motion`.
- Bộ biểu tượng: <tên, giấy phép>; biểu tượng đứng một mình có nhãn cho trình đọc màn hình.

## 9. Kiểm tự động

- Test tương phản chạy trên file token trong CI: `<lệnh>`.
- Kiểm tiếp cận tự động trên các màn chính: `<lệnh>`.

## 10. Câu hỏi mở

- [CẦN XÁC NHẬN: <câu hỏi>]
