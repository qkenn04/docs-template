# Conventional Commits

Chọn topic này nếu project muốn commit message nhất quán, dễ đọc và có thể dùng để tạo changelog hoặc hỗ trợ release.

Nó thêm [mẫu quy ước commit](files/docs/dev/commit-conventions.md) vào `docs/dev/commit-conventions.md`. Topic chỉ thêm tài liệu; không cài commit hook hay ép Git tự chặn commit.

```bash
docs-template/scripts/new-project-docs.sh --topic git/conventional-commits standard ../my-app "My App"
```

Nếu project chưa có `docs/dev/`, generator sẽ tạo thư mục đó. File đã tồn tại được giữ nguyên; so sánh và cập nhật thủ công nếu muốn nhận bản mẫu mới.
