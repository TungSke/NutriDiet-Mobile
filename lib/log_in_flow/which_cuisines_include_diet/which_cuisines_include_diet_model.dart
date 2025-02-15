import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'which_cuisines_include_diet_widget.dart'
    show WhichCuisinesIncludeDietWidget;
import 'package:flutter/material.dart';

class WhichCuisinesIncludeDietModel
    extends FlutterFlowModel<WhichCuisinesIncludeDietWidget> {
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
