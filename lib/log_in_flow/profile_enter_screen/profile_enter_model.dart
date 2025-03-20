import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileEnterModel {
  final UserService _userService = UserService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DateTime? birthDate;
  String gender = "Male";
  String avatar = "";
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();

  Future<void> updateUserProfile(BuildContext context) async {
    if (fullNameController.text.isEmpty || birthDate == null) {
      _showErrorDialog(context, "Vui lòng nhập đầy đủ thông tin cá nhân.");
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
