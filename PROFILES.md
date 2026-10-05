# Chọn hồ sơ tài liệu

> Trạng thái: Đang áp dụng · Cập nhật: 2026-10-03 · Liên quan: [README](README.md), [Khung tài liệu](README.md#1-khung-tài-liệu), [Bảng file theo hồ sơ](README.md#2-hồ-sơ), [Script dựng](scripts/new-project-docs.sh)

Bộ tài liệu đầy đủ của bộ khuôn có 38 file, nhưng không dự án nào nên mang đủ 38 file ngay từ đầu. Một CLI nhỏ mà có `threat-model.md`, `runbooks/`, `specs/` và `design/` thì phần lớn là file rỗng: không ai điền, không ai đọc, và làm người mới khó thấy đâu là tài liệu thật. Ngược lại, một dịch vụ đang chạy thật mà thiếu runbook hay tài liệu cấu hình thì sẽ trả giá lúc có sự cố.

**Nếu 8 file của LITE vẫn quá nhiều:** dùng [`minimal`](profiles/minimal.txt). Hồ sơ này chỉ thêm một `README.md` ngắn, không có `docs/`, ADR, AGENTS, mẫu PR hay script kiểm link. Nó là điểm khởi đầu thực dụng nằm ngoài bảng phân tầng bên dưới. Khi cần thêm tài liệu, chạy hồ sơ khác; script giữ README hiện có, nên hãy bổ sung link tới file mới theo nhu cầu.

**Hồ sơ** giải quyết chuyện đó: mỗi hồ sơ là một danh sách file (`profiles/<hồ-sơ>.txt`) hợp với một cỡ và một giai đoạn sống của dự án. Chọn theo hai câu hỏi:

- **Cỡ:** dự án có người dùng thật không, có phải vận hành (deploy, trực sự cố, giữ dữ liệu) không, bao nhiêu người cùng làm.
- **Giai đoạn:** đang xây, đang chạy, hay đã có quyết định ngừng.

Chọn nhỏ cũng không sao: script chỉ **thêm** file còn thiếu và không bao giờ ghi đè, nên lên hồ sơ lớn hơn sau này chỉ tốn một lệnh ([mục 8](#8-lên-mức-khi-dự-án-lớn-dần)).

Mục lục: [1. Chọn nhanh](#1-chọn-nhanh) · [2. So sánh](#2-so-sánh-5-hồ-sơ) · [3. FULL](#3-full) · [4. STANDARD](#4-standard) · [5. PLATFORM](#5-platform) · [6. LITE](#6-lite) · [7. RETIRING](#7-retiring) · [8. Lên mức](#8-lên-mức-khi-dự-án-lớn-dần) · [9. Câu hỏi thường gặp](#9-câu-hỏi-thường-gặp)

## 1. Chọn nhanh

Đi từ trên xuống; câu trả lời "có" đầu tiên cho ra hồ sơ:

```text
[1] Hệ thống đã có quyết định ngừng? ---------------------------- có --> RETIRING
     | không
     v
[2] Repo hạ tầng: cấu hình máy chủ, CI dùng chung, giám sát? ---- có --> PLATFORM
     | không
     v
[3] Nhỏ, một người dùng, không có vận hành đáng kể? ------------- có --> LITE
     | không
     v
[4] Có người dùng thật và phải vận hành: ít nhất là STANDARD.
     |
     v
[5] Sản phẩm chính, nhiều tính năng, sống lâu? ------------------ có --> FULL
     | không
     v
    STANDARD
```

Cùng nội dung, dạng danh sách:

1. Hệ thống **đã có quyết định ngừng**? → **RETIRING**.
2. Repo là **hạ tầng**: cấu hình máy chủ, CI dùng chung, giám sát? → **PLATFORM**.
3. **Nhỏ**, một người dùng (hoặc chỉ chính bạn), **không có vận hành đáng kể**? → **LITE**.
4. **Có người dùng thật và phải vận hành** (deploy, sự cố, dữ liệu)? → **STANDARD**.
5. Hơn thế: **sản phẩm chính, nhiều tính năng, sống lâu**, nhiều người cùng làm? → **FULL**.

Phân vân giữa hai hồ sơ thì chọn hồ sơ nhỏ hơn. Bốn hồ sơ LITE, PLATFORM, STANDARD, FULL lồng nhau (mỗi hồ sơ chứa trọn hồ sơ đứng trước), nên lên mức không bao giờ phải bỏ file nào. RETIRING đứng riêng: nó dùng biến thể của README, AGENTS và lộ trình.

## 2. So sánh 5 hồ sơ

Tầng lấy theo [khung tài liệu](README.md#1-khung-tài-liệu): T1 bắt buộc, T1\* bắt buộc khi điều kiện xảy ra, T2 nên có khi dự án có khía cạnh đó, T3 tuỳ chọn cho dự án lớn. Mỗi ô ghi số file riêng / số ô của tầng; "mục" là nội dung nằm thành một mục trong `docs/README.md` thay vì file riêng.

| | FULL | STANDARD | PLATFORM | LITE | RETIRING |
|---|:-:|:-:|:-:|:-:|:-:|
| **Số file** | 38 | 32 | 25 | 8 | 4 |
| **T1** (8 ô) | 8/8 | 8/8 | 8/8 | 4/8, còn lại là mục | 2/8, biến thể |
| **T1\*** (4 ô) | 4/4 | 4/4 | 4/4 | 1/4, thuật ngữ là mục | 1/4 |
| **T2** (21 ô, gồm threat model) | 21/21 | 18/21 | 11/21 | 1/21, 4 ô là mục | 1/21, kế hoạch ngừng |
| **T3** (3 ô) | 3/3 | 0/3 | 0/3 | 0/3 | 0/3 |
| **File kèm** (mẫu PR, `check-links.py`) | 2/2 | 2/2 | 2/2 | 2/2 | 0/2 |
| **Dự án điển hình** | Sản phẩm chính nhiều tính năng, có người dùng ngoài | Web app, API, bot đang chạy thật | Cấu hình máy chủ, CI dùng chung, giám sát | Tool nhỏ, thư viện, CLI, site tĩnh, prototype | Hệ thống đã quyết định ngừng |

Bảng từng file theo hồ sơ: [README, mục 2](README.md#2-hồ-sơ). Nguồn sự thật là `profiles/<hồ-sơ>.txt`.

**Dự án dùng NestJS:** sau khi dựng hồ sơ STANDARD hoặc FULL, chép thêm [mẫu cấu trúc NestJS](template/docs/dev/backend-nestjs.md) vào `docs/dev/backend-nestjs.md` và điền theo dự án ([lệnh chép](README.md#82-repo-có-sẵn-script)). Đây là mẫu theo công nghệ, độc lập với cỡ hồ sơ; các hồ sơ không tự thêm nó cho dự án dùng backend khác. Mẫu hướng dẫn tổ chức mã nguồn, không tạo mã NestJS.

Mọi lệnh dưới đây chạy từ thư mục chứa bản clone `docs-template/`; thêm `--dry-run` để xem trước mà không ghi gì.

## 3. FULL

**Dùng khi** dự án là sản phẩm chính: nhiều tính năng, có người dùng ngoài, có giao diện, API và vận hành, sống nhiều năm, nhiều người hoặc nhiều nhóm cùng làm. Ví dụ:

- ứng dụng SaaS chính của một nhóm: giao diện web, API công khai, người dùng trả phí;
- ứng dụng di động kèm backend, phát hành theo mốc, có nhóm thiết kế riêng;
- nền tảng nội bộ lớn được nhiều nhóm dùng, thay đổi lớn cần bàn trước bằng RFC.

**Tạo những file gì** ([profiles/full.txt](profiles/full.txt)):

<details>
<summary>38 file (bấm để mở)</summary>

| File | Dùng để |
|---|---|
| `README.md` | Cổng vào repo: dự án là gì, quick start, đọc tiếp ở đâu |
| `AGENTS.md` | Quy tắc cho agent AI và người mới; ngắn, chỉ trỏ vào `docs/`; viết sau cùng |
| `CLAUDE.md` | Dòng `@AGENTS.md` và vài ghi chú riêng cho Claude Code |
| `.github/pull_request_template.md` | Checklist Definition of Done cho tài liệu trong mỗi PR |
| `scripts/check-links.py` | Kiểm link tương đối và anchor trong mọi file Markdown (chạy tay hoặc trong CI) |
| `docs/README.md` | Bản đồ tài liệu: câu hỏi nào đọc file nào, quy ước, Definition of Done |
| `docs/product/spec.md` | Mục tiêu, điều không làm, tiêu chí nghiệm thu cấp sản phẩm |
| `docs/product/nfr.md` | Yêu cầu phi chức năng, ngân sách hiệu năng, độ sẵn sàng, bảo mật |
| `docs/product/glossary.md` | Thuật ngữ riêng của dự án, mỗi từ một nghĩa |
| `docs/architecture/ARCHITECTURE.md` | Thành phần, luồng, môi trường (C4 mức 1–2) |
| `docs/architecture/data-model.md` | Thực thể, bất biến, vòng đời dữ liệu |
| `docs/architecture/principles.md` | Nguyên tắc kiến trúc viết sao cho kiểm được |
| `docs/architecture/diagrams/README.md` | Quy ước và mục lục sơ đồ Mermaid kiểu C4 |
| `docs/adr/README.md` | Mục lục ADR, vòng đời trạng thái, khi nào cần ADR |
| `docs/adr/0000-template.md` | Mẫu ADR để chép (không phải quyết định) |
| `docs/adr/0001-record-architecture-decisions.md` | ADR đầu tiên: quyết định ghi quyết định bằng ADR |
| `docs/api/openapi.yaml` | Hợp đồng API máy đọc được (OpenAPI 3.1) |
| `docs/api/api.md` | Quy ước API cho người đọc: xác thực, lỗi, phân trang, phiên bản |
| `docs/dev/testing.md` | Chiến lược test, lệnh test, cổng chất lượng trong CI |
| `docs/dev/configuration.md` | Biến môi trường, cờ cấu hình, bí mật (chỉ tên, không giá trị) |
| `docs/dev/design-system.md` | Design token và thành phần giao diện |
| `docs/dev/frontend.md` | Cấu trúc thư mục front-end: tầng app, features, shared; luật import; bộ khung một feature |
| `docs/dev/perf.md` | Số đo hiệu năng thật so với ngân sách trong `nfr.md` |
| `docs/security/threat-model.md` | Tài sản, tác nhân, đe doạ, lớp bảo vệ |
| `docs/plan/roadmap.md` | Thứ tự mốc, phụ thuộc, điều kiện xong của mỗi mốc |
| `docs/plan/tasks.md` | Hàng đợi việc 1–2 tuần cấp dự án |
| `docs/plan/progress.md` | Mốc nào xong, khi nào, bằng chứng, lệch ước lượng |
| `docs/specs/README.md` | Mục lục spec tính năng, khi nào cần spec |
| `docs/specs/000-template/spec.md` | Mẫu spec một tính năng: hành vi, tiêu chí Given/When/Then |
| `docs/specs/000-template/plan.md` | Mẫu kế hoạch làm một tính năng: thiết kế, thứ tự, rủi ro |
| `docs/specs/000-template/tasks.md` | Mẫu danh sách việc tick được của một tính năng |
| `docs/design/README.md` | Mục lục RFC, vòng đời, khi nào viết RFC |
| `docs/design/0000-rfc-template.md` | Mẫu RFC để chép |
| `docs/ops/deployment.md` | Cách deploy, rollback, môi trường |
| `docs/ops/runbooks/README.md` | Bảng tra nhanh sự cố và mục lục runbook |
| `docs/ops/runbooks/000-template.md` | Mẫu runbook xử lý một loại sự cố |
| `docs/ops/postmortems/README.md` | Khi nào viết postmortem, nguyên tắc, mục lục |
| `docs/ops/postmortems/000-template.md` | Mẫu postmortem sau sự cố P1/P2 |

</details>

**Bỏ qua những gì và vì sao.** Không bỏ ô nào. Một số ô chỉ có nghĩa khi điều kiện xảy ra: `design-system.md` khi có giao diện riêng, `frontend.md` khi có ứng dụng giao diện có state, `perf.md` khi đã có số đo, `glossary.md` khi có thuật ngữ riêng. Chưa tới lúc thì để file ở trạng thái Nháp hoặc xoá hàng tương ứng trong bản đồ của `docs/README.md`.

```bash
docs-template/scripts/new-project-docs.sh full ../my-app "My App"
```

## 4. STANDARD

**Dùng khi** dự án là một web app, API hay bot đang chạy thật: có người dùng thật, có dữ liệu, phải deploy và xử lý sự cố, nhưng chưa lớn tới mức cần RFC hay design system. Đây là hồ sơ mặc định cho phần lớn dự án. Ví dụ:

- web app hoặc dịch vụ API có người dùng thật, một nhóm nhỏ phát triển;
- bot chat hoặc worker xử lý hàng đợi chạy production;
- công cụ nội bộ có dữ liệu thật, cần deploy và trực sự cố.

**Tạo những file gì** ([profiles/standard.txt](profiles/standard.txt)):

<details>
<summary>32 file (bấm để mở)</summary>

| File | Dùng để |
|---|---|
| `README.md` | Cổng vào repo: dự án là gì, quick start, đọc tiếp ở đâu |
| `AGENTS.md` | Quy tắc cho agent AI và người mới; ngắn, chỉ trỏ vào `docs/`; viết sau cùng |
| `CLAUDE.md` | Dòng `@AGENTS.md` và vài ghi chú riêng cho Claude Code |
| `.github/pull_request_template.md` | Checklist Definition of Done cho tài liệu trong mỗi PR |
| `scripts/check-links.py` | Kiểm link tương đối và anchor trong mọi file Markdown (chạy tay hoặc trong CI) |
| `docs/README.md` | Bản đồ tài liệu: câu hỏi nào đọc file nào, quy ước, Definition of Done |
| `docs/product/spec.md` | Mục tiêu, điều không làm, tiêu chí nghiệm thu cấp sản phẩm |
| `docs/product/nfr.md` | Yêu cầu phi chức năng, ngân sách hiệu năng, độ sẵn sàng, bảo mật |
| `docs/product/glossary.md` | Thuật ngữ riêng của dự án, mỗi từ một nghĩa |
| `docs/architecture/ARCHITECTURE.md` | Thành phần, luồng, môi trường (C4 mức 1–2) |
| `docs/architecture/data-model.md` | Thực thể, bất biến, vòng đời dữ liệu |
| `docs/architecture/diagrams/README.md` | Quy ước và mục lục sơ đồ Mermaid kiểu C4 |
| `docs/adr/README.md` | Mục lục ADR, vòng đời trạng thái, khi nào cần ADR |
| `docs/adr/0000-template.md` | Mẫu ADR để chép (không phải quyết định) |
| `docs/adr/0001-record-architecture-decisions.md` | ADR đầu tiên: quyết định ghi quyết định bằng ADR |
| `docs/api/openapi.yaml` | Hợp đồng API máy đọc được (OpenAPI 3.1) |
| `docs/api/api.md` | Quy ước API cho người đọc: xác thực, lỗi, phân trang, phiên bản |
| `docs/dev/testing.md` | Chiến lược test, lệnh test, cổng chất lượng trong CI |
| `docs/dev/configuration.md` | Biến môi trường, cờ cấu hình, bí mật (chỉ tên, không giá trị) |
| `docs/security/threat-model.md` | Tài sản, tác nhân, đe doạ, lớp bảo vệ |
| `docs/plan/roadmap.md` | Thứ tự mốc, phụ thuộc, điều kiện xong của mỗi mốc |
| `docs/plan/tasks.md` | Hàng đợi việc 1–2 tuần cấp dự án |
| `docs/plan/progress.md` | Mốc nào xong, khi nào, bằng chứng, lệch ước lượng |
| `docs/specs/README.md` | Mục lục spec tính năng, khi nào cần spec |
| `docs/specs/000-template/spec.md` | Mẫu spec một tính năng: hành vi, tiêu chí Given/When/Then |
| `docs/specs/000-template/plan.md` | Mẫu kế hoạch làm một tính năng: thiết kế, thứ tự, rủi ro |
| `docs/specs/000-template/tasks.md` | Mẫu danh sách việc tick được của một tính năng |
| `docs/ops/deployment.md` | Cách deploy, rollback, môi trường |
| `docs/ops/runbooks/README.md` | Bảng tra nhanh sự cố và mục lục runbook |
| `docs/ops/runbooks/000-template.md` | Mẫu runbook xử lý một loại sự cố |
| `docs/ops/postmortems/README.md` | Khi nào viết postmortem, nguyên tắc, mục lục |
| `docs/ops/postmortems/000-template.md` | Mẫu postmortem sau sự cố P1/P2 |

</details>

**Bỏ qua những gì và vì sao** (so với FULL, 6 file):

| Bỏ | Vì sao | Thêm khi |
|---|---|---|
| `docs/dev/design-system.md` | Nhiều dịch vụ không có giao diện riêng, hoặc dùng thư viện UI có sẵn | Có design token, thành phần giao diện dùng lại |
| `docs/dev/frontend.md` | Dịch vụ không có ứng dụng giao diện, hoặc giao diện chỉ vài màn | Có ứng dụng giao diện có state (form, gọi API) và từ hai tính năng trở lên |
| `docs/dev/perf.md` | File số đo mà chưa đo thì rỗng; ngân sách hiệu năng đã nằm trong `nfr.md` | Đã có lần đo đầu tiên |
| `docs/architecture/principles.md` | T3; với một nhóm nhỏ, ADR đã đủ giữ lý do | Nhiều người phải theo cùng nguyên tắc mà ADR không tiện tra |
| `docs/design/README.md`, `docs/design/0000-rfc-template.md` | T3; RFC chỉ đáng công khi thay đổi lớn cần nhiều người góp ý trước | Thay đổi lớn cần bàn trước khi quyết |

```bash
docs-template/scripts/new-project-docs.sh standard ../my-app "My App"
```

## 5. PLATFORM

**Dùng khi** repo là hạ tầng hoặc nền tảng dùng chung: nặng vận hành và bảo mật, không có tính năng cho người dùng cuối, không có API công khai. Ví dụ:

- repo cấu hình máy chủ, reverse proxy, container (infrastructure as code);
- workflow CI hoặc action dùng chung cho nhiều repo;
- cấu hình giám sát: dashboard, rule cảnh báo, kênh báo động.

**Tạo những file gì** ([profiles/platform.txt](profiles/platform.txt)):

<details>
<summary>25 file (bấm để mở)</summary>

| File | Dùng để |
|---|---|
| `README.md` | Cổng vào repo: dự án là gì, quick start, đọc tiếp ở đâu |
| `AGENTS.md` | Quy tắc cho agent AI và người mới; ngắn, chỉ trỏ vào `docs/`; viết sau cùng |
| `CLAUDE.md` | Dòng `@AGENTS.md` và vài ghi chú riêng cho Claude Code |
| `.github/pull_request_template.md` | Checklist Definition of Done cho tài liệu trong mỗi PR |
| `scripts/check-links.py` | Kiểm link tương đối và anchor trong mọi file Markdown (chạy tay hoặc trong CI) |
| `docs/README.md` | Bản đồ tài liệu: câu hỏi nào đọc file nào, quy ước, Definition of Done |
| `docs/product/spec.md` | Mục tiêu, điều không làm, tiêu chí nghiệm thu cấp sản phẩm |
| `docs/product/nfr.md` | Yêu cầu phi chức năng, ngân sách hiệu năng, độ sẵn sàng, bảo mật |
| `docs/product/glossary.md` | Thuật ngữ riêng của dự án, mỗi từ một nghĩa |
| `docs/architecture/ARCHITECTURE.md` | Thành phần, luồng, môi trường (C4 mức 1–2) |
| `docs/architecture/diagrams/README.md` | Quy ước và mục lục sơ đồ Mermaid kiểu C4 |
| `docs/adr/README.md` | Mục lục ADR, vòng đời trạng thái, khi nào cần ADR |
| `docs/adr/0000-template.md` | Mẫu ADR để chép (không phải quyết định) |
| `docs/adr/0001-record-architecture-decisions.md` | ADR đầu tiên: quyết định ghi quyết định bằng ADR |
| `docs/dev/testing.md` | Chiến lược test, lệnh test, cổng chất lượng trong CI |
| `docs/dev/configuration.md` | Biến môi trường, cờ cấu hình, bí mật (chỉ tên, không giá trị) |
| `docs/security/threat-model.md` | Tài sản, tác nhân, đe doạ, lớp bảo vệ |
| `docs/plan/roadmap.md` | Thứ tự mốc, phụ thuộc, điều kiện xong của mỗi mốc |
| `docs/plan/tasks.md` | Hàng đợi việc 1–2 tuần cấp dự án |
| `docs/plan/progress.md` | Mốc nào xong, khi nào, bằng chứng, lệch ước lượng |
| `docs/ops/deployment.md` | Cách deploy, rollback, môi trường |
| `docs/ops/runbooks/README.md` | Bảng tra nhanh sự cố và mục lục runbook |
| `docs/ops/runbooks/000-template.md` | Mẫu runbook xử lý một loại sự cố |
| `docs/ops/postmortems/README.md` | Khi nào viết postmortem, nguyên tắc, mục lục |
| `docs/ops/postmortems/000-template.md` | Mẫu postmortem sau sự cố P1/P2 |

</details>

**Bỏ qua những gì và vì sao** (so với STANDARD, thêm 7 file):

| Bỏ | Vì sao |
|---|---|
| `docs/api/openapi.yaml`, `docs/api/api.md` | Không có API công khai; giao diện với bên ngoài là cấu hình, ghi trong `configuration.md` |
| `docs/architecture/data-model.md` | Không sở hữu dữ liệu nghiệp vụ; nơi dữ liệu nằm và sao lưu ghi trong `ARCHITECTURE.md`, `deployment.md` |
| `docs/specs/` (4 file) | Không có tính năng người dùng; thay đổi hạ tầng ghi bằng ADR, việc ghi trong `plan/tasks.md` |
| Các ô FULL mà STANDARD cũng bỏ | Cùng lý do như ở mục 4 |

Repo hạ tầng mà sau này có API công khai (ví dụ API quản trị cho nhóm khác gọi): chạy lại script với `standard` để thêm `api/`, `data-model.md`, `specs/`.

```bash
docs-template/scripts/new-project-docs.sh platform ../infra "Infra"
```

## 6. LITE

**Dùng khi** dự án nhỏ, một người dùng hoặc chỉ chính bạn, không có vận hành đáng kể: không trực sự cố, không giữ dữ liệu của ai. Ví dụ:

- tool nhỏ, thư viện, CLI;
- site tĩnh một trang, script tiện ích;
- prototype thử ý tưởng, chưa có người dùng.

**Tạo những file gì** ([profiles/lite.txt](profiles/lite.txt)):

| File | Dùng để |
|---|---|
| `README.md` | Cổng vào repo: dự án là gì, quick start, đọc tiếp ở đâu |
| `AGENTS.md` | Quy tắc cho agent AI và người mới; ngắn, chỉ trỏ vào `docs/`; viết sau cùng |
| `CLAUDE.md` | Dòng `@AGENTS.md` và vài ghi chú riêng cho Claude Code |
| `.github/pull_request_template.md` | Checklist Definition of Done cho tài liệu trong mỗi PR |
| `scripts/check-links.py` | Kiểm link tương đối và anchor trong mọi file Markdown (chạy tay hoặc trong CI) |
| `docs/README.md` | Biến thể LITE: một file chứa các mục T1 (mục tiêu, NFR, kiến trúc, thuật ngữ, quyết định, lệnh, vận hành, tiến độ) + quy ước |
| `docs/adr/0000-template.md` | Mẫu ADR để chép (không phải quyết định) |
| `docs/adr/0001-record-architecture-decisions.md` | ADR đầu tiên: quyết định ghi quyết định bằng ADR |

**Bỏ qua những gì và vì sao.** Mọi file riêng còn lại. Nội dung T1 vẫn bắt buộc, nhưng nằm thành mục trong một file `docs/README.md` cho tới khi đủ lớn để tách (xem [mục 8](#8-lên-mức-khi-dự-án-lớn-dần)): dự án nhỏ đọc một file nhanh hơn mười file nửa trống. Không có runbook, postmortem, threat model vì không có vận hành hay dữ liệu người dùng đáng kể; không có lộ trình và hàng đợi việc riêng vì tiến độ chỉ là một mục. ADR vẫn là file riêng vì mỗi quyết định là một file bất biến ngay từ đầu.

```bash
docs-template/scripts/new-project-docs.sh lite ../my-cli "My CLI"
```

## 7. RETIRING

**Dùng khi** hệ thống **đã có quyết định ngừng**. Hệ thống sắp ngừng không nên nhận tài liệu mới; nó chỉ cần ba thứ: ai mở repo cũng thấy ngay là đang ngừng, người sửa repo biết mình còn được làm gì, và một kế hoạch ngừng để gỡ không sót và không mất dữ liệu. Ví dụ:

- dịch vụ cũ đã có hệ thống mới thay;
- tính năng hoặc sản phẩm thử nghiệm không đạt, sắp tắt;
- công cụ nội bộ không còn ai dùng, cần gỡ sạch tài nguyên và thu hồi bí mật.

**Tạo những file gì** ([profiles/retiring.txt](profiles/retiring.txt)):

| File | Dùng để |
|---|---|
| `README.md` | Biến thể RETIRING: banner "Đang ngừng" ở đầu, người dùng cần làm gì, còn được sửa gì |
| `AGENTS.md` | Biến thể RETIRING: chỉ sửa lỗi hoặc làm bước trong kế hoạch ngừng; không xoá gì khi chưa khôi phục thử bản sao lưu |
| `CLAUDE.md` | Dòng `@AGENTS.md` và vài ghi chú riêng cho Claude Code |
| `docs/plan/roadmap.md` | Biến thể RETIRING, kế hoạch ngừng: khi nào, gỡ gì, dữ liệu và bản sao lưu đi đâu, báo ai, khi nào dừng lại hoặc lùi |

**Bỏ qua những gì và vì sao.** Mọi file khác, kể cả mẫu PR và `check-links.py`. Tài liệu dự án đã có (triển khai, runbook, cấu hình, ADR) **giữ nguyên** và dùng tiếp tới ngày ngừng; ba file mẫu chỉ nhắc chúng bằng đường dẫn dạng chữ, ví dụ "(nếu dự án có: `docs/ops/deployment.md`)", nên bộ 4 file không có link hỏng dù dự án có hay không có các file đó. Quyết định trong lúc ngừng ghi ở mục "Nhật ký quyết định" của kế hoạch ngừng thay vì viết ADR mới. Kiểm link bằng bản của bộ khuôn: `python3 docs-template/scripts/check-links.py <repo>`.

Repo mới hoặc chưa có các file này:

```bash
docs-template/scripts/new-project-docs.sh retiring ../old-app "Old App"
```

Repo **đã có** `README.md`, `AGENTS.md`, `docs/plan/roadmap.md` (thường gặp nhất): script báo "bỏ qua" các file đó và không ghi đè. Dựng ra thư mục tạm rồi chép phần cần:

```bash
tmp="$(mktemp -d)"
docs-template/scripts/new-project-docs.sh retiring "$tmp" "Old App"
# 1. ../old-app/README.md: chép khối banner "> [!WARNING] ... Đang ngừng ..." và mục
#    "Người dùng cần làm gì" từ "$tmp/README.md" lên ngay dưới dòng metadata.
# 2. ../old-app/AGENTS.md: chép mục "Giai đoạn ngừng" từ "$tmp/AGENTS.md" lên đầu file.
# 3. Lộ trình cũ hết hiệu lực: giữ lại để tra (đổi trạng thái sang "Lưu trữ"), kế hoạch ngừng thay chỗ nó.
git -C ../old-app mv docs/plan/roadmap.md docs/plan/roadmap-archive.md
cp "$tmp/docs/plan/roadmap.md" ../old-app/docs/plan/roadmap.md
rm -rf "${tmp:?}"
python3 docs-template/scripts/check-links.py ../old-app   # link tới anchor của lộ trình cũ báo lỗi: trỏ sang roadmap-archive.md
```

Trong repo đã có tài liệu, các đường dẫn dạng chữ trong kế hoạch ngừng (deployment, runbook, cấu hình) đổi thành link thật được.

## 8. Lên mức khi dự án lớn dần

### 8.1 Khi nào tách một mục thành file

Quy tắc chung của bộ khuôn ([README, mục 3](README.md#3-quy-tắc-tách-file)): một mục trong `README.md` hoặc `docs/README.md` được tách thành file riêng, đúng ô của khung, khi

1. mục đó dài quá khoảng **80 dòng**, hoặc
2. **tài liệu khác cần link tới nó.**

Tách một hai mục thì chép file mẫu từ `docs-template/template/`. Khi nhiều mục cùng tới ngưỡng, hoặc dự án đổi hẳn cỡ (prototype có người dùng thật, tool cá nhân thành dịch vụ), chạy lại script với hồ sơ lớn hơn.

### 8.2 Chạy lại script với hồ sơ lớn hơn

Script chỉ **thêm** file còn thiếu; file đã có (kể cả file bạn đã sửa) được giữ nguyên và báo "bỏ qua". Ví dụ thật: dự án dựng bằng `lite`, sau đó chạy `standard` (xem trước bằng `--dry-run`, cùng lệnh):

```console
$ docs-template/scripts/new-project-docs.sh standard my-app "My App"
Hồ sơ: standard · Đích: /path/to/my-app · Tên dự án: My App · Ngày: 2026-09-28
  bỏ qua  README.md (đã có)
  bỏ qua  AGENTS.md (đã có)
  bỏ qua  CLAUDE.md (đã có)
  bỏ qua  .github/pull_request_template.md (đã có)
  bỏ qua  scripts/check-links.py (đã có)
  bỏ qua  docs/README.md (đã có)
  chép    docs/product/spec.md  <-  template/docs/product/spec.md
  chép    docs/product/nfr.md  <-  template/docs/product/nfr.md
  chép    docs/product/glossary.md  <-  template/docs/product/glossary.md
  chép    docs/architecture/ARCHITECTURE.md  <-  template/docs/architecture/ARCHITECTURE.md
  chép    docs/architecture/data-model.md  <-  template/docs/architecture/data-model.md
  chép    docs/architecture/diagrams/README.md  <-  template/docs/architecture/diagrams/README.md
  chép    docs/adr/README.md  <-  template/docs/adr/README.md
  bỏ qua  docs/adr/0000-template.md (đã có)
  bỏ qua  docs/adr/0001-record-architecture-decisions.md (đã có)
  chép    docs/api/openapi.yaml  <-  template/docs/api/openapi.yaml
  chép    docs/api/api.md  <-  template/docs/api/api.md
  chép    docs/dev/testing.md  <-  template/docs/dev/testing.md
  chép    docs/dev/configuration.md  <-  template/docs/dev/configuration.md
  chép    docs/security/threat-model.md  <-  template/docs/security/threat-model.md
  chép    docs/plan/roadmap.md  <-  template/docs/plan/roadmap.md
  chép    docs/plan/tasks.md  <-  template/docs/plan/tasks.md
  chép    docs/plan/progress.md  <-  template/docs/plan/progress.md
  chép    docs/specs/README.md  <-  template/docs/specs/README.md
  chép    docs/specs/000-template/spec.md  <-  template/docs/specs/000-template/spec.md
  chép    docs/specs/000-template/plan.md  <-  template/docs/specs/000-template/plan.md
  chép    docs/specs/000-template/tasks.md  <-  template/docs/specs/000-template/tasks.md
  chép    docs/ops/deployment.md  <-  template/docs/ops/deployment.md
  chép    docs/ops/runbooks/README.md  <-  template/docs/ops/runbooks/README.md
  chép    docs/ops/runbooks/000-template.md  <-  template/docs/ops/runbooks/000-template.md
  chép    docs/ops/postmortems/README.md  <-  template/docs/ops/postmortems/README.md
  chép    docs/ops/postmortems/000-template.md  <-  template/docs/ops/postmortems/000-template.md
Tổng: 24 chép, 8 bỏ qua (đã có)
File đã có được giữ nguyên. So với mẫu nếu cần: diff <file> /path/to/docs-template/template/<file>
Tiếp theo:
  1. Mở docs/README.md (bản đồ tài liệu), xoá hàng không dùng; bắt đầu điền từ docs/product/spec.md
     (hồ sơ lite: mục đầu của docs/README.md).
  2. Tìm chỗ cần điền: grep -rnE '<[^!/-]|YYYY-MM-DD|CẦN XÁC NHẬN' "/path/to/my-app/docs"
  3. Viết AGENTS.md sau cùng, khi docs/ đã có nội dung.
  4. Kiểm link: python3 "/path/to/my-app/scripts/check-links.py" "/path/to/my-app"
```

(Đường dẫn tuyệt đối trong kết quả được thay bằng `/path/to/…`.) Tám file của LITE được giữ; 24 file mới là mẫu trống. Chạy tiếp `full` sẽ thêm 6 file còn lại ("Tổng: 6 chép, 32 bỏ qua").

### 8.3 Chuyển nội dung từ `docs/README.md` của LITE sang file mới

Sau khi lên từ LITE, `docs/README.md` vẫn là bản LITE, nội dung còn nằm trong các mục của nó. Chuyển từng mục sang file mới:

| Mục trong `docs/README.md` (LITE) | Chuyển sang |
|---|---|
| Mục tiêu và phạm vi | `docs/product/spec.md` |
| Yêu cầu phi chức năng | `docs/product/nfr.md` |
| Kiến trúc | `docs/architecture/ARCHITECTURE.md` (sơ đồ vào `docs/architecture/diagrams/`) |
| Thuật ngữ | `docs/product/glossary.md` |
| Quyết định | `docs/adr/README.md` (mục lục); ADR đã là file riêng từ đầu |
| Phát triển và kiểm thử | `docs/dev/testing.md`, `docs/dev/configuration.md` |
| Phát hành và vận hành | `docs/ops/deployment.md`; sự cố vào `docs/ops/runbooks/` |
| Tiến độ | `docs/plan/progress.md`; việc sắp làm vào `docs/plan/tasks.md` |

Với mỗi mục:

1. Dán nội dung vào đúng mục của file mới, xoá phần ví dụ và comment hướng dẫn mà nội dung thật đã thay.
2. Ở chỗ cũ để lại một câu tóm tắt và link tới file mới (chưa chuyển xong thì cứ giữ nguyên mục cũ; hai nơi cùng viết một điều là thứ cần tránh).
3. Đổi ngày `Cập nhật` ở cả hai file; chạy `python3 scripts/check-links.py .`.

Khi mọi mục đã chuyển, thay `docs/README.md` bằng bản đồ tài liệu đầy đủ của hồ sơ mới (bản dựng ra thư mục tạm đã điền sẵn tên dự án và ngày):

```bash
tmp="$(mktemp -d)"
docs-template/scripts/new-project-docs.sh standard "$tmp" "My App"
cp "$tmp/docs/README.md" my-app/docs/README.md
rm -rf "${tmp:?}"
python3 my-app/scripts/check-links.py my-app
```

## 9. Câu hỏi thường gặp

### Chọn sai thì sao?

- **Chọn nhỏ quá:** chạy lại script với hồ sơ lớn hơn ([mục 8.2](#82-chạy-lại-script-với-hồ-sơ-lớn-hơn)). Không mất gì, không ghi đè gì.
- **Chọn lớn quá:** xoá các file chưa điền và không cần (câu hỏi dưới). Nếu chưa điền gì, nhanh hơn là xoá cả bộ vừa dựng rồi dựng lại với hồ sơ nhỏ hơn.
- **Dùng RETIRING rồi dự án được giữ lại:** chạy script với hồ sơ phù hợp ra thư mục tạm, lấy `README.md`, `AGENTS.md` từ đó thay cho biến thể RETIRING; kế hoạch ngừng chuyển trạng thái "Lưu trữ" (đổi tên, ví dụ `roadmap-retirement.md`) để giữ lịch sử quyết định.

### Có xoá được file không cần không?

Được. Hồ sơ chỉ là điểm xuất phát, không phải luật. Khi xoá:

1. Xoá file (`git rm`), bỏ hàng của nó trong bản đồ `docs/README.md` hoặc đổi link thành đường dẫn dạng `code`.
2. Chạy `python3 scripts/check-links.py .` để tìm link còn trỏ tới file đã xoá.
3. Nhớ rằng chạy lại script với cùng hồ sơ sẽ **tạo lại** file đã xoá (script chỉ nhìn file có hay chưa). Luôn chạy `--dry-run` trước và bỏ qua những dòng "chép" không mong muốn.

Đừng xoá ADR (kể cả ADR bị bác) và `docs/adr/0000-template.md`: ADR giữ số mãi mãi, mẫu cần cho lần viết sau.

### Dự án đã có docs thì sao?

Script không bao giờ ghi đè: chạy `--dry-run` để xem file nào sẽ thêm, file nào "bỏ qua". Tài liệu cũ nằm chỗ khác (thư mục khác, wiki, một README dài): dựng ra thư mục tạm, rồi chuyển nội dung cũ vào đúng ô bằng `git mv` để giữ lịch sử. Chi tiết ở [README, mục 8.2](README.md#82-repo-có-sẵn-script). Với hệ thống đang ngừng mà đã có tài liệu, xem cách làm ở [mục 7](#7-retiring).
