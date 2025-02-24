import 'package:http/http.dart' as http;
import 'package:diet_plan_app/services/api_service.dart';
class UserService {
  final ApiService _apiService = ApiService();

  Future<http.Response> Register(String email, String password) async {
    final response = await _apiService.post(
      "api/user/register",
      body: {'email': email, 'password': password},
    );
    return response;
  }

  Future<http.Response> VerifyAccount(String email, String otp) async{
    final response = await _apiService.post(
      "api/user/verify-account",
      body: {'email': email, 'otp': otp},
    );
    return response;
  }

  Future<http.Response> ResendOTP(String email) async{
    final response = await _apiService.post(
      "api/user/resend-otp",
      body: {'email': email},
    );
    return response;
  }

}
