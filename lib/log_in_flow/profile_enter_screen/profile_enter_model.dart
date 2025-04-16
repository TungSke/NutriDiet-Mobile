import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/systemconfiguration_service.dart';

class ProfileEnterModel {
  final UserService _userService = UserService();
  final SystemConfigurationService _systemConfigService = SystemConfigurationService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DateTime? birthDate;
  String gender = "Male";
  String avatar = "";
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();

  double? minAge;
  double? maxAge;

  Future<void> init(BuildContext context) async {
    try {
      // Gọi API lấy cấu hình theo ID (configId = 1 cho UserAge)
      final response = await _systemConfigService.getSystemConfigById(1);

      // Lấy dữ liệu từ response
      final userAgeConfig = response['data'];

      if (userAgeConfig != null) {
        minAge = userAgeConfig['minValue']?.toDouble();
        maxAge = userAgeConfig['maxValue']?.toDouble();
      }

      if (minAge == null || maxAge == null) {
        // Sử dụng giá trị mặc định nếu không lấy được cấu hình
        minAge = 13;
        maxAge = 100;
        debugPrint("Cấu hình null, sử dụng giá trị mặc định (13-100).");
      }
    } catch (e) {
      // Xử lý lỗi khi gọi API
      minAge = 13;
      maxAge = 100;
      debugPrint("Lỗi khi lấy cấu hình tuổi: $e. Sử dụng giá trị mặc định (13-100).");
      _showErrorDialog(context, "Sử dụng giá trị mặc định tuổi cho phép (13-100).");
    }
  }
  
  Future<void> updateUserProfile(BuildContext context) async {
    if (fullNameController.text.isEmpty || birthDate == null) {
      _showErrorDialog(context, "Vui lòng nhập đầy đủ thông tin cá nhân.");
      return;
    }

    final int age = DateTime.now().year - birthDate!.year;
    if (age < minAge! || age > maxAge!) {
      _showErrorDialog(context, "Tuổi của bạn phải từ ${minAge!.toInt()} đến ${maxAge!.toInt()}");
      return;
    }

    try {
      final String fullName = fullNameController.text.trim();
      final String location = locationController.text.trim();
      final int age = DateTime.now().year - birthDate!.year;

      final response = await _userService.updateUser(
        fullName: fullName,
        age: age,
        gender: gender,
        location: location,
        avatar: avatar,
      );

      // Kiểm tra lại mã trạng thái phản hồi để đảm bảo cập nhật thành công
      if (response.statusCode == 200) {
        print('✅ Cập nhật thành công!'); // Thêm thông báo debug
        context.push("/hightEnterScreen");
      } else {
        print('❌ Cập nhật không thành công. Mã lỗi: ${response.statusCode}');
        _showErrorDialog(
            context, "Cập nhật thông tin thất bại, vui lòng thử lại.");
      }
    } catch (e) {
      print('❌ Đã xảy ra lỗi: $e'); // Thêm thông báo debug
      _showErrorDialog(context, "Đã xảy ra lỗi: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  void dispose() {
    fullNameController.dispose();
    locationController.dispose();
  }
}
