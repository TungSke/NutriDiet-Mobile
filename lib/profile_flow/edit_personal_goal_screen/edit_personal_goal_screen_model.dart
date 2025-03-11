import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class EditPersonalGoalScreenModel extends ChangeNotifier {
  final Map<String, int> _weightChangeRateMap = {
    'Giữ cân': 0,
    'Tăng 0.25kg/1 tuần': 250,
    'Tăng 0.5kg/1 tuần': 500,
    'Giảm 0.25Kg/1 tuần': -250,
    'Giảm 0.5Kg/1 tuần': -500,
    'Giảm 0.75Kg/1 tuần': -750,
    'Giảm 1Kg/1 tuần': -1000,
  };

  // Mảng ánh xạ giá trị số về giá trị mô tả
  final Map<int, String> _reverseWeightChangeRateMap = {
    0: 'Giữ cân',
    250: 'Tăng 0.25kg/1 tuần',
    500: 'Tăng 0.5kg/1 tuần',
    -250: 'Giảm 0.25Kg/1 tuần',
    -500: 'Giảm 0.5Kg/1 tuần',
    -750: 'Giảm 0.75Kg/1 tuần',
    -1000: 'Giảm 1Kg/1 tuần',
  };

  // Mảng ánh xạ goalType từ tiếng Anh sang tiếng Việt
  final Map<String, String> _goalTypeMap = {
    'LoseWeight': 'Giảm cân',
    'Maintain': 'Giữ cân',
    'GainWeight': 'Tăng cân',
  };

  // Mảng ánh xạ từ tiếng Việt sang tiếng Anh
  final Map<String, String> _reverseGoalTypeMap = {
    'Giảm cân': 'LoseWeight',
    'Giữ cân': 'Maintain',
    'Tăng cân': 'GainWeight',
  };

  String goalType = ''; // Mục tiêu
  int targetWeight = 0; // Cân nặng mục tiêu
  String weightChangeRate = ''; // Mức độ thay đổi cân nặng

  bool isLoading = true;
  int currentWeight = 0; // Biến lưu trữ cân nặng hiện tại

  // Lấy dữ liệu mục tiêu cá nhân từ API
// Lấy dữ liệu mục tiêu cá nhân từ API
  // Lấy dữ liệu mục tiêu cá nhân từ API
  Future<void> fetchPersonalGoal() async {
    try {
      // Fetch health profile first to get the current weight
      final healthProfileResponse = await UserService().getHealthProfile();

      if (healthProfileResponse.statusCode == 200) {
        final healthProfileData = jsonDecode(healthProfileResponse.body);
        currentWeight = healthProfileData['data']['weight'] != null
            ? int.parse(healthProfileData['data']['weight'].toString())
            : 0; // Get weight from health profile

        // Print current weight to the console
        print("Current Weight: $currentWeight");
      } else {
        print("❌ Lỗi khi lấy health profile: ${healthProfileResponse.body}");
        currentWeight = 70; // Default weight in case of error
      }

      // Now fetch the personal goal
      final response = await UserService().getPersonalGoal();
      if (response.statusCode == 200) {
        final personalData = jsonDecode(response.body);
        goalType =
            _goalTypeMap[personalData['data']['goalType']] ?? "Chưa cập nhật";
        targetWeight =
            personalData['data']['targetWeight'] ?? 70; // Set target weight

        // Ánh xạ từ giá trị số về giá trị mô tả
        weightChangeRate = _reverseWeightChangeRateMap[personalData['data']
                ['weightChangeRate']] ??
            "Chưa cập nhật";

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
    }
  }

  // Cập nhật mục tiêu cá nhân
  Future<void> updatePersonalGoal(BuildContext context) async {
    try {
      // Khi chọn mục tiêu "Giữ cân", sử dụng cân nặng hiện tại
      if (goalType == 'Giữ cân') {
        targetWeight = currentWeight; // Gửi cân nặng hiện tại
        weightChangeRate = 'Giữ cân';
      }

      final weightChangeRateNumber =
          _weightChangeRateMap[weightChangeRate] ?? 0;
      final goalTypeInEnglish = _reverseGoalTypeMap[goalType] ?? 'LoseWeight';

      final response = await UserService().updatePersonalGoal(
        goalType: goalTypeInEnglish,
        targetWeight: targetWeight ?? 0,
        weightChangeRate: weightChangeRateNumber.toString(),
        context: context,
      );

      if (response.statusCode == 200) {
        print('✅ Update successful!');
        await fetchPersonalGoal();
        Navigator.pop(context, true);
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage =
            responseData['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại';

        print("❌ Error from API: $errorMessage");
      }
    } catch (e) {
      print("❌ Exception caught: $e");
    }
  }
}
