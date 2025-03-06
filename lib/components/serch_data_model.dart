import 'package:diet_plan_app/components/search_empty_model.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_model.dart';
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
  late FoodListComponentModel foodListComponentModel1;
  // Model for comon_componet component.

  late SearchEmptyModel searchemptyModel;

  @override
  void initState(BuildContext context) {
    foodListComponentModel1 =
        createModel(context, () => FoodListComponentModel());

    searchemptyModel = createModel(context, () => SearchEmptyModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    foodListComponentModel1.dispose();

    searchemptyModel.dispose();
  }
}
