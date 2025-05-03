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
// }ử lại';
//
//         print("❌ Error from API: $errorMessage");
//       }
//     } catch (e) {
//       print("❌ Exception caught: $e");
//     }
//   }
// }
import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/user_service.dart';

class EditPersonalGoalScreenModel extends ChangeNotifier {
  final _userService = UserService();
  String name = '';
  String age = '';
  String phoneNumber = '';
  String location = '';
  String email = '';
  String avatar = '';

  double height = 0;
  double weight = 0.0;
  String activityLevel = '';
  bool isLoading = true;
  String userId = '';
  String errorMessage = "";

  final Map<String, int> _weightChangeRateMap = {
    'Giữ cân': 0,
    'Tăng 0.25kg/1 tuần': 250,
    'Tăng 0.5kg/1 tuần': 500,
    'Giảm 0.25Kg/1 tuần': -250,
    'Giảm 0.5Kg/1 tuần': -500,
    'Giảm 0.75Kg/1 tuần': -750,
    'Giảm 1Kg/1 tuần': -1000,
  };

  final Map<int, String> _reverseWeightChangeRateMap = {
    0: 'Giữ cân',
    250: 'Tăng 0.25kg/1 tuần',
    500: 'Tăng 0.5kg/1 tuần',
    -250: 'Giảm 0.25Kg/1 tuần',
    -500: 'Giảm 0.5Kg/1 tuần',
    -750: 'Giảm 0.75Kg/1 tuần',
    -1000: 'Giảm 1Kg/1 tuần',
  };

  final Map<String, String> _goalTypeMap = {
    'LoseWeight': 'Giảm cân',
    'Maintain': 'Giữ cân',
    'GainWeight': 'Tăng cân',
  };

  final Map<String, String> _reverseGoalTypeMap = {
    'Giảm cân': 'LoseWeight',
    'Giữ cân': 'Maintain',
    'Tăng cân': 'GainWeight',
  };

  double dailyCalories = 0;
  double dailyCarb = 0;
  double dailyFat = 0;
  double dailyProtein = 0;
  String goalType = '';
  double targetWeight = 0.0;
  String notes = '';
  String goalDescription = '';
  String weightChangeRate = '';
  double currentWeight = 0.0;
  String evaluate = '';
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
        avatar = data["avatar"] ?? "";
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin người dùng: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHealthProfile() async {
    try {
      final response = await UserService().getHealthProfile();
      if (response.statusCode == 200) {
        final healthData = jsonDecode(response.body);
        height = healthData['data']['height'] != null
            ? double.parse(healthData['data']['height'].toString())
            : 0;
        weight = healthData['data']['weight'] != null
            ? double.parse(healthData['data']['weight'].toString())
            : 0.0;
        evaluate = healthData['data']['evaluate'] ?? '';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin hồ sơ sức khỏe: $e");
    }
  }

  Future<void> fetchPersonalGoal() async {
    try {
      final healthProfileResponse = await UserService().getHealthProfile();
      if (healthProfileResponse.statusCode == 200) {
        final healthProfileData = jsonDecode(healthProfileResponse.body);
        currentWeight = healthProfileData['data']['weight'] != null
            ? double.parse(healthProfileData['data']['weight'].toString())
            : 0.0;
        print("Current Weight: $currentWeight");
      } else {
        print("❌ Lỗi khi lấy health profile: ${healthProfileResponse.body}");
        currentWeight = 70.0;
      }

      final response = await UserService().getPersonalGoal();
      if (response.statusCode == 200) {
        final personalData = jsonDecode(response.body);
        goalType =
            _goalTypeMap[personalData['data']['goalType']] ?? "Chưa cập nhật";
        targetWeight = personalData['data']['targetWeight'] != null
            ? double.parse(personalData['data']['targetWeight'].toString())
            : 0.0;
        dailyCalories = personalData['data']['dailyCalories'] != null
            ? double.parse(personalData['data']['dailyCalories'].toString())
            : 0.0;
        dailyCarb = personalData['data']['dailyCarb'] != null
            ? double.parse(personalData['data']['dailyCarb'].toString())
            : 0.0;
        dailyFat = personalData['data']['dailyFat'] != null
            ? double.parse(personalData['data']['dailyFat'].toString())
            : 0.0;
        dailyProtein = personalData['data']['dailyProtein'] != null
            ? double.parse(personalData['data']['dailyProtein'].toString())
            : 0.0;
        weightChangeRate = _reverseWeightChangeRateMap[personalData['data']
                ['weightChangeRate']] ??
            "Chưa cập nhật";
        print("Weight Change Rate: $weightChangeRate");
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
    }
  }

  Future<void> updatePersonalGoal(BuildContext context) async {
    try {
      // Validation cục bộ trước khi gửi API
      if (goalType != 'Giữ cân') {
        if (targetWeight < 30 || targetWeight > 250) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mục tiêu cân nặng phải từ 30-250 kg'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (weightChangeRate.isEmpty ||
            _weightChangeRateMap[weightChangeRate] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng chọn mức độ thay đổi cân nặng'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (goalType == 'Giữ cân') {
        targetWeight = currentWeight;
        weightChangeRate = 'Giữ cân';
      }

      final weightChangeRateNumber =
          _weightChangeRateMap[weightChangeRate] ?? 0;
      final goalTypeInEnglish = _reverseGoalTypeMap[goalType] ?? 'LoseWeight';

      final response = await UserService().createPersonalGoal(
          goalType: goalTypeInEnglish,
          targetWeight: targetWeight,
          weightChangeRate: weightChangeRateNumber.toString(),
          notes: notes,
          goalDescription: goalDescription,
          context: context);

      if (response.statusCode == 201) {
        print('✅ Cập nhật thành công!');
        await fetchHealthProfile(); // Fetch updated data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thành công!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
        context.pushNamed('my_profile');
      } else if (response.statusCode == 500) {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['Message'] ?? 'Cập nhật thất bại';
        print('❌ Lỗi: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red, // Nền đỏ
          ),
        );
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật mục tiêu sức khoẻ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại.')),
      );
    }
  }

  Future<http.Response?> validateBMIGoalBeforeUpdate() async {
    try {
      final goalTypeInEnglish = _reverseGoalTypeMap[goalType] ?? 'LoseWeight';
      final weightChangeRateValue =
          _weightChangeRateMap[weightChangeRate]?.toString();

      final response = await _userService.validateBMIBasedGoal(
        goalType: goalTypeInEnglish,
        targetWeight: targetWeight,
        weightChangeRate: weightChangeRateValue,
        goalDescription: "None",
        notes: notes,
      );

      return response;
    } catch (e) {
      print("❌ Lỗi khi gọi validate BMI goal: $e");
      return null;
    }
  }
}
