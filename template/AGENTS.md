# AGENTS.md

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [README](README.md), [Tài liệu](docs/README.md)

<!--
Viết file này SAU CÙNG, khi docs/ đã có nội dung thật.
Người đọc: agent AI (Claude Code, Codex, Cursor, ...) và người mới vào dự án.
Giữ ngắn (dưới ~150 dòng), trung lập với công cụ, chỉ TRỎ vào docs/, không chép lại nội dung.
Ghi chú chỉ dành cho một công cụ thì để ở file của công cụ đó (ví dụ CLAUDE.md).
-->

## Dự án

<Tên dự án>: <một câu mô tả>. Mục tiêu và phạm vi: docs/product/spec.md (hồ sơ lite: mục đầu của [docs/README.md](docs/README.md)).

## Bản đồ repo

<!-- Chỉ các thư mục người/agent hay chạm. Cập nhật khi đổi cấu trúc. -->

| Đường dẫn | Chứa gì |
|---|---|
| `docs/` | Toàn bộ tài liệu; cổng vào [docs/README.md](docs/README.md) |
| `scripts/check-links.py` | Kiểm link tương đối và anchor trong Markdown |
| `<src/>` | <mã nguồn chính> |
| `<tests/>` | <thư mục test> |

## Tài liệu nằm ở đâu

Bản đồ đầy đủ: [docs/README.md](docs/README.md). Tra nhanh:

| Cần biết | Đọc |
|---|---|
| Xây gì, không xây gì, xong khi nào | `docs/product/spec.md`, spec của tính năng trong `docs/specs/` |
| Hệ thống gồm gì, chạy thế nào | `docs/architecture/ARCHITECTURE.md` |
| Vì sao chọn công nghệ hay cách làm này | `docs/adr/` (đừng đề xuất lại phương án một ADR đã bác, trừ khi có lý do mới) |
| Lệnh test, cấu hình, biến môi trường | `docs/dev/testing.md`, `docs/dev/configuration.md` |
| Đang làm gì, tới đâu | `docs/plan/progress.md`, `docs/plan/tasks.md` |
| Deploy, rollback, sự cố | `docs/ops/deployment.md`, `docs/ops/runbooks/` |

File nào chưa có ở dự án này thì nội dung tương ứng nằm trong một mục của `docs/README.md`.

## Cách làm việc

1. Đọc spec và ADR liên quan trước khi sửa code. Không rõ thì hỏi, không đoán.
2. Mỗi thay đổi cập nhật tài liệu trong cùng PR theo [Definition of Done cho tài liệu](docs/README.md#definition-of-done-cho-tài-liệu). Tóm tắt:
   - hành vi đổi → spec; quyết định kiến trúc → ADR mới (trạng thái Đề xuất, theo [mẫu](docs/adr/0000-template.md));
   - biến môi trường → configuration; endpoint → api; schema → data-model;
   - deploy hay vận hành đổi → deployment, runbook; sự cố → postmortem.
3. Chỗ chưa chắc ghi `[CẦN XÁC NHẬN: …]`; ước lượng ghi "ước lượng thô"; số liệu ghi nguồn và ngày.
4. Sửa nội dung một file tài liệu thì đổi ngày `Cập nhật:` ở dòng metadata.
5. Chạy `python3 scripts/check-links.py .` trước khi kết thúc.

## Lệnh

<!-- Điền khi có code. Mỗi lệnh chạy được từ gốc repo. -->

| Việc | Lệnh |
|---|---|
| Cài đặt | `<lệnh>` |
| Chạy dev | `<lệnh>` |
| Test | `<lệnh>` |
| Lint, kiểu | `<lệnh>` |
| Kiểm link tài liệu | `python3 scripts/check-links.py .` |

## Quy tắc an toàn

- Không đưa secret, token, mật khẩu, IP (ngoài loopback), hostname nội bộ vào repo, tài liệu, log hay commit message.
- Không chạy lệnh ghi, xoá, deploy hay migration lên môi trường thật khi chưa được người phụ trách cho phép. Script thử chạy trong thư mục tạm hoặc container.
- Agent chỉ viết ADR ở trạng thái Đề xuất; chỉ người có quyền quyết định mới chuyển sang Chấp nhận.
- Một repo chỉ có một người (hoặc một agent) ghi cùng lúc; làm song song thì tách nhánh hoặc worktree.
- Commit message bằng tiếng Anh, mô tả vì sao chứ không chỉ cái gì.

## Khi gặp điều bất ngờ

<!-- Ví dụ riêng của dự án: bẫy đã gặp, lệnh không được chạy, dịch vụ ngoài hay chậm. Mỗi mục một dòng, link tới nơi giải thích. -->

- <bẫy hoặc lưu ý, kèm link tài liệu>
