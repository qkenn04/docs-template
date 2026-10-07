# Định dạng code với Prettier

> Trạng thái: Đề xuất · Cập nhật: YYYY-MM-DD

## Thiết lập

Cài Prettier trong từng project và khóa phiên bản chính xác. Sau khi cài, commit cả `package.json` lẫn lockfile để editor và CI dùng cùng phiên bản.

```bash
npm install --save-dev --save-exact prettier
```

Thêm các script sau vào mục `scripts` của `package.json`:

```json
{
  "format": "prettier --write .",
  "format:check": "prettier --check ."
}
```

Chạy `npm run format` khi cần định dạng; chạy `npm run format:check` trong CI. Với repo đã có nhiều file, có thể giới hạn lệnh vào các thư mục mã nguồn trước khi định dạng toàn repo. Thay đổi định dạng lớn nên được review riêng để dễ nhìn thấy thay đổi logic.

Editor cần dùng bản Prettier đã cài trong project. Nếu bật format khi lưu, chọn Prettier làm formatter cho các loại file liên quan. Tránh để một formatter khác cùng sửa file theo quy tắc trái với `.prettierrc.json`.

## Quy ước trong cấu hình

`printWidth: 80` là mục tiêu xuống dòng gần đúng, không phải giới hạn cứng. Cấu hình dùng 2 dấu cách, dấu nháy kép trong JavaScript, dấu chấm phẩy, dấu phẩy cuối danh sách đa dòng và ngoặc cho tham số arrow function. `endOfLine: "lf"` thống nhất line ending giữa các hệ điều hành; lần đầu áp dụng có thể làm thay đổi nhiều dòng trong file CRLF.

Các giá trị này chủ yếu là mặc định của Prettier 3, được ghi rõ để project mới có cùng quy ước. Prettier không sắp xếp import. Giữ quy tắc về chất lượng code trong ESLint; nếu ESLint có quy tắc định dạng xung đột, cân nhắc `eslint-config-prettier` theo cấu hình ESLint đang dùng.

`.prettierignore` bỏ qua output build và coverage. Prettier cũng đọc `.gitignore` tại thư mục chạy lệnh. Bổ sung đường dẫn được tạo tự động riêng của project vào một trong hai file nếu cần.

## Tuỳ chọn cho Tailwind CSS

Project dùng Tailwind và muốn tự sắp xếp class có thể cài `prettier-plugin-tailwindcss` riêng. Với Tailwind CSS v4, làm theo hướng dẫn của plugin để khai báo `tailwindStylesheet` trỏ tới file CSS đầu vào thực tế. Nếu class nằm trong `clsx`, `cn` hoặc hàm tương tự, cấu hình thêm `tailwindFunctions` theo API của plugin. Không thêm plugin vào cấu hình chung vì các project khác có thể không dùng Tailwind.

Nguồn tham khảo: [cài đặt Prettier](https://prettier.io/docs/install), [các tuỳ chọn](https://prettier.io/docs/options), [bỏ qua file](https://prettier.io/docs/ignore), [plugin Tailwind](https://github.com/tailwindlabs/prettier-plugin-tailwindcss#readme).
