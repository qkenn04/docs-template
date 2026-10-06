# Quy ước JavaScript và TypeScript

> Trạng thái: Đề xuất · Cập nhật: YYYY-MM-DD

## 1. Mục đích và phạm vi

Tài liệu này chọn các quy tắc về correctness và khả năng đọc từ Airbnb JavaScript Style Guide cùng thực hành TypeScript thông dụng. Đây không phải bộ cấu hình ESLint; project phải chọn compiler, linter và formatter phù hợp với toolchain của mình.

Quy tắc framework-specific thuộc tài liệu riêng, ví dụ React hoặc NestJS. Khi project đã có convention khác được kiểm tra tự động, ghi convention đó tại đây thay vì duy trì hai chuẩn cạnh tranh.

## 2. Khả năng thay đổi và mutation

- Ưu tiên `const`; dùng `let` nếu cần gán lại; không dùng `var`.
- `const` cấm gán lại biến, không làm object hay array bên trong bất biến.
- Không mutate object/array được chia sẻ hoặc nhận từ bên ngoài; tạo giá trị mới để thể hiện cập nhật.
- Mutation cục bộ được phép nếu giá trị được tạo và dùng riêng trong phạm vi hàm, và cách đó dễ đọc hơn.

```ts
const userName = "Khanh";
let retryCount = 0;
retryCount += 1;

const updatedUser = {
  ...user,
  profile: {
    ...user.profile,
    displayName: nextName,
  },
};
```

Lý do: phạm vi `let`/`const` và quyền gán lại dễ nhìn; tránh mutation chia sẻ giảm thay đổi ngầm. Object spread là bản sao nông, nên cập nhật đúng cấp lồng nhau.

## 3. Tên và cấu trúc module

- Tên biến và hàm dùng `camelCase`; class dùng `PascalCase`.
- Tên mô tả vai trò hoặc hành động: `closingDate`, `calculateMonthlyTotal`, `parseUserPayload`.
- Tránh tên mơ hồ như `data2`, `x` ngoài ngữ cảnh ngắn, hoặc `doStuff`.
- Dùng chữ viết tắt phổ biến trong domain một cách nhất quán; nếu không quen thuộc, viết đầy đủ.
- Giữ public API của module nhỏ. Module khác import từ điểm public được chọn, không đi sâu vào file nội bộ.
- Không tạo barrel `index.ts` chỉ theo thói quen nếu nó che cấu trúc, tạo vòng import hoặc làm dependency khó lần theo.

Lý do: tên tốt giảm suy luận cho người đọc; public API rõ giảm coupling khi cấu trúc nội bộ thay đổi. Convention đặt tên file và alias phải theo project/framework và được ghi trong tài liệu kiến trúc của project.

## 4. So sánh và điều kiện

Dùng `===` và `!==`, tránh `==` và `!=` để không dựa vào ép kiểu ngầm. Với chuỗi và số, diễn đạt điều kiện mong muốn một cách rõ ràng.

```ts
if (employeeId === requestedEmployeeId) {
  // ...
}

if (name !== "") {
  // ...
}

if (items.length > 0) {
  // ...
}
```

Boolean có thể được kiểm tra trực tiếp (`if (isValid)`). Với điều kiện nghiệp vụ, tránh dựa vào truthiness nếu `0`, `""` hoặc `null` có ý nghĩa khác nhau.

## 5. Object, destructuring và collections

- Dùng object literal `{}` để tạo object.
- Dùng shorthand khi tên property và biến trùng nhau.
- Destructure khi đọc nhiều thuộc tính và kết quả dễ đọc hơn.
- Chọn `map`/`filter` cho biến đổi đơn giản; dùng vòng lặp khi có nhiều nhánh, early exit hoặc nhiều bước rõ ràng hơn.
- Không dùng `reduce` chỉ để rút ngắn code.

```ts
function getFullName(user: User): string {
  const { firstName, lastName } = user;
  return `${firstName} ${lastName}`;
}

const payload = { userId, displayName };
```

Destructuring là công cụ, không phải luật bắt buộc. `user.profile.name` có thể rõ hơn nếu chỉ đọc một giá trị hoặc ngữ cảnh mất đi khi destructure.

## 6. Hàm, I/O và side effects

- Đặt tên hàm theo kết quả hoặc hành động: `isWithinPeriod`, `parseDate`, `saveClosing`.
- Giữ mỗi hàm tập trung vào một nhiệm vụ có thể tóm tắt rõ.
- Tách phép tính thuần khỏi I/O khi điều đó làm logic dễ test hoặc dễ hiểu hơn.
- Không thêm abstraction chỉ để giảm số dòng; code trực tiếp tốt hơn nếu luồng đơn giản.

```ts
function calculateTotal(order: Order): number {
  return order.items.reduce(
    (total, item) => total + item.price * item.quantity,
    0,
  );
}

async function submitOrder(order: Order): Promise<void> {
  const total = calculateTotal(order);
  await orderRepository.save(order, total);
}
```

Lý do: phép tính thuần dễ kiểm tra; ranh giới I/O rõ giúp mock, xử lý lỗi và quan sát hành vi hệ thống.

## 7. Promise và xử lý lỗi

- `await` hoặc return Promise để lỗi đi tới caller có trách nhiệm xử lý.
- Không để Promise bị bỏ quên. Với tác vụ nền có chủ ý, xử lý rejection và ghi nhận lỗi.
- Không nuốt lỗi trong `catch` rỗng.
- Bắt lỗi ở tầng có đủ ngữ cảnh để chuyển thành phản hồi người dùng, retry, rollback hoặc log.
- Không log token, password, session, dữ liệu cá nhân hoặc payload nhạy cảm.

```ts
try {
  await saveOrder(order);
} catch (error: unknown) {
  reportError(error);
  throw new OrderSaveError("Unable to save order", { cause: error });
}
```

Không bắt rồi throw lại cùng lỗi nếu không bổ sung xử lý hoặc ngữ cảnh hữu ích.

## 8. TypeScript và mức an toàn kiểu

- Project mới bật `"strict": true`; codebase cũ có thể bật theo giai đoạn và ghi ngoại lệ còn lại.
- Tránh `any`; tại ranh giới chưa biết cấu trúc, nhận `unknown` rồi validate hoặc narrow.
- Không dùng `as` hoặc non-null assertion `!` để che lỗi kiểu. Nếu cần, chứng minh invariant ở runtime hoặc giải thích vì sao assertion an toàn.
- Khai báo `null`/`undefined` tường minh khi chúng là trạng thái hợp lệ.
- Dùng discriminated union cho các trạng thái loại trừ nhau; xử lý hết nhánh bằng `switch`.
- Ưu tiên suy luận kiểu cho giá trị hiển nhiên; thêm annotation ở public API, ranh giới module và nơi annotation giúp hợp đồng rõ hơn.

```ts
type LoadResult<T> =
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; message: string };

function renderResult<T>(result: LoadResult<T>): string {
  switch (result.status) {
    case "loading":
      return "Loading";
    case "success":
      return "Loaded";
    case "error":
      return result.message;
  }
}
```

Lý do: `strict` và narrowing phát hiện sớm đường code có thể sai kiểu hoặc thiếu dữ liệu. TypeScript types không xác thực JSON lúc runtime.

## 9. Validate dữ liệu ở runtime

Coi dữ liệu từ API, form, file, `localStorage`, message queue và environment là chưa tin cậy. Type assertion không kiểm tra dữ liệu thật.

```ts
const payload: unknown = await response.json();
const user = userSchema.parse(payload);
```

Dùng schema validator của project hoặc type guard tương đương. Validate tại ranh giới một lần rồi truyền kiểu đã xác thực vào phần lõi. Không lặp cùng validation không cần thiết ở mọi hàm nội bộ.

## 10. Bảo mật cơ bản

- Không hardcode secret hoặc đưa secret vào source, test fixture, log hay ví dụ tài liệu.
- Không dùng `eval` hoặc thực thi code từ input.
- Không render HTML từ input chưa sanitize; dùng text API/framework mặc định khi có thể.
- Validate đầu vào và encode/escape theo đúng ngữ cảnh đầu ra.
- Không coi TypeScript type, form validation phía client hoặc hidden UI là ranh giới bảo mật; xác thực và phân quyền phải được kiểm ở server.

## 11. Comment và format

- Comment giải thích lý do, invariant, giới hạn bên ngoài hoặc workaround; không diễn đạt lại câu lệnh ngay bên dưới.
- Cập nhật hoặc xóa comment khi logic thay đổi.
- Dùng formatter đã chọn của project cho dấu nháy, dấu phẩy, khoảng trắng và xuống dòng.
- Dùng linter cho correctness và quy tắc code; tránh áp đồng thời các rule format xung đột.

```ts
// Ignore responses from older requests; they can arrive after the latest search.
if (requestId !== latestRequestId) return;
```

Không quy định dấu nháy, độ dài dòng hay một kiểu brace toàn cục ở đây; để formatter và project config quyết định.

## 12. Kiểm tra tự động và review

Chọn công cụ và lệnh dựa trên project. Mẫu lệnh thường gặp:

```bash
pnpm format:check
pnpm lint
pnpm typecheck
pnpm test:run
```

Chỉ giữ lệnh thực sự tồn tại. Cổng tối thiểu cho TypeScript nên chạy typecheck riêng; một số linter không thay thế TypeScript compiler. Lint có thể enforce `no-explicit-any`, Promise handling và import boundaries nếu project bật rule tương ứng.

Các mục như tên có rõ không, abstraction có cần thiết không, lỗi có được chuyển đúng tầng không thường cần review. Không tuyên bố máy kiểm một quy tắc nếu chưa có cấu hình và lệnh chạy trong CI.

## 13. Ngoại lệ

Convention có thể được điều chỉnh khi framework/API yêu cầu hoặc quy tắc làm code kém rõ ràng trong trường hợp cụ thể. Với ngoại lệ lặp lại hoặc ảnh hưởng public API, ghi quyết định trong tài liệu/ADR của project và thêm kiểm tra tự động nếu có thể.

## 14. Tham khảo

- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [TypeScript Handbook: The Basics](https://www.typescriptlang.org/docs/handbook/2/basic-types)
- [TypeScript TSConfig: `strict`](https://www.typescriptlang.org/tsconfig/strict)
- [TypeScript: Unions and Intersection Types](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html)
- [typescript-eslint shared configs](https://typescript-eslint.io/users/configs/)
- [Prettier: Integrating with Linters](https://prettier.io/docs/integrating-with-linters.html)
