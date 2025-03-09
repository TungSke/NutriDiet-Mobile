import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/foodList_component_model.dart';
import 'search_result_screen_widget.dart' show SearchResultScreenWidget;

class SearchResultScreenModel
    extends FlutterFlowModel<SearchResultScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel1;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodListComponentModel1 = createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodListComponentModel1.dispose();
  }
}
