import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class EditHealthProfileScreenModel extends ChangeNotifier {
  // Mảng ánh xạ các giá trị mô tả tới giá trị số cho activityLevel
  final Map<String, String> _activityLevelMap = {
    'Ít vận động': 'Sedentary',
    'Vận động nhẹ': 'LightlyActive',
    'Vận động vừa phải': 'ModeratelyActive',
    'Vận động nhiều': 'VeryActive',
    'Cường độ rất cao': 'ExtraActive',
  };

  // Mảng ánh xạ giá trị số về giá trị mô tả
  final Map<String, String> _reverseActivityLevelMap = {
    'Sedentary': 'Ít vận động',
    'LightlyActive': 'Vận động nhẹ',
    'ModeratelyActive': 'Vận động vừa phải',
    'VeryActive': 'Vận động nhiều',
    'ExtraActive': 'Cường độ rất cao',
  };

  int height = 0; // Chiều cao
  int weight = 0; // Cân nặng
  String activityLevel = ''; // Mức độ vận động

  bool isLoading = true;

  // Lấy dữ liệu sức khỏe từ API
  Future<void> fetchHealthProfile() async {
    try {
      final response = await UserService().getHealthProfile();

      if (response.statusCode == 200) {
        final healthData = jsonDecode(response.body);

        // Parse height and weight as integers
        height = healthData['data']['height'] != null
            ? int.parse(healthData['data']['height'].toString())
            : 0;
        weight = healthData['data']['weight'] != null
            ? int.parse(healthData['data']['weight'].toString())
            : 0;

        // Ánh xạ từ giá trị số về giá trị mô tả cho activityLevel
        activityLevel =
            _reverseActivityLevelMap[healthData['data']['activityLevel']] ??
                "Chưa cập nhật";

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
    }
  }

  // Cập nhật hồ sơ sức khỏe
  Future<void> updateHealthProfile(BuildContext context) async {
    try {
      // Lấy giá trị activityLevel đã ánh xạ
      final activityLevelInEnglish =
          _activityLevelMap[activityLevel] ?? 'Sedentary'; // Default value

      final response = await UserService().updateHealthProfile(
        activityLevel:
            activityLevelInEnglish, // Gửi giá trị activityLevel đã ánh xạ
        weight: weight, // Cân nặng đã là kiểu int
        height: height, // Chiều cao đã là kiểu int
      );

      if (response.statusCode == 200) {
        print('✅ Cập nhật thành công!');
        await fetchHealthProfile(); // Fetch dữ liệu mới sau khi cập nhật
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cập nhật thành công!"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      } else if (response.statusCode == 400) {
        // Xử lý lỗi 400 và hiển thị thông báo lỗi
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'] ?? 'Cập nhật thất bại';

        // In thông báo lỗi vào console
        print('❌ Lỗi: $errorMessage');

        // Hiển thị thông báo lỗi trong SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Xử lý lỗi khác
        print('❌ Lỗi không xác định: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Xử lý ngoại lệ và hiển thị lỗi
      print("❌ Lỗi khi cập nhật hồ sơ sức khỏe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã xảy ra lỗi, vui lòng thử lại."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
