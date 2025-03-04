import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/user_service.dart';
import 'hight_enter_screen_widget.dart'; // Import UserService

class HightEnterScreenModel extends FlutterFlowModel<HightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  late AppbarModel appbarModel;

  FocusNode? cmFocusNode;
  TextEditingController? cmTextController;
  String? Function(BuildContext, String?)? cmTextControllerValidator;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    cmTextControllerValidator = _cmTextControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    cmFocusNode?.dispose();
    cmTextController?.dispose();
  }

  String? _cmTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập chiều cao';
    }
    return null;
  }

  Future<void> updateHeight(BuildContext context) async {
    final newHeightStr = cmTextController?.text.trim();
    if (newHeightStr == null || newHeightStr.isEmpty) {
      return;
    }

    final int? newHeight = int.tryParse(newHeightStr);
    if (newHeight == null || newHeight <= 0) {
      showSnackbar(context, 'Chiều cao không hợp lệ, vui lòng nhập số dương.');
      return;
    }

    try {
      final response = await UserService().updateHealthProfile(
        height: newHeight, // ✅ Chuyển sang int
        weight: null,
        activityLevel: null,
        aisuggestion: null,
        allergies: [],
        diseases: [],
      );

      if (response.statusCode == 200) {
        FFAppState().cmvalue = newHeight.toString(); // Lưu lại dưới dạng String
        FFAppState().update(() {});
        showSnackbar(context, 'Cập nhật chiều cao thành công!');
      } else {
        final error = response.body;
        showSnackbar(context, 'Cập nhật thất bại: $error');
      }
    } catch (e) {
      showSnackbar(context, 'Lỗi: $e');
    }
  }
}
