import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/foodList_component_model.dart';
import 'fav_screen_widget.dart' show FavScreenWidget;

class FavScreenModel extends FlutterFlowModel<FavScreenWidget> {
  late AppbarModel appbarModel;
  late FoodListComponentModel foodListComponentModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    foodListComponentModel = createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    foodListComponentModel.dispose();
  }
}