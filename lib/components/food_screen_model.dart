import 'package:diet_plan_app/components/food_screen_widget.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_model.dart';

class FoodScreenModel extends FlutterFlowModel<FoodScreenWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
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
    textFieldFocusNode?.dispose();
    textController?.dispose();

    foodListComponentModel1.dispose();
    foodListComponentModel2.dispose();
    foodListComponentModel3.dispose();
    foodListComponentModel4.dispose();
    foodListComponentModel5.dispose();
  }
}
