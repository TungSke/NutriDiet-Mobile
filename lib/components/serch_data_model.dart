import 'package:diet_plan_app/components/search_empty_model.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_model.dart';
import 'serch_data_widget.dart' show SerchDataWidget;

class SerchDataModel extends FlutterFlowModel<SerchDataWidget> {
  bool reslut = true;
  bool select = true;

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  late FoodListComponentModel foodListComponentModel;
  late SearchEmptyModel searchemptyModel;

  @override
  void initState(BuildContext context) {
    foodListComponentModel = createModel(context, () => FoodListComponentModel());
    searchemptyModel = createModel(context, () => SearchEmptyModel());
    foodListComponentModel.fetchFoods(context: context);
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    foodListComponentModel.dispose();
    searchemptyModel.dispose();
  }
}