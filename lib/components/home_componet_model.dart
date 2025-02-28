import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'food_component_model.dart';
import 'home_componet_widget.dart' show HomeComponetWidget;

class HomeComponetModel extends FlutterFlowModel<HomeComponetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel1;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel2;
  // Model for comon_componet component.
  late FoodComponentModel foodComponentModel3;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    foodComponentModel1 = createModel(context, () => FoodComponentModel());
    foodComponentModel2 = createModel(context, () => FoodComponentModel());
    foodComponentModel3 = createModel(context, () => FoodComponentModel());
  }

  @override
  void dispose() {
    foodComponentModel1.dispose();
    foodComponentModel2.dispose();
    foodComponentModel3.dispose();
  }
}
