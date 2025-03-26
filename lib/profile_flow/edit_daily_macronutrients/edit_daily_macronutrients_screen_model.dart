// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// import '../../services/user_service.dart';
//
// class EditPersonalGoalScreenModel extends ChangeNotifier {
//   final _userService = UserService();
//   String name = '';
//   String age = '';
//   String phoneNumber = '';
//   String location = '';
//   String email = '';
//
//   int height = 0; // Chiều cao
//   int weight = 0; // Cân nặng
//   String activityLevel = ''; // Mức độ vận động
//
//   bool isLoading = true;
//
//   String userId = '';
//
//   String errorMessage = "";
//
//   final Map<String, int> _weightChangeRateMap = {
//     'Giữ cân': 0,
//     'Tăng 0.25kg/1 tuần': 250,
//     'Tăng 0.5kg/1 tuần': 500,
//     'Giảm 0.25Kg/1 tuần': -250,
//     'Giảm 0.5Kg/1 tuần': -500,
//     'Giảm 0.75Kg/1 tuần': -750,
//     'Giảm 1Kg/1 tuần': -1000,
//   };
//
//   // Mảng ánh xạ giá trị số về giá trị mô tả
//   final Map<int, String> _reverseWeightChangeRateMap = {
//     0: 'Giữ cân',
//     250: 'Tăng 0.25kg/1 tuần',
//     500: 'Tăng 0.5kg/1 tuần',
//     -250: 'Giảm 0.25Kg/1 tuần',
//     -500: 'Giảm 0.5Kg/1 tuần',
//     -750: 'Giảm 0.75Kg/1 tuần',
//     -1000: 'Giảm 1Kg/1 tuần',
//   };
//
//   // Mảng ánh xạ goalType từ tiếng Anh sang tiếng Việt
//   final Map<String, String> _goalTypeMap = {
//     'LoseWeight': 'Giảm cân',
//     'Maintain': 'Giữ cân',
//     'GainWeight': 'Tăng cân',
//   };
//
//   // Mảng ánh xạ từ tiếng Việt sang tiếng Anh
//   final Map<String, String> _reverseGoalTypeMap = {
//     'Giảm cân': 'LoseWeight',
//     'Giữ cân': 'Maintain',
//     'Tăng cân': 'GainWeight',
//   };
//
//   String goalType = ''; // Mục tiêu
//   int targetWeight = 0; // Cân nặng mục tiêu
//   String weightChangeRate = ''; // Mức độ thay đổi cân nặng
//
//   int currentWeight = 0; // Biến lưu trữ cân nặng hiện tại
//
//   // Lấy dữ liệu mục tiêu cá nhân từ API
// // Lấy dữ liệu mục tiêu cá nhân từ API
//   // Lấy dữ liệu mục tiêu cá nhân từ API
//   Future<void> fetchHealthProfile() async {
//     try {
//       final response = await UserService().getHealthProfile();
//
//       if (response.statusCode == 200) {
//         final healthData = jsonDecode(response.body);
//
//         // Parse height and weight as integers
//         height = healthData['data']['height'] != null
//             ? int.parse(healthData['data']['height'].toString())
//             : 0;
//         weight = healthData['data']['weight'] != null
//             ? int.parse(healthData['data']['weight'].toString())
//             : 0;
//
//         // Ánh xạ từ giá trị số về giá trị mô tả cho activityLevel
//
//         isLoading = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
//     }
//   }
//
//   Future<void> fetchUserProfile() async {
//     try {
//       final response = await UserService().whoAmI();
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         name = data['name'] ?? "Chưa cập nhật";
//         age = data['age']?.toString() ?? "0";
//         phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
//         location = data['address'] ?? "Chưa cập nhật";
//         email = data["email"] ?? "Chưa cập nhật";
//         userId = data['id']?.toString() ?? "";
//         isLoading = false; // Đặt trạng thái không còn loading
//
//         isLoading = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
//     }
//   }
//
//   Future<void> fetchPersonalGoal() async {
//     try {
//       // Fetch health profile first to get the current weight
//       final healthProfileResponse = await UserService().getHealthProfile();
//
//       if (healthProfileResponse.statusCode == 200) {
//         final healthProfileData = jsonDecode(healthProfileResponse.body);
//         currentWeight = healthProfileData['data']['weight'] != null
//             ? int.parse(healthProfileData['data']['weight'].toString())
//             : 0; // Get weight from health profile
//
//         // Print current weight to the console
//         print("Current Weight: $currentWeight");
//       } else {
//         print("❌ Lỗi khi lấy health profile: ${healthProfileResponse.body}");
//         currentWeight = 70; // Default weight in case of error
//       }
//
//       // Now fetch the personal goal
//       final response = await UserService().getPersonalGoal();
//       if (response.statusCode == 200) {
//         final personalData = jsonDecode(response.body);
//         goalType =
//             _goalTypeMap[personalData['data']['goalType']] ?? "Chưa cập nhật";
//         targetWeight =
//             personalData['data']['targetWeight'] ?? 70; // Set target weight
//
//         // Ánh xạ từ giá trị số về giá trị mô tả
//         weightChangeRate = _reverseWeightChangeRateMap[personalData['data']
//                 ['weightChangeRate']] ??
//             "Chưa cập nhật";
//
//         isLoading = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
//     }
//   }
//
//   // Cập nhật mục tiêu cá nhân
//   Future<void> updatePersonalGoal(BuildContext context) async {
//     try {
//       // Khi chọn mục tiêu "Giữ cân", sử dụng cân nặng hiện tại
//       if (goalType == 'Giữ cân') {
//         targetWeight = currentWeight; // Gửi cân nặng hiện tại
//         weightChangeRate = 'Giữ cân';
//       }
//
//       final weightChangeRateNumber =
//           _weightChangeRateMap[weightChangeRate] ?? 0;
//       final goalTypeInEnglish = _reverseGoalTypeMap[goalType] ?? 'LoseWeight';
//
//       final response = await UserService().updatePersonalGoal(
//         goalType: goalTypeInEnglish,
//         targetWeight: targetWeight ?? 0,
//         weightChangeRate: weightChangeRateNumber.toString(),
//         context: context,
//       );
//
//       if (response.statusCode == 200) {
//         print('✅ Update successful!');
//         await fetchPersonalGoal();
//         Navigator.pop(context, true);
//       } else {
//         final responseData = jsonDecode(response.body);
//         final errorMessage =
//             responseData['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại';
//
//         print("❌ Error from API: $errorMessage");
//       }
//     } catch (e) {
//       print("❌ Exception caught: $e");
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class EditDailyMacronutrientsScreenModel extends ChangeNotifier {
  int dailyCalories = 0;
  double dailyCarb = 0;
  double dailyFat = 0;
  double dailyProtein = 0;
  int height = 0;
  final _userService = UserService();
  String name = '';
  String avatar = '';
  String age = '';
  String phoneNumber = '';
  String location = '';
  String email = '';
  bool isLoading = true;
  String userId = '';
  String errorMessage = "";
  double weight = 0.0;
  double currentWeight =
      0.0; // Biến lưu trữ cân nặng hiện tại (thay đổi kiểu thành double)
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
            ? double.parse(
                healthData['data']['weight'].toString()) // Chuyển sang double
            : 0.0;

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
    }
  }

  Future<void> fetchPersonalGoal() async {
    try {
      final healthProfileResponse = await UserService().getHealthProfile();

      if (healthProfileResponse.statusCode == 200) {
        final healthProfileData = jsonDecode(healthProfileResponse.body);
        currentWeight = healthProfileData['data']['weight'] != null
            ? double.parse(healthProfileData['data']['weight']
                .toString()) // Cập nhật thành double
            : 0.0; // Lấy trọng lượng từ hồ sơ sức khỏe

        print("Current Weight: $currentWeight");
      } else {
        print("❌ Lỗi khi lấy health profile: ${healthProfileResponse.body}");
        currentWeight = 70.0; // Cân nặng mặc định khi có lỗi
      }

      final response = await UserService().getPersonalGoal();
      if (response.statusCode == 200) {
        final personalData = jsonDecode(response.body);

        dailyCalories = personalData['data']['dailyCalories'] ?? 0;
        dailyCarb = personalData['data']['dailyCarb'] != null
            ? double.parse(personalData['data']['dailyCarb']
                .toString()) // Chuyển sang double
            : 0.0;
        // dailyCarb = personalData['data']['dailyCarb'] ?? 0;
        dailyFat = personalData['data']['dailyFat'] != null
            ? double.parse(personalData['data']['dailyFat']
                .toString()) // Chuyển sang double
            : 0.0;
        dailyProtein = personalData['data']['dailyProtein'] != null
            ? double.parse(personalData['data']['dailyProtein']
                .toString()) // Chuyển sang double
            : 0.0;

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        name = data['name'] ?? "Chưa cập nhật";
        age = data['age']?.toString() ?? "0";
        phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
        location = data['address'] ?? "Chưa cập nhật";
        email = data["email"] ?? "Chưa cập nhật";
        userId = data['id']?.toString() ?? "";
        avatar = data['avatar'];
        isLoading = false; // Đặt trạng thái không còn loading
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDailyMacronutrients(BuildContext context) async {
    try {
      // Khi chọn mục tiêu "Giữ cân", sử dụng cân nặng hiện tại

      final response = await UserService().updateDailyMacronutrients(
        dailyCarb: dailyCarb,
        dailyFat: dailyFat,
        dailyProtein: dailyProtein,
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
