# Prettier cho project JavaScript và TypeScript

> Trạng thái: Đang áp dụng · Cập nhật: 2026-10-07 · Liên quan: [Topic](../../README.md), [Hướng dẫn áp dụng](files/docs/dev/formatting.md)

Topic này thêm ba file vào project đích:

| File | Mục đích |
|---|---|
| `.prettierrc.json` | Quy ước định dạng chung, tương thích Prettier 3 |
| `.prettierignore` | Bỏ qua thư mục được tạo ra khi build hoặc chạy test |
| `docs/dev/formatting.md` | Cách cài, chạy trong editor và CI, và xử lý project đã có code |

```bash
docs-template/scripts/new-project-docs.sh --topic javascript/prettier minimal ../my-app "My App"
```

Topic dùng được với mọi profile. Script chỉ chép file còn thiếu; nếu project đã có cấu hình Prettier, file đó được giữ nguyên để bạn so sánh và quyết định có đổi hay không. Script không sửa `package.json` hoặc workflow CI. Làm các bước cài đặt trong [hướng dẫn](files/docs/dev/formatting.md) sau khi thêm topic.

Cấu hình chỉ ghi các lựa chọn cơ bản để tạo một chuẩn dễ nhận biết giữa các project. Các giá trị này trùng mặc định của Prettier 3; `endOfLine: "lf"` được ghi rõ để nhấn mạnh quy ước line ending. Các plugin theo framework, như sắp xếp class Tailwind, được chọn riêng cho từng project.
