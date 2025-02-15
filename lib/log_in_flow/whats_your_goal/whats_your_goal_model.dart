import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'whats_your_goal_widget.dart' show WhatsYourGoalWidget;
import 'package:flutter/material.dart';

class WhatsYourGoalModel extends FlutterFlowModel<WhatsYourGoalWidget> {
  ///  Local state fields for this page.

  int? select = 0;

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
