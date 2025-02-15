import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'security_screen_widget.dart' show SecurityScreenWidget;
import 'package:flutter/material.dart';

class SecurityScreenModel extends FlutterFlowModel<SecurityScreenWidget> {
  ///  Local state fields for this page.

  bool? btn1;

  bool? btn2;

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
