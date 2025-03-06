import 'package:diet_plan_app/log_in_flow/whats_your_goal/whats_your_goal_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../services/user_service.dart';

class WhatsYourGoalModel extends FlutterFlowModel<WhatsYourGoalWidget> {
  int? select = 0;
  String? goalType = 'Maintain'; // Giá trị mặc định
  late AppbarModel appbarModel;
  static const List<String?> goalLevels = [
    'Maintain',
    'LoseWeight',
    'GainWeight',
  ];

  String? get selectedGoalLevel =>
      (select != null && select! >= 0 && select! < goalLevels.length)
          ? goalLevels[select!]
          : null;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
  }

  Future<void> updateGoalLevel(BuildContext context) async {
    final String? newGoalLevel = selectedGoalLevel;

    if (newGoalLevel == null) {
      showSnackbar(context, 'Vui lòng chọn mức độ hoạt động.');
      return;
    }

    try {
      // 🔹 Gọi API cập nhật mức độ hoạt động
      final response = await UserService().createPersonalGoal(
        goalType: newGoalLevel,
        targetWeight: 0,
        notes: "12334",
        goalDescription: "123",
        weightChangeRate: "MaintainWeight",
      );

      print("🔹 Status cập nhật: ${response.statusCode}");
      print("🔹 Response cập nhật: ${response.body}");

      if (response.statusCode == 200) {
        FFAppState().activityLevel = newGoalLevel;
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
