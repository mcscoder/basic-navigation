# Flutter Basic Navigation and Authentication

## 1.BLoC

### 1.1. Khi nào thì dùng `BLoC` ? Khi nào thì dùng `StatefulWidget` ?

- Hãy tự hỏi: "Dữ liệu/trạng thái này có cần thiết ở một nơi nào khác ngoài widget này không? Nó có cần tồn tại sau khi widget này bị hủy và tạo lại không?"

  - Nếu câu trả lời là KHÔNG -> Dùng `StatefulWidget`
  - Nếu câu trả lời là CÓ -> Dùng `BLoC`

### 1.2. Những loại `Widget` hoặc thành phần nào sẽ thường xuyên cần `BLoC`?

1. **Màn hình Đăng nhập/Đăng ký (Authentication Screens)**: Cần gọi API, xử lý loading, thành công, thất bại. Trạng thái đăng nhập cần được chia sẻ toàn ứng dụng.

2. **Màn hình danh sách dữ liệu (Data Listing Screens)**: Ví dụ danh sách sản phẩm, bài viết, tin tức. Cần gọi API để lấy dữ liệu, xử lý trạng thái loading, hiển thị danh sách khi thành công, hoặc thông báo lỗi khi thất bại. Các chức năng như "tải thêm" (load more), "làm mới" (pull-to-refresh) cũng được xử lý trong BLoC.

3. **Giỏ hàng (Shopping Cart)**: Trạng thái giỏ hàng (số lượng sản phẩm, tổng tiền) cần được truy cập từ nhiều nơi: từ trang danh sách sản phẩm, trang chi tiết sản phẩm, và trang giỏ hàng.

4. **Trang hồ sơ cá nhân (Profile Page)**: Cần lấy thông tin người dùng từ API và cho phép họ cập nhật thông tin đó.

5. **Các Form phức tạp**: Form có nhiều bước hoặc cần xác thực dữ liệu với server.

- **Về cơ bản, bất kỳ "tính năng" (feature) hoặc "màn hình" (screen) nào có logic nghiệp vụ và tương tác với dữ liệu thì đều là nơi lý tưởng để áp dụng BLoC**

### 1.3. Những logic thường sẽ dùng `StatefulWidget`

- **UI State (Trạng thái Giao diện)**: Là những trạng thái tạm thời, chỉ phục vụ cho việc hiển thị hoặc tương tác của một widget cụ thể. Nó không phải là dữ liệu "cốt lõi" của ứng dụng.

- **Ví dụ**:

  1. Toggle Button (Ví dụ: Nút hiện/ẩn mật khẩu)

  - **Logic**: Một biến boolean `_isPasswordVisible` để chuyển đổi giữa hai trạng thái.

  - **Câu hỏi cần đặt ra**:

    - Trạng thái `_isPasswordVisible` này có cần được màn hình nào khác biết đến không? -> **Không**.

    - Khi người dùng rời khỏi màn hình đăng nhập, trạng thái này có cần được lưu lại không? -> **Không**.

    - Nó có phải là dữ liệu nghiệp vụ quan trọng không? -> **Không**, nó chỉ là một tiện ích giao diện.
  
  - **Kết luận**: Đây là một **UI State** điển hình. Đặt nó trong một `StatefulWidget` là lựa chọn hoàn hảo và đơn giản nhất. Dùng BLoC cho việc này sẽ là "dùng dao mổ trâu để giết gà", làm code phức tạp không cần thiết.

### 1.4. `BlocBuilder` vs `BlocListener`

| Đặc điểm                       | `BlocBuilder`                                   | `BlocListener`                                            |
| ------------------------------ | ----------------------------------------------- | --------------------------------------------------------- |
| **Dùng để làm gì?**            | Dùng để **build lại UI** khi state thay đổi     | Dùng để **xử lý side effects** (SnackBar, Navigation,...) |
| **Gọi lại (trigger rebuild)?** | Khi `state` thay đổi                            | Khi `state` thay đổi (nhưng không rebuild gì cả)          |
| **Dùng để làm UI?**            | ✅ Có – thường nằm trong cây widget              | ❌ Không – không hiển thị gì, chỉ thực hiện hành động      |
| **Ví dụ thường dùng**          | Hiện loading, ẩn nút, đổi màu, build widget mới | Hiện thông báo, điều hướng, log sự kiện,...               |

### 1.5. `BlocProvider`

- `BlocProvider` là widget có nhiệm vụ:

  - Khởi tạo BLoC (hoặc nhận một BLoC có sẵn)

  - Cung cấp BLoC cho các widget con thông qua context

  - Gọi `context.read<YourBloc>()` hoặc `context.watch<YourBloc>()` ở các widget con bên dưới

- **Cách dùng**

  **Cách 1: Tự khởi tạo (dùng `create`)**

  ```dart
  BlocProvider(
    create: (context) => getIt<AppBloc>(),
    child: AppPage(),
  );
  ```

  - Khi đó, `AppPage` và tất cả các widget bên dưới có thể truy cập `AppBloc` qua `context.read<AppBloc>()`.

  **Cách 2: Cung cấp BLoC có sẵn (dùng `value`)**

  ```dart
  BlocProvider.value(
    value: getIt<AppBloc>(),
    child: AppPage(),
  );
  ```

  - Thường dùng khi đã có 1 instance (đã được tạo trước đó) và không muốn tạo mới. Ví dụ ở đây `AppBloc` là một singleton.

#### Tóm tắt

| `BlocProvider` làm gì?                           |
| ------------------------------------------------ |
| Tạo và cung cấp một BLoC xuống cây widget        |
| Cho phép các widget con sử dụng `context.read()` |
| Quản lý vòng đời của BLoC (auto `close()`)       |

### 1.6. `BlocProvider(create: ...)` vs `BlocProvider.value()`

| Tiêu chí                               | `BlocProvider(create: ...)`                    | `BlocProvider.value(...)`                         |
| -------------------------------------- | ---------------------------------------------- | ------------------------------------------------- |
| **Tạo mới BLoC?**                      | ✅ Có – BLoC được khởi tạo tại đây              | ❌ Không – dùng instance BLoC có sẵn               |
| **Tự động dispose khi không cần nữa?** | ✅ Có – gọi `bloc.close()` khi widget bị remove | ❌ Không – bạn phải tự quản lý (cẩn thận bị leak)  |
| **Dùng khi nào?**                      | Dùng để tạo và cung cấp BLoC mới               | Dùng khi đã có sẵn BLoC (đã được tạo ở chỗ khác)  |
| **Tình huống thích hợp**               | Gần như luôn dùng trong UI page/screen mới     | Dùng để chia sẻ BLoC giữa các màn hình/widget con |

#### `BlocProvider(create: ...)`

```dart
BlocProvider(
  create: (context) => getIt<AppBloc>(),
  child: AppPage(),
);
```

- Flutter sẽ:

  - Gọi hàm `create` đúng 1 lần

  - Gọi `bloc.close()` khi `BlocProvider` bị gỡ khỏi cây

- 👉 Dễ dùng, an toàn, nên dùng trong hầu hết các trường hợp

#### `BlocProvider.value(...)`

```dart
BlocProvider.value(
  value: getIt<AppBloc>(),
  child: AppPage(),
);
```

- Flutter không quản lý vòng đời của BLoC này

- Nếu không tự `close()`, BLoC sẽ không bị giải phóng, gây memory leak

- 👉 Thường dùng:

  - Khi **đã tạo BLoC từ trước** (ví dụ từ DI như `getIt`, khi này `getIt` sẽ quản lý vòng đời (life cycle) chứ không phải là BLoC nữa)

  - Khi **di chuyển BLoC giữa các widget**, như trong `ListView.builder`, `Navigator.push`, v.v.

#### Cảnh báo sai phổ biến

- Nếu dùng `BlocProvider.value()` như sau mà không cẩn thận:

```dart
BlocProvider.value(
  value: AppBloc(), // tạo mới ở đây luôn
  child: AppPage(),
)
```

- **SAI nghiêm trọng**: `AppBloc` sẽ không được dispose → gây leak, bug khó tìm.

- **Nguyên nhân**: Do không có cái gì reference tới nên cũng không dispose được, bình thường nếu dùng `getIt` thì `getIt` sẽ quản lý nó và có một reference (tham chiếu) tới chính cái BLoC đó để có thể kích hoạt dispose.

#### Tóm lại

| Nếu...                                                 | Nên dùng gì?                         |
| ------------------------------------------------------ | ------------------------------------ |
| Tạo mới BLoC tại chỗ và muốn Flutter quản lý lifecycle | `BlocProvider(create: ...)` ✅        |
| Đã có sẵn BLoC (qua DI hoặc chia sẻ BLoC)              | `BlocProvider.value(...)` ✅          |
| Không chắc cái nào nên dùng                            | **Dùng `create:` là an toàn nhất** ✅ |
