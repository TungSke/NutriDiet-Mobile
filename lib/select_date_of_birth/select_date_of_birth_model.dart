import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_date_of_birth_widget.dart' show SelectDateOfBirthWidget;
import 'package:flutter/material.dart';

class SelectDateOfBirthModel extends FlutterFlowModel<SelectDateOfBirthWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  void dispose() {
    appbarModel.dispose();
  }
}
