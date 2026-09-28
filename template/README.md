# <Tên dự án>

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Tài liệu](docs/README.md), [AGENTS.md](AGENTS.md)

<!-- README ở gốc repo trả lời ba câu: đây là gì, chạy thử thế nào, đọc tiếp ở đâu. Giữ ngắn (dưới ~80 dòng); mọi chi tiết để ở docs/. -->

<Một hai câu: dự án là gì, cho ai, giải quyết vấn đề gì.>

## Trạng thái

<!-- Một dòng. Trạng thái chi tiết chỉ ghi ở một nơi: docs/plan/progress.md (hoặc mục "Tiến độ" trong docs/README.md ở hồ sơ lite). -->

<Ví dụ: Đang ở mốc M1, chưa phát hành. Chi tiết trong docs/.>

## Quick start

<!-- Lệnh tối thiểu để một người mới chạy được trên máy sạch, copy-paste được từng dòng. Chưa có code thì ghi "Chưa có code" và trỏ tới việc đầu tiên trong kế hoạch. -->

```bash
# Ví dụ: thay bằng lệnh thật của dự án
git clone <repo-url>
cd <repo-dir>
cp .env.example .env      # điền giá trị theo tài liệu cấu hình (chỉ tên biến nằm trong repo)
<lệnh cài đặt>
<lệnh chạy>               # ví dụ: mở http://127.0.0.1:3000
<lệnh test>
```

Yêu cầu: <ngôn ngữ, phiên bản, công cụ cần cài trước>.

## Tài liệu

Bắt đầu từ [docs/README.md](docs/README.md): bản đồ tài liệu, đọc gì trước theo vai, và quy ước chung.

<!-- Liệt kê tối đa 3–4 link quan trọng nhất sau khi các file đó có nội dung, ví dụ đặc tả sản phẩm, kiến trúc, lộ trình. -->

## Đóng góp

- Quy tắc làm việc cho người và agent AI: [AGENTS.md](AGENTS.md).
- Mỗi thay đổi cập nhật tài liệu trong cùng PR, theo [Definition of Done cho tài liệu](docs/README.md#definition-of-done-cho-tài-liệu).
- Kiểm link trước khi mở PR: `python3 scripts/check-links.py .`
- Commit message viết bằng tiếng Anh.

## Giấy phép

<!-- Ghi tên giấy phép và link tới file LICENSE, hoặc "Chưa chọn [CẦN XÁC NHẬN]". Repo riêng tư vẫn nên ghi rõ. -->

<Tên giấy phép, ví dụ MIT; xem file LICENSE.>
