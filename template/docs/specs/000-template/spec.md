# NNN: <Tên tính năng>

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [Mục lục spec](../README.md), [plan.md](plan.md), [tasks.md](tasks.md), [ADR NNNN](../../adr/NNNN-<name>.md), [Lộ trình M#](../../plan/roadmap.md)

<!-- check-links: template -->

<!--
MẪU. Khi dùng: copy cả thư mục 000-template thành NNN-<name>; đổi Trạng thái thành "Nháp"; xoá dòng
"check-links: template" ở trên; thay mọi <…>, NNN, NNNN, M#; xoá comment hướng dẫn khi đã điền.
Spec trả lời: làm GÌ và thế nào là XONG. Cách làm kỹ thuật để ở plan.md.
-->

<1–2 đoạn: tính năng là gì, cho ai, vì sao cần bây giờ.>

## 1. Mục tiêu

<!-- 2–5 mục tiêu kiểm được. Nếu hệ thống hiện tại đã có thứ tương đương, thêm "Hiện trạng" và nói giữ gì, đổi gì. -->

1. <mục tiêu>

## 2. Câu chuyện người dùng

| # | Là | Tôi muốn | Để |
|---|---|---|---|
| U1 | <vai trò> | <hành động> | <lợi ích> |

## 3. Giao diện

<!-- Nếu có UI: màn nào, trạng thái nào, link tới thiết kế. Không có UI thì ghi "Không có giao diện" và mô tả đầu vào, đầu ra (CLI, API). -->

<…>

## 4. Dữ liệu

<!-- Thực thể và trường liên quan, TRỎ về mô hình dữ liệu; không định nghĩa lại. Thứ mới ghi "Đề xuất". -->

- Dùng: <thực thể, trường> ([mô hình dữ liệu](../../architecture/data-model.md))
- Đề xuất thêm: <…>

## 5. API

<!-- Endpoint liên quan, trỏ về API. Endpoint mới ghi "Đề xuất, chưa có trong api.md". -->

| Method | Path | Dùng để | Ghi chú |
|---|---|---|---|
| <…> | <…> | <…> | <…> |

## 6. Quy tắc và kiểm tra

<!-- Quy tắc nghiệp vụ, kiểm tra đầu vào, giới hạn, quyền. Mỗi quy tắc nên xuất hiện trong ít nhất một tiêu chí nghiệm thu. -->

1. <quy tắc>

## 7. Trạng thái trống, lỗi, đang tải

| Tình huống | Người dùng thấy | Hệ thống ghi lại |
|---|---|---|
| Chưa có dữ liệu | <…> | — |
| Lỗi mạng hoặc lỗi máy chủ | <thông báo rõ, không mất dữ liệu đang nhập> | Log có mã lỗi và request id |
| Đang xử lý lâu | <trạng thái thật, không có tiến độ giả> | <…> |

## 8. Tiêu chí nghiệm thu

<!-- Given/When/Then, mỗi dòng kiểm được, có loại test (U, I, E, C, M theo dev/testing.md). -->

| Mã | Cho (Given) | Khi (When) | Thì (Then) | Loại |
|---|---|---|---|---|
| NNN-AC-01 | <trạng thái ban đầu, dữ liệu cụ thể> | <hành động> | <kết quả đo được> | I |
| NNN-AC-02 | <…> | <…> | <…> | E |

## 9. Ngoài phạm vi

- <điều cố ý không làm trong spec này, và nơi nó sẽ được làm nếu có>

## 10. Phụ thuộc

- Cần: <spec khác, ADR, dịch vụ ngoài>
- Chặn: <spec khác cần spec này>

## 11. Mốc

M# ([lộ trình](../../plan/roadmap.md)).

## 12. Câu hỏi mở

- [CẦN XÁC NHẬN: <câu hỏi>]

## Lịch sử thay đổi

| Ngày | Thay đổi |
|---|---|
| YYYY-MM-DD | Tạo, trạng thái Nháp |
