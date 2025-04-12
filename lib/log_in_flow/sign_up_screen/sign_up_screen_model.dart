import 'dart:convert';

import 'package:diet_plan_app/services/user_service.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'sign_up_screen_widget.dart' show SignUpScreenWidget;
import 'package:flutter/material.dart';

class SignUpScreenModel extends FlutterFlowModel<SignUpScreenWidget> {
  ///  State fields for stateful widgets in this page.
  final UserService _userService = UserService();
  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  bool isLoading = false;

  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Yêu cầu nhập địa chỉ email hợp lệ';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Yêu cầu nhập địa chỉ email hợp lệ';
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
      return 'Yêu cầu nhập mật khẩu hợp lệ';
    }
    if (val.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;

// Thêm validator cho mật khẩu xác nhận
  String? Function(String?)? textController3Validator;

  String? _textController3Validator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }
    if (val != textController2?.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  Future<void> handleSignUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading = true;
    try {
      final response = await _userService.register(
        textController1!.text, // Email
        textController2!.text, // Password
      );

      if (response.statusCode == 200) {
        FFAppState().email = textController1!.text;
        context.push("/verificationScreen");
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        String errorMessage = responseBody["message"] ?? "Registration failed.";

        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, "An error occurred: $e");
    }
    isLoading = false;
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


  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    passwordVisibility = false;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
