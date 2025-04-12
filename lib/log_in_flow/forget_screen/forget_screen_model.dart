import 'dart:convert';
import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/user_service.dart';
import 'package:flutter/material.dart';
import 'forget_screen_widget.dart' show ForgetScreenWidget;

class ForgetScreenModel extends FlutterFlowModel<ForgetScreenWidget> {
  final formKey = GlobalKey<FormState>();
  late AppbarModel appbarModel;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  final UserService _userService = UserService();
  bool isLoading = false;

  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập địa chỉ email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return 'Vui lòng nhập địa chỉ email hợp lệ';
    }
    return null;
  }

  Future<bool> sendForgotPasswordRequest(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return false;
    }

    setLoading(true);

    try {
      final response = await _userService.forgotPassword(textController!.text);
      if (response.statusCode == 200) {
        FFAppState().email = textController!.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mã OTP đã được gửi đến email của bạn!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        return true;
      } else {
        String errorMessage = 'Lỗi không xác định';
        try {
          final body = jsonDecode(response.body);
          errorMessage = body['message'] ?? body['Message'] ?? body['error'] ?? 'Lỗi không xác định từ server';
          if (response.statusCode == 404 && errorMessage.contains('Email not existed')) {
            errorMessage = 'Email không tồn tại';
          }
        } catch (_) {
          errorMessage = 'Không thể đọc phản hồi từ server: ${response.body}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi gửi yêu cầu: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

void notifyListeners() {}