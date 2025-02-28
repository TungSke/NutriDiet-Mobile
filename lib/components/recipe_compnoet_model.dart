import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'food_component_model.dart';
import 'recipe_compnoet_widget.dart' show RecipeCompnoetWidget;

class RecipeCompnoetModel extends FlutterFlowModel<RecipeCompnoetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel1;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel2;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel3;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel4;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel5;

  @override
  void initState(BuildContext context) {
    foodComponentModel1 = createModel(context, () => FoodComponentModel());
    foodComponentModel2 = createModel(context, () => FoodComponentModel());
    foodComponentModel3 = createModel(context, () => FoodComponentModel());
    foodComponentModel4 = createModel(context, () => FoodComponentModel());
    foodComponentModel5 = createModel(context, () => FoodComponentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    foodComponentModel1.dispose();
    foodComponentModel2.dispose();
    foodComponentModel3.dispose();
    foodComponentModel4.dispose();
    foodComponentModel5.dispose();
  }
}
