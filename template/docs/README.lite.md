# Tài liệu <Tên dự án>

> Trạng thái: Đang áp dụng · Cập nhật: YYYY-MM-DD · Liên quan: [README repo](../README.md), [AGENTS.md](../AGENTS.md), [ADR 0001](adr/0001-record-architecture-decisions.md)

<!--
Hồ sơ LITE: file này thay cho cả bộ docs của một dự án nhỏ (thư viện, CLI, script, prototype).
Mỗi mục dưới đây ứng với một ô của khung (ghi trong ngoặc). Nội dung T1 vẫn bắt buộc, chỉ là nằm ở đây.
Khi một mục dài quá ~80 dòng hoặc cần được link từ chỗ khác, tách nó thành file riêng theo "Quy tắc tách file".
Xoá mục không áp dụng (ví dụ Vận hành với một thư viện chỉ phát hành lên registry).
-->

<Một đoạn: dự án là gì, cho ai, giải quyết vấn đề gì.>

## Mục tiêu và phạm vi

<!-- Ô product/spec.md (T1). Mục tiêu đo được, điều cố ý không làm, và thế nào là xong. -->

- **Vấn đề:** <điều gì đang khó hoặc tốn công, cho ai>
- **Mục tiêu:**
  - G1 <mục tiêu>, đo bằng <cách đo>
  - G2 <mục tiêu>, đo bằng <cách đo>
- **Không làm:**
  - NG1 <điều không làm>, vì <lý do>
- **Tiêu chí nghiệm thu:**
  - AC-01 <cho đầu vào X, khi làm Y, thì thấy Z>
- **Xong khi (Definition of Done cho một thay đổi):** test xanh trong CI, tài liệu cập nhật theo [Definition of Done cho tài liệu](#definition-of-done-cho-tài-liệu), <điều kiện phát hành>.

## Yêu cầu phi chức năng

<!-- Ô product/nfr.md (T1). Chỉ ghi yêu cầu có ngưỡng đo được. Ví dụ bên dưới: thay hoặc xoá. -->

| Mã | Yêu cầu | Ngưỡng | Cách đo |
|---|---|---|---|
| PERF-01 | *Ví dụ:* thời gian chạy lệnh chính trên dữ liệu mẫu | < 2 s | `time <lệnh>` trên máy dev, ghi kết quả vào mục Tiến độ |
| OPS-01 | *Ví dụ:* lỗi phải có thông báo rõ và mã thoát khác 0 | 100% đường lỗi | test |

## Kiến trúc

<!-- Ô architecture/ARCHITECTURE.md (T1). Một sơ đồ và một bảng thành phần là đủ cho dự án nhỏ. -->

```mermaid
flowchart LR
  user(["Người dùng"]) --> cli["CLI / API công khai"]
  cli --> core["Lõi xử lý"]
  core --> store[("Tệp hoặc dịch vụ ngoài")]
```

| Thành phần | Trách nhiệm | Ở đâu trong repo |
|---|---|---|
| *Ví dụ:* CLI | Đọc tham số, in kết quả | `src/cli` |
| *Ví dụ:* Lõi | Xử lý chính, không đụng I/O | `src/core` |

## Thuật ngữ

<!-- Ô product/glossary.md (T1*: bắt buộc khi dự án có từ viết tắt hoặc từ dùng với nghĩa riêng). Xoá mục nếu không có. -->

| Thuật ngữ | Nghĩa trong dự án này |
|---|---|
| <thuật ngữ> | <nghĩa> |

## Quyết định

<!-- Ô adr/ (T1). Mục lục ADR của dự án nhỏ nằm ở đây. Mỗi quyết định vẫn là một file adr/NNNN-<name>.md. -->

| Số | Quyết định | Trạng thái | Ngày |
|---|---|---|---|
| [0000](adr/0000-template.md) | Mẫu ADR | Mẫu | — |
| [0001](adr/0001-record-architecture-decisions.md) | Ghi lại quyết định kiến trúc bằng ADR | Chấp nhận | <Ngày tạo> |

## Phát triển và kiểm thử

<!-- Ô dev/testing.md và dev/configuration.md (T2). -->

| Việc | Lệnh |
|---|---|
| Cài đặt | `<lệnh>` |
| Test | `<lệnh>` |
| Kiểm link tài liệu | `python3 scripts/check-links.py .` |

Cấu hình (chỉ tên biến, không giá trị bí mật):

| Biến | Bắt buộc | Mặc định | Nghĩa |
|---|---|---|---|
| <TÊN_BIẾN> | có / không | <giá trị> | <nghĩa> |

## Phát hành và vận hành

<!-- Ô ops/deployment.md (T2). Với thư viện hoặc CLI: cách đánh version và phát hành. Với dịch vụ nhỏ: chạy ở đâu, rollback thế nào. -->

1. <bước phát hành>
2. <cách quay lại bản trước>

## Tiến độ

<!-- Ô plan/ (T2). Danh sách việc ngắn; xong thì tick và ghi ngày, commit. Là nguồn sự thật duy nhất về trạng thái. -->

- [ ] <việc> (ước lượng thô: <…>)
- [x] Dựng bộ tài liệu từ docs-template (<Ngày tạo>)

## Quy ước

- Văn xuôi tiếng Việt; tên file, định danh, lệnh, commit message tiếng Anh. Không emoji.
- Tên file ASCII kebab-case tiếng Anh. Đầu mỗi file: `# Tiêu đề` rồi dòng metadata `> Trạng thái: … · Cập nhật: YYYY-MM-DD · Liên quan: …`.
- Trạng thái: **Nháp** (đang viết) · **Đề xuất** (chờ chốt) · **Đang áp dụng** (sự thật hiện tại) · **Đã thay thế** (có tài liệu mới thay) · **Lưu trữ** (đã ngừng hoặc bị bác, chỉ để đọc lại).
- Chưa biết thì ghi `[CẦN XÁC NHẬN: …]`; ước lượng ghi "ước lượng thô"; số liệu ghi nguồn và ngày.
- Link tương đối; kiểm bằng `python3 scripts/check-links.py .`.
- Không secret, token, IP (ngoài loopback), hostname nội bộ, chi tiết lỗ hổng chưa vá.

## Definition of Done cho tài liệu

Một thay đổi chỉ xong khi tài liệu tương ứng đã sửa trong cùng PR:

| Khi thay đổi | Cập nhật |
|---|---|
| Hành vi người dùng thấy | [Mục tiêu và phạm vi](#mục-tiêu-và-phạm-vi) (tiêu chí nghiệm thu) |
| Quyết định kiến trúc | ADR mới từ [mẫu](adr/0000-template.md), thêm vào [Quyết định](#quyết-định) |
| Thành phần hoặc luồng | [Kiến trúc](#kiến-trúc) |
| Biến cấu hình, lệnh | [Phát triển và kiểm thử](#phát-triển-và-kiểm-thử) |
| Cách phát hành hoặc chạy | [Phát hành và vận hành](#phát-hành-và-vận-hành) |
| Xong việc | [Tiến độ](#tiến-độ) |
| Mọi thay đổi tài liệu | Ngày `Cập nhật`; `check-links.py` sạch; không secret |

## Quy tắc tách file

Tách một mục ở trên thành file riêng, đúng ô của khung (ví dụ `docs/product/spec.md`), khi mục đó dài quá khoảng 80 dòng hoặc tài liệu khác cần link tới nó. Chép file mẫu từ bộ khuôn (hoặc chạy lại script dựng với hồ sơ lớn hơn: script chỉ thêm file còn thiếu), chuyển nội dung sang, để lại ở đây một câu tóm tắt và link.
