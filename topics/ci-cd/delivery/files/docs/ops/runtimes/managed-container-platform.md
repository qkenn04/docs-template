# CI/CD Runtime Adapter: Managed Container Platform

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Core policy](../ci-cd-core.md)

Áp dụng [core policy](../ci-cd-core.md) cho nền tảng container được quản lý, chẳng hạn Cloud Run hoặc dịch vụ tương đương. Tính năng traffic, revision và identity khác nhau theo nền tảng; xác nhận hỗ trợ thực tế rồi điền bảng cuối tài liệu.

## 1. Ranh giới trách nhiệm

| Thành phần | Cần xác định |
|---|---|
| Registry | Nơi lưu image, quyền pull, retention và digest |
| CI identity | Quyền tạo revision/deploy, tách staging và production |
| Runtime identity | Quyền ứng dụng gọi database, secret manager và dịch vụ khác |
| Runtime secrets | Nơi giữ, version, cách cấp và xoay vòng |
| Network | Ingress, egress, database connectivity và domain |
| Persistent data | Database/object storage ngoài container, backup và restore |

Nền tảng quản lý máy chạy không tự quản lý dữ liệu, migration hoặc quyết định rollback của ứng dụng.

## 2. Promotion

```text
Xác minh release manifest và image digest
→ staging deploy đúng digest → readiness/smoke test
→ production approval
→ tạo revision từ cùng digest, chưa chuyển traffic nếu nền tảng hỗ trợ
→ kiểm revision qua đường nội bộ/tagged URL
→ chuyển traffic dần hoặc toàn bộ theo policy
→ smoke test qua domain thật, quan sát metric
→ ghi kết quả hoặc rollback traffic/revision
```

Không dùng lệnh “deploy from source” trong bước promote vì nó có thể build lại artifact. Lưu revision ID cùng release ID và digest, kiểm image mà revision thực sự chạy. Nếu nền tảng không cho tạo revision chưa nhận traffic, ghi rõ cách kiểm trước và ngưỡng dừng rollout.

## 3. Migration và rollout

- Migration chạy một lần qua job/task riêng có lock và timeout; kiểm backup/recovery point trước thay đổi rủi ro.
- Khi hai revision cùng nhận traffic, schema phải tương thích cả hai. Session, upload, worker và cron không được phụ thuộc filesystem tạm của instance.
- Đặt giới hạn concurrency, autoscaling, timeout và min/max instances theo tải đã đo; kiểm quota và chi phí khi giữ revision cũ.
- Readiness và smoke test phải kiểm hành vi quan trọng; theo dõi 5xx, p95, database và queue trước khi tăng traffic.
- Chặn release cũ đến muộn bằng lock và kiểm release ID còn hợp lệ tại thời điểm chuyển traffic.

## 4. Rollback và disaster recovery

Rollback có thể chuyển traffic về revision cũ nếu image, runtime secrets và schema vẫn tương thích. Xác minh phục hồi bằng smoke test và metric; rollback revision không khôi phục database. Giữ revision và image cũ đủ lâu theo RTO, đồng thời thử restore dữ liệu và tái tạo cấu hình/IaC định kỳ.

## 5. Điều cần điền cho dự án

| Mục | Giá trị |
|---|---|
| Nền tảng, account/project, region | <…> |
| Staging/production service và identity | <…> |
| Registry, image digest và retention | <…> |
| Secret manager, network và persistent data | <…> |
| Migration job, lock, backup/recovery point | <…> |
| Revision/traffic API, readiness, smoke test | <…> |
| Metric gate, rollback và runbook restore | <…> |

Ví dụ năng lực nền tảng cần đối chiếu khi dùng Cloud Run: [revision và chuyển traffic](https://cloud.google.com/run/docs/rollouts-rollbacks-traffic-migration), [service identity](https://cloud.google.com/run/docs/securing/service-identity). Với nền tảng khác, dùng tài liệu chính thức tương ứng trước khi điền lệnh.
