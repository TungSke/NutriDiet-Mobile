import '/components/appbar_widget.dart';
import '/components/comon_componet_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'breskfast_screen_widget.dart' show BreskfastScreenWidget;
import 'package:flutter/material.dart';

class BreskfastScreenModel extends FlutterFlowModel<BreskfastScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for appbar component.
  late AppbarModel appbarModel;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel1;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel2;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel3;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel4;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    comonComponetModel1 = createModel(context, () => ComonComponetModel());
    comonComponetModel2 = createModel(context, () => ComonComponetModel());
    comonComponetModel3 = createModel(context, () => ComonComponetModel());
    comonComponetModel4 = createModel(context, () => ComonComponetModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    comonComponetModel1.dispose();
    comonComponetModel2.dispose();
    comonComponetModel3.dispose();
    comonComponetModel4.dispose();
  }
}
