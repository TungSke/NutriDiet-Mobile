import '/components/comon_componet_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recipe_compnoet_widget.dart' show RecipeCompnoetWidget;
import 'package:flutter/material.dart';

class RecipeCompnoetModel extends FlutterFlowModel<RecipeCompnoetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel1;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel2;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel3;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel4;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel5;

  @override
  void initState(BuildContext context) {
    comonComponetModel1 = createModel(context, () => ComonComponetModel());
    comonComponetModel2 = createModel(context, () => ComonComponetModel());
    comonComponetModel3 = createModel(context, () => ComonComponetModel());
    comonComponetModel4 = createModel(context, () => ComonComponetModel());
    comonComponetModel5 = createModel(context, () => ComonComponetModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    comonComponetModel1.dispose();
    comonComponetModel2.dispose();
    comonComponetModel3.dispose();
    comonComponetModel4.dispose();
    comonComponetModel5.dispose();
  }
}
