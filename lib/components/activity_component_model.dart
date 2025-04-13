import 'package:diet_plan_app/components/activity_component_widget.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../services/health_service.dart';
import '../services/user_service.dart';

class ActivityComponentModel extends FlutterFlowModel<ActivityComponentWidget> {
  final UserService _userService = UserService();
  String bmi = '';
  String bmiType = '';
  String tdee = '';
  String evaluate = '';
  String name = '';
  String age = '';
  String phoneNumber = '';
  String gender = '';
  String location = '';
  String profileOption = '';
  String email = '';
  double height = 0.0;
  double weight = 0.0;
  String activityLevel = '';
  String userId = '';
  String avatar = '';
  List<int> selectedAllergyIds = []; // Danh sách các dị ứng đã chọn
  List<int> selectedDiseaseIds = [];
  List<int> allergies = []; // ✅ Dị ứng
  List<int> diseases = []; // ✅ Bệnh nền
  String goalType = ''; // ✅ Mục tiêu sức khỏe
  double targetWeight = 0; // ✅ Cân nặng mục tiêu
  String weightChangeRate = '';
  int progressPercentage = 0;
  String aisuggestion = '';
  String dietStyle = '';

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
  final Map<String, String> _reverseActivityLevelMap = {
    'Sedentary': 'Ít vận động',
    'LightlyActive': 'Vận động nhẹ',
    'ModeratelyActive': 'Vận động vừa phải',
    'VeryActive': 'Vận động nhiều',
    'ExtraActive': 'Cường độ rất cao',
  };
  final Map<String, String> _reverseDietStyleMap = {
    'HighCarbLowProtein': 'Nhiều Carb, giảm Protein',
    'HighProteinLowCarb': 'Nhiều Protein, giảm Carb',
    'Vegetarian': 'Ăn chay',
    'Vegan': 'Thuần chay',
    'Balanced': 'Cân bằng',
  };
  final Map<String, String> _goalTypeMap = {
    'LoseWeight': 'Giảm cân',
    'Maintain': 'Giữ cân',
    'GainWeight': 'Tăng cân',
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
  Future<void> fetchTargetWeight() async {
    try {
      final response = await _userService.getPersonalGoal();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        {
          // targetWeight = data['targetWeight']?.toDouble() ?? 80.0;
          targetWeight = data["targetWeight"] != null
              ? double.parse(data['targetWeight'].toString())
              : 0.0;
        }
        ;
      } else {
        throw Exception('Failed to load target weight');
      }
    } catch (e) {
      print('Error fetching target weight: $e');
    }
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
        avatar = data["avatar"] ?? "";
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

        bmi = data["BMI"] ?? "N/A";
        bmiType = data["BMIType"] ?? "N/A";
        tdee = data["TDEE"] ?? "N/A";
        evaluate = data["evaluate"] ?? '';
        // height = data["height"];
        height = data["height"] != null
            ? double.parse(data['height'].toString())
            : 0.0;
        // weight = data["weight"];
        weight = data["weight"] != null
            ? double.parse(data['weight'].toString())
            : 0.0;
        activityLevel = data["activityLevel"] ?? "";
        aisuggestion = data['aisuggestion'] ?? " Chưa có lời khuyên ";
        dietStyle = data["dietStyle"] ?? "";
        // Lấy danh sách dị ứng
        allergies = (data['allergies'] as List?)
                ?.map((e) => int.tryParse(e['allergyId'].toString()) ?? 0)
                .where((e) => e > 0)
                .toList() ??
            [];

        diseases = (data['diseases'] as List?)
                ?.map((e) => int.tryParse(e['diseaseId'].toString()) ?? 0)
                .where((e) => e > 0)
                .toList() ??
            [];

        // Nếu có dữ liệu mục tiêu cá nhân
        if (healthData["personalGoal"] != null) {
          final personalGoal = healthData["personalGoal"];
          goalType =
              _goalTypeMap[personalGoal["goalType"]] ?? "Chưa đặt mục tiêu";

          targetWeight = personalGoal["targetWeight"] != null
              ? double.parse(personalGoal['targetWeight'].toString())
              : 0.0;
          progressPercentage = personalGoal["progressPercentage"] ?? 0;
          weightChangeRate =
              _weightChangeRateMap[personalGoal["weightChangeRate"]] ??
                  "Chưa cập nhật";
        }
      } else {
        print("❌ Lỗi khi lấy dữ liệu sức khỏe: ${healthData["errorMessage"]}");
      }
    } catch (e) {
      print("❌ Lỗi khi fetch dữ liệu sức khỏe: $e");
    }
  }

  Future<bool> checkTodayUpdate() async {
    try {
      final response = await _userService.getTodayCheck(); // Call API

      if (response.statusCode == 200) {
        // Directly parse the response body as a boolean
        final bool isUpdatedToday = jsonDecode(response.body);

        return isUpdatedToday ??
            false; // If the response is true, return true, else return false
      } else {
        throw Exception("Lỗi khi lấy kiểm tra hôm nay");
      }
    } catch (e) {
      print("❌ Lỗi khi kiểm tra: $e");
      return false; // Return false if there's an error
    }
  }

  Future<void> updateHealthProfile(
      BuildContext context, String profileOption) async {
    try {
      // Giữ lại allergies và diseases hiện tại từ hồ sơ sức khỏe
      final currentAllergies = allergies.isNotEmpty ? allergies : [];
      final currentDiseases = diseases.isNotEmpty ? diseases : [];

      final response = await _userService.updateHealthProfile(
        activityLevel: activityLevel,
        weight: weight,
        height: height,

        dietStyle: dietStyle,
        aisuggestion: aisuggestion,
        profileOption: profileOption,
        allergies: currentAllergies, // Gửi lại allergies hiện tại
        diseases: currentDiseases, // Gửi lại diseases hiện tại
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        print('✅ Cập nhật thành công!');
        await fetchHealthProfile();
        await fetchTargetWeight(); // Fetch updated data
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cập nhật thành công!')));
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'] ?? 'Cập nhật thất bại';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật hồ sơ sức khỏe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại.')));
    }
  }

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {
    fetchUserProfile();
    fetchHealthProfile();
  }
}

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    ),
    backgroundColor: Colors.green, // Set background color to green
    duration: Duration(seconds: 2), // Duration for the snackbar to be visible
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
