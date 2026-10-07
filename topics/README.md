# Topic chọn thêm

> Trạng thái: Đang áp dụng · Cập nhật: 2026-10-07 · Liên quan: [README](../README.md), [CI/CD](ci-cd/delivery/README.md)

Profile quyết định số tài liệu chung. Topic thêm tài liệu cho công nghệ hoặc công việc cụ thể. Mỗi topic có `files.txt` liệt kê đường dẫn **trong project đích**; file nguồn nằm dưới `files/` với cùng đường dẫn. Topic React và NestJS cần profile `standard` hoặc `full` vì mẫu liên kết tới tài liệu chung; CI/CD dùng với mọi profile.

| Topic | Thêm gì | Dùng khi |
|---|---|---|
| [git/conventional-commits](git/conventional-commits/README.md) | `docs/dev/commit-conventions.md` | Muốn commit history nhất quán; mọi profile |
| [javascript/airbnb](javascript/airbnb/README.md) | `docs/dev/javascript-conventions.md` | Project JavaScript/TypeScript cần quy ước chung chọn lọc; mọi profile |
| [frontend/react](frontend/react/README.md) | `docs/dev/frontend.md` | Ứng dụng React có state và gọi API; `standard`/`full` |
| [backend/nestjs](backend/nestjs/README.md) | `docs/dev/backend-nestjs.md` | Back-end NestJS; `standard`/`full` |
| [observability/startup-information](observability/startup-information/README.md) | `docs/ops/startup-information.md` | Quy ước thông tin khởi động hoặc bản triển khai; mọi profile, nhiều loại ứng dụng |
| [ci-cd/delivery](ci-cd/delivery/README.md) | Core policy và các mẫu adapter CI provider/runtime để chọn và điền | Cần tài liệu cho đường release của dự án |

```bash
docs-template/scripts/new-project-docs.sh --topic backend/nestjs --topic ci-cd/delivery --topic git/conventional-commits --topic javascript/airbnb standard ../my-app "My App"
```

Script chỉ thêm file còn thiếu. Chạy lại cùng profile với topic mới cũng được; file cũ được giữ nguyên. `full` đã gồm `docs/dev/frontend.md`, nên chọn thêm `frontend/react` sẽ không tạo file trùng. Topic CI/CD là **mẫu tài liệu**, chưa tạo workflow có thể chạy vì lệnh build, test và deploy phải lấy từ project thực tế.

Khi thêm topic: tạo `README.md`, `files.txt`, và file nguồn dưới `files/`; thêm một bài kiểm tra trong `scripts/test-profiles.sh`. Giữ nguyên đường dẫn file ở project đích nếu chỉ sắp xếp lại bộ khuôn này.
