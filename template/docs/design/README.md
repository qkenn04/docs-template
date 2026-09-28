# Đề xuất thiết kế (RFC)

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [Mẫu RFC](0000-rfc-template.md), [Mục lục ADR](../adr/README.md), [Đặc tả tính năng](../specs/README.md), [Lộ trình](../plan/roadmap.md)

<!--
Tầng T3: dùng khi dự án đủ lớn để một thay đổi cần được bàn trước khi quyết (nhiều người, nhiều thành phần,
hoặc tốn nhiều tuần). Dự án nhỏ: bàn thẳng trong ADR ở trạng thái Đề xuất.
-->

RFC là đề xuất để bàn: vấn đề, phương án, tác động, kế hoạch chuyển. Khi được chấp nhận, RFC sinh ra một hoặc nhiều ADR (quyết định) và spec (hành vi); RFC giữ lại làm hồ sơ của cuộc bàn.

| | RFC (`design/`) | ADR (`adr/`) | Spec (`specs/`) |
|---|---|---|---|
| Trả lời | Nên làm gì, cân nhắc những gì | Đã quyết gì, vì sao | Tính năng làm gì, xong khi nào |
| Độ dài | Dài được | 1–2 trang | Theo tính năng |
| Sửa sau khi chốt | Không; ghi kết quả ở cuối | Không; thay bằng ADR mới | Có, theo thay đổi hành vi |

## 1. Mục lục

| Số | Tiêu đề | Trạng thái | Người đề xuất | Kết quả (ADR, spec) |
|---|---|---|---|---|
| [0000](0000-rfc-template.md) | Mẫu RFC | Mẫu | — | — |

## 2. Vòng đời

| Trạng thái RFC | Dòng metadata | Nghĩa |
|---|---|---|
| Nháp | `Nháp` | Đang viết |
| Đang bàn | `Đề xuất` | Mở để góp ý, có hạn chót |
| Chấp nhận | `Đang áp dụng` | Đã quyết; ADR và spec đã được tạo |
| Bị bác hoặc rút | `Lưu trữ` | Giữ lại để không bàn lại từ đầu |

## 3. Cách viết

1. Copy [0000-rfc-template.md](0000-rfc-template.md) thành `NNNN-<name>.md` (4 chữ số, tiếng Anh kebab-case).
2. Viết tới mục "Câu hỏi mở", đặt trạng thái `Nháp`; xoá dòng marker `check-links: template`.
3. Mở để bàn: đổi sang `Đề xuất`, ghi hạn chót góp ý.
4. Chốt: ghi kết quả ở mục cuối, tạo ADR và spec, thêm dòng vào bảng mục 1.
