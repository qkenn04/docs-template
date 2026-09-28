# AGENTS.md

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [README](README.md), [Kế hoạch ngừng](docs/plan/roadmap.md)

<!--
AGENTS.md cho hệ thống ĐANG NGỪNG (hồ sơ retiring). Người đọc: agent AI (Claude Code, Codex, Cursor, ...) và người sửa repo.
Giữ ngắn, trung lập với công cụ. Mục đích: ai mở repo cũng biết ngay hệ thống sắp gỡ, chỉ được sửa gì,
và mọi việc gỡ đi theo kế hoạch ngừng.
Repo đã có AGENTS.md: script không ghi đè; chép mục "Giai đoạn ngừng" dưới đây lên đầu file cũ.
-->

## Dự án

<Tên dự án> **đang ngừng**: <một câu mô tả hệ thống>. Ngừng hẳn dự kiến YYYY-MM-DD; thay bằng <hệ thống thay thế, hoặc "không thay">. Lịch, phạm vi và tiến độ gỡ: [docs/plan/roadmap.md](docs/plan/roadmap.md).

## Giai đoạn ngừng

- **Được:** sửa lỗi ảnh hưởng người dùng hoặc lỗi bảo mật; làm một bước của kế hoạch ngừng khi người phụ trách giao; cập nhật banner README, kế hoạch ngừng và tài liệu đã có cho đúng hiện trạng.
- **Không được:** thêm tính năng, refactor, nâng cấp phụ thuộc không vì bảo mật, viết tài liệu mới ngoài kế hoạch ngừng.
- **Không bao giờ:** xoá dữ liệu, tài nguyên, bản sao lưu hay bí mật khi bản sao lưu cuối chưa được khôi phục thử thành công (kế hoạch ngừng, mục "Dữ liệu và bản sao lưu đi đâu").

## Tài liệu nằm ở đâu

| Cần biết | Đọc |
|---|---|
| Khi nào ngừng, gỡ gì, báo cho ai, khi nào dừng lại | [docs/plan/roadmap.md](docs/plan/roadmap.md) |
| Hệ thống là gì, người dùng cần làm gì | [README.md](README.md) |
| Deploy, rollback, sự cố tới ngày ngừng | Tài liệu sẵn có, nếu dự án có: `docs/ops/deployment.md`, `docs/ops/runbooks/` |
| Vì sao ngừng, vì sao từng chọn vậy | Kế hoạch ngừng, mục "Tóm tắt"; ADR nếu dự án có: `docs/adr/` |

## Cách làm việc

1. Trước mỗi thay đổi, đọc kế hoạch ngừng: thay đổi phải là sửa lỗi hoặc một bước trong đó.
2. Xong một bước gỡ: tick trong kế hoạch ngừng, ghi ngày và bằng chứng (lệnh, log, commit) ở mục "Theo dõi".
3. Quyết định mới (hoãn ngày, giữ lại một phần): ghi ở mục "Nhật ký quyết định" của kế hoạch ngừng; người phụ trách chốt.
4. Chỗ chưa chắc ghi `[CẦN XÁC NHẬN: …]`; không đoán ngày, không đoán ai còn dùng hệ thống.
5. Sửa nội dung một file tài liệu thì đổi ngày `Cập nhật:` ở dòng metadata.

## Lệnh

<!-- Chỉ các lệnh cần tới ngày ngừng. Mỗi lệnh chạy được từ gốc repo. -->

| Việc | Lệnh |
|---|---|
| Kiểm hệ thống còn chạy | `<lệnh>` |
| Sao lưu | `<lệnh>` |
| Khôi phục thử bản sao lưu vào môi trường tạm | `<lệnh>` |

## Quy tắc an toàn

- Không dừng dịch vụ, gỡ tài nguyên hay thu hồi bí mật khi người phụ trách chưa cho phép, kể cả khi kế hoạch đã ghi bước đó.
- Không đưa secret, token, mật khẩu, IP (ngoài loopback), hostname nội bộ vào repo, tài liệu, log hay commit message, kể cả khi hệ thống sắp gỡ.
- Commit message bằng tiếng Anh, mô tả vì sao chứ không chỉ cái gì.
