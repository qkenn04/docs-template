# Thông tin khởi động

Chọn topic này khi project cần biết tiến trình hoặc bản triển khai nào đang chạy, với cấu hình vận hành chính nào. Quy ước áp dụng cho backend, CMS, frontend, worker và CLI; cách hiển thị phụ thuộc loại ứng dụng.

Topic thêm [mẫu thông tin khởi động](files/docs/ops/startup-information.md) vào `docs/ops/startup-information.md`. Đây là tài liệu để điền theo project, không thêm mã ghi log hay endpoint kiểm tra sức khoẻ.

```bash
docs-template/scripts/new-project-docs.sh --topic observability/startup-information standard ../my-app "My App"
```

Dùng được với mọi profile. Script chỉ thêm file còn thiếu; nếu project đã có file cùng tên, so sánh và cập nhật thủ công.
