import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;

class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for appbar component.
  late AppbarModel appbarModel;

  // State field(s) for cm widget.
  FocusNode? kgFocusNode;
  TextEditingController? kgTextController;
  String? Function(BuildContext, String?)? kgTextControllerValidator;
  String? _cmTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    kgTextControllerValidator = _cmTextControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    kgFocusNode?.dispose();
    kgTextController?.dispose();
  }
}
