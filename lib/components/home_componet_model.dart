import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_model.dart';
import 'home_componet_widget.dart' show HomeComponetWidget;

class HomeComponetModel extends FlutterFlowModel<HomeComponetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel1;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel2;
  // Model for comon_componet component.
  late FoodListComponentModel foodListComponentModel3;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    foodListComponentModel1 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel2 =
        createModel(context, () => FoodListComponentModel());
    foodListComponentModel3 =
        createModel(context, () => FoodListComponentModel());
  }

  @override
  void dispose() {
    foodListComponentModel1.dispose();
    foodListComponentModel2.dispose();
    foodListComponentModel3.dispose();
  }
}
