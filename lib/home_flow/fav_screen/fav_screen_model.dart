import '/components/appbar_widget.dart';
import '/components/comon_componet_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'fav_screen_widget.dart' show FavScreenWidget;
import 'package:flutter/material.dart';

class FavScreenModel extends FlutterFlowModel<FavScreenWidget> {
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
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel5;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    comonComponetModel1 = createModel(context, () => ComonComponetModel());
    comonComponetModel2 = createModel(context, () => ComonComponetModel());
    comonComponetModel3 = createModel(context, () => ComonComponetModel());
    comonComponetModel4 = createModel(context, () => ComonComponetModel());
    comonComponetModel5 = createModel(context, () => ComonComponetModel());
  }

  @override
  void dispose() {
    appbarModel.dispose();
    comonComponetModel1.dispose();
    comonComponetModel2.dispose();
    comonComponetModel3.dispose();
    comonComponetModel4.dispose();
    comonComponetModel5.dispose();
  }
}
