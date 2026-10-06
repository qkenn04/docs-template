# Frontend Template

Topic này chứa kiến trúc frontend dùng lại cho các project React/TypeScript có state, form, API hoặc routing.

Nó cũng ghi convention React về render purity, immutable props/state, Hooks, state structure, Effects, lists, forms và accessibility. Đây là hướng dẫn cho code ứng dụng React; không thay thế cấu hình lint/test cụ thể của từng project.

Tài liệu chính hỗ trợ hai profile:

- `react-spa`: ứng dụng client-side dùng router runtime.
- `next-app-router`: ứng dụng Next.js dùng file-system routing và Server/Client Components.

Mẫu tài liệu được tạo tại [`files/docs/dev/frontend.md`](files/docs/dev/frontend.md). Khi áp dụng, chọn một profile công nghệ, ghi quyết định vào ADR của project và xoá các phần không sử dụng.

```bash
docs-template/scripts/new-project-docs.sh --topic frontend/react standard ../my-app "My App"
```
