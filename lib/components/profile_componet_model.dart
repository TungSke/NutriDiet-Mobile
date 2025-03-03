import '/flutter_flow/flutter_flow_util.dart';
import 'profile_componet_widget.dart' show ProfileComponetWidget;
import 'package:flutter/material.dart';
import 'package:diet_plan_app/services/user_service.dart';

class ProfileComponetModel extends FlutterFlowModel<ProfileComponetWidget>  {
  final UserService _userService = UserService();

  String name = "Chưa đăng nhập"; // Giá trị mặc định
  String email = "@gmail.com"; // Giá trị mặc định
  bool isLoading = true; // Trạng thái loading

  @override
  void initState(BuildContext context) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = data["name"] ?? "Unknown User";
        email = data["email"] ?? "No Email";
      } else {
        debugPrint("Lỗi khi gọi API: ${response.body}");
      }
    } catch (e) {
      debugPrint("Lỗi khi lấy thông tin người dùng: $e");
    }

    isLoading = false;
  }

  @override
  void dispose() {}
}
