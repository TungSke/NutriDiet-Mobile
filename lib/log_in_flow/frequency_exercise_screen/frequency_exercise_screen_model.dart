import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../services/models/health_profile_provider.dart';
import 'frequency_exercise_screen_widget.dart';

class FrequencyExerciseScreenModel
    extends FlutterFlowModel<FrequencyExerciseScreenWidget> {
  ///  Local state fields for this page.
  int? select = 0;

  ///  State fields for stateful widgets in this page.
  late AppbarModel appbarModel;

  /// Danh sách ánh xạ select -> ActivityLevel (bao gồm null)
  static const List<String?> activityLevels = [
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
      // Cập nhật mức độ hoạt động
      FFAppState().activityLevel = newActivityLevel;
      FFAppState().update(() {});

      // Lưu mức độ hoạt động vào provider (nếu cần)
      Provider.of<HealthProfileProvider>(context, listen: false)
          .setActivityLevel(newActivityLevel);

      // In ra mức độ hoạt động đã lưu
      print(
          'Mức độ hoạt động đã lưu vào provider: ${Provider.of<HealthProfileProvider>(context, listen: false).activityLevel}');

      showSnackbar(context, 'Cập nhật mức độ hoạt động thành công!');
    } catch (e) {
      print("❌ Lỗi xảy ra: $e");
      showSnackbar(context, 'Lỗi: $e');
    }
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
