## Thay đổi

<!-- Thay đổi gì và vì sao, 2–4 câu. Link spec, ADR, issue liên quan. -->

## Definition of Done cho tài liệu

<!-- Tick mục đã làm; mục không áp dụng thì xoá dòng. Chi tiết: docs/README.md, mục "Definition of Done cho tài liệu". File chưa có ở dự án này: cập nhật mục tương ứng trong docs/README.md. -->

- [ ] Hành vi người dùng thấy đổi → spec cập nhật (`docs/specs/NNN-<name>/spec.md` hoặc `docs/product/spec.md`); tiêu chí nghiệm thu khớp test
- [ ] Quyết định kiến trúc → ADR mới `docs/adr/NNNN-<name>.md` (trạng thái Đề xuất) và mục lục ADR; ADR bị thay thế đã đổi trạng thái
- [ ] Biến môi trường hoặc cấu hình → `docs/dev/configuration.md` và `.env.example` (chỉ tên biến)
- [ ] Endpoint hoặc hợp đồng API → `docs/api/openapi.yaml` và `docs/api/api.md`
- [ ] Schema hoặc migration → `docs/architecture/data-model.md`
- [ ] Thành phần, luồng, ranh giới → `docs/architecture/ARCHITECTURE.md` và sơ đồ
- [ ] Deploy, hạ tầng, thao tác vận hành → `docs/ops/deployment.md` và runbook liên quan
- [ ] Bề mặt tấn công, bí mật, quyền → `docs/security/threat-model.md`
- [ ] Ngân sách hoặc số đo hiệu năng → `docs/product/nfr.md`, `docs/dev/perf.md`
- [ ] Giao diện hoặc design token → `docs/dev/design-system.md`
- [ ] Thêm feature front-end, đổi tầng hoặc luật import → `docs/dev/frontend.md`
- [ ] Thuật ngữ mới → `docs/product/glossary.md`
- [ ] Cách test hoặc lệnh test → `docs/dev/testing.md`
- [ ] Xong việc hoặc đổi mốc → `docs/plan/progress.md`, `docs/plan/tasks.md`, `tasks.md` của spec
- [ ] Sự cố đã xử lý → postmortem `docs/ops/postmortems/NNN-<name>.md`; runbook đã sửa

## Mọi PR có sửa tài liệu

- [ ] Ngày `Cập nhật:` ở dòng metadata của file đã sửa nội dung là hôm nay
- [ ] `python3 scripts/check-links.py .` không báo lỗi
- [ ] Không secret, token, IP (ngoài loopback), hostname nội bộ, chi tiết lỗ hổng chưa vá
- [ ] Chỗ chưa chắc ghi `[CẦN XÁC NHẬN: …]`; ước lượng ghi "ước lượng thô"
- [ ] File mới đã được link từ `docs/README.md` hoặc mục lục của thư mục chứa nó

## Kiểm thế nào

<!-- Lệnh đã chạy, kết quả, ảnh chụp nếu có giao diện. -->
