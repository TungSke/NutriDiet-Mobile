import 'package:flutter/material.dart';

import '/services/user_service.dart';
import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'frequency_exercise_screen_widget.dart';

class FrequencyExerciseScreenModel
    extends FlutterFlowModel<FrequencyExerciseScreenWidget> {
  ///  Local state fields for this page.
  int? select = 0;

  ///  State fields for stateful widgets in this page.
  late AppbarModel appbarModel;

  /// Danh sách ánh xạ select -> ActivityLevel (bao gồm null)
  static const List<String?> activityLevels = [
    null, // 0 - Không chọn
    'Sedentary', // 1
    'LightlyActive', // 2
    'ModeratelyActive', // 3
    'VeryActive', // 4
    'ExtraActive' // 5
  ];

  /// Hàm lấy giá trị ActivityLevel tương ứng
  String? get selectedActivityLevel =>
      (select != null && select! >= 0 && select! < activityLevels.length)
          ? activityLevels[select!]
          : null;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
  }

  Future<void> updateActivityLevel(BuildContext context) async {
    final String? newActivityLevel = selectedActivityLevel;

    if (newActivityLevel == null) {
      showSnackbar(context, 'Vui lòng chọn mức độ hoạt động.');
      return;
    }

    try {
      // 🔹 Gọi API lấy thông tin sức khỏe
      final healthProfileResponse = await UserService().getHealthProfile();
      print("🔹 Status Code: ${healthProfileResponse.statusCode}");
      print("🔹 Response Body: ${healthProfileResponse.body}");

      if (healthProfileResponse.statusCode != 200) {
        showSnackbar(context, 'Lỗi API: Không thể lấy thông tin sức khỏe.');
        return;
      }

      // Parse dữ liệu JSON
      final Map<String, dynamic> healthProfile =
          jsonDecode(healthProfileResponse.body);
      print("🔹 Dữ liệu healthProfile: $healthProfile");

      final profileData = healthProfile['data'];
      if (profileData == null) {
        showSnackbar(context, '⚠️ Lỗi: Không có dữ liệu sức khỏe hợp lệ.');
        return;
      }

      int? height = profileData['height'] != null
          ? int.tryParse(profileData['height'].toString())
          : null;
      int? weight = profileData['weight'] != null
          ? int.tryParse(profileData['weight'].toString())
          : null;

      // 🔹 Kiểm tra nếu height hoặc weight bị null
      if (height == null || weight == null) {
        showSnackbar(context,
            '⚠️ Không thể lấy thông tin sức khỏe, vui lòng thử lại sau.');
        return;
      }

      // 🔹 Gọi API cập nhật mức độ hoạt động
      final response = await UserService().updateHealthProfile(
        height: height,
        weight: weight,
        activityLevel: newActivityLevel,
        aisuggestion: null,
        allergies: [],
        diseases: [],
      );

      print("🔹 Status cập nhật: ${response.statusCode}");
      print("🔹 Response cập nhật: ${response.body}");

      if (response.statusCode == 200) {
        FFAppState().activityLevel = newActivityLevel;
        FFAppState().update(() {});
        showSnackbar(context, 'Cập nhật mức độ hoạt động thành công!');
      } else {
        showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
      }
    } catch (e) {
      print("❌ Lỗi xảy ra: $e");
      showSnackbar(context, 'Lỗi: $e');
    }
  }
}
