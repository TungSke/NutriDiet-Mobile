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
  String location = '';
  String email = '';
  String height = '';
  String weight = '';
  String activityLevel = '';
  String userId = '';
  List<String> allergies = []; // ✅ Dị ứng
  List<String> diseases = []; // ✅ Bệnh nền
  String goalType = ''; // ✅ Mục tiêu sức khỏe
  String targetWeight = ''; // ✅ Cân nặng mục tiêu

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
        location = data['address'] ?? "Chưa cập nhật";
        email = data["email"] ?? "Chưa cập nhật";
        userId = data['id']?.toString() ?? "";
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
        activityLevel = data["activityLevel"] ?? "N/A";

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
          goalType = personalGoal["goalType"] ?? "Chưa đặt mục tiêu";
          targetWeight = personalGoal["targetWeight"]?.toString() ?? "N/A";
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
