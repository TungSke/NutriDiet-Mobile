import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diet_plan_app/services/user_service.dart';

class ProfileEnterModel {
  final UserService _userService = UserService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DateTime? birthDate;
  String gender = "Male";

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
      );

      if (response.statusCode == 200) {
        context.push("/hightEnterScreen");
      } else {
        _showErrorDialog(context, "Cập nhật thông tin thất bại, vui lòng thử lại.");
      }
    } catch (e) {
      _showErrorDialog(context, "Đã xảy ra lỗi: \$e");
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
