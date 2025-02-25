import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;
import 'package:flutter/material.dart';

class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // State field(s) for lb widget.
  FocusNode? lbFocusNode;
  TextEditingController? lbTextController;
  String? Function(BuildContext, String?)? lbTextControllerValidator;
  // State field(s) for kg widget.
  FocusNode? kgFocusNode;
  TextEditingController? kgTextController;
  String? Function(BuildContext, String?)? kgTextControllerValidator;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    lbFocusNode?.dispose();
    lbTextController?.dispose();

    kgFocusNode?.dispose();
    kgTextController?.dispose();
  }
}
