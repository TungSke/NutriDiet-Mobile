import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'setting_screen_widget.dart' show SettingScreenWidget;
import 'package:flutter/material.dart';

class SettingScreenModel extends FlutterFlowModel<SettingScreenWidget> {
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
