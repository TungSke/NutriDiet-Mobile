import 'dart:convert';

import 'package:diet_plan_app/services/user_service.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'verification_screen_widget.dart' show VerificationScreenWidget;
import 'package:flutter/material.dart';

class VerificationScreenModel
    extends FlutterFlowModel<VerificationScreenWidget> {
  ///  State fields for stateful widgets in this page.
  final UserService _userService = UserService();
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
    if (val.length < 6) {
      return 'Requires 6 characters.';
    }
    return null;
  }

  Future<void> VerifyAccount(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    // String email = FFAppState().email;
    String email = FFAppState().email.isEmpty ? "trinhsontung2410@gmail.com" : FFAppState().email;
    final response = await _userService.verifyAccount(email, pinCodeController.text);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification successful!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      context.push("/loginScreen");
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      String errorMessage = responseBody["message"] ?? "Verification failed.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> ResendOTP() async{
    String email = FFAppState().email.isEmpty ? "trinhsontung2410@gmail.com" : FFAppState().email;
    print("resed");
    final response = await _userService.resendOTP(email);
    if(response.statusCode == 200){
      print("resend success");
      return;
    }
    else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      String errorMessage = responseBody["message"] ?? "Resend code failed.";

      print("error: $errorMessage");
    }
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
