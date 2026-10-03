# docs-template

> Trạng thái: Đang áp dụng · Cập nhật: 2026-10-03 · Liên quan: [Chọn hồ sơ](PROFILES.md), [Mẫu docs/README](template/docs/README.md), [Hồ sơ FULL](profiles/full.txt), [Script dựng](scripts/new-project-docs.sh), [Kiểm link](scripts/check-links.py), [Mẫu PR](.github/pull_request_template.md)

Bộ khuôn tài liệu phân tầng để dùng lại cho mọi dự án. Repo này **không** là tài liệu của một dự án nào. Nó gồm ba thứ:

- **Mẫu** cho từng ô của khung tài liệu (`template/`): mỗi file có sẵn các mục, comment hướng dẫn bằng tiếng Việt, placeholder và ví dụ được đánh dấu là ví dụ.
- **Hồ sơ** (`profiles/`): mỗi loại dự án cần những ô nào. Chọn hồ sơ nào: [PROFILES.md](PROFILES.md).
- **Script** (`scripts/`): dựng bộ tài liệu theo hồ sơ vào một repo mới hoặc có sẵn, và kiểm link.

Bộ khuôn dùng được ngay; nó không có bước "hoàn tất tài liệu". Việc điền nội dung thuộc về từng dự án, sau khi dựng.

## Bắt đầu nhanh

**Chọn hồ sơ trước:** [PROFILES.md](PROFILES.md) giải thích 5 hồ sơ (FULL, STANDARD, PLATFORM, LITE, RETIRING): dùng khi nào, tạo file gì, bỏ gì, sơ đồ chọn nhanh và cách lên mức khi dự án lớn dần.

```bash
git clone <url-của-repo-này> docs-template
docs-template/scripts/new-project-docs.sh --dry-run standard ../my-app "My App"   # xem trước, không ghi gì
docs-template/scripts/new-project-docs.sh standard ../my-app "My App"
python3 ../my-app/scripts/check-links.py ../my-app
```

Mục lục: [1. Khung tài liệu](#1-khung-tài-liệu) · [2. Hồ sơ](#2-hồ-sơ) · [3. Quy tắc tách file](#3-quy-tắc-tách-file) · [4. Quy ước](#4-quy-ước) · [5. Definition of Done cho tài liệu](#5-definition-of-done-cho-tài-liệu) · [6. Quy tắc ADR](#6-quy-tắc-adr) · [7. Spec, lộ trình, việc, tiến độ](#7-spec-lộ-trình-việc-tiến-độ) · [8. Cách dùng](#8-cách-dùng) · [9. Giữ tài liệu sống](#9-giữ-tài-liệu-sống) · [10. Bảo trì bộ khuôn](#10-bảo-trì-bộ-khuôn)

## 1. Khung tài liệu

```text
<dự án>/
├── README.md                        T1   quick start + link tới docs/
├── AGENTS.md                        T1   viết SAU CÙNG; ngắn, chỉ trỏ vào docs/
├── CLAUDE.md                        T1*  "@AGENTS.md" + ghi chú riêng cho Claude Code
├── .github/pull_request_template.md      checklist Definition of Done cho tài liệu
├── scripts/check-links.py                kiểm link tương đối và anchor
└── docs/
    ├── README.md                    T2   bản đồ tài liệu, quy ước, DoD
    ├── product/
    │   ├── spec.md                  T1   mục tiêu, không làm, tiêu chí nghiệm thu, DoD
    │   ├── nfr.md                   T1   yêu cầu phi chức năng, ngân sách PERF
    │   └── glossary.md              T1*  thuật ngữ
    ├── architecture/
    │   ├── ARCHITECTURE.md          T1   thành phần, luồng, môi trường (C4 mức 1–2)
    │   ├── data-model.md            T2   thực thể, bất biến, vòng đời
    │   ├── principles.md            T3   nguyên tắc kiểm được
    │   └── diagrams/                T2   Mermaid, kiểu C4
    ├── adr/                         T1   README (mục lục), 0000-template, 0001-record-architecture-decisions, NNNN-<name>
    ├── api/                         T2   openapi.yaml (OpenAPI 3.1), api.md
    ├── dev/                         T2   testing, configuration, design-system (khi có UI), frontend (khi có ứng dụng giao diện), perf (số đã đo)
    │                                     backend-nestjs (mẫu tuỳ chọn khi dùng NestJS)
    ├── security/threat-model.md     T2/T3
    ├── plan/                        T2   roadmap, tasks, progress
    ├── specs/NNN-<name>/            T2   spec, plan, tasks (mẫu: 000-template/)
    ├── design/                      T3   RFC (mẫu: 0000-rfc-template.md)
    └── ops/                         T2   deployment, runbooks/ (mẫu 000-template), postmortems/ (T1*, sau mỗi sự cố)
```

| Tầng | Nghĩa | Ví dụ |
|---|---|---|
| **T1** | Bắt buộc với mọi dự án. Ở hồ sơ LITE, nội dung T1 được phép là một mục trong `docs/README.md` cho tới khi đủ điều kiện tách file | spec, nfr, ARCHITECTURE, adr |
| **T1\*** | Bắt buộc có điều kiện: điều kiện xảy ra thì phải có | glossary (khi có thuật ngữ riêng), postmortem (sau mỗi sự cố P1/P2), CLAUDE.md (khi dùng Claude Code) |
| **T2** | Nên có khi dự án có khía cạnh đó | api/ khi có API; design-system khi có giao diện; frontend khi có ứng dụng giao diện có state; perf khi đã đo; threat model khi có người dùng hoặc dữ liệu |
| **T3** | Tuỳ chọn, cho dự án lớn | principles, design/ (RFC), threat model đầy đủ theo STRIDE |

Nhãn tầng lấy theo khung gốc. Chỗ khung gốc không ghi nhãn, bộ khuôn gán: `README.md` và `AGENTS.md` ở gốc là T1; `adr/README.md` (mục lục) thuộc ô T1 của adr; `specs/` là T2; `postmortems/` và `CLAUDE.md` là T1\*; mẫu PR và `check-links.py` là file đi kèm.

## 2. Hồ sơ

Hướng dẫn chọn đầy đủ (sơ đồ quyết định, ví dụ, file bị bỏ và vì sao, câu hỏi thường gặp): **[PROFILES.md](PROFILES.md)**.

| Hồ sơ | Chọn khi | Số file |
|---|---|---|
| **FULL** | Sản phẩm có người dùng, có giao diện, API và vận hành, nhiều mốc. Đủ mọi ô T1, T2, T3 | 38 |
| **STANDARD** | Ứng dụng hoặc dịch vụ thông thường (web app, API, bot). T1 + T2; chưa có ô T3 và ô tuỳ điều kiện (design-system, frontend, perf) | 32 |
| **PLATFORM** | Repo hạ tầng hoặc nền tảng: cấu hình máy chủ, CI dùng chung, giám sát. Nặng vận hành và bảo mật; không có API công khai, mô hình dữ liệu hay spec tính năng | 25 |
| **LITE** | Thư viện, CLI, script, prototype. Một file `docs/README.md` chứa các mục T1 (mục tiêu, NFR, kiến trúc, thuật ngữ, quyết định, lệnh, tiến độ) + ADR | 8 |
| **RETIRING** | Hệ thống đã có quyết định ngừng. Không thêm tài liệu mới: README có banner "Đang ngừng", AGENTS.md giới hạn việc được làm, và kế hoạch ngừng thay cho lộ trình. Tài liệu đã có giữ nguyên | 4 |

File mỗi hồ sơ tạo (nguồn sự thật: `profiles/<hồ-sơ>.txt`):

| File | Tầng | FULL | STANDARD | PLATFORM | LITE | RETIRING |
|---|---|:-:|:-:|:-:|:-:|:-:|
| `README.md` | T1 | x | x | x | x | biến thể |
| `AGENTS.md` | T1 | x | x | x | x | biến thể |
| `CLAUDE.md` | T1\* | x | x | x | x | x |
| `.github/pull_request_template.md` | kèm | x | x | x | x | |
| `scripts/check-links.py` | kèm | x | x | x | x | |
| `docs/README.md` | T2 | x | x | x | biến thể | |
| `docs/product/spec.md` | T1 | x | x | x | mục | |
| `docs/product/nfr.md` | T1 | x | x | x | mục | |
| `docs/product/glossary.md` | T1\* | x | x | x | mục | |
| `docs/architecture/ARCHITECTURE.md` | T1 | x | x | x | mục | |
| `docs/architecture/data-model.md` | T2 | x | x | | | |
| `docs/architecture/principles.md` | T3 | x | | | | |
| `docs/architecture/diagrams/README.md` | T2 | x | x | x | | |
| `docs/adr/README.md` | T1 | x | x | x | mục | |
| `docs/adr/0000-template.md` | T1 | x | x | x | x | |
| `docs/adr/0001-record-architecture-decisions.md` | T1 | x | x | x | x | |
| `docs/api/openapi.yaml` | T2 | x | x | | | |
| `docs/api/api.md` | T2 | x | x | | | |
| `docs/dev/testing.md` | T2 | x | x | x | mục | |
| `docs/dev/configuration.md` | T2 | x | x | x | mục | |
| `docs/dev/design-system.md` | T2 | x | | | | |
| `docs/dev/frontend.md` | T2 | x | | | | |
| `docs/dev/perf.md` | T2 | x | | | | |
| `docs/security/threat-model.md` | T2/T3 | x | x | x | | |
| `docs/plan/roadmap.md` | T2 | x | x | x | | biến thể |
| `docs/plan/tasks.md` | T2 | x | x | x | | |
| `docs/plan/progress.md` | T2 | x | x | x | mục | |
| `docs/specs/README.md` | T2 | x | x | | | |
| `docs/specs/000-template/spec.md` | T2 | x | x | | | |
| `docs/specs/000-template/plan.md` | T2 | x | x | | | |
| `docs/specs/000-template/tasks.md` | T2 | x | x | | | |
| `docs/design/README.md` | T3 | x | | | | |
| `docs/design/0000-rfc-template.md` | T3 | x | | | | |
| `docs/ops/deployment.md` | T2 | x | x | x | mục | |
| `docs/ops/runbooks/README.md` | T2 | x | x | x | | |
| `docs/ops/runbooks/000-template.md` | T2 | x | x | x | | |
| `docs/ops/postmortems/README.md` | T1\* | x | x | x | | |
| `docs/ops/postmortems/000-template.md` | T1\* | x | x | x | | |
| **Số file** | | 38 | 32 | 25 | 8 | 4 |

`x` = file riêng từ `template/`. `biến thể` = file riêng lấy từ biến thể của hồ sơ (`template/README.retiring.md`, `template/AGENTS.retiring.md`, `template/docs/README.lite.md`, `template/docs/plan/roadmap.retiring.md`). `mục` = nội dung nằm thành một mục trong `docs/README.md` của hồ sơ đó, tách thành file khi đủ điều kiện ở mục 3.

**Mẫu riêng cho NestJS:** [template/docs/dev/backend-nestjs.md](template/docs/dev/backend-nestjs.md) mô tả cây mã nguồn, ranh giới module, DTO/DB/CLI/job, validation, bảo mật HTTP, log, health/shutdown, preset thư viện cho backend mới và cổng kiểm trong CI. File này không nằm trong hồ sơ nào vì FULL và STANDARD cũng dùng được với backend không phải NestJS. Repo này chưa chứa starter mã nguồn hoặc thư viện NestJS đã cài. Cách thêm tài liệu sau khi dựng hồ sơ ở [mục 8.2](#82-repo-có-sẵn-script).

RETIRING cố ý không đủ các ô T1: hệ thống sắp ngừng không nên nhận tài liệu mới. Ba file biến thể của nó chỉ link tới nhau; tài liệu dự án đã có (triển khai, runbook, cấu hình, ADR) được nhắc bằng đường dẫn dạng `code`, nên bộ 4 file không có link hỏng dù dự án có hay không có các file đó.

**Đổi hồ sơ.** Script chỉ thêm file còn thiếu, nên chạy lại với hồ sơ lớn hơn (ví dụ `standard` rồi `full`) sẽ bổ sung các ô mới mà không đụng file đã có. LITE, PLATFORM, STANDARD, FULL lồng nhau theo thứ tự đó. Riêng `docs/README.md` không bị thay: khi lên từ LITE, chuyển các mục của nó sang file mới theo quy tắc tách file ([PROFILES.md, mục 8](PROFILES.md#8-lên-mức-khi-dự-án-lớn-dần)).

## 3. Quy tắc tách file

Một mục trong README (hoặc trong một file khác) được tách thành file riêng, đúng ô của khung, khi:

1. mục đó dài quá khoảng **80 dòng**, hoặc
2. **tài liệu khác cần link tới nó.**

Khi tách: chép file mẫu từ `template/` (hoặc chạy lại script với hồ sơ có ô đó), chuyển nội dung sang, ở chỗ cũ để lại một câu tóm tắt và link, thêm file vào bản đồ trong `docs/README.md`. Ngược lại, file quá mỏng và không ai link tới thì có thể gộp về một mục.

## 4. Quy ước

- **Tên file tiếng Anh**, ASCII, kebab-case: `threat-model.md`, `0007-use-postgres-job-queue.md`, `004-password-reset/`. Giữ chữ hoa quen thuộc: `README.md`, `AGENTS.md`, `CLAUDE.md`, `ARCHITECTURE.md`. Không dùng tiền tố `_` cho file hay thư mục.
- **Văn xuôi tiếng Việt**; code, định danh, lệnh, tên sản phẩm và commit message tiếng Anh. Không emoji.
- **Dòng metadata** ngay dưới tiêu đề của mọi file Markdown (trừ `CLAUDE.md` và mẫu PR):
  `> Trạng thái: <trạng thái> · Cập nhật: YYYY-MM-DD · Liên quan: [<tên>](<đường dẫn>), …`
  Đổi ngày `Cập nhật` mỗi khi sửa nội dung.
- **Trạng thái tài liệu:**

  | Trạng thái | Nghĩa |
  |---|---|
  | Nháp | Đang viết, chưa dùng để ra quyết định |
  | Đề xuất | Viết xong, chờ người có quyền chốt |
  | Đang áp dụng | Sự thật hiện tại; làm theo |
  | Đã thay thế | Có tài liệu mới thay; dòng metadata link tới tài liệu thay thế |
  | Lưu trữ | Thứ nó mô tả đã ngừng hoặc bị bác, không có tài liệu thay; chỉ để đọc lại |

- **Chưa biết** ghi `[CẦN XÁC NHẬN: …]`, không đoán. **Ước lượng** ghi "ước lượng thô". **Số liệu** ghi nguồn và "tính tới YYYY-MM-DD".
- **Mã định danh** (`G1`, `NG1`, `AC-01`, `PERF-01`, `NNN-AC-01`, `M0`, `TK01`, `T01`, …): bảng đầy đủ trong [template/docs/README.md](template/docs/README.md#mã-định-danh).
- **Sơ đồ** viết bằng Mermaid trong Markdown, theo mức C4 ([quy ước sơ đồ](template/docs/architecture/diagrams/README.md)).
- **Công khai được:** không secret, token, mật khẩu, IP (ngoài loopback), hostname nội bộ, dữ liệu cá nhân, chi tiết lỗ hổng chưa vá.
- **Trong mẫu:** hướng dẫn nằm trong comment HTML `<!-- … -->` (không hiện khi xem trên GitHub, xoá khi đã điền); ví dụ đánh dấu *Ví dụ:*; placeholder dạng `<…>` tiếng Việt, hoặc tiếng Anh nhưng đặt trong code (placeholder ASCII như `<name>` nằm ngoài code sẽ bị GitHub hiểu là thẻ HTML và ẩn đi).

## 5. Definition of Done cho tài liệu

Một thay đổi chỉ xong khi tài liệu tương ứng đã sửa **trong cùng PR**. Bản checklist nằm ở [mẫu PR](.github/pull_request_template.md); bản trong dự án nằm ở `docs/README.md`.

| Khi thay đổi | Cập nhật |
|---|---|
| Hành vi người dùng thấy | Spec của tính năng (`specs/NNN-<name>/spec.md`) hoặc `product/spec.md`; tiêu chí nghiệm thu khớp test |
| Quyết định kiến trúc, chọn hoặc bỏ công nghệ | ADR mới; ADR cũ chuyển "Đã thay thế"; mục lục ADR |
| Biến môi trường, cờ cấu hình | `dev/configuration.md` và `.env.example` (chỉ tên biến) |
| Endpoint, hợp đồng API | `api/openapi.yaml` và `api/api.md` |
| Schema, migration | `architecture/data-model.md` |
| Thành phần, luồng, ranh giới | `architecture/ARCHITECTURE.md` và sơ đồ |
| Cách deploy, hạ tầng, thao tác vận hành | `ops/deployment.md`, runbook liên quan |
| Bề mặt tấn công, bí mật, quyền | `security/threat-model.md` |
| Ngân sách hoặc số đo hiệu năng | `product/nfr.md` (ngân sách), `dev/perf.md` (số đo) |
| Giao diện, design token | `dev/design-system.md` |
| Cấu trúc thư mục front-end, luật import giữa các tầng | `dev/frontend.md` |
| Cấu trúc module NestJS, luật phụ thuộc giữa các feature | `dev/backend-nestjs.md` khi dùng NestJS |
| Thuật ngữ mới | `product/glossary.md` |
| Cách test, lệnh test | `dev/testing.md` |
| Xong việc, đổi mốc | `plan/progress.md`, `plan/tasks.md`, `tasks.md` của spec |
| Sự cố P1/P2 | Postmortem trong 5 ngày làm việc; sửa runbook |
| Mọi thay đổi tài liệu | Ngày `Cập nhật`; link tương đối; `check-links.py` sạch; không secret |

File đích chưa có ở hồ sơ đang dùng: ghi vào mục gần nhất của tài liệu đang có, rồi tách theo mục 3.

## 6. Quy tắc ADR

- **Đánh số theo từng repo**, 4 chữ số, bắt đầu từ `0001`; không dùng chung dãy số giữa các repo. Nhắc ADR của repo khác thì ghi tên repo kèm số.
- **`0000` luôn là mẫu** (`0000-template.md`), không phải quyết định. **`0001` ghi chính việc dùng ADR** và được tạo sẵn khi dựng.
- **Tên file tiếng Anh**: `NNNN-<name>.md`. Văn xuôi tiếng Việt, khung Nygard: Trạng thái, Ngày, Bối cảnh, Các phương án đã cân nhắc, Quyết định, Hệ quả, Điều kiện xem lại, Liên quan, Nguồn/bằng chứng, Lịch sử thay đổi.
- **Vòng đời:** Đề xuất → Chấp nhận → (Chấp nhận · sẽ bị thay thế) → Đã thay thế; hoặc Bị bác, Ngừng dùng. Ánh xạ sang dòng metadata: Chấp nhận = Đang áp dụng; Bị bác và Ngừng dùng = Lưu trữ.
- **Bất biến khi đã chấp nhận.** Muốn đổi thì viết ADR mới **thay thế** ADR cũ; ở ADR cũ chỉ sửa dòng trạng thái, "Liên quan", "Lịch sử thay đổi" (và link hỏng, chính tả).
- **Không xoá, không đánh số lại.** ADR bị bác vẫn giữ số.
- **Agent viết, người chốt:** agent AI chỉ tạo ADR ở trạng thái Đề xuất.

Chi tiết: [template/docs/adr/README.md](template/docs/adr/README.md), [ADR 0001 mẫu](template/docs/adr/0001-record-architecture-decisions.md).

## 7. Spec, lộ trình, việc, tiến độ

Mỗi loại thông tin có đúng một nơi là nguồn sự thật; nơi khác chỉ link.

| File | Trả lời | Thay đổi khi | Không chứa |
|---|---|---|---|
| `product/spec.md` | Sản phẩm: xây gì, cho ai, không làm gì, xong khi nào (cấp sản phẩm) | Đổi mục tiêu hoặc phạm vi (thường kèm ADR) | Hành vi chi tiết của từng tính năng |
| `specs/NNN-<name>/spec.md` | Một tính năng: hành vi, tiêu chí nghiệm thu Given/When/Then | Đổi hành vi | Cách làm kỹ thuật, trạng thái |
| `specs/NNN-<name>/plan.md` | Tính năng đó làm thế nào: thiết kế, thứ tự, rủi ro, cách lùi | Khi bắt đầu làm; khi đổi cách làm | Quyết định kiến trúc (thuộc ADR) |
| `specs/NNN-<name>/tasks.md` | Việc tick được của tính năng đó | Hằng ngày khi làm | Việc của tính năng khác |
| `plan/roadmap.md` | Thứ tự mốc, phụ thuộc, điều kiện xong của mỗi mốc | Đổi thứ tự hoặc phạm vi mốc | Trạng thái, việc chi tiết |
| `plan/tasks.md` | Hàng đợi 1–2 tuần cấp dự án: việc chéo spec, vận hành, nợ kỹ thuật; trỏ tới tasks của spec | Hằng tuần | Việc chi tiết đã có trong tasks của spec |
| `plan/progress.md` | Trạng thái: mốc nào xong, khi nào, bằng chứng, lệch ước lượng | Khi xong việc đáng kể, đóng mốc | Kế hoạch tương lai |

## 8. Cách dùng

### 8.1 Dự án mới: GitHub "Use this template"

1. Một lần: trên GitHub, repo docs-template → Settings → General → tick **Template repository**.
2. Mỗi dự án mới: **Use this template** → **Create a new repository** → clone về máy.
3. Trong repo mới (đứng ở gốc repo), dựng tài liệu ra thư mục tạm, gỡ phần riêng của bộ khuôn, rồi chép bộ tài liệu vào:

```bash
tmp="$(mktemp -d)"
scripts/new-project-docs.sh standard "$tmp" "Tên dự án"    # chọn hồ sơ theo PROFILES.md
# Nếu dùng NestJS: cp template/docs/dev/backend-nestjs.md "$tmp/docs/dev/backend-nestjs.md"
git rm -rq README.md PROFILES.md template profiles scripts/new-project-docs.sh scripts/test-profiles.sh
cp -R "$tmp"/. . && rm -rf "${tmp:?}"
python3 scripts/check-links.py .
git add -A && git commit -m "Add project docs from docs-template (standard profile)"
```

Dùng `cp -R`, không dùng `cp -a`: `mktemp -d` tạo thư mục quyền 0700, và `cp -a` chép cả quyền đó lên thư mục gốc của repo. `cp -R` không đổi quyền thư mục đã có; file và thư mục mới theo umask (umask 022: file 0644, thư mục 0755, `check-links.py` giữ bit chạy).

`scripts/check-links.py` và `.github/pull_request_template.md` được giữ (dự án dùng chúng; bản trong thư mục tạm chép đè lên với nội dung như cũ). Nếu chép mẫu NestJS, điền ngày metadata, phạm vi và ADR sau khi tạo repo. Hồ sơ `retiring` không có hai file này: xoá chúng bằng `git rm` nếu không dùng. `LICENSE` của bộ khuôn còn lại: giữ nếu dự án cũng dùng MIT, sửa tên người giữ bản quyền hoặc thay giấy phép nếu không. Script từ chối dựng thẳng vào chính thư mục bộ khuôn, nên cần bước thư mục tạm ở trên.

### 8.2 Repo có sẵn: script

```bash
docs-template/scripts/new-project-docs.sh --dry-run <profile> <target-dir> ["Tên dự án"]   # xem trước
docs-template/scripts/new-project-docs.sh <profile> <target-dir> ["Tên dự án"]
```

File đã có ở đích **không bao giờ bị ghi đè**; script báo "bỏ qua" từng file. So file cũ với mẫu bằng `diff <file> docs-template/template/<file>` rồi chép tay phần muốn lấy. Repo đã có tài liệu ở chỗ khác: dựng vào thư mục tạm, rồi chuyển nội dung cũ vào đúng ô (dùng `git mv` để giữ lịch sử).

Nếu dự án dùng NestJS, sau khi dựng hồ sơ STANDARD hoặc FULL, chép thêm mẫu theo công nghệ:

```bash
cp docs-template/template/docs/dev/backend-nestjs.md <target-dir>/docs/dev/backend-nestjs.md
```

Điền phạm vi, ADR, luật CI và ngày `Cập nhật`; thêm file vào bản đồ của `<target-dir>/docs/README.md`. Mẫu này là **tài liệu về cấu trúc**, không tạo thư mục hay mã NestJS. Không thêm file cho dự án không dùng NestJS.

### 8.3 Script làm gì

- Đọc `profiles/<profile>.txt` (mỗi dòng một đường dẫn đích, `#` là comment), kiểm mọi nguồn có tồn tại **trước khi** chép.
- Nguồn của mỗi đường dẫn, theo thứ tự: biến thể `template/<thư mục>/<tên>.<profile>.<đuôi>`, rồi `template/<đường dẫn>`, rồi file cùng tên ở gốc bộ khuôn (file dùng chung: mẫu PR, `check-links.py`).
- Với `.md`, `.yaml`, `.yml`: thay `<Tên dự án>` bằng tên truyền vào (bỏ trống thì giữ placeholder), thay `<Ngày tạo>` bằng ngày hôm nay, và thay `YYYY-MM-DD` **chỉ ở dòng metadata đầu file** bằng ngày hôm nay. Các `YYYY-MM-DD` khác (trong khối mẫu, bảng lịch sử) giữ nguyên để điền khi dùng mẫu.
- `--dry-run` in danh sách sẽ chép và sẽ bỏ qua, không ghi gì. Thoát với lỗi khi hồ sơ không có, đường dẫn trong hồ sơ không hợp lệ, hoặc đích nằm trong bộ khuôn.
- Yêu cầu: bash, coreutils, awk; `python3` cho `check-links.py`.

### 8.4 Sau khi dựng: thứ tự điền

1. `docs/product/spec.md`: tóm tắt, mục tiêu, không làm, tiêu chí nghiệm thu (hồ sơ LITE: mục đầu của `docs/README.md`).
2. `docs/product/nfr.md`, `docs/architecture/ARCHITECTURE.md`.
3. ADR cho các quyết định đã có (ghi lại sau, có dòng "Ghi lại:"); đọc lại ADR 0001 và điền người quyết định.
4. `docs/plan/roadmap.md` và `docs/plan/tasks.md`; các ô T2 còn lại khi dự án chạm tới khía cạnh đó.
5. `README.md` ở gốc (quick start), rồi **`AGENTS.md` sau cùng**, khi `docs/` đã có nội dung.

Hồ sơ RETIRING không theo thứ tự trên: chỉ điền banner ở `README.md`, mục đầu của `AGENTS.md` và kế hoạch ngừng `docs/plan/roadmap.md` ([PROFILES.md, mục 7](PROFILES.md#7-retiring)).
6. Xoá hàng không dùng trong bản đồ của `docs/README.md`; tìm chỗ còn trống:

```bash
grep -rnE '<[^!/-]|YYYY-MM-DD|CẦN XÁC NHẬN' docs README.md AGENTS.md
python3 scripts/check-links.py .
```

## 9. Giữ tài liệu sống

- **Mỗi PR** theo Definition of Done ở mục 5; mẫu PR nhắc từng mục.
- **CI kiểm link** trên mọi PR, ví dụ:

```yaml
# .github/workflows/docs.yml
name: docs
on: [pull_request]
jobs:
  links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: python3 scripts/check-links.py .
```

- **Cuối mỗi mốc:** cập nhật `plan/progress.md`; rà quyết định nào chưa thành ADR, `[CẦN XÁC NHẬN]` nào đã có câu trả lời.
- **Mỗi tháng:** liệt kê file theo ngày `Cập nhật` (lệnh trong `docs/README.md`, mục "Cách giữ tài liệu sống"); file cũ mà code liên quan đã đổi thì sửa, hoặc chuyển "Lưu trữ".
- **Sau sự cố:** postmortem và sửa runbook.
- **Ngừng tính năng hay hệ thống:** chuyển tài liệu sang "Lưu trữ", không xoá. Cả hệ thống ngừng: dùng hồ sơ `retiring` (banner "Đang ngừng" ở README, kế hoạch ngừng thay lộ trình). Repo đã có `README.md`, `AGENTS.md`, `docs/plan/roadmap.md` thì script bỏ qua cả ba; dựng ra thư mục tạm rồi chép phần cần theo [PROFILES.md, mục 7](PROFILES.md#7-retiring).

## 10. Bảo trì bộ khuôn

### 10.1 Cấu trúc repo này

```text
docs-template/
├── README.md                     tài liệu của bộ khuôn (file này)
├── PROFILES.md                   chọn hồ sơ: dùng khi nào, tạo gì, bỏ gì, lên mức
├── LICENSE                       MIT
├── .github/pull_request_template.md   checklist DoD; dự án dùng chung
├── profiles/                     full, standard, platform, lite, retiring (.txt)
├── scripts/
│   ├── new-project-docs.sh       dựng bộ tài liệu theo hồ sơ
│   ├── check-links.py            kiểm link và anchor; dự án dùng chung
│   └── test-profiles.sh          tự kiểm bộ khuôn
└── template/                     cây mẫu FULL và mẫu riêng theo công nghệ
    ├── README.md, AGENTS.md, CLAUDE.md
    ├── README.retiring.md, AGENTS.retiring.md   biến thể (tên.<hồ-sơ>.đuôi, nằm cạnh file gốc)
    └── docs/ …                   (thêm README.lite.md, plan/roadmap.retiring.md)
```

### 10.2 Sửa hoặc thêm mẫu

1. Sửa file trong `template/`. File chung mới: thêm đường dẫn vào các `profiles/*.txt` phù hợp, vào bảng ở mục 2 và vào danh sách file của hồ sơ trong [PROFILES.md](PROFILES.md). Mẫu riêng theo công nghệ (như `backend-nestjs.md`) ở ngoài các hồ sơ; ghi cách chép và điều kiện áp dụng ở README và PROFILES.
2. **Link trong mẫu chỉ trỏ tới file có mặt ở mọi hồ sơ chứa file nguồn.** Ô có thể vắng ở một hồ sơ thì viết đường dẫn dạng `code`, không viết link. Ví dụ: `docs/README.md` (dùng cho FULL, STANDARD, PLATFORM) chỉ link tới file cả ba hồ sơ đều có; `api/`, `specs/`, `data-model.md` ghi dạng code.
3. File mẫu để chép (`0000-template.md`, `000-template/`, `0000-rfc-template.md`) có dòng marker `<!-- check-links: template -->` riêng một dòng: `check-links.py` cho phép placeholder trong link của file đó. Marker còn sót trong file không mang tên "template" là lỗi, nhờ vậy file chép từ mẫu mà quên điền sẽ bị bắt.
4. Chạy tự kiểm; mọi hồ sơ phải đạt:

```bash
scripts/test-profiles.sh          # dựng từng hồ sơ vào thư mục tạm, kiểm số file, quyền file, placeholder, ngày, link, openapi, chạy lại không ghi đè
python3 scripts/check-links.py .  # kiểm link trên chính bộ khuôn
```

5. `.github/pull_request_template.md` và `scripts/check-links.py` là bản dùng chung cho cả bộ khuôn lẫn dự án: sửa một chỗ.

## Giấy phép

MIT, xem [LICENSE](LICENSE).
