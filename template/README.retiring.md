# <Tên dự án>

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [Kế hoạch ngừng](docs/plan/roadmap.md), [AGENTS.md](AGENTS.md)

> [!WARNING]
> **Đang ngừng** — chỉ sửa lỗi ảnh hưởng người dùng; ngừng hẳn dự kiến YYYY-MM-DD; hệ thống thay thế: <tên và đường dẫn tới hệ thống thay thế, hoặc "không có">.

<!--
README cho hệ thống ĐANG NGỪNG (hồ sơ retiring). Banner ở trên là thứ đầu tiên người đọc thấy: giữ nó ngay dưới dòng
metadata tới khi gỡ xong. Điền ngày ngừng hẳn và hệ thống thay thế (thay placeholder bằng link thật).
Hồ sơ này cố ý chỉ có 4 file: README này, AGENTS.md, CLAUDE.md và kế hoạch ngừng (docs/plan/roadmap.md).
Hệ thống sắp ngừng không cần thêm tài liệu mới. Tài liệu dự án đã có (triển khai, runbook, cấu hình, ADR) giữ nguyên;
nhắc tới chúng bằng đường dẫn dạng `code`, chỉ đổi thành link khi file có thật trong repo.
Repo đã có README: script không ghi đè; chép banner và mục "Người dùng cần làm gì" lên đầu README cũ.
-->

<Một câu: hệ thống này làm gì, cho ai.>

## Người dùng cần làm gì

- Chuyển sang <hệ thống thay thế> trước YYYY-MM-DD. Hướng dẫn chuyển: <nơi có hướng dẫn, hoặc "không cần">.
- Dữ liệu của bạn: <xuất ở đâu, định dạng gì, tải được tới ngày nào>.
- Câu hỏi: <kênh liên hệ, ví dụ issue của repo này>.

Lịch, phạm vi và tiến độ ngừng: [Kế hoạch ngừng](docs/plan/roadmap.md).

## Còn được làm gì trong repo này

| Được | Không được |
|---|---|
| Sửa lỗi ảnh hưởng người dùng, sửa lỗi bảo mật | Thêm tính năng, đổi hợp đồng dữ liệu hay API |
| Xuất dữ liệu, sao lưu cuối, chuyển hướng người dùng | Xoá dữ liệu trước khi bản sao lưu cuối đã được khôi phục thử |
| Cập nhật banner, kế hoạch ngừng và tài liệu đã có cho đúng hiện trạng | Viết tài liệu mới ngoài kế hoạch ngừng; dựng thêm môi trường |

## Vận hành tới ngày ngừng

- Deploy, rollback: theo tài liệu sẵn có của dự án (nếu dự án có: `docs/ops/deployment.md`).
- Sự cố: theo runbook sẵn có (nếu dự án có: `docs/ops/runbooks/`). Chưa có runbook thì ghi cách đã xử lý vào mục "Nhật ký quyết định" của kế hoạch ngừng.
- Cấu hình và bí mật phải thu hồi khi gỡ: liệt kê ở mục "Gỡ những gì" của kế hoạch ngừng (đối chiếu, nếu dự án có: `docs/dev/configuration.md`).

```bash
# Ví dụ: lệnh kiểm tra nhanh hệ thống còn chạy đúng (thay bằng lệnh thật)
curl -fsS http://127.0.0.1:8080/health
```

## Tài liệu

- [Kế hoạch ngừng](docs/plan/roadmap.md): khi nào ngừng, gỡ gì, dữ liệu và bản sao lưu đi đâu, báo cho ai, khi nào dừng lại hoặc lùi.
- [AGENTS.md](AGENTS.md): quy tắc cho người và agent AI trong giai đoạn ngừng.
- Tài liệu cũ (nếu có, thường trong `docs/`): giữ nguyên, không viết thêm; sau khi gỡ xong chuyển trạng thái "Lưu trữ".

## Giấy phép

<Tên giấy phép; xem file LICENSE.>
