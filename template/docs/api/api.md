# API

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [openapi.yaml](openapi.yaml), [Mô hình dữ liệu](../architecture/data-model.md), [Kiến trúc](../architecture/ARCHITECTURE.md), [Mô hình đe doạ](../security/threat-model.md)

<!--
File này trả lời: API giao tiếp theo quy ước nào, gồm endpoint nào, và hành vi nào không nằm được trong OpenAPI.
openapi.yaml là hợp đồng máy đọc (đường dẫn, tham số, schema): sửa ở đó trước, rồi cập nhật bảng ở đây.
Tên trường và enum lấy nguyên văn từ mô hình dữ liệu; không định nghĩa lại dữ liệu ở đây.
Endpoint mới chưa chốt ghi "Đề xuất" ở cột Trạng thái.
-->

## 1. Phạm vi

| Có | Không có |
|---|---|
| <API nào, cho ai gọi> | *Ví dụ:* API đọc công khai cho bên thứ ba, CORS |

## 2. Quy ước chung

### 2.1 Định dạng

- JSON UTF-8, `Content-Type: application/json` (trừ upload).
- Thời gian: chuỗi ISO 8601 có múi giờ (`2026-01-31T09:30:00Z`).
- Id: <kiểu id>.

### 2.2 Xác thực và phân quyền

<Cách xác thực (phiên, token), header nào, route nào công khai. Chi tiết bảo vệ ở mô hình đe doạ.>

### 2.3 Định dạng lỗi

Mọi lỗi trả cùng một hình dạng; `code` là hằng số ổn định để client xử lý, `message` cho người đọc.

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Tiêu đề không được để trống",
    "details": [{ "field": "title", "code": "REQUIRED" }],
    "requestId": "<id của request, để tra log>"
  }
}
```

| HTTP | `code` | Khi nào |
|---|---|---|
| 400 | `VALIDATION_FAILED` | Dữ liệu gửi lên sai |
| 401 | `UNAUTHENTICATED` | Chưa đăng nhập hoặc phiên hết hạn |
| 403 | `FORBIDDEN` | Không có quyền |
| 404 | `NOT_FOUND` | Không có tài nguyên |
| 409 | `CONFLICT` | Xung đột phiên bản (xem 2.5) |
| 429 | `RATE_LIMITED` | Vượt giới hạn tần suất |
| 500 | `INTERNAL` | Lỗi không lường trước; có `requestId` |

*Ví dụ: sửa cho khớp dự án.*

### 2.4 Phân trang, lọc, sắp xếp

<Kiểu phân trang (cursor hay offset), tham số, giới hạn tối đa.>

### 2.5 Ghi đồng thời và idempotency

<Cách tránh ghi đè (ETag / If-Match, version), khoá idempotency cho thao tác tạo.>

### 2.6 Phiên bản API và thay đổi phá vỡ

<Cách đánh phiên bản; thay đổi nào là phá vỡ; báo trước bao lâu. Thay đổi phá vỡ hợp đồng công khai cần ADR.>

### 2.7 Giới hạn tần suất

| Nhóm route | Giới hạn | Theo |
|---|---|---|
| <…> | <số request mỗi phút> | <IP hoặc người dùng> |

## 3. Bảng tổng endpoint

| Method | Path | Mục đích | Xác thực | Spec | Trạng thái |
|---|---|---|---|---|---|
| `GET` | `/health/live` | *Ví dụ:* tiến trình còn phục vụ được | không | — | Đề xuất |
| `GET` | `/health/ready` | *Ví dụ:* bản này đã sẵn sàng nhận request | không | — | Đề xuất |
| <…> | <…> | <…> | <…> | `NNN` | <…> |

## 4. Endpoint chi tiết

<!-- Chỉ ghi điều OpenAPI không diễn tả được: tác dụng phụ, thứ tự kiểm tra, lỗi cụ thể, ví dụ đầy đủ. Mỗi endpoint một mục con. -->

### 4.1 `GET /health/live` và `GET /health/ready`

*Ví dụ.* `/health/live` trả `200 {"status":"ok"}` khi process còn phục vụ được; không gọi DB/dịch vụ ngoài. `/health/ready` trả `200` khi các phụ thuộc bắt buộc đã sẵn sàng và `503` khi đang khởi động, đang dừng hoặc không thể phục vụ request. Không cần xác thực; có thể bỏ qua access log của probe thành công, nhưng vẫn ghi lỗi và giữ tín hiệu vận hành. Giới hạn thông tin công khai trong response.

```bash
curl -fsS http://127.0.0.1:3000/health/live
curl -fsS http://127.0.0.1:3000/health/ready
```

## 5. Kiểm thử hợp đồng

<!-- Các ca bắt buộc có test tự động cho mọi endpoint, ví dụ: không phiên → 401; sai schema → 400 đúng code; không có quyền → 403. -->

| # | Ca kiểm | Áp cho | Test |
|---|---|---|---|
| 1 | *Ví dụ:* mọi route cần xác thực trả 401 khi không có phiên | Mọi route trừ `/health/live` và `/health/ready` | <tên test> |

## 6. Câu hỏi mở

- [CẦN XÁC NHẬN: <câu hỏi>]
