import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'hight_enter_screen_widget.dart' show HightEnterScreenWidget;

class HightEnterScreenModel extends FlutterFlowModel<HightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for appbar component.
  late AppbarModel appbarModel;

  // State field(s) for cm widget.
  FocusNode? cmFocusNode;
  TextEditingController? cmTextController;
  String? Function(BuildContext, String?)? cmTextControllerValidator;
  String? _cmTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

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
}
