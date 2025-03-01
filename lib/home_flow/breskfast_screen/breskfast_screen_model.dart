import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/foodList_component_model.dart';
import 'breskfast_screen_widget.dart' show BreskfastScreenWidget;

class BreskfastScreenModel extends FlutterFlowModel<BreskfastScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodListComponentModel =
        createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodListComponentModel.dispose();
  }
}
