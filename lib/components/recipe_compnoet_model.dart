import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_model.dart';
import 'recipe_compnoet_widget.dart' show RecipeCompnoetWidget;

class RecipeCompnoetModel extends FlutterFlowModel<RecipeCompnoetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel1;

  @override
  void initState(BuildContext context) {
    foodListComponentModel1 =
        createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    foodListComponentModel1.dispose();
  }
}
