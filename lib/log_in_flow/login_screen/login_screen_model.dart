import 'dart:io';

import 'package:diet_plan_app/services/user_service.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final UserService _userService = UserService();
  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid email address';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Please enter valid email address';
    }
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid password';
    }

    return null;
  }
  Future<void> handleLogin(BuildContext context) async{
    if(!formKey.currentState!.validate()){
      return;
    }
    try{
      final response = await _userService.login(textController1!.text, textController2!.text);

      if(response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["data"] != null && responseBody["data"]["accessToken"] != null) {
          String token = responseBody["data"]["accessToken"];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login success!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Chuyển hướng sau khi hiển thị thông báo
          await Future.delayed(Duration(seconds: 1));

          context.push("/bottomNavbarScreen");
        }

      }
        else{
          final responseBody = jsonDecode(response.body);
          String errorMessage = responseBody["message"] ?? "Login failed!";
          showErrorMessage(context, errorMessage);

      }
    } catch (e){
      showErrorMessage(context, "An error occurred: $e");
    }
  }
  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  Future<void> loginFaceBook() async{
     final response = await _userService.loginWithFacebook();
     if(response.statusCode == 200){
       print("sucess");
       print(response.body);
     }
     else{
       print(response);
     }
  }

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    passwordVisibility = false;
    textController2Validator = _textController2Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
