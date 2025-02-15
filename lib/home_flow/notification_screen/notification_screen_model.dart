import '/components/appbar_widget.dart';
import '/components/notification_componet_empty_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'notification_screen_widget.dart' show NotificationScreenWidget;
import 'package:flutter/material.dart';

class NotificationScreenModel
    extends FlutterFlowModel<NotificationScreenWidget> {
  ///  Local state fields for this page.

  bool istap = false;

  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for notification_componet_empty component.
  late NotificationComponetEmptyModel notificationComponetEmptyModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    notificationComponetEmptyModel =
        createModel(context, () => NotificationComponetEmptyModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    notificationComponetEmptyModel.dispose();
  }
}
