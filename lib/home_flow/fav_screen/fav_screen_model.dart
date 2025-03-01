import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/foodList_component_model.dart';
import 'fav_screen_widget.dart' show FavScreenWidget;

class FavScreenModel extends FlutterFlowModel<FavScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel1;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel2;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel3;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel4;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel5;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodListComponentModel1 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel2 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel3 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel4 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel5 =
        createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodListComponentModel1.dispose();
    foodListComponentModel2.dispose();
    foodListComponentModel3.dispose();
    foodListComponentModel4.dispose();
    foodListComponentModel5.dispose();
  }
}
