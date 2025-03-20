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
  String name = '';
  String age = '';
  String phoneNumber = '';
  String gender = '';
  String location = '';
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
  String targetWeight = ''; // ✅ Cân nặng mục tiêu
  String weightChangeRate = '';
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
  final Map<String, String> _reverseActivityLevelMap = {
    'Sedentary': 'Ít vận động',
    'LightlyActive': 'Vận động nhẹ',
    'ModeratelyActive': 'Vận động vừa phải',
    'VeryActive': 'Vận động nhiều',
    'ExtraActive': 'Cường độ rất cao',
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
          targetWeight = data['targetWeight']?.toDouble() ?? 80.0;
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
        height = data["height"];
        weight = data["weight"];
        activityLevel =
            _reverseActivityLevelMap[data["activityLevel"]] ?? "N/A";

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
          targetWeight = personalGoal["targetWeight"]?.toString() ?? "N/A";
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

  Future<void> updateHealthProfile(BuildContext context) async {
    try {
      // Giữ lại allergies và diseases hiện tại từ hồ sơ sức khỏe
      final currentAllergies = allergies.isNotEmpty ? allergies : [];
      final currentDiseases = diseases.isNotEmpty ? diseases : [];

      // Đảm bảo gửi đúng giá trị activityLevel
      final activityLevelInEnglish =
          _activityLevelMap[activityLevel] ?? 'Sedentary';

      // Gửi yêu cầu cập nhật hồ sơ sức khỏe
      final response = await _userService.updateHealthProfile(
        activityLevel: activityLevelInEnglish,
        weight: weight,
        height: height,
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
