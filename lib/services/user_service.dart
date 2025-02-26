import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<http.Response> register(String email, String password) async {
    final response = await _apiService.post(
      "api/user/register",
      body: {'email': email, 'password': password},
    );
    return response;
  }

  Future<http.Response> verifyAccount(String email, String otp) async {
    final response = await _apiService.post(
      "api/user/verify-account",
      body: {'email': email, 'otp': otp},
    );
    return response;
  }

  Future<http.Response> resendOTP(String email) async {
    final response = await _apiService.post(
      "api/user/resend-otp",
      body: {'email': email},
    );
    return response;
  }

  Future<http.Response> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    final AccessToken accessToken = result.accessToken!;

    final response = await _apiService.post(
          "api/user/login-with-facebook?idToken=${accessToken.tokenString}",
          body: {});
      return response;
  }

  Future<http.Response> login(String email, String password) async {
    final response = await _apiService.post(
      "api/user/login",
      body: {'email': email, 'password': password},
    );
    return response;
  }

  Future<http.Response> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      if (signInAccount == null) {
        throw Exception("Đăng nhập Google đã bị hủy");
      }
      final GoogleSignInAuthentication googleAuth = await signInAccount.authentication;

      final response = await _apiService.post(
          "api/user/login-with-google?idToken=${googleAuth.idToken
          }",
          body: {});

      return response;
    } catch (e) {
      throw Exception("Google login failed: $e");
    }
  }
  Future<http.Response> whoAmI() async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

    final String? token = await _flutterSecureStorage.read(key: 'accessToken');
    if (token == null || token.isEmpty) {
      throw Exception("Access token not found.");
    }
    final response = await _apiService.get("/api/user/whoami", token: token);
    return response;
  }
}
