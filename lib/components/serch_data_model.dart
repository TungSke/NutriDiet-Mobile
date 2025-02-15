import '/components/comon_componet_widget.dart';
import '/components/searchempty_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serch_data_widget.dart' show SerchDataWidget;
import 'package:flutter/material.dart';

class SerchDataModel extends FlutterFlowModel<SerchDataWidget> {
  ///  Local state fields for this component.

  bool reslut = false;

  bool select = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel1;
  // Model for comon_componet component.
  late ComonComponetModel comonComponetModel2;
  // Model for searchempty component.
  late SearchemptyModel searchemptyModel;

  @override
  void initState(BuildContext context) {
    comonComponetModel1 = createModel(context, () => ComonComponetModel());
    comonComponetModel2 = createModel(context, () => ComonComponetModel());
    searchemptyModel = createModel(context, () => SearchemptyModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    comonComponetModel1.dispose();
    comonComponetModel2.dispose();
    searchemptyModel.dispose();
  }
}
