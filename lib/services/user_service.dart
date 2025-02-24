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

  Future<http.Response> verifyAccount(String email, String otp) async{
    final response = await _apiService.post(
      "api/user/verify-account",
      body: {'email': email, 'otp': otp},
    );
    return response;
  }

  Future<http.Response> resendOTP(String email) async{
    final response = await _apiService.post(
      "api/user/resend-otp",
      body: {'email': email},
    );
    return response;
  }

  Future<void> loginWithFacebook() async{
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
    } else {
      print(result.status);
      print(result.message);
    }
  }

  Future<http.Response> login(String email, String password) async{
    final response = await _apiService.post(
      "api/user/login",
      body: {'email': email, 'password': password},
    );
    return response;
  }
}
