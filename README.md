# Hướng dẫn chạy dự án Flutter

## Cập nhật dependencies

Trước khi chạy dự án, bạn có thể kiểm tra và cập nhật các gói thư viện:

```sh
flutter pub outdated  # Kiểm tra các gói đã lỗi thời
flutter pub upgrade   # Nâng cấp các gói lên phiên bản mới nhất
```

## Chạy ứng dụng

Sau khi đã cập nhật các gói cần thiết, chạy ứng dụng bằng lệnh:

```sh
flutter run
```

Nếu muốn chạy trên một thiết bị cụ thể, sử dụng:

```sh
flutter devices  # Kiểm tra danh sách thiết bị
flutter run -d <device_id>  # Chạy trên thiết bị chỉ định
```

## Các lệnh hữu ích khác

- **Dọn dẹp project Flutter:**
  ```sh
  flutter clean
  ```
- **Cài đặt lại dependencies:**
  ```sh
  flutter pub get
  ```
- **Kiểm tra môi trường Flutter:**
  ```sh
  flutter doctor
  
