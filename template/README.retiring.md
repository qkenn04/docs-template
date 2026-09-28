# <Tên dự án>

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [Tài liệu](docs/README.md), [Kế hoạch ngừng](docs/plan/roadmap.md), [AGENTS.md](AGENTS.md)

<!-- README cho hệ thống ĐANG NGỪNG (hồ sơ retiring). Người đọc cần biết ngay: không dùng cho việc mới, thay bằng gì, tới khi nào còn chạy. -->

**Đang ngừng.** <Tên dự án> không nhận tính năng mới. <Thay bằng hệ thống nào, hoặc "không có hệ thống thay thế">. Dự kiến gỡ: YYYY-MM-DD. Kế hoạch và tiến độ gỡ: [docs/plan/roadmap.md](docs/plan/roadmap.md).

<Một câu: hệ thống này từng làm gì, cho ai.>

## Còn được làm gì

| Được | Không được |
|---|---|
| Sửa lỗi bảo mật, sửa sự cố theo runbook | Thêm tính năng, đổi hợp đồng dữ liệu hay API |
| Xuất dữ liệu, sao lưu cuối, chuyển hướng người dùng | Xoá dữ liệu trước khi bản sao lưu cuối đã được khôi phục thử |
| Cập nhật tài liệu để phản ánh hiện trạng | Dựng thêm môi trường mới |

## Vận hành tới ngày gỡ

- Deploy, rollback, cấu hình: [docs/ops/deployment.md](docs/ops/deployment.md).
- Sự cố: [runbook](docs/ops/runbooks/README.md).

```bash
# Ví dụ: lệnh kiểm tra nhanh hệ thống còn chạy đúng (thay bằng lệnh thật)
curl -fsS http://127.0.0.1:8080/health
```

## Tài liệu

Bắt đầu từ [docs/README.md](docs/README.md). Quy tắc cho người và agent AI: [AGENTS.md](AGENTS.md).

## Giấy phép

<Tên giấy phép; xem file LICENSE.>
