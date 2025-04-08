import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../services/models/health_profile_provider.dart';
import 'diet_style_screen_widget.dart';

class DietStyleScreenModel extends FlutterFlowModel<DietStyleScreenWidget> {
  ///  Local state fields for this page.
  int? select = 0;

  ///  State fields for stateful widgets in this page.
  late AppbarModel appbarModel;

  static const List<String?> dietStyles = [
    'HighCarbLowProtein', // 1
    'HighProteinLowCarb', // 2
    'Vegetarian', // 3
    'Vegan', // 4
    'Balanced' // 5
  ];

  /// Hàm lấy giá trị ActivityLevel tương ứng
  String? get selectedDietStyle =>
      (select != null && select! >= 0 && select! < dietStyles.length)
          ? dietStyles[select!]
          : null;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
  }

  Future<void> updateDietStyle(BuildContext context) async {
    final String? newDietStyle = selectedDietStyle;

    if (newDietStyle == null) {
      showSnackbar(context, 'Vui lòng chọn chế độ ăn.');
      return;
    }

    try {
      FFAppState().dietStyle = newDietStyle;
      FFAppState().update(() {});

      // Lưu mức độ hoạt động vào provider (nếu cần)
      Provider.of<HealthProfileProvider>(context, listen: false)
          .setDietStyle(newDietStyle);

      // In ra mức độ hoạt động đã lưu
      print(
          'Chế độ đã lưu vào provider: ${Provider.of<HealthProfileProvider>(context, listen: false).dietStyle}');

      showSnackbar(context, 'Cập nhật chế độ ăn thành công!');
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
