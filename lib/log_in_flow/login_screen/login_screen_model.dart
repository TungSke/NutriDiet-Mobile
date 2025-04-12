
import 'package:diet_plan_app/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    return null;
  }

  Future<void> handleLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      String? fcmToken = "";

      // Kiểm tra quyền thông báo trước khi lấy token
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }

      final response = await _userService.login(
          textController1!.text, textController2!.text, fcmToken);


      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["data"] != null &&
            responseBody["data"]["accessToken"] != null) {
          final String? accessToken = responseBody["data"]["accessToken"];
          final String? refreshToken = responseBody["data"]["refreshToken"];

          if (accessToken == null || refreshToken == null) {
            throw Exception("Invalid response: Missing accessToken or refreshToken");
          }

          await setDataAfterLogin(accessToken, refreshToken);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đăng nhập thành công!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          final userData = await _userService.whoAmI();
          if (userData.statusCode != 200) {
            throw Exception("Failed to fetch user data: ${userData.statusCode}");
          }

          final userDataJson = jsonDecode(userData.body);
          final String? email = userDataJson["email"];
          if (email == null || email.isEmpty) {
            throw Exception("Địa chỉ email không tồn tại");
          }

          FFAppState().email = email;
          // Chuyển hướng sau khi hiển thị thông báo
          await Future.delayed(Duration(seconds: 1));

            final String? name = userDataJson["name"];
            final String? gender = userDataJson["gender"];
            final String? age = userDataJson["age"];
            final String? address = userDataJson["address"];
            if(name == null || name.isEmpty || gender == null || gender.isEmpty ||
                age == null || age.isEmpty || address == null || address.isEmpty){
              context.push("/profileEnterScreen");
          }
          else {
              context.push("/bottomNavbarScreen");
            }
        }
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody["message"] ?? "Login failed!";
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
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

  Future<void> loginGoogle(BuildContext context) async {
    try{
      String? fcmToken = "";

      // Kiểm tra quyền thông báo trước khi lấy token
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      final response = await _userService.loginWithGoogle(fcmToken);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final String? accessToken = responseBody["data"]["accessToken"];
        final String? refreshToken = responseBody["data"]["refreshToken"];

        if (accessToken == null || refreshToken == null) {
          throw Exception("Invalid response: Missing accessToken or refreshToken");
        }

        await setDataAfterLogin(accessToken, refreshToken);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login success!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        final userData = await _userService.whoAmI();
        if (userData.statusCode != 200) {
          throw Exception("Failed to fetch user data: ${userData.statusCode}");
        }

        final userDataJson = jsonDecode(userData.body);
        final String? email = userDataJson["email"];
        if (email == null || email.isEmpty) {
          throw Exception("Địa chỉ email không tồn tại");
        }

        FFAppState().email = email;

        // Chuyển hướng sau khi hiển thị thông báo
        await Future.delayed(Duration(seconds: 1));

        final String? name = userDataJson["name"];
        final String? gender = userDataJson["gender"];
        final String? age = userDataJson["age"];
        final String? address = userDataJson["address"];
        if(name == null || name.isEmpty || gender == null || gender.isEmpty ||
            age == null || age.isEmpty || address == null || address.isEmpty){
          context.push("/profileEnterScreen");
        }
        else {
          context.push("/bottomNavbarScreen");
        }
      } else {
        print("Google Login failed: ${response.statusCode} - ${response.body}");
      }
    }catch (e) {
      showErrorMessage(context, "Error during login Google: $e");
    }
  }

  Future<void> loginFaceBook(BuildContext context) async {
    try {
      String? fcmToken = "";

      // Kiểm tra quyền thông báo trước khi lấy token
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      final response = await _userService.loginWithFacebook(fcmToken);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login success!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        final responseBody = jsonDecode(response.body);
        final String? accessToken = responseBody["data"]["accessToken"];
        final String? refreshToken = responseBody["data"]["refreshToken"];

        if (accessToken == null || refreshToken == null) {
          throw Exception("Invalid response: Missing accessToken or refreshToken");
        }

        await setDataAfterLogin(accessToken, refreshToken);

        // ✅ Gọi whoAmI() sau khi đã lưu accessToken
        final userData = await _userService.whoAmI();

        if (userData.statusCode != 200) {
          throw Exception("Failed to fetch user data: ${userData.statusCode}");
        }
        final userDataJson = jsonDecode(userData.body);
        final String? email = userDataJson["email"];
        if (email == null || email.isEmpty) {
          throw Exception("User email not found.");
        }

        FFAppState().email = email;

        // Chuyển hướng sau khi hiển thị thông báo
        await Future.delayed(Duration(seconds: 1));

        final String? name = userDataJson["name"];
        final String? gender = userDataJson["gender"];
        final String? age = userDataJson["age"];
        final String? address = userDataJson["address"];
        if(name == null || name.isEmpty || gender == null || gender.isEmpty ||
            age == null || age.isEmpty || address == null || address.isEmpty){
          context.push("/profileEnterScreen");
        }
        else {
          context.push("/bottomNavbarScreen");
        }
      } else {
        print("Login failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error during Facebook login: $e");
    }
  }

  Future<void> setDataAfterLogin(String accessToken, String refreshToken) async {
    final storage = FlutterSecureStorage();

    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);

    FFAppState().isLogin = true;

    print("User data saved successfully.");
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
