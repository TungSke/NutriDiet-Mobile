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

}
