import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'hight_enter_screen_widget.dart' show HightEnterScreenWidget;
import 'package:flutter/material.dart';

class HightEnterScreenModel extends FlutterFlowModel<HightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for appbar component.
  late AppbarModel appbarModel;
  // State field(s) for feet widget.
  FocusNode? feetFocusNode;
  TextEditingController? feetTextController;
  String? Function(BuildContext, String?)? feetTextControllerValidator;
  String? _feetTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for inch widget.
  FocusNode? inchFocusNode;
  TextEditingController? inchTextController;
  String? Function(BuildContext, String?)? inchTextControllerValidator;
  String? _inchTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

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
    feetTextControllerValidator = _feetTextControllerValidator;
    inchTextControllerValidator = _inchTextControllerValidator;
    cmTextControllerValidator = _cmTextControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    feetFocusNode?.dispose();
    feetTextController?.dispose();

    inchFocusNode?.dispose();
    inchTextController?.dispose();

    cmFocusNode?.dispose();
    cmTextController?.dispose();
  }
}
