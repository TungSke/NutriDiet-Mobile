import 'package:flutter/material.dart';

import '/components/searchempty_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'food_component_model.dart';
import 'serch_data_widget.dart' show SerchDataWidget;

class SerchDataModel extends FlutterFlowModel<SerchDataWidget> {
  ///  Local state fields for this component.

  bool reslut = false;

  bool select = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel1;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel2;
  // Model for searchempty component.
  late SearchemptyModel searchemptyModel;

  @override
  void initState(BuildContext context) {
    foodComponentModel1 = createModel(context, () => FoodComponentModel());
    foodComponentModel2 = createModel(context, () => FoodComponentModel());
    searchemptyModel = createModel(context, () => SearchemptyModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    foodComponentModel1.dispose();
    foodComponentModel2.dispose();
    searchemptyModel.dispose();
  }
}
