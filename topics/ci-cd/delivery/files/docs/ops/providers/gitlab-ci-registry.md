# CI/CD Provider Adapter: GitLab CI + Container Registry

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Core policy](../ci-cd-core.md)

Áp dụng [core policy](../ci-cd-core.md) bằng GitLab CI và Container Registry. Chọn runtime adapter riêng; điền tên project, branch, runner và lệnh thật trước khi sử dụng.

## 1. Mapping

| Core concept | GitLab |
|---|---|
| Change review | Merge request, approval và protected branch |
| CI runner | Runner được quản lý theo mức tin cậy của job |
| Artifact registry | Container Registry; lưu image theo registry digest |
| Environment gate | Protected environment và quyền deploy/approval theo project |
| Credentials | CI/CD variables hoặc identity federation khi nơi đích hỗ trợ |
| Deployment lock | `resource_group` trong CI và lock tại runtime |
| Evidence | Job log, test report, release manifest, signature/provenance |

## 2. Phân tách pipeline

```text
Merge request: lint → test → scan; không có production credentials
Merge vào branch phát hành: test lại commit → build một lần → test image
→ push registry → lấy registry digest → ký/attest → lưu release manifest
→ deploy staging bằng digest → smoke test → approval → deploy production
→ quan sát hoặc rollback
```

Chỉ cho publish từ ref đã kiểm soát. Không cho runner xử lý mã không tin cậy dùng chung quyền registry write, deploy hoặc production variables. Protected branch, tag, environment và runner phải được cấu hình trong GitLab; một dòng `environment:` trong `.gitlab-ci.yml` chưa tạo approval policy.

## 3. Release job contract

1. Checkout đúng commit sau merge và dùng lockfile.
2. Chạy source tests, build image một lần, chạy test trên image đó.
3. Scan image, tạo SBOM, push registry và lấy digest do registry trả về. Không coi image ID cục bộ hoặc tag là digest đã push.
4. Tạo signature/provenance theo policy, lưu release manifest gắn commit, digest, kết quả test và migration version.
5. Truyền `image_ref` dạng `registry.example.com/app@sha256:<FULL_DIGEST>` và `release_id` sang job deploy. Job deploy xác minh manifest, nguồn và digest trước khi dùng.

Không rebuild khi promote staging sang production. Giữ manifest và image đủ lâu để rollback hoặc điều tra sự cố.

## 4. Quyền và runner

| Job | Quyền cần thiết | Runner |
|---|---|---|
| Merge request | Đọc source, ghi test report | Runner không có production secret |
| Publish | Đọc source, đẩy image vào registry, ghi evidence | Runner build đã kiểm soát |
| Staging | Đọc artifact, deploy staging | Runner/identity cho staging |
| Production | Đọc artifact, deploy production | Runner/identity cho production |

Giới hạn CI/CD variables theo environment và trạng thái protected; masking không thay thế việc tách runner và giới hạn quyền. Nếu dùng OIDC/identity federation, cấu hình trust policy theo đúng project, ref và environment, rồi cấp token ngắn hạn tại job cần dùng. Không lưu token deploy dài hạn trong source hoặc image.

## 5. Approval, lock và chống release lỗi thời

- Cấu hình protected environment `production` và người có quyền approve/deploy theo chính sách của dự án.
- Gán cùng `resource_group` cho mọi job có thể thay đổi một environment; serialize cả rollback nếu rollback đi qua CI.
- Runtime phải có lock bao phủ migration, chuyển traffic và rollback. CI lock không bảo vệ thao tác ngoài pipeline.
- Sau khi lấy lock, kiểm release được approve vẫn là release được phép deploy; từ chối job cũ tới muộn.
- Đặt timeout và ghi trạng thái remote để khi job bị huỷ có thể xác định deploy đã đi đến bước nào.

## 6. Điều cần điền cho dự án

| Mục | Giá trị |
|---|---|
| Ref phát hành và merge rules | <…> |
| Runner cho PR, publish, staging, production | <…> |
| Registry, tên image và retention | <…> |
| Lệnh test/build/scan/sign/verify | <…> |
| Nơi lưu manifest và evidence | <…> |
| Người approve production | <…> |
| Lock runtime, smoke test và runbook rollback | <…> |

Tài liệu tham khảo: [Protected environments](https://docs.gitlab.com/ci/environments/protected_environments/), [Resource groups](https://docs.gitlab.com/ci/resource_groups/), [Container Registry](https://docs.gitlab.com/user/packages/container_registry/).
