import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/food_component_model.dart';
import 'breskfast_screen_widget.dart' show BreskfastScreenWidget;

class BreskfastScreenModel extends FlutterFlowModel<BreskfastScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodComponentModel = createModel(context, () => FoodComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodComponentModel.dispose();
  }
}
