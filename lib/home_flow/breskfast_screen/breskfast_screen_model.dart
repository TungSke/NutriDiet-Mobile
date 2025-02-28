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
  late FoodComponentModel foodComponentModel1;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel2;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel3;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel4;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodComponentModel1 = createModel(context, () => FoodComponentModel());
    foodComponentModel2 = createModel(context, () => FoodComponentModel());
    foodComponentModel3 = createModel(context, () => FoodComponentModel());
    foodComponentModel4 = createModel(context, () => FoodComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodComponentModel1.dispose();
    foodComponentModel2.dispose();
    foodComponentModel3.dispose();
    foodComponentModel4.dispose();
  }
}
