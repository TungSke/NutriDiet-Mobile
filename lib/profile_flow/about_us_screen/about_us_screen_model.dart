import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'about_us_screen_widget.dart' show AboutUsScreenWidget;
import 'package:flutter/material.dart';

class AboutUsScreenModel extends FlutterFlowModel<AboutUsScreenWidget> {
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
