import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'verification_screen_widget.dart' show VerificationScreenWidget;
import 'package:flutter/material.dart';

class VerificationScreenModel
    extends FlutterFlowModel<VerificationScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for appbar component.
  late AppbarModel appbarModel;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  String? _pinCodeControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter a valid OTP';
    }
    if (val.length < 4) {
      return 'Requires 4 characters.';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    pinCodeController = TextEditingController();
    pinCodeControllerValidator = _pinCodeControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    pinCodeController?.dispose();
  }
}
