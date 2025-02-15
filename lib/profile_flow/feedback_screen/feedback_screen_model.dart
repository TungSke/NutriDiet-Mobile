import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'feedback_screen_widget.dart' show FeedbackScreenWidget;
import 'package:flutter/material.dart';

class FeedbackScreenModel extends FlutterFlowModel<FeedbackScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for appbar component.
  late AppbarModel appbarModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid your feedback.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
