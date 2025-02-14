import 'dart:convert';

import 'package:fitnessapp/models/request/register_request.dart';
import 'package:fitnessapp/models/response/login_response.dart';
import 'package:fitnessapp/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<LoginResponse> Login(String email, String password) async {
    final response = await _apiService.post(
      'api/user/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> Register(String email, String password) async {
    final response = await _apiService.post(
      "api/user/register",
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
