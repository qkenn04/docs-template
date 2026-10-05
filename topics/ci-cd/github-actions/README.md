# CI/CD với GitHub Actions

Topic này tạo [mẫu `docs/ops/ci-cd.md`](files/docs/ops/ci-cd.md) để project ghi rõ các bước kiểm tra, build, phát hành và rollback. Nó áp dụng được cho frontend, backend hoặc project khác dùng GitHub Actions.

```bash
docs-template/scripts/new-project-docs.sh --topic ci-cd/github-actions standard ../my-app "My App"
```

Mẫu chưa tạo `.github/workflows/*.yml`: một workflow chạy thật cần lệnh test/build, runner, quyền và môi trường deploy của project. Sau khi điền tài liệu, tạo workflow tương ứng trong project và liên kết từ tài liệu này.
