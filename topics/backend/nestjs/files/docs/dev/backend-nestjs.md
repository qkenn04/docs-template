# Cấu trúc back-end NestJS

> Trạng thái: Nháp · Cập nhật: YYYY-MM-DD · Liên quan: [Kiến trúc](../architecture/ARCHITECTURE.md), [Kiểm thử](testing.md), [Cấu hình](configuration.md), [Mục lục ADR](../adr/README.md)

<!--
Mẫu tuỳ chọn cho dự án dùng NestJS. Chép vào docs/dev/backend-nestjs.md sau khi dựng hồ sơ STANDARD hoặc FULL.
File này mô tả nơi đặt mã và luật phụ thuộc; nó không tạo mã nguồn, không chọn ORM, hàng đợi hay cách deploy.
Thay các đường dẫn và ví dụ bằng quyết định của dự án. Chỉ tạo thư mục khi có file thật.
Chọn cấu trúc này hoặc cấu trúc khác là quyết định kiến trúc: ghi ADR rồi link ở mục 1.
-->

## 1. Phạm vi và quyết định

| Ứng dụng NestJS | Thư mục trong repo | Vai trò | Áp dụng file này |
|---|---|---|---|
| <tên ứng dụng> | `<đường dẫn, ví dụ backend/>` | <HTTP API, CLI, job hoặc vai trò khác> | Có |

Quyết định chọn cấu trúc: ADR `NNNN` <!-- đổi thành link sau khi có ADR -->.

Ghi ở đây các ngoại lệ có chủ đích: <một hoặc hai câu; nếu không có, ghi "Không có">. Cây thư mục cấp repo và các process nằm ở [Kiến trúc](../architecture/ARCHITECTURE.md); file này chỉ quản lý cấu trúc **bên trong** ứng dụng NestJS.

Đánh dấu những điểm vào mà ứng dụng thực sự có. Nếu chỉ có CLI hoặc worker, bỏ nhánh HTTP trong cây, ghi mục 6 là "Không áp dụng" và thay cổng OpenAPI ở mục 11 bằng hợp đồng phù hợp với giao diện của ứng dụng. Nếu dùng GraphQL, RPC hoặc giao thức khác, ghi hợp đồng tương ứng trong kiến trúc và điều chỉnh các ví dụ HTTP bên dưới.

Trước khi sao chép cấu trúc, chốt các biến số sau. Bộ khuôn không ngầm quyết định thay cho dự án:

| Quyết định | Ghi vào tài liệu dự án |
|---|---|
| Runtime | Phiên bản Node đang được hỗ trợ, NestJS, HTTP adapter và package manager; kiểm ma trận tương thích của các package đã chọn |
| Hợp đồng giao diện | Contract-first với `openapi.yaml` như bộ docs này, hoặc code-first sinh OpenAPI từ Nest; chỉ **một** nguồn sự thật và một lệnh CI bắt sai lệch |
| Dữ liệu | Loại DB, công cụ migration, chủ sở hữu schema, cách chạy migration khi deploy và phương án rollback |
| Vận hành | Process HTTP/CLI/worker, số replica, proxy tin cậy, health probe, nơi thu log và quyền xem log |
| Bảo mật | Cách xác thực, phiên/cookie hay bearer token, phân quyền, CORS/CSRF, rate limit và nơi phát security headers |

## 2. Nguyên tắc và ranh giới module

Một năng lực nghiệp vụ nằm trong `src/modules/<feature>/`. Một module Nest gom controller và provider liên quan; `imports` và `exports` là ranh giới sử dụng provider. `AppModule` ghép các module, không chứa logic nghiệp vụ.

Đặt tên feature theo **năng lực mà ứng dụng thực hiện**, không tự động tạo một module cho mỗi bảng DB hoặc mỗi URL. Với HTTP, một feature có thể có nhiều controller; một controller có thể phục vụ nhiều route của cùng năng lực. Bảng feature thật của dự án nằm ở mục 9.

| # | Luật | Cách kiểm |
|---|---|---|
| B1 | Module khác chỉ dùng provider mà module sở hữu **export**, thông qua `imports` của module tiêu thụ. Không lấy repository, DTO nội bộ hoặc hàm riêng bằng import sâu xuyên feature | Review + kiểm ranh giới import ở mục 11 |
| B2 | Đồ thị phụ thuộc giữa các feature không có vòng. Khi A và B cần nhau, đưa luồng phối hợp lên module thứ ba hoặc tách năng lực dùng chung có chủ sở hữu rõ | Kiểm vòng import/module trong CI + review |
| B3 | Khi có HTTP, `controller` nhận request đã kiểm, gọi service rồi đổi kết quả thành response. Quy tắc nghiệp vụ và transaction ở service/use case, để CLI hoặc job cũng dùng được | Test service ngoài HTTP; review |
| B4 | `common/` chỉ chứa phần không biết thực thể nghiệp vụ và được dùng ở nhiều nơi. Guard hay validator biết nghiệp vụ thuộc feature sở hữu nó | Review; kiểm import từ `common/` |
| B5 | Kết nối DB và client dịch vụ ngoài có một nơi sở hữu. Truy vấn và cách ánh xạ dữ liệu của một feature ở trong feature đó; migration ở thư mục của công cụ DB | Test tích hợp + review |
| B6 | Khi có HTTP, DTO, mô hình lưu trữ và mô hình nghiệp vụ có vai trò khác nhau. Không trả trực tiếp bản ghi ORM nếu nó chứa trường nội bộ hoặc làm lệch [hợp đồng API](../api/openapi.yaml) | Test hợp đồng response, nếu có HTTP |
| B7 | Chỉ tạo thư mục và lớp trừu tượng khi có nhu cầu thật. Không bắt mọi feature phải có `domain/`, `repository/`, `use-cases/` hay `index.ts` | Review |
| B8 | Provider mặc định giữ singleton. Chỉ dùng request scope khi ngữ cảnh thật sự cần; logger và kết nối DB không cần đổi scope chỉ để mang `requestId` | Review scope và test tải khi thay đổi |

Các file của Nest module và provider import trực tiếp từ đường dẫn cụ thể; **không bắt buộc barrel `index.ts`**. Barrel có thể gây vòng phụ thuộc trong Nest. Ghi ngoại lệ ở ADR nếu dự án dùng cách khác.

Luật import B1/B2 chỉ kiểm **đường phụ thuộc trong mã**. Nó không chứng minh `imports`/`exports` của Nest đã đúng: phải khởi tạo `TestingModule` hoặc ứng dụng thật trong test tích hợp. Không dùng `forwardRef()` làm cách tổ chức mặc định cho vòng phụ thuộc; tìm lại chủ sở hữu hoặc use case điều phối trước.

*Ví dụ* cách nối module của API đơn hàng và lập hóa đơn ở mục 3. Các dòng `import` TypeScript được lược bớt để tập trung vào ranh giới NestJS:

```ts
// src/infrastructure/database/database.module.ts
@Module({
  providers: [DatabaseService],
  exports: [DatabaseService],
})
export class DatabaseModule {}

// src/modules/orders/orders.module.ts
@Module({
  imports: [DatabaseModule],
  controllers: [OrdersController],
  providers: [OrdersService, OrdersRepository],
  exports: [OrdersService], // chỉ export khi feature khác thật sự cần
})
export class OrdersModule {}

// src/modules/billing/billing.module.ts
@Module({
  imports: [OrdersModule, DatabaseModule],
  controllers: [BillingController],
  providers: [BillingService],
})
export class BillingModule {}

// src/app.module.ts
@Module({
  imports: [
    LoggerModule.forRoot({ pinoHttp: pinoHttpOptions }),
    HealthModule,
    OrdersModule,
    BillingModule,
  ],
})
export class AppModule {}
```

`OrdersRepository` inject `DatabaseService` sau khi `OrdersModule` import `DatabaseModule`. `BillingService` inject `OrdersService` và `DatabaseService` từ hai module đã import; nó không truy cập `orders/persistence/` hoặc gọi `OrdersController`. Import lớp provider công khai qua file cụ thể của feature là hợp lệ; cấm import những file nội bộ không thuộc giao diện mà module công bố. Nếu chỉ cần một phần hành vi, export một provider có giao diện hẹp thay vì toàn bộ service.

## 3. Cây thư mục tham chiếu

<!-- Đây là bộ ô được phép dùng, không phải danh sách thư mục phải tạo sẵn. Xoá nhánh không dùng. -->

```text
<ứng-dụng-nestjs>/
├── package.json
├── <cấu hình-build-và-test>
├── <schema-và-migrations>/          nếu có DB; vị trí theo công cụ đã chọn
├── src/
│   ├── main.ts                      điểm vào HTTP, nếu có; cấu hình rồi listen
│   ├── configure-http-app.ts        cấu hình HTTP dùng chung cho main/test, nếu cần
│   ├── app.module.ts                composition root: import các module
│   ├── config/                      đọc, kiểm và định kiểu cấu hình
│   ├── common/                      filter, pipe, request ID không nghiệp vụ
│   ├── lib/                         hàm thuần dùng nhiều feature, nếu có
│   ├── infrastructure/              client và adapter kỹ thuật dùng chung, nếu có
│   │   ├── database/                module + provider quản lý kết nối DB
│   │   └── logging/                 cấu hình logger/HTTP serializer, nếu chọn Pino
│   ├── system/                      endpoint kỹ thuật live/ready, nếu cần probe HTTP
│   ├── modules/
│   │   ├── <feature-nhỏ>/           module, controller, service, DTO khi cần
│   │   └── <feature-lớn>/           tách thêm http/, application/, persistence/ khi cần
│   ├── cli/                         điểm vào và bộ phân lệnh, nếu có CLI
│   └── worker.ts                    điểm vào worker riêng, nếu có
└── test/                            test đầu-cuối theo giao diện và fixture tích hợp
```

`src/modules/` là quy ước của mẫu để tách code nghiệp vụ khỏi khởi động và hạ tầng. NestJS không đòi tên thư mục này. Nếu repo có nhiều ứng dụng hoặc thư viện, vị trí của chúng thuộc [cây repo](../architecture/ARCHITECTURE.md#9-cấu-trúc-thư-mục-repo), không tự động thành module NestJS.

### Preset HTTP đề xuất cho dự án mới

Repo `docs-template` chỉ chứa **tài liệu**: chép file này không tạo ứng dụng NestJS và không cài package. Nếu tạo thêm một starter backend chạy được cho dự án mới, cấu trúc ngày đầu nên là:

```text
backend/
├── README.md                     lệnh chạy và quyết định preset
├── .gitignore
├── package.json
├── package-lock.json              hoặc một lockfile của package manager đã chọn
├── .node-version                  ghim phiên bản Node đã kiểm
├── .env.example                   tên biến và giá trị mẫu vô hại
├── nest-cli.json
├── tsconfig.json
├── tsconfig.build.json
├── vitest.config.ts
├── vitest.config.e2e.ts
├── .oxlintrc.json
├── .prettierrc
├── .dependency-cruiser.mjs       luật B1/B2 theo import đã resolve
├── src/
│   ├── main.ts                    tạo app, gắn logger, shutdown và listen
│   ├── configure-http-app.ts      security headers, validation, CORS theo quyết định
│   ├── app.module.ts              cấu hình module gốc, không chứa nghiệp vụ
│   ├── config/
│   │   └── env.validation.ts      kiểm và đổi kiểu cấu hình lúc khởi động
│   ├── common/http/
│   │   └── api-exception.filter.ts   chuyển lỗi thành hợp đồng API công khai
│   ├── infrastructure/logging/
│   │   └── pino-http.options.ts   request ID, serializer và redaction
│   └── system/health/
│       ├── health.module.ts
│       └── health.controller.ts   /health/live và /health/ready
└── test/e2e/
    └── http-baseline.e2e-spec.ts  bootstrap, header, lỗi, log và probe
```

Tạo `src/modules/<feature>/` với feature đầu tiên; không thêm sẵn `auth/`, `database/`, `jobs/`, `worker.ts`, queue hoặc thư mục rỗng. Nếu dự án chưa có cách thu thập log phù hợp, có thể khởi đầu bằng JSON logger tích hợp của Nest thay cho nhánh `infrastructure/logging/`; chính sách schema log và redaction vẫn giữ nguyên. Ví dụ `orders`/`billing` bên dưới minh họa **bước sau khi đã có nghiệp vụ**, không phải file phải chép vào mọi dự án.

### Thư viện cài sẵn của preset HTTP

Preset tham chiếu dùng NestJS **12.1+**, một HTTP adapter là Express, TypeScript/ESM, Vitest và Node **24 LTS** (ít nhất 24.15 để chạy Nest CLI) tại thời điểm viết. Ghim phiên bản Node đã kiểm trong `.node-version` và `engines` của `package.json`; toàn bộ package được khóa bằng lockfile. Giữ `@nestjs/common`, `@nestjs/core`, `@nestjs/platform-express` và `@nestjs/testing` cùng major tương thích; các package Nest bổ trợ có major riêng nên kiểm `peerDependencies` thay vì ép cùng số major.

| Nhóm | Package trong preset | Trách nhiệm |
|---|---|---|
| Nest nền tảng | `@nestjs/common`, `@nestjs/core`, `@nestjs/platform-express`, `reflect-metadata`, `rxjs` | Module, DI và HTTP adapter; CLI Nest đã tạo các gói này |
| Cấu hình | `@nestjs/config` | Nạp cấu hình; `env.validation.ts` kiểm biến bắt buộc và đổi kiểu lúc khởi động |
| DTO HTTP | `class-validator`, `class-transformer` | Một chiến lược mặc định với `ValidationPipe`; không cài thêm schema validator thứ hai nếu chưa chọn đổi chiến lược |
| Log | `nestjs-pino`, `pino`, `pino-http` | JSON log theo request, request ID và redaction; phải cấu hình serializer theo danh sách trường cho phép trước khi chạy production |
| Giới hạn tần suất | `@nestjs/throttler` | Gắn `ThrottlerGuard` và viết chính sách theo route; hoàn thiện ngưỡng/kho đếm trước khi API mở ra ngoài |
| Build và test (devDependencies) | `@nestjs/cli`, `@nestjs/testing`, `typescript`, `vitest`, `@vitest/coverage-v8`, `supertest`, `@types/node`, `@types/express`, `@types/supertest`, `oxlint`, `prettier`, `dependency-cruiser` | Build, typecheck, unit/e2e, lint, format và kiểm vòng/ràng buộc import; chọn **một** test runner và một linter |

Sau khi Nest CLI tạo ứng dụng với ESM/Vitest, bỏ qua tùy chọn NestJS Observe nếu dự án chưa chọn dịch vụ đó, kiểm lại package hỗ trợ/deploy do CLI sinh ra và thêm các gói ngoài bộ khởi tạo bằng package manager đã chọn. Ví dụ với npm:

```bash
npm install @nestjs/config class-validator class-transformer nestjs-pino pino pino-http @nestjs/throttler
npm install --save-dev dependency-cruiser
```

Kiểm phiên bản/peer dependencies tại thời điểm tạo dự án, chạy test rồi commit `package-lock.json`. Các máy và CI sau đó cài bằng `npm ci` để dùng đúng lockfile. Cấu hình `dependency-cruiser` phải bắt được import chéo feature và vòng phụ thuộc theo fixture ở mục 11; việc có package trong `devDependencies` tự nó chưa tạo cổng kiểm.

Với dự án HTTP công khai, có thể cài nhóm bổ sung sau khi chọn đường xác thực/hợp đồng dữ liệu:

| Khi nào thêm | Package hoặc cơ chế |
|---|---|
| Có DB | Một ORM/query builder + driver + công cụ migration cùng hệ; không cài đồng thời nhiều ORM theo mặc định |
| Nhiều replica và rate limit ở app | Một `ThrottlerStorage` dùng chung tương thích, cùng kho Redis hoặc dịch vụ tương đương; storage mặc định chỉ ở memory từng process |
| Cần auth | Package session/JWT/Passport tương ứng với giao thức và mô hình đe dọa đã chọn |
| Health indicator phức tạp | `@nestjs/terminus`; endpoint live/ready đơn giản có thể tự cài bằng Nest |
| Code-first OpenAPI | `@nestjs/swagger`; với bộ docs contract-first hiện tại, `docs/api/openapi.yaml` đã là nguồn sự thật nên không cài chỉ để có Swagger UI |
| Worker, queue, cache, metrics/tracing | Thêm đúng adapter sau khi có process hoặc yêu cầu thật; không có mặt trong preset ngày đầu |

NestJS 12.1+ đã có `app.useSecurityHeaders()` dùng mặc định tương đương Helmet 8, nên preset này **không cài `helmet`**. Nếu dự án dùng phiên bản cũ hơn, chọn `helmet` cho Express hoặc `@fastify/helmet` cho Fastify. Chống CSRF cũng là quyết định theo kiểu xác thực: khi dùng cookie/session cho trình duyệt, cấu hình `app.enableCsrfProtection()` trên NestJS 12.1+ hoặc cơ chế tương ứng. [Tài liệu NestJS](https://docs.nestjs.com/security/helmet), [CSRF](https://docs.nestjs.com/security/csrf).

Đây là **preset tham chiếu**, không phải bộ package đã được cài trong repo `docs-template`. Khi tạo starter mã nguồn thực, phải chạy `npm install` theo package manager đã chọn, commit lockfile, kiểm build/test/e2e và cập nhật ma trận phiên bản. Nếu chọn Fastify, CommonJS/Jest, JSON logger tích hợp hoặc schema runtime thay DTO class, thay **cả nhánh cấu hình và test liên quan** để starter chỉ có một cách làm cho mỗi việc.

### Ví dụ cụ thể: API đơn hàng và lập hóa đơn

Giả sử một dự án có **một HTTP API** tại `backend/`, hai feature `orders` và `billing`, và dùng file SQL để migration. Đây chỉ là ví dụ đặt file: tên nghiệp vụ, công cụ DB và thư mục migration được thay theo dự án. Ứng dụng này chọn Pino và có health probe HTTP; chưa có CLI, worker hoặc thư viện dùng chung, nên không tạo những nhánh đó.

```text
backend/
├── README.md
├── .gitignore
├── package.json
├── package-lock.json
├── .node-version
├── .env.example
├── nest-cli.json
├── tsconfig.json
├── tsconfig.build.json
├── vitest.config.ts
├── vitest.config.e2e.ts
├── .oxlintrc.json
├── .prettierrc
├── .dependency-cruiser.mjs
├── db/
│   └── migrations/
│       ├── 001_create_orders.sql
│       └── 002_create_invoices.sql
├── src/
│   ├── main.ts
│   ├── configure-http-app.ts
│   ├── app.module.ts
│   ├── config/
│   │   └── env.validation.ts
│   ├── common/http/
│   │   └── api-exception.filter.ts
│   ├── infrastructure/
│   │   ├── database/
│   │   │   ├── database.module.ts
│   │   │   └── database.service.ts
│   │   └── logging/
│   │       └── pino-http.options.ts
│   ├── system/
│   │   └── health/
│   │       ├── health.module.ts
│   │       └── health.controller.ts
│   └── modules/
│       ├── orders/
│       │   ├── orders.module.ts
│       │   ├── http/
│       │   │   ├── orders.controller.ts
│       │   │   ├── order-response.mapper.ts
│       │   │   └── dto/
│       │   │       ├── create-order.dto.ts
│       │   │       └── order-response.dto.ts
│       │   ├── application/
│       │   │   ├── orders.service.ts
│       │   │   └── orders.service.spec.ts
│       │   ├── domain/
│       │   │   └── order-policy.ts
│       │   └── persistence/
│       │       └── orders.repository.ts
│       └── billing/
│           ├── billing.module.ts
│           ├── billing.controller.ts
│           ├── billing.service.ts
│           ├── billing.service.spec.ts
│           └── dto/
│               └── create-invoice.dto.ts
└── test/
    ├── e2e/
    │   ├── orders.e2e-spec.ts
    │   ├── billing.e2e-spec.ts
    │   └── http-baseline.e2e-spec.ts
    └── integration/
        └── orders.repository.int-spec.ts
```

| File trong ví dụ | Trách nhiệm cụ thể |
|---|---|
| `src/main.ts` | Tạo HTTP app, gắn Pino vào Nest, gọi `configureHttpApp`, bật shutdown hooks rồi listen. |
| `src/configure-http-app.ts` | Hàm cấu hình HTTP dùng chung cho `main.ts` và e2e; gắn security headers trước middleware có thể tự trả response, cùng pipe, filter và CORS. |
| `src/app.module.ts` | Import `OrdersModule`, `BillingModule`, `HealthModule` và cấu hình Pino một lần; không viết nghiệp vụ. |
| `src/config/env.validation.ts` | Kiểm và đổi kiểu biến môi trường, gồm DB, cổng, `LOG_LEVEL`, khi app khởi động. |
| `src/infrastructure/database/` | `DatabaseModule` sở hữu và export `DatabaseService` quản lý kết nối DB. |
| `src/infrastructure/logging/pino-http.options.ts` | Chỉ định request ID, trường log cho phép, redaction và mức log; được module gốc dùng. |
| `src/system/health/` | Endpoint liveness/readiness kỹ thuật, không mang nghiệp vụ đơn hàng. |
| `src/modules/orders/http/` | `OrdersController` nhận request; DTO kiểm input và mô tả response; mapper đổi kết quả service thành response công khai. |
| `src/modules/orders/application/orders.service.ts` | Thực hiện thao tác tạo/đọc đơn hàng, kiểm quy tắc và quyết định ranh giới transaction. |
| `src/modules/orders/domain/order-policy.ts` | Quy tắc thuần của đơn hàng, chẳng hạn không cho tạo đơn rỗng; không import NestJS hay DB. |
| `src/modules/orders/persistence/orders.repository.ts` | Truy vấn và lưu đơn hàng thông qua `DatabaseService`; không nhận request HTTP. |
| `src/modules/billing/` | `BillingService` dùng `OrdersService` đã export để lấy đơn có thể lập hóa đơn, rồi lưu hóa đơn qua `DatabaseService`. Feature còn ít file nên chưa cần `application/` và `persistence/` riêng. |
| `test/e2e/` và `test/integration/` | Kiểm endpoint qua cùng cấu hình bootstrap; kiểm header, log, readiness; kiểm repository và migration với DB tạm. |

Luồng `POST /orders`: `create-order.dto.ts` → `orders.controller.ts` → `orders.service.ts` → `order-policy.ts` và `orders.repository.ts` → `database.service.ts`; kết quả đi qua `order-response.mapper.ts` trước khi trả về. Luồng `POST /invoices`: `billing.controller.ts` → `billing.service.ts` → `OrdersService` được `OrdersModule` export; `BillingService` dùng kết nối DB qua `DatabaseModule` để lưu hóa đơn. Khi phần hóa đơn có nhiều truy vấn hoặc quy tắc, tách `billing/persistence/` và `billing/application/` theo mục 4.

## 4. Một feature bắt đầu nhỏ và lớn lên

*Ví dụ* một feature chỉ có HTTP, quy tắc đơn giản và DB:

```text
src/modules/<feature>/
├── <feature>.module.ts
├── <feature>.controller.ts
├── <feature>.service.ts
├── <feature>.service.spec.ts
└── dto/
    ├── create-<feature>.dto.ts
    └── <feature>-response.dto.ts
```

Khi feature có nhiều endpoint, nguồn dữ liệu hoặc luồng, tách theo vai trò **trong chính feature**:

```text
src/modules/<feature>/
├── <feature>.module.ts
├── http/                         controller, request/response DTO, mapper HTTP
├── application/                  use case, transaction, phối hợp provider
├── domain/                       quy tắc thuần, chỉ khi có logic đáng tách
├── persistence/                  truy vấn và ánh xạ DB riêng của feature
├── integrations/                 adapter dịch vụ ngoài riêng của feature
└── jobs/                         job do feature sở hữu
```

Không chuyển sang cây lớn chỉ vì có thêm một controller. Tách khi vai trò đã có nhiều file, cần test riêng, hoặc hai loại I/O đang chen vào cùng một service. Nếu một tích hợp chỉ phục vụ một feature, giữ nó trong `integrations/` của feature; phần kết nối dùng chung có thể nằm ở `infrastructure/`.

| Khi cần thêm | Đặt ở đâu | Lý do |
|---|---|---|
| Endpoint của feature đang có | Controller của feature, hoặc controller thứ hai trong `http/` | Module vẫn sở hữu use case |
| Quy tắc thuần chỉ một feature dùng | Trong feature, `domain/` hoặc `utils/` khi đủ nhiều file | Không đẩy lên `common/` sớm |
| Pipe/guard biết người dùng hay thực thể của feature | Trong feature sở hữu nó | Giữ ranh giới nghiệp vụ |
| Filter, request id, pipe trung lập cho nhiều feature | `common/` | Chỉ phần thực sự chung |
| Truy vấn DB riêng của feature | Service hoặc `persistence/` của feature | Không tạo kho repository chung cho cả ứng dụng |
| Job hoặc lịch của feature | `jobs/` của feature | Cùng chủ sở hữu, cùng service |
| Hàm thuần dùng ở nhiều feature | `src/lib/` hoặc package thuần nếu dự án có nhiều app | Không phải Nest module nếu không cần DI |

## 5. Trách nhiệm của từng lớp

| Nơi | Được làm | Không làm |
|---|---|---|
| `main.ts` nếu có HTTP | Tạo app, gắn logger và HTTP security trước `init`/`listen`, gọi cấu hình HTTP chung, bật shutdown hook rồi listen | Truy vấn DB, xử lý nghiệp vụ |
| `app.module.ts` | Import module và cấu hình composition root | Chứa controller/service của mọi feature |
| `config/` | Kiểm biến môi trường khi khởi động, cấp cấu hình đã định kiểu | Ghi secret vào repo hoặc in giá trị bí mật khi lỗi |
| `common/` | Xử lý lỗi chung, request id, pipe thật sự trung lập | `helpers.ts` chứa logic của nhiều feature; guard phụ thuộc một thực thể nghiệp vụ |
| `infrastructure/` | Quản lý kết nối, client kỹ thuật, logger adapter và vòng đời tài nguyên dùng chung | Quyết định nghiệp vụ của một feature |
| `system/` nếu có | Endpoint kỹ thuật như live/ready và health module | Logic nghiệp vụ hoặc kiểm DB trong liveness |
| `<feature>/http/` hoặc controller | Nhận request, kiểm input, gọi use case, map response | Truy vấn ORM trực tiếp, transaction nhiều bước |
| `<feature>/application/` hoặc service | Thực hiện use case, kiểm bất biến, phối hợp DB và tác dụng phụ | Phụ thuộc vào `Request`/`Response` HTTP nếu cùng luồng còn có CLI/job |
| `<feature>/persistence/` | Truy vấn và ánh xạ dữ liệu của feature | Trả bản ghi chứa trường nội bộ thẳng ra HTTP |
| `<feature>/domain/` | Hàm, kiểu và quy tắc nghiệp vụ thuần | Import NestJS, ORM, HTTP hoặc client dịch vụ ngoài |

Luồng điển hình: `controller → service/use case → persistence → database`. CLI và job đi vào **cùng service/use case**. Một feature nhỏ có thể để service gọi provider DB trực tiếp; `repository` chỉ cần khi truy vấn hoặc cách lưu trữ đã đủ phức tạp để đáng tách.

Với guard, filter hoặc interceptor dùng chung mà cần DI, đăng ký bằng provider `APP_GUARD`, `APP_FILTER` hoặc `APP_INTERCEPTOR` trong module sở hữu. `main.ts` dành cho thao tác bootstrap và cấu hình adapter; tránh tạo instance thủ công rồi đánh mất DI. Nếu HTTP e2e tự tạo Nest app, dùng chung hàm cấu hình với `main.ts` để pipe, filter, CORS và header trong test khớp production.

```text
HTTP controller ─┐
CLI command ─────┼──► service / use case ──► persistence ──► DB
job handler ─────┘              │
                                └────────► tích hợp ngoài (nếu có)
```

## 6. HTTP API, DTO và kiểm dữ liệu (khi có HTTP)

Với cách **contract-first** của bộ docs này, [OpenAPI](../api/openapi.yaml) là nguồn sự thật cho path, tham số, request và response; quy ước và hành vi lỗi nằm ở [API](../api/api.md). Nếu dự án chọn code-first của Nest, sửa dòng này, sinh một OpenAPI artifact trong CI và kiểm client/schema với artifact đó; không duy trì hai bản hợp đồng sửa tay. Nếu ứng dụng không có HTTP, ghi "Không áp dụng" ở đây. Nếu có HTTP, chọn cách tạo DTO/runtime schema cho NestJS rồi ghi lệnh và chủ sở hữu:

| Việc | Quyết định của dự án |
|---|---|
| Kiểm request lúc chạy (DTO class + pipe, hoặc schema + pipe) | <cách chọn và lệnh kiểm> |
| Đổi DTO thành input của service | <mapper hoặc truyền thẳng khi hình dạng giống nhau> |
| Đổi kết quả thành response công khai | <mapper/serializer và nơi đặt> |
| Kiểm backend khớp `openapi.yaml` | <lệnh test hợp đồng trong CI> |
| Sinh client/schema cho bên gọi API, nếu có | <lệnh sinh và cổng kiểm file sinh không cũ> |

TypeScript `interface` chỉ tồn tại lúc biên dịch nên không tự kiểm request lúc chạy. Quy tắc an toàn và bất biến phải nằm ở service/use case hoặc sâu hơn: pipe, guard và interceptor HTTP **không chạy** khi CLI gọi provider qua application context.

Với DTO class, điểm khởi đầu là `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true })`; với schema runtime, chọn chính sách từ chối trường lạ và chuyển kiểu tương đương theo hợp đồng. Kiểm cả `params`, `query`, body và giới hạn kích thước request. Phép chuyển kiểu có thể làm đổi ý nghĩa dữ liệu: chỉ cho phép kiểu và giá trị đã ghi trong OpenAPI, rồi test input sai kiểu và trường thừa. Response đi qua DTO/mapper công khai; không serialize nguyên entity hoặc đối tượng lỗi nội bộ.

### Xác thực, phân quyền và lỗi

| Ranh giới | Quy ước của mẫu | Nơi đặt khi có tính năng |
|---|---|---|
| Xác thực | Nếu đa số route là riêng tư, đăng ký guard toàn cục và đánh dấu route công khai một cách tường minh; chọn session/cookie hoặc bearer theo kiến trúc. | Cơ chế chung ở module xác thực; guard/strategy biết nghiệp vụ ở feature sở hữu |
| Phân quyền | Kiểm quyền **theo hành động và đối tượng** trong use case hoặc policy của feature, gồm tenant/owner nếu có. Guard route chỉ là lớp đầu; CLI/job cũng phải qua cùng quy tắc khi thực hiện hành động. | `<feature>/application/` hoặc `<feature>/domain/`; test chủ thể khác quyền |
| Lỗi | Một ranh giới HTTP đổi lỗi có mã ổn định thành response theo [quy ước API](../api/api.md). Lỗi 5xx trả thông báo chung và `requestId`; chi tiết nội bộ chỉ ở log đã lọc. CLI/job ánh xạ lỗi thành mã thoát hoặc trạng thái job. | Filter HTTP trung lập ở `common/` nếu thật sự cần; mã lỗi nghiệp vụ ở feature |
| Tài nguyên đầu vào | Chỉ nhận kiểu/kích thước được phép; giới hạn body và, nếu có upload, số file/kích thước/loại file. Không bật upload module khi chưa có luồng upload. | Cấu hình adapter và validator trong feature |

Không xem CORS là xác thực hay CSRF protection. Nếu browser dùng cookie/session để gọi thao tác ghi, chọn chính sách chống CSRF; NestJS v12.1+ có `enableCsrfProtection()` dựa trên `Origin`/Fetch Metadata, phiên bản khác cần phương án phù hợp. Cơ chế tích hợp cho phép request thiếu cả hai header này; nếu dự án phải bảo vệ trình duyệt cũ theo mô hình đe doạ, cân nhắc thêm token CSRF. Với UI khác origin, cấu hình danh sách origin được phép của **CORS và CSRF riêng**; không dùng origin `*` cùng credentials. Kiểm cookie `SameSite`/`Secure` và proxy/HTTPS trong môi trường thật. Các request từ webhook hoặc client không phải browser cần chính sách xác thực và ngoại lệ CSRF có phạm vi rõ.

### Header bảo mật và giới hạn tần suất

| Nội dung | Quy ước của mẫu | Quyết định cần ghi cho dự án |
|---|---|---|
| Header bảo mật | Gắn sớm trong `main.ts`, trước các middleware có thể tự trả response. Với NestJS v12.1+, có thể dùng `app.useSecurityHeaders()`; ở phiên bản khác chọn Helmet cho Express hoặc plugin tương ứng cho Fastify. Chỉ có một nơi chịu trách nhiệm cho mỗi header. | Phiên bản Nest/HTTP adapter, cấu hình CSP/HSTS và nơi phát header (ứng dụng hoặc edge) |
| Rate limit | Đặt chính sách ở `config/` hoặc module gốc; `@nestjs/throttler` chỉ thực thi sau khi **gắn `ThrottlerGuard`** toàn cục (`APP_GUARD`) hoặc ở route. Route nhạy cảm có ngưỡng riêng trong feature sở hữu. | Route, khóa đếm (IP/tài khoản/tenant), `limit`, `ttl` theo **mili giây**, thời gian chặn, response `429` |
| Proxy và nhiều replica | Chỉ tin proxy/địa chỉ trung gian đã cấu hình; kiểm IP thật dùng để đếm. Khi chạy nhiều instance, dùng kho đếm chung nếu giới hạn cần có hiệu lực trên toàn hệ thống. | Chuỗi proxy tin cậy, chỗ giữ bộ đếm, chính sách ở edge và ở app |
| Ngoại lệ | Ghi rõ route nào được bỏ qua hoặc có hạn mức khác, ví dụ health check hay luồng tải dài. | Lý do, chủ sở hữu và test cho từng ngoại lệ |

Kiểm CSP trên UI/API docs/WebSocket thực tế trước khi chốt; kiểm HSTS theo domain và HTTPS của môi trường triển khai. Với đăng nhập, dùng hạn mức **độc lập** theo IP và định danh tài khoản (không chỉ khóa ghép IP+tài khoản), rồi thiết kế chính sách số lần sai/khóa tài khoản riêng. Mã lỗi và thông tin trả về khi bị giới hạn phải khớp [quy ước API](../api/api.md); không lộ thông tin để suy đoán tài khoản có tồn tại.

## 7. DB, transaction và tích hợp ngoài

- Một module hạ tầng sở hữu provider kết nối DB và vòng đời mở/đóng; feature cần DB import module đó. ORM cụ thể (Prisma, TypeORM, công cụ khác) là quyết định của dự án.
- Schema và migration ở chỗ công cụ DB yêu cầu, có commit và test trên DB tạm. Không đặt migration cạnh controller.
- Use case sở hữu ranh giới transaction. Code trong `persistence/` không tự tạo transaction độc lập làm mất tính nguyên tử của một thao tác nhiều bước.
- Interface/port chỉ thêm khi có ít nhất hai cách cài đặt, cần thay trong test, hoặc ranh giới ngoài thật sự phức tạp. Không tạo lớp repository bọc từng hàm ORM theo thói quen.
- Client dịch vụ ngoài có timeout, giới hạn kết nối và cách báo lỗi rõ trong [cấu hình](configuration.md); nếu có HTTP, ghi cách trả lỗi trong [quy ước API](../api/api.md). Adapter riêng một feature ở trong feature đó.
- Chỉ retry thao tác đã chứng minh an toàn khi gọi lại; có giới hạn số lần, thời gian và điều kiện dừng. Với lệnh ghi có thể bị gửi lặp, quyết định idempotency key hoặc cơ chế chống trùng ở use case. Nếu cần bảo đảm phát sự kiện sau commit, ghi rõ outbox hoặc cách tương đương; không thêm hàng đợi/outbox trước khi có yêu cầu thật.
- Không ghép SQL từ input; dùng truy vấn có tham số/ORM. Tách migration khỏi bootstrap HTTP; khi deploy, chạy migration đúng một nơi và kiểm bản build mới đọc được schema trong giai đoạn chuyển tiếp.
- Nếu ứng dụng gọi URL do người dùng cung cấp, xác định đích được phép và kiểm cả redirect, địa chỉ nội bộ và egress mạng theo mô hình đe doạ; không tạo adapter tải URL khi không có luồng này.

## 8. HTTP, CLI và job

| Vai trò | Điểm vào | Gọi gì | Ghi chú |
|---|---|---|---|
| HTTP | `src/main.ts` | Controller → service | Có pipe, guard, interceptor HTTP |
| CLI | `src/cli/<tên>.ts` hoặc `src/cli.ts` | Service qua Nest application context | Kiểm input lệnh và gọi quy tắc nghiệp vụ trong service; đóng app sau khi chạy |
| Job cùng process | `jobs/` của feature sở hữu | Service của feature | Ghi cách tránh chạy trùng nếu có nhiều replica |
| Worker process riêng | `src/worker.ts` nếu đã có lý do tách | Cùng service/module | Ghi module nào worker nạp, cách shutdown và deploy |

Không tạo `worker.ts`, `jobs/` hay hàng đợi trước khi dự án thực sự cần. Những thao tác có cả đường HTTP lẫn CLI phải có một use case dùng chung, để hai đường kiểm cùng điều kiện.

*Ví dụ* điểm vào CLI lấy provider từ application context, không gọi controller HTTP:

```ts
const app = await NestFactory.createApplicationContext(AppModule)
try {
  const service = app.get(OrdersService)
  await service.runCommand(input)
} finally {
  await app.close()
}
```

Application context không chạy pipe, guard hoặc interceptor HTTP. Vì vậy `runCommand()` phải nhận input đã kiểm và service vẫn phải bảo vệ các bất biến nghiệp vụ mà HTTP cũng cần.

### Sẵn sàng phục vụ và tắt ứng dụng

Nếu môi trường triển khai dùng HTTP probe, đặt endpoint kỹ thuật trong `src/system/health/`. **Liveness** chỉ trả lời process còn phục vụ được; không gọi DB hay dịch vụ ngoài để tránh khởi động lại hàng loạt khi dependency bị lỗi. **Readiness** kiểm những phụ thuộc bắt buộc và trả trạng thái chưa sẵn sàng khi khởi động, đang drain hoặc không thể phục vụ request. Đặt timeout ngắn cho phép kiểm; không trả secret hay thông tin hạ tầng chi tiết ra response công khai. Dùng `@nestjs/terminus` khi cần nhiều health indicator; endpoint đơn giản không bắt buộc thêm package.

Với process nhận tín hiệu dừng, bật `app.enableShutdownHooks()` và đóng DB, consumer, kết nối ngoài theo lifecycle hook. Ghi timeout drain ở [triển khai](../ops/deployment.md) để load balancer ngừng đưa request mới trước khi process thoát; test `SIGTERM` và request đang chạy. CLI/application context phải gọi `app.close()` trong `finally` như ví dụ trên.

### Log có cấu trúc và liên kết tác vụ

| Nội dung | Quy ước của mẫu |
|---|---|
| Đầu ra | Mỗi bản ghi là một dòng JSON gửi ra stdout/stderr để hạ tầng thu thập. Đặt mức log bằng `LOG_LEVEL` đã kiểm trong [cấu hình](configuration.md); định dạng dễ đọc chỉ dùng khi phát triển cục bộ. |
| Ngữ cảnh | HTTP có `requestId` duy nhất giữa các instance; tạo ở ingress hoặc kiểm giới hạn độ dài/ký tự trước khi chấp nhận từ client, rồi trả lại trong response qua header đã công bố. Truyền ID qua lời gọi nội bộ nếu có nhiều dịch vụ. Job/CLI có `runId` hoặc `jobId` và tên thao tác. Nếu có tracing, thêm `traceId`/`spanId`. |
| Trường ổn định | `time`, `level`, `service`, `environment`, `event`, `requestId` hoặc ID của tác vụ; với HTTP thêm method, **mẫu route** (không chứa query), status và thời gian xử lý; với lỗi thêm `errorCode` và stack nội bộ khi cần. |
| Sự kiện | Ghi một bản ghi hoàn tất cho request/job và sự kiện nghiệp vụ quan trọng. Cho phép bỏ qua hoặc lấy mẫu access log của health/metrics theo chính sách đã ghi, nhưng vẫn giữ lỗi và tín hiệu vận hành. Chọn một lớp sở hữu log lỗi để tránh cùng lỗi bị ghi lặp ở controller, service và filter. Phân biệt lỗi dự kiến với lỗi hệ thống khi đặt mức log. |
| Bảo mật và audit | Khi có đăng nhập/quyền, ghi sự kiện đăng nhập thất bại, từ chối quyền và thay đổi quyền với hành động, kết quả và ID chủ thể/tài nguyên phù hợp; không ghi credential. Xác định sự kiện audit cần giữ riêng hoặc lâu hơn access log theo yêu cầu dự án. |
| Dữ liệu nhạy cảm | Chỉ serialize các trường HTTP được cho phép. Không ghi body, query string, toàn bộ `req`/`res`, headers, cookie, token, mật khẩu, khóa, mã một lần hoặc dữ liệu cá nhân theo mặc định. Cấu hình redaction là lớp bảo vệ bổ sung; kiểm cả lỗi, startup log và debug log. |
| Vòng đời | Gắn logger trước `app.init()`/`app.listen()` để log khởi động và lỗi khởi tạo đi cùng định dạng. CLI và worker dùng cùng quy ước logger, flush/đóng tài nguyên trước khi thoát khi adapter cần. |

NestJS có JSON logger tích hợp. Nếu dự án chọn **Pino** để tự gắn ngữ cảnh request, redaction hoặc đáp ứng tải log lớn, đặt `pino-http.options.ts` trong `src/infrastructure/logging/`, đăng ký `LoggerModule.forRoot({ pinoHttp: ... })` **một lần** ở module gốc, rồi thay logger của Nest khi khởi động:

```ts
// main.ts; Logger ở đây được import từ nestjs-pino
const app = await NestFactory.create(AppModule, { bufferLogs: true });
app.useLogger(app.get(Logger));
configureHttpApp(app); // security headers được gắn đầu tiên trong hàm này
app.enableShutdownHooks();
await app.listen(port);
```

Trong `pino-http.options.ts`, cấu hình `genReqId`, serializer theo danh sách trường cho phép, `redact`, mức log và cách ghi request hoàn tất. ID số mặc định của `pino-http` không đủ để phân biệt nhiều instance. Không giữ mặc định `req.headers`/URL đầy đủ vì query và header có thể chứa bí mật. Kiểm phiên bản Nest, Node và `nestjs-pino` tương thích khi thêm dependency. Một bản ghi mục tiêu (tên trường do dự án thống nhất) có dạng:

```json
{"level":30,"time":1760000000000,"service":"api","environment":"production","event":"http.request.completed","requestId":"550e8400-e29b-41d4-a716-446655440000","method":"GET","route":"/orders/:id","statusCode":200,"durationMs":18}
```

Ghi thời gian lưu log, quyền truy cập, cách tra cứu theo `requestId`/`runId` và cảnh báo từ log trong [tài liệu triển khai](../ops/deployment.md) hoặc tài liệu vận hành riêng của dự án.

Nếu có hệ thống metric/trace, đo số request, tỷ lệ lỗi, thời gian xử lý HTTP và độ trễ phụ thuộc quan trọng; ghi ngưỡng cảnh báo theo [yêu cầu phi chức năng](../product/nfr.md). Nhãn metric chỉ dùng giá trị có số lượng hữu hạn như method, **mẫu route** và nhóm status; không đưa URL thô, `requestId` hay user ID vào nhãn. Truyền trace context qua các dịch vụ khi hệ thống có nhiều hop; code tích hợp thu thập dùng chung ở `infrastructure/` khi thật sự cần.

## 9. Danh sách feature của dự án

<!-- Một hàng mỗi năng lực nghiệp vụ. Chỉ ghi module đã có hoặc sắp làm trong mốc đang mở. -->

| Feature | Module | Route / CLI / job | Spec | Provider export cho module khác | Phụ thuộc vào module nào |
|---|---|---|---|---|---|
| `<tên>` | `<TênModule>` | `<…>` | `NNN` | `<provider hoặc không>` | `<module hoặc không>` |

## 10. Test đặt ở đâu

| Loại | Vị trí | Kiểm gì |
|---|---|---|
| Unit | `*.spec.ts` cạnh service, mapper hoặc hàm thuần | Quy tắc, nhánh lỗi, không cần I/O thật |
| Tích hợp | Cạnh feature hoặc `test/integration/` | Module + DB thật tạm thời để kiểm transaction và ràng buộc; giả lập dịch vụ ngoài khi phù hợp |
| Bootstrap/cấu hình | `test/integration/` | Thiếu/sai biến môi trường thì app không khởi động; module có đủ `imports`/`exports`; e2e dùng cùng cấu hình HTTP với production |
| API đầu-cuối, nếu có HTTP | `test/e2e/` | Request thật qua Nest app: auth, pipe, filter, response |
| Bảo vệ HTTP, nếu có | `test/e2e/` | Input sai/trường thừa; header trên response thành công và lỗi; CSP ở trang thực; CORS/CSRF nếu dùng cookie; rate limit trả `429`, khóa đếm và proxy đúng khi có nhiều client/replica |
| Phân quyền, nếu có | `*.spec.ts` và `test/e2e/` | Chủ thể thiếu quyền hoặc sai tenant không đọc/ghi được tài nguyên qua HTTP **và** qua use case do job/CLI gọi |
| Log và dữ liệu nhạy cảm | `test/integration/` hoặc `test/e2e/` | `requestId` trong response khớp log; lỗi và job có ID tương quan; token, cookie, query nhạy cảm và body mẫu không xuất hiện trong log |
| Hợp đồng HTTP, nếu có | `test/contract/` hoặc `test/e2e/` | Request, response và mã lỗi khớp `openapi.yaml` |
| CLI/job | `test/` hoặc cạnh lệnh | Cùng service/use case; lỗi trả mã thoát và thông báo đúng |
| Vận hành, nếu có HTTP probe | `test/e2e/` hoặc test tích hợp | Liveness không phụ thuộc DB; readiness báo chưa sẵn sàng khi dependency bắt buộc lỗi hoặc process đang drain; đóng tài nguyên khi dừng |

Lệnh chạy được thật, DB tạm, fixture và tiêu chí nghiệm thu nằm ở [Kiểm thử](testing.md). Test không chạy vào DB hoặc thư mục thật của môi trường production.

## 11. Tên file và kiểm ranh giới tự động

| Chủ đề | Quy ước |
|---|---|
| File | ASCII `kebab-case`: `create-order.dto.ts`, `orders.service.ts` |
| Class | `PascalCase`: `OrdersModule`, `CreateOrderDto` |
| Test | Unit `*.spec.ts` cạnh mã; API `*.e2e-spec.ts` ở `test/` |
| Import nội bộ feature | Đường dẫn cụ thể; không cần `index.ts` cho module/provider |
| Import xuyên feature | Chỉ provider được module kia export; không import repository hoặc DTO nội bộ |
| Alias | <alias của dự án, hoặc không dùng>; không để alias che đường import vi phạm B1–B2 |

| Cổng | Công cụ của dự án | Lệnh chạy từ gốc repo |
|---|---|---|
| Lint + kiểu | <ESLint, TypeScript, công cụ khác> | `<lệnh>` |
| B1/B2: ranh giới + không vòng | <công cụ kiểm import/module, gồm alias và đường tương đối> | `<lệnh>` |
| Khởi động module + cấu hình HTTP | <test runner khởi tạo Nest app> | `<lệnh>` |
| Test unit, tích hợp, e2e | <test runner> | `<lệnh>` |
| Hợp đồng OpenAPI, nếu có HTTP API | <công cụ kiểm schema và response> | `<lệnh>` |
| Build chạy được + dependency | <lệnh build, smoke entrypoint, kiểm dependency theo chính sách repo> | `<lệnh>` |

Kiểm B1/B2 bằng fixture nhỏ trước khi tuyên bố cổng CI đã hoạt động:

| Tình huống | Kết quả mong đợi |
|---|---|
| `billing` import `OrdersService` công khai; `BillingModule` import `OrdersModule` và `OrdersModule` export provider | Cho phép; Nest app khởi động được |
| `billing` import `orders/persistence/orders.repository.ts` | Báo lỗi ranh giới dù đường dẫn là alias hay tương đối |
| `common/` import `modules/orders/` | Báo lỗi phụ thuộc ngược |
| `orders` import `billing` và `billing` import `orders` | Báo vòng phụ thuộc |
| Bỏ `exports: [OrdersService]` khỏi `OrdersModule` nhưng vẫn inject ở `BillingModule` | Test khởi động Nest báo lỗi DI |

Một luật chỉ được ghi là "kiểm tự động" khi có cấu hình, fixture sai bị bắt và lệnh chạy trong CI. Nếu chưa có, ghi "review" và việc bổ sung kiểm ở [kế hoạch](../plan/tasks.md). Build và smoke phải chạy **file entrypoint thực của bản build**; không mặc định mọi cấu hình Nest đều sinh `dist/main.js`.

## 12. Khi nào điều chỉnh mẫu

- Ứng dụng rất nhỏ có thể bắt đầu với `AppModule` và một feature; giữ tên file và trách nhiệm ở mục 5, thêm `modules/` khi feature thứ hai xuất hiện.
- Dự án nhiều app/process hoặc microservice cần ghi ranh giới deployment và ownership trong [Kiến trúc](../architecture/ARCHITECTURE.md), rồi điều chỉnh cây ở mục 3.
- Thư viện TypeScript thuần, renderer không dùng Nest DI hoặc SDK không phải server NestJS có cây riêng; không ép thành `@Module()`.
- Cấu trúc khác (ví dụ phân tầng domain/application/infrastructure trên toàn repo) cần ADR và luật phụ thuộc tương ứng.

## 13. Câu hỏi cần điền trước khi áp dụng

- [CẦN XÁC NHẬN: ứng dụng NestJS nằm ở đâu và có những điểm vào nào?]
- [CẦN XÁC NHẬN: Node/Nest/HTTP adapter và phiên bản package tương thích nào?]
- [CẦN XÁC NHẬN: ứng dụng có API không; nếu có, ai sở hữu hợp đồng và backend kiểm lệch bằng lệnh nào?]
- [CẦN XÁC NHẬN: DB, migration và ranh giới transaction dùng cách nào?]
- [CẦN XÁC NHẬN: luật B1–B2 được kiểm bằng công cụ nào trong CI?]
- [CẦN XÁC NHẬN: auth, phân quyền theo đối tượng, CORS/CSRF và chính sách lỗi do module nào sở hữu?]
- [CẦN XÁC NHẬN: ai phát security headers; rate limit dùng khóa, kho đếm và ngưỡng nào?]
- [CẦN XÁC NHẬN: logger nào, schema log, tên header request ID và ID tương quan nào; kiểm redaction bằng lệnh nào?]
- [CẦN XÁC NHẬN: liveness/readiness, cách drain và timeout shutdown nào phù hợp triển khai?]

## 14. Điều kiện áp dụng xong

- [ ] Đã ghi ADR cho ranh giới module, điểm vào, nguồn hợp đồng API và ngoại lệ của mẫu.
- [ ] Đã thay cây ví dụ bằng feature thật; chỉ tạo thư mục có file, không giữ tên `orders`/`billing` của ví dụ.
- [ ] Đã chọn phiên bản tương thích, kiểm env lúc khởi động, ghi lệnh migration/build và thử lỗi cấu hình.
- [ ] Nếu có HTTP: đã dùng cùng cấu hình bootstrap trong e2e; kiểm input, response, auth/phân quyền, security headers, CORS/CSRF và rate limit theo tính năng thực tế.
- [ ] Đã thử log JSON, tương quan request/job và kiểm không rò dữ liệu nhạy cảm; đã chọn liveness/readiness/shutdown theo cách deploy.
- [ ] Đã chứng minh cổng ranh giới module, test và build chạy trong CI; các quyết định còn thiếu được ghi ở [kế hoạch](../plan/tasks.md).

## 15. Nguồn tham chiếu khi áp dụng

Kiểm tài liệu theo **phiên bản NestJS/package thực tế** trước khi chép API hoặc cấu hình; những gợi ý theo phiên bản ở trên được đối chiếu vào 2026-10-03.

| Chủ đề | Tài liệu gốc |
|---|---|
| Starter và công cụ | [NestJS First steps](https://docs.nestjs.com/first-steps), [NestJS TypeScript starter](https://github.com/nestjs/typescript-starter/blob/master/package.json), [Node.js releases](https://nodejs.org/en/about/previous-releases), [dependency-cruiser rules](https://github.com/sverweij/dependency-cruiser/blob/main/doc/rules-reference.md) |
| Module, vòng phụ thuộc, scope | [NestJS Modules](https://docs.nestjs.com/modules), [Circular dependency](https://docs.nestjs.com/fundamentals/circular-dependency), [Injection scopes](https://docs.nestjs.com/fundamentals/injection-scopes) |
| Validation, cấu hình, kiểm thử | [NestJS Validation](https://docs.nestjs.com/techniques/validation), [Configuration](https://docs.nestjs.com/techniques/configuration), [Testing](https://docs.nestjs.com/fundamentals/testing) |
| Bảo mật HTTP | [NestJS Security headers](https://docs.nestjs.com/security/helmet), [Rate limiting](https://docs.nestjs.com/security/rate-limiting), [CORS](https://docs.nestjs.com/security/cors), [CSRF](https://docs.nestjs.com/security/csrf), [OWASP Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html), [Error handling](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html) |
| Log | [NestJS Logger](https://docs.nestjs.com/techniques/logger), [nestjs-pino](https://github.com/iamolegga/nestjs-pino), [pino-http](https://github.com/pinojs/pino-http), [Pino redaction](https://github.com/pinojs/pino/blob/main/docs/redaction.md), [OWASP Logging](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html) |
| Metric và trace | [OpenTelemetry HTTP metrics](https://opentelemetry.io/docs/specs/semconv/http/http-metrics/), [Metric cardinality](https://opentelemetry.io/docs/concepts/signals/metrics/) |
| Vận hành và tác dụng phụ | [NestJS lifecycle](https://docs.nestjs.com/fundamentals/lifecycle-events), [Health checks](https://docs.nestjs.com/recipes/terminus), [Resilience](https://docs.nestjs.com/reliability/resilience), [Idempotency](https://docs.nestjs.com/reliability/idempotency), [OWASP SSRF](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html) |
