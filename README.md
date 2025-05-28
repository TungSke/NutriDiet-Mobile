Dưới đây là mẫu nội dung chuyên nghiệp và đầy đủ cho file `README.md` dành cho **NutriDiet - Mobile**, một ứng dụng Flutter hỗ trợ quản lý dinh dưỡng và sức khỏe cá nhân:

---

# NutriDiet - Mobile 📱🥗

NutriDiet là một ứng dụng di động được phát triển bằng Flutter, tích hợp với nền tảng **Health Connect** của Android và sử dụng trí tuệ nhân tạo để đề xuất thực đơn theo sức khỏe, khẩu vị, dị ứng, và mục tiêu cá nhân. Ứng dụng là một phần của hệ sinh thái NutriDiet bao gồm cả nền tảng web và cơ sở dữ liệu backend mạnh mẽ.

---

## 🚀 Tính năng nổi bật

- 🔎 **Tìm kiếm & Quản lý thực phẩm**: Lọc theo thành phần, bệnh lý, hoặc dị ứng.
- 🧠 **Đề xuất bữa ăn thông minh**: AI gợi ý thực đơn theo hồ sơ sức khỏe, mục tiêu cá nhân.
- 🚫 **Từ chối thực đơn**: Cho phép người dùng báo lý do từ chối món và cập nhật dữ liệu AI.
- 👣 **Đếm bước chân**: Ghi lại bước đi hàng ngày từ Pedometer hoặc Health Connect.
- 🔥 **Theo dõi calories & sức khỏe**: Ghi calorie tiêu thụ và hoạt động thể chất tự động.
- 🔔 **Nhắc nhở & Thông báo**: Gợi ý giờ ăn, cảnh báo thiếu hụt dinh dưỡng.
- 🌐 **Đồng bộ & Lưu trữ**: Đồng bộ dữ liệu với server để đảm bảo không mất dữ liệu.

---

## 🏗️ Kiến trúc chính

- **Flutter**: Giao diện người dùng đa nền tảng.
- **Provider / Riverpod**: State management (tuỳ chọn theo project).
- **Health Connect SDK**: Tương tác với dữ liệu sức khỏe Android.
- **Pedometer Plugin**: Ghi dữ liệu bước chân theo thời gian thực.
- **RESTful API**: Kết nối với hệ thống backend (ASP.NET Web API).
- **SQLServer / SharedPreferences**: Lưu dữ liệu tạm thời hoặc cục bộ.

---

## 📲 Hướng dẫn cài đặt

### 1. Yêu cầu hệ thống

- Flutter >= 3.10
- Dart >= 3.0
- Android SDK >= 30
- Health Connect (đã cài đặt trên thiết bị)

### 2. Cài đặt dự án

```bash
https://github.com/TungSke/NutriDiet-Mobile.git
cd nutridiet-mobile
flutter pub get
````

### 3. Chạy ứng dụng

```bash
flutter run
```

> 💡 Đảm bảo bạn đã cấp quyền truy cập Health Connect và bật cảm biến bước chân.

---

## 🔐 Phân quyền & Quyền truy cập

Ứng dụng yêu cầu các quyền sau:

* `ACTIVITY_RECOGNITION`: để ghi lại bước chân.
* `BODY_SENSORS`: để truy cập dữ liệu sức khỏe.
* `INTERNET`: để giao tiếp với server AI.
* `READ_HEALTH_DATA`, `WRITE_HEALTH_DATA`: dùng với Health Connect.

---

## 📁 Cấu trúc thư mục

```plaintext
lib/
├── main.dart
├── models/           # Các model dữ liệu
├── services/         # Health, AI, API, Local DB...
├── screens/          # Giao diện người dùng
├── components/       # Widget tái sử dụng
├── app_state.dart/   # State management
```

---

## 🤖 AI Đề xuất bữa ăn

Ứng dụng sẽ gửi hồ sơ sức khỏe và khẩu vị lên server Gemini AI, nhận lại thực đơn phù hợp, đồng thời ghi nhận phản hồi từ người dùng để cải thiện gợi ý về sau.

---

## 📜 Giấy phép

NutriDiet - Mobile được phát hành dưới giấy phép [MIT](LICENSE).

---
> Hãy cùng nhau xây dựng một hệ sinh thái chăm sóc sức khỏe cá nhân thông minh và toàn diện!
