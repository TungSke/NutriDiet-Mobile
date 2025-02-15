import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'privcy_policy_screen_widget.dart' show PrivcyPolicyScreenWidget;
import 'package:flutter/material.dart';

class PrivcyPolicyScreenModel
    extends FlutterFlowModel<PrivcyPolicyScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
  }
}
