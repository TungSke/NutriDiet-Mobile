import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '../../services/health_service.dart';
import '../../services/user_service.dart';
import 'my_profile_widget.dart';

class MyProfileModel extends FlutterFlowModel<MyProfileWidget>
    with ChangeNotifier {
  final UserService _userService = UserService();

  String name = '';
  String age = '';
  String phoneNumber = '';
  String gender = '';
  String location = '';
  String email = '';
  String height = '';
  String weight = '';
  String activityLevel = '';
  String dietStyle = '';
  String userId = '';
  String avatar = '';
  List<String> allergies = []; // ✅ Dị ứng
  List<String> diseases = []; // ✅ Bệnh nền
  String goalType = ''; // ✅ Mục tiêu sức khỏe
  double targetWeight = 0.0; // ✅ Cân nặng mục tiêu
  String weightChangeRate = '';
  int dailyCalories = 0;
  double dailyCarb = 0.0;
  double dailyFat = 0.0;
  double dailyProtein = 0.0;
  int progressPercentage = 0;
  final Map<String, String> _goalTypeMap = {
    'LoseWeight': 'Giảm cân',
    'Maintain': 'Giữ cân',
    'GainWeight': 'Tăng cân',
  };
  final Map<String, String> _genderMap = {
    'Nam': 'Male',
    'Nữ': 'Female',
  };

  // Mảng ánh xạ giá trị số về giá trị mô tả
  final Map<String, String> _reverseGenderMap = {
    'Male': 'Nam',
    'Female': 'Nữ',
  };
  final Map<String, String> _activityLevelMap = {
    'Sedentary': 'Ít vận động',
    'LightlyActive': 'Vận động nhẹ',
    'ModeratelyActive': 'Vận động vừa phải',
    'VeryActive': 'vận động nhiều',
    'ExtraActive': 'Cường độ rất cao',
  };
  final Map<String, String> _dietStyleMap = {
    'HighCarbLowProtein': 'Nhiều Carb, giảm Protein',
    'HighProteinLowCarb': 'Nhiều Protein, giảm Carb',
    'Vegetarian': 'Ăn chay',
    'Vegan': 'Thuần chay',
    'Balanced': 'Cân bằng',
  };

  final Map<int, String> _weightChangeRateMap = {
    0: 'Giữ cân',
    250: 'Tăng 0.25kg/1 tuần',
    500: 'Tăng 0.5kg/1 tuần',
    -250: 'Giảm 0.25Kg/1 tuần',
    -500: 'Giảm 0.5Kg/1 tuần',
    -750: 'Giảm 0.75Kg/1 tuần',
    -1000: 'Giảm 1Kg/1 tuần',
  };

  @override
  void initState(BuildContext context) {
    fetchUserProfile();
    fetchHealthProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      print("🔄 Đang gọi API cập nhật profile...");
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = data['name'] ?? "Chưa cập nhật";
        age = data['age']?.toString() ?? "0";
        phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
        gender = _reverseGenderMap[data['gender']] ?? "Chưa cập nhật";
        location = data['address'] ?? "Chưa cập nhật";
        email = data["email"] ?? "Chưa cập nhật";
        userId = data['id']?.toString() ?? "";
        avatar = data["avatar"] ?? "Chưa cập nhật";
        notifyListeners();
      } else {
        debugPrint('❌ Failed to fetch user profile');
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi lấy thông tin người dùng: $e");
    }
  }

  Future<void> fetchHealthProfile() async {
    try {
      print("🔄 Đang lấy thông tin sức khỏe từ API...");
      final healthData = await HealthService.fetchHealthData();

      if (healthData["healthData"] != null) {
        final data = healthData["healthData"];

        height = data["height"]?.toString() ?? "N/A";
        weight = data["weight"]?.toString() ?? "N/A";
        activityLevel = _activityLevelMap[data["activityLevel"]] ?? "N/A";
        dietStyle = _dietStyleMap[data["dietStyle"]] ?? "N/A";
        // Lấy danh sách dị ứng
        allergies = data["allergies"] != null
            ? (data["allergies"] as List)
                .map((allergy) => allergy["allergyName"].toString())
                .toList()
            : [];

        // Lấy danh sách bệnh nền
        diseases = data["diseases"] != null
            ? (data["diseases"] as List)
                .map((diseases) => diseases["diseaseName"].toString())
                .toList()
            : [];

        // Nếu có dữ liệu mục tiêu cá nhân
        if (healthData["personalGoal"] != null) {
          final personalGoal = healthData["personalGoal"];
          goalType =
              _goalTypeMap[personalGoal["goalType"]] ?? "Chưa đặt mục tiêu";
          // targetWeight = personalGoal["targetWeight"]?.toString() ?? "N/A";
          targetWeight = personalGoal["targetWeight"] != null
              ? double.parse(personalGoal['targetWeight'].toString())
              : 0.0;
          progressPercentage = personalGoal["progressPercentage"] ?? 0;
          dailyCalories = personalGoal["dailyCalories"] ?? "";
          dailyCarb = personalGoal["dailyCarb"] != null
              ? double.parse(personalGoal['dailyCarb'].toString())
              : 0.0;
          dailyFat = personalGoal["dailyFat"] != null
              ? double.parse(personalGoal['dailyFat'].toString())
              : 0.0;
          dailyProtein = personalGoal["dailyProtein"] != null
              ? double.parse(personalGoal['dailyProtein'].toString())
              : 0.0;
          weightChangeRate =
              _weightChangeRateMap[personalGoal["weightChangeRate"]] ??
                  "Chưa cập nhật";
        }

        notifyListeners();
      } else {
        print("❌ Lỗi khi lấy dữ liệu sức khỏe: ${healthData["errorMessage"]}");
      }
    } catch (e) {
      print("❌ Lỗi khi fetch dữ liệu sức khỏe: $e");
    }
  }

  @override
  void dispose() {}
}
