import '/components/comon_componet_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_componet_widget.dart' show HomeComponetWidget;
import 'package:flutter/material.dart';

class HomeComponetModel extends FlutterFlowModel<HomeComponetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel1;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel2;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel3;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    comonComponetModel1 = createModel(context, () => ComonComponetModel());
    comonComponetModel2 = createModel(context, () => ComonComponetModel());
    comonComponetModel3 = createModel(context, () => ComonComponetModel());
  }

  @override
  void dispose() {
    comonComponetModel1.dispose();
    comonComponetModel2.dispose();
    comonComponetModel3.dispose();
  }
}
