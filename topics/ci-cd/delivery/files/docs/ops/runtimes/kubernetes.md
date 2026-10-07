# CI/CD Runtime Adapter: Kubernetes

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Core policy](../ci-cd-core.md)

Áp dụng [core policy](../ci-cd-core.md) cho một ứng dụng chạy trên Kubernetes. Provider CI phải tạo release manifest và image theo digest; điền tên cluster, namespace và lệnh thật của dự án trước khi sử dụng.

## 1. Ranh giới môi trường

| Mục | Cách chọn |
|---|---|
| Staging/production | Cluster hoặc namespace riêng theo mức cô lập cần thiết |
| Identity deploy | Service account hoặc cloud identity theo environment, quyền nhỏ nhất |
| Runtime secret | Secret manager/cluster secret theo environment; không nhúng vào image |
| Artifact | `registry.example.com/app@sha256:<FULL_DIGEST>` từ release manifest |
| Evidence | Manifest, rollout status, smoke test, metric, người approve |

Định nghĩa tài nguyên theo GitOps hoặc manifest/Helm/Kustomize đã review. Không cho PR không tin cậy dùng production kubeconfig hay identity deploy.

## 2. Deploy flow

```text
Lấy deployment lock
→ xác minh release manifest, chữ ký/provenance và image digest
→ kiểm backup/recovery point và migration version
→ chạy migration Job duy nhất có lock và timeout
→ cập nhật Deployment với image digest
→ chờ rollout/readiness trong timeout
→ kiểm nội bộ, rồi smoke test qua đường người dùng
→ theo dõi metric, ghi kết quả hoặc xử lý rollback
```

Job migration cần tên/version duy nhất, cách xử lý khi chạy dở và lịch sử thực thi. Không chạy migration từ mọi Pod khi scale. Schema phải tương thích với Pod cũ trong thời gian rolling update hoặc rollback.

## 3. Readiness, traffic và rollout

- `readinessProbe` chỉ cho Pod nhận traffic khi dependency thiết yếu sẵn sàng; `livenessProbe` dành cho phát hiện tiến trình kẹt, không thay smoke test.
- Đặt `maxSurge`, `maxUnavailable`, `progressDeadlineSeconds`, request/limit và PodDisruptionBudget theo SLO của dự án.
- Rolling update của Deployment không tự cung cấp canary theo phần trăm traffic. Muốn canary/blue-green cần ingress, service mesh hoặc rollout controller hỗ trợ, và phải ghi rõ cách chuyển traffic.
- Giữ Pod cũ đủ lâu cho request dài/WebSocket; worker và cron phải tránh xử lý trùng khi hai version cùng tồn tại.
- Chặn release cũ đến muộn bằng lock và kiểm release ID mới nhất còn được phép promote.

## 4. Rollback và xác nhận phục hồi

Lưu digest bản trước và bản cấu hình tương ứng. Khi lỗi, kiểm schema và runtime secrets còn tương thích trước khi đưa bản cũ trở lại. `kubectl rollout undo` chỉ quay lại Pod template trong lịch sử Deployment; nó không khôi phục database, secret hay tài nguyên đã đổi ngoài Deployment.

Sau rollback, chờ readiness, smoke test qua endpoint thật và theo dõi metric. Nếu migration đã đổi dữ liệu không tương thích, làm theo runbook khôi phục riêng thay vì rollback container mù quáng.

## 5. Backup, audit và DR

Backup database, volume bền vững, manifest/IaC, release evidence và cấu hình truy cập. Thử restore trong môi trường cách ly, ghi RPO/RTO thực tế. Audit trail cần commit, digest, namespace, người approve, thời điểm rollout, traffic và kết quả rollback.

## 6. Điều cần điền cho dự án

| Mục | Giá trị |
|---|---|
| Cluster/namespace staging và production | <…> |
| Controller/IaC và owner review | <…> |
| Registry pull identity và deploy identity | <…> |
| Migration Job, lock và timeout | <…> |
| Readiness, smoke test và metric gate | <…> |
| Chiến lược traffic, drain, worker/cron | <…> |
| Release history và runbook rollback/restore | <…> |

Tài liệu tham khảo: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [Probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/), [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/).
