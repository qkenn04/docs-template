# CI/CD của <Tên dự án>

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD

<!-- Điền lệnh và điều kiện thật của project. Xoá bước không áp dụng. Không ghi secret. -->

## Mục tiêu

- Mỗi pull request phải vượt qua: <lint, typecheck, test hoặc kiểm tra khác>.
- Bản phát hành được tạo từ: <nhánh, tag hoặc thao tác thủ công>.
- Nơi triển khai: <môi trường và người phụ trách>.

## Pipeline

| Khi nào | Job | Lệnh hoặc workflow | Điều kiện đạt |
|---|---|---|---|
| Pull request | Kiểm tra | `<lệnh>` | <ngưỡng hoặc điều kiện> |
| Sau khi merge | Build | `<lệnh>` | <artifact cần tạo> |
| Phát hành | Deploy | `<lệnh hoặc workflow>` | <health check> |

Workflow thực tế nằm ở `.github/workflows/<tên>.yml`. Ghi tên file sau khi tạo; nếu chưa có, ghi rõ "Chưa cấu hình".

## Quyền và bí mật

| Workflow/job | Quyền tối thiểu | Secret cần có | Nơi quản lý |
|---|---|---|---|
| <tên> | <ví dụ: chỉ đọc mã nguồn> | <tên secret, không ghi giá trị> | <GitHub environment hoặc nơi khác> |

## Phát hành và rollback

1. Trước khi phát hành: <kiểm tra và người phê duyệt nếu cần>.
2. Sau khi phát hành: <cách kiểm sức khoẻ và nơi xem log>.
3. Khi lỗi: <cách quay về bản trước và cách xác nhận đã phục hồi>.

## Lần kiểm tra gần nhất

<Ngày, commit, workflow run và kết quả. Cập nhật khi pipeline thay đổi.>
