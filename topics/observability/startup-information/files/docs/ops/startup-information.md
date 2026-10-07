# Thông tin khởi động

> Trạng thái: Đề xuất · Cập nhật: YYYY-MM-DD

<!--
Điền quy ước cho project thật: loại ứng dụng, nơi ghi thông tin, tên trường và nguồn giá trị.
Các khối dưới đây là ví dụ, không phải mã đã được cài vào ứng dụng.
Xoá phần không áp dụng. Không ghi secret, dữ liệu cá nhân hay hostname nội bộ vào tài liệu.
-->

## 1. Mục đích và phạm vi

Thông tin khởi động giúp trả lời: **service nào**, **bản nào**, **môi trường nào** vừa khởi động, và đang dùng cấu hình vận hành chính nào. Ghi sau khi đã kiểm cấu hình bắt buộc và hoàn tất các bước khởi tạo cần thiết. Nếu khởi động thất bại, ghi lỗi và thoát; không in sự kiện hoàn tất.

Sự kiện khởi động là ảnh chụp tại một thời điểm. Nó không thay cho health/readiness probe, không chứng minh service còn sẵn sàng ở thời điểm đọc log. Với site tĩnh không có tiến trình ứng dụng, dùng thông tin bản build/triển khai thay cho sự kiện khởi động.

| Thuộc project này | Giá trị cần điền |
|---|---|
| Loại ứng dụng | <API, CMS, SSR, site tĩnh, worker, CLI hoặc loại khác> |
| Nơi hiển thị | <terminal local, log collector, trang About, release manifest> |
| Thời điểm ghi | <sau bước khởi tạo nào; hoặc khi build/deploy với site tĩnh> |
| Nơi kiểm tra trạng thái hiện tại | <readiness endpoint, lệnh kiểm tra hoặc không áp dụng> |

## 2. Chọn trường

| Trường | Dùng khi | Nguồn giá trị |
|---|---|---|
| `service` | Mọi ứng dụng | Tên ổn định của ứng dụng/service |
| `role` | Một repo có web, API, worker, scheduler hoặc CLI | Vai trò của tiến trình |
| `environment` | Có nhiều môi trường | Biến môi trường đã kiểm và chuẩn hoá |
| `appVersion` | Có version ứng dụng | Metadata của artifact/package |
| `commit` hoặc `artifactDigest` | Có build/deploy cần truy vết | Metadata được gắn khi build; không lấy từ nhánh Git đang trôi |
| `startedAt` | Có tiến trình khởi động | Thời điểm theo ISO 8601, nên dùng UTC trong log tập trung |
| `startupDurationMs` | Đo được từ đầu tới hết bước khởi tạo | Đồng hồ đo khoảng thời gian; định nghĩa rõ mốc đầu/cuối |
| `instance` | Có nhiều container, pod hoặc bản chạy song song | ID instance do runtime cấp |
| `runtime` | Phiên bản runtime giúp chẩn đoán | Runtime thực tế, ví dụ Node.js hoặc JVM |
| `listenPort` hoặc `publicUrl` | Service HTTP | Cổng lắng nghe hoặc URL công khai; phân biệt hai giá trị |
| `databaseType`, `storageType`, `queue` | Phụ thuộc này ảnh hưởng vận hành | Tên loại dịch vụ, không phải chuỗi kết nối |
| `runId` | CLI, batch job hoặc tác vụ theo đợt | ID của một lần chạy để ghép log bắt đầu/kết thúc |

Không cần mọi trường trong mọi project. Trường đặc thù framework (ví dụ gói Strapi hay schema PostgreSQL) là tuỳ chọn. Nếu ghi tên database, bucket, schema hoặc tên queue, chỉ đưa vào log nội bộ khi thông tin đó thực sự giúp chẩn đoán.

## 3. Cách hiển thị theo loại ứng dụng

| Loại | Nơi hiển thị | Nội dung chính |
|---|---|---|
| Backend/API/CMS | Terminal local; log có cấu trúc ở production | Service, build, môi trường, thời gian, cổng, loại phụ thuộc |
| Nhiều instance hoặc service | Log tập trung | Thêm `service`, `role`, `instance` và build để lọc, so sánh |
| Worker/scheduler | Log khi bắt đầu nhận việc | Service, role, build, queue/tác vụ; không cần URL nếu không có HTTP |
| Frontend SSR | Log của server | Service, build, môi trường, cổng/URL |
| Frontend tĩnh | Trang About, release manifest hoặc thông tin deploy | Version, build, thời điểm deploy; chỉ thông tin được phép công khai |
| CLI/batch | Đầu và cuối một lần chạy; lệnh `--version` khi phù hợp | Công cụ, version, môi trường, `runId`, kết quả và thời lượng |
| Thư viện/package | Ứng dụng sử dụng thư viện quyết định | Thư viện không tự in log khi được import |

Ở local, bảng dễ đọc có thể hữu ích. Ở production, ghi sự kiện có tên và trường có cấu trúc để hệ thống log lọc được. Tránh in cả bảng và JSON cho cùng một sự kiện trong cùng môi trường nếu điều đó tạo log trùng.

## 4. Ví dụ minh hoạ

### 4.1 CMS ở local

```text
Service         example-cms
Role            CMS API + Admin
App version     0.1.0
Environment     development
Startup time    5800 ms
Server          http://localhost:1337
Database        PostgreSQL
Media storage   MinIO
```

### 4.2 API vừa deploy, có nhiều instance

```json
{"event":"startup_complete","service":"example-api","role":"api","environment":"production","appVersion":"1.4.2","commit":"b7c9d2e","instance":"api-02","startedAt":"2026-10-07T12:11:05Z","startupDurationMs":3200,"listenPort":3000}
```

Nếu các instance có `commit` khác nhau, kiểm lại trạng thái rollout. Giữ mã commit hoặc digest đủ dài để phân biệt bản build trong hệ thống deploy.

### 4.3 Worker

```text
Service         image-worker
Role            background worker
Version         0.3.1
Environment     production
Queue           image-processing
Concurrency     4
```

### 4.4 Frontend SSR và frontend tĩnh

*Ví dụ SSR:* server ghi `service=example-web role=web commit=b7c9d2e environment=production listenPort=3000` vào log nội bộ.

*Ví dụ site tĩnh:* trang About công khai ghi `Phiên bản: 1.2.0 · Bản build: b7c9d2e · Triển khai: 2026-10-07`. Không đưa cấu hình server vào bundle của trình duyệt.

### 4.5 CLI hoặc batch job

```text
Task            import-posts
Version         0.4.0
Environment     staging
Run ID          import-20261007-001
Started at      2026-10-07T12:11:05Z
Result          imported=23 failed=1 duration=8400ms
```

Với lệnh ngắn, ưu tiên `--version` và chỉ in chi tiết khi bật chế độ verbose; không bắt người dùng đọc bảng dài cho mỗi lần gọi.

## 5. An toàn và kiểm tra

- Chỉ ghi các trường được chọn rõ ràng. Không dump toàn bộ biến môi trường, đối tượng cấu hình hay request.
- Không ghi mật khẩu, token, API key, cookie, chuỗi kết nối, hostname nội bộ hoặc dữ liệu cá nhân. Giới hạn người được xem log production; thông tin public của frontend phải ít hơn log nội bộ.
- Khi thiếu cấu hình bắt buộc hoặc phụ thuộc khởi tạo thất bại, ghi lỗi không kèm giá trị bí mật và thoát theo quy tắc của project. Không ghi `startup_complete`.
- Kiểm một lần khởi động thành công: đúng service, môi trường, build và cổng; mỗi instance có thể phân biệt được. Kiểm một lần khởi động thất bại: không có sự kiện hoàn tất.
- Kiểm bản production không đưa trường nội bộ vào frontend tĩnh hoặc log công khai. Kiểm readiness riêng sau deploy và khi vận hành.
