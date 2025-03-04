import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../services/user_service.dart';
import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;

class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  late AppbarModel appbarModel;

  FocusNode? kgFocusNode;
  TextEditingController? kgTextController;
  String? Function(BuildContext, String?)? kgTextControllerValidator;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    kgTextControllerValidator = _kgTextControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    kgFocusNode?.dispose();
    kgTextController?.dispose();
  }

  String? _kgTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập cân nặng';
    }
    return null;
  }

  Future<void> updateWeight(BuildContext context) async {
    final newWeightStr = kgTextController?.text.trim();
    if (newWeightStr == null || newWeightStr.isEmpty) {
      return;
    }

    final int? newWeight = int.tryParse(newWeightStr);
    if (newWeight == null || newWeight <= 0) {
      showSnackbar(context, 'Cân nặng không hợp lệ, vui lòng nhập số dương.');
      return;
    }

    try {
      final response = await UserService().updateHealthProfile(
        height: null,
        weight: newWeight, // ✅ Chuyển sang int
        activityLevel: null,
        aisuggestion: null,
        allergies: [],
        diseases: [],
      );

      if (response.statusCode == 200) {
        FFAppState().kgvalue = newWeight.toString(); // Lưu lại dưới dạng String
        FFAppState().update(() {});
        showSnackbar(context, 'Cập nhật cân nặng thành công!');
      } else {
        final error = response.body;
        showSnackbar(context, 'Cập nhật thất bại: $error');
      }
    } catch (e) {
      showSnackbar(context, 'Lỗi: $e');
    }
  }
}
