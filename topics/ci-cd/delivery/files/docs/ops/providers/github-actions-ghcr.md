# CI/CD Provider Adapter: GitHub Actions + GHCR
> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Core policy](../ci-cd-core.md)

File này mô tả cách triển khai [core policy](../ci-cd-core.md) bằng GitHub Actions và GitHub Container Registry. Điền scripts, secrets và điều kiện thật của dự án trước khi chạy.

## 1. Mapping

| Core concept | GitHub/GHCR |
|---|---|
| Change review | Pull Request + branch rules |
| CI runner | GitHub-hosted hoặc self-hosted runner |
| Artifact registry | GHCR |
| Environment gate | GitHub Environments + required reviewers |
| Identity | `GITHUB_TOKEN`, OIDC hoặc secret manager |
| Deployment lock | `concurrency` + lock ở runtime server |
| Evidence | Checks, workflow artifacts, attestations và release manifest |

## 2. Repository policy

Cấu hình tối thiểu:

- Branch protection/ruleset cho `main`.
- Required status checks.
- Review policy cho workflow, Dockerfile, migration và infrastructure.
- Không cho PR fork không tin cậy dùng production secrets.
- Pin action bằng full commit SHA đã xác minh.
- Giới hạn `permissions` ở mức nhỏ nhất.

## 3. Workflow responsibilities

Tách workflow hoặc job theo trách nhiệm:

```text
pull_request
  → source quality + test

push sau merge vào main
  → build + test artifact + scan + SBOM + push GHCR
  → sign/attest + release manifest
  → staging
  → production approval + deploy
```

PR job không nên có quyền publish image hoặc deploy production.

## 4. Quyền theo job

| Job | Quyền |
|---|---|
| Source/PR | `contents: read` và quyền test cần thiết |
| Publish | `contents: read`, packages write; thêm OIDC/attestation nếu dùng |
| Staging | Quyền environment staging và pull artifact |
| Production | Quyền environment production, artifact và runtime deploy |

Không dùng một token quản trị cho toàn bộ workflow.

## 5. Release job contract

Release job phải:

1. Checkout đúng commit sau merge.
2. Cài dependency theo lockfile.
3. Chạy source tests.
4. Build image.
5. Chạy chính image vừa build.
6. Scan image và tạo SBOM.
7. Push image lên GHCR.
8. Lấy digest đầy đủ.
9. Ký/attest digest.
10. Lưu release manifest.
11. Export `image_ref` và `release_id` cho deploy job.

Không build lại image ở staging hoặc production.

## 6. Workflow khung

```yaml
name: release-and-deploy

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  source:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@<VERIFIED_FULL_COMMIT_SHA>
        with:
          ref: ${{ github.sha }}
          persist-credentials: false
      - run: ./scripts/ci-source.sh

  release:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: source
    runs-on: ubuntu-latest
    timeout-minutes: 30
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    outputs:
      image_ref: ${{ steps.publish.outputs.image_ref }}
      release_id: ${{ steps.publish.outputs.release_id }}
    steps:
      - uses: actions/checkout@<VERIFIED_FULL_COMMIT_SHA>
        with:
          ref: ${{ github.sha }}
          persist-credentials: false
      - id: publish
        run: ./scripts/ci-release.sh

  staging:
    needs: release
    environment: staging
    permissions:
      contents: read
      # Thêm id-token: write khi dùng OIDC; packages: read khi dùng GITHUB_TOKEN kéo GHCR riêng tư.
    concurrency:
      group: app-staging
      cancel-in-progress: false
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<VERIFIED_FULL_COMMIT_SHA>
        with:
          ref: ${{ github.sha }}
          persist-credentials: false
      - env:
          TARGET_ENV: staging
          IMAGE_REF: ${{ needs.release.outputs.image_ref }}
          RELEASE_ID: ${{ needs.release.outputs.release_id }}
        run: ./scripts/deploy-release.sh

  production:
    needs: [release, staging]
    environment: production
    permissions:
      contents: read
      # Thêm id-token: write khi dùng OIDC; packages: read khi dùng GITHUB_TOKEN kéo GHCR riêng tư.
    concurrency:
      group: app-production
      cancel-in-progress: false
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<VERIFIED_FULL_COMMIT_SHA>
        with:
          ref: ${{ github.sha }}
          persist-credentials: false
      - env:
          TARGET_ENV: production
          IMAGE_REF: ${{ needs.release.outputs.image_ref }}
          RELEASE_ID: ${{ needs.release.outputs.release_id }}
        run: ./scripts/deploy-release.sh
```

Đây là khung minh họa. Cần cấu hình required reviewers, secrets, SSH/cloud identity và scripts thực tế trước khi dùng.

## 7. GHCR và digest

Tag có thể dùng để tìm image:

```text
ghcr.io/org/app:sha-a1b2c3d
```

Production phải dùng digest:

```text
ghcr.io/org/app@sha256:<FULL_DIGEST>
```

Không dùng `latest` làm input deploy. Không coi Docker image ID trên runner là registry digest.

## 8. OIDC, secrets và environments

- Dùng GitHub Environment để tách staging/production secrets và approval.
- `environment: production` chỉ liên kết job với environment; required reviewers phải được cấu hình riêng.
- Dùng OIDC nếu cloud/secret manager hỗ trợ trust policy theo đúng repository, workflow và environment.
- Nếu job deploy dùng OIDC, thêm `id-token: write` tại job đó. Nếu dùng `GITHUB_TOKEN` để kéo image GHCR riêng tư, thêm `packages: read` và cấp quyền đọc package cho repository chạy workflow.
- Với VPS SSH, dùng deploy user riêng, host key verification và credential có giới hạn.
- Không checkout code PR không tin cậy trong job có production secrets.

## 9. Adapter checklist

- [ ] Actions đã pin bằng full commit SHA.
- [ ] `permissions` được giới hạn theo job.
- [ ] PR job không publish/deploy production.
- [ ] GHCR image được push sau khi test.
- [ ] Digest đầy đủ được lưu trong release manifest.
- [ ] Signature/attestation được verify trước deploy.
- [ ] Staging và production dùng cùng `image_ref`.
- [ ] Environment reviewers và secrets đã cấu hình.
- [ ] `concurrency` kết hợp với lock ở runtime server.
- [ ] Workflow timeout không để remote deployment ở trạng thái không rõ.
