# CI/CD delivery policy và adapters

> Trạng thái: Đang áp dụng · Cập nhật: 2026-10-07 · Liên quan: [Danh sách topic](../../README.md), [Core policy](files/docs/ops/ci-cd-core.md)

Topic này dựng một core policy và các mẫu adapter cho CI provider/runtime. Chọn một provider và một runtime phù hợp với dự án, điền thông tin thật rồi xoá các adapter không dùng. Các file đều là mẫu tài liệu, chưa phải pipeline đã cấu hình.

```bash
docs-template/scripts/new-project-docs.sh --topic ci-cd/delivery standard ../my-app "My App"
```

Cấu trúc được tạo trong project:

```text
docs/ops/ci-cd-core.md
docs/ops/providers/
docs/ops/runtimes/
```

| Vai trò | File có sẵn |
|---|---|
| Core | [Chính sách release](files/docs/ops/ci-cd-core.md) |
| CI provider | [GitHub Actions + GHCR](files/docs/ops/providers/github-actions-ghcr.md), [GitLab CI + Registry](files/docs/ops/providers/gitlab-ci-registry.md), [Jenkins + Registry](files/docs/ops/providers/jenkins-registry.md) |
| Runtime | [VPS + Docker Compose](files/docs/ops/runtimes/vps-docker-compose.md), [Kubernetes](files/docs/ops/runtimes/kubernetes.md), [Managed container platform](files/docs/ops/runtimes/managed-container-platform.md) |

Sau khi sinh, thêm link tới core và adapter đã chọn trong `docs/README.md` của project (hoặc `README.md` với profile minimal/retiring); ghi lệnh, quyền, identity, nơi lưu evidence, SLO và runbook thật trong docs triển khai. Script giữ nguyên file đã có nên không tự sửa bản đồ tài liệu của project. Workflow, Compose/Kubernetes manifest và script deploy phải được tạo theo project thực tế.
