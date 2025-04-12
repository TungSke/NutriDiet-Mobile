import 'dart:async';
import 'dart:convert';
import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'reset_password_screen_widget.dart' show ResetPasswordScreenWidget;

class ResetPasswordScreenModel extends FlutterFlowModel<ResetPasswordScreenWidget> with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late AppbarModel appbarModel;
  final UserService _userService = UserService();
  bool isLoading = false;
  int countdown = 60;
  Timer? timer;

  // OTP field
  FocusNode? otpFocusNode;
  TextEditingController? otpController;
  String? Function(BuildContext, String?)? otpValidator;
  String? _otpValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập mã OTP';
    }
    if (val.length < 6) {
      return 'Mã OTP phải có 6 chữ số';
    }
    return null;
  }

  // New password field
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordValidator;
  String? _passwordValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập mật khẩu mới';
    }
    if (val.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // Confirm password field
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordController;
  late bool confirmPasswordVisibility;
  String? Function(BuildContext, String?)? confirmPasswordValidator;
  String? _confirmPasswordValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (val != passwordController?.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  Future<bool> resetPassword(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return false;
    }

    String email = FFAppState().email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: Không tìm thấy email trong trạng thái ứng dụng'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    setLoading(true);

    try {
      final request = ResetPasswordRequest(
        email: email,
        otp: otpController!.text,
        newPassword: passwordController!.text,
      );
      final response = await _userService.resetPassword(request);
      if (response.statusCode == 200) {
        // Xóa email khỏi FFAppState sau khi thành công
        FFAppState().clearEmail();
        debugPrint("Cleared email from FFAppState");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đặt lại mật khẩu thành công!'),
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
          if (response.statusCode == 404) {
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
      debugPrint("Error in resetPassword: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi đặt lại mật khẩu: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    String email = FFAppState().email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không tìm thấy email trong trạng thái ứng dụng'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    debugPrint("Resending OTP for email: $email");
    try {
      final response = await _userService.forgotPassword(email);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mã OTP đã được gửi lại!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        startCountdown();
      } else {
        String errorMessage = 'Lỗi không xác định';
        try {
          final body = jsonDecode(response.body);
          errorMessage = body['message'] ?? body['Message'] ?? body['error'] ?? 'Lỗi không xác định từ server';
          if (errorMessage.toLowerCase().contains('otp') && errorMessage.toLowerCase().contains('incorrect')) {
            errorMessage = 'Sai mã OTP';
          } else if (response.statusCode == 404) {
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
      }
    } catch (e) {
      debugPrint("Error in resendOtp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi gửi lại OTP: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void startCountdown() {
    countdown = 60;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    otpController = TextEditingController();
    otpFocusNode = FocusNode();
    otpValidator = _otpValidator;
    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();
    passwordVisibility = false;
    passwordValidator = _passwordValidator;
    confirmPasswordController = TextEditingController();
    confirmPasswordFocusNode = FocusNode();
    confirmPasswordVisibility = false;
    confirmPasswordValidator = _confirmPasswordValidator;
    startCountdown();
  }

  @override
  void dispose() {
    appbarModel.dispose();
    otpFocusNode?.dispose();
    otpController?.dispose();
    passwordFocusNode?.dispose();
    passwordController?.dispose();
    confirmPasswordFocusNode?.dispose();
    confirmPasswordController?.dispose();
    timer?.cancel();
    super.dispose();
  }
}