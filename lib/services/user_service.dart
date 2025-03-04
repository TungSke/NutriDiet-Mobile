import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

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
      final GoogleSignInAuthentication googleAuth =
          await signInAccount.authentication;

      final response = await _apiService.post(
          "api/user/login-with-google?idToken=${googleAuth.idToken}",
          body: {});

      return response;
    } catch (e) {
      throw Exception("Google login failed: $e");
    }
  }

  Future<http.Response> whoAmI() async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

    final String? token = await _flutterSecureStorage.read(key: 'accessToken');
    print("Token hiện tại: $token");
    if (token == null || token.isEmpty) {
      throw Exception("Access token not found.");
    }
    final response = await _apiService.get("/api/user/whoami", token: token);
    return response;
  }

  Future<http.Response> updateUser({
    required String fullName,
    required int? age,
    required String gender,
    required String? location,
  }) async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');
    print("Token hiện tại: $token");

    if (token == null || token.isEmpty) {
      throw Exception("Access token not found.");
    }

    final Map<String, dynamic> body = {
      "fullName": fullName,
      "age": age,
      "gender": gender,
      "location": location,
    };
    print("Request body: ${jsonEncode(body)}");

    final response = await _apiService.put(
      "/api/user",
      token: token,
      body: body, // Đảm bảo body đúng format JSON
    );

    return response;
  }

  Future<http.Response> updatePersonalGoal({
    required String goalType,
    required int? targetWeight,
    required String? weightChangeRate,
    required String goalDescription,
    required String? notes,
  }) async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token not found.");
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("${_apiService.baseUrl}/api/personal-goal"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['GoalType'] = goalType;
    if (targetWeight != null) {
      request.fields['TargetWeight'] = targetWeight.toString();
    }
    if (weightChangeRate != null) {
      request.fields['WeightChangeRate'] = weightChangeRate;
    }
    request.fields['GoalDescription'] = goalDescription;
    if (notes != null) {
      request.fields['Notes'] = notes;
    }

    print("Request body: ${request.fields}");

    final response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> updateHealthProfile({
    String? fullName,
    int? age,
    String? gender,
    String? location,
    required int? height,
    required int? weight,
    required String? activityLevel,
    required String? aisuggestion,
    required List<String> allergies,
    required List<String> diseases,
  }) async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    // 🔹 Nếu thiếu thông tin, gọi API lấy hồ sơ từ whoAmI
    if (fullName == null ||
        fullName.isEmpty ||
        age == null ||
        gender == null ||
        location == null) {
      final currentProfileResponse = await _apiService.get(
        "/api/user/whoami",
        token: token,
      );

      if (currentProfileResponse.statusCode != 200) {
        throw Exception("❌ Không thể lấy thông tin hồ sơ.");
      }

      final Map<String, dynamic> currentProfile =
          jsonDecode(currentProfileResponse.body);

      // ✅ Gán giá trị nếu chưa được truyền vào
      fullName ??= currentProfile['name']; // API trả về 'name'
      location ??= currentProfile['address']; // API trả về 'address'
      gender ??= currentProfile['gender'];
      age ??= int.tryParse(
          currentProfile['age']?.toString() ?? '0'); // Chuyển age sang int

      if (fullName == null || fullName.isEmpty) {
        throw Exception("⚠️ Tên không hợp lệ, vui lòng cập nhật hồ sơ trước.");
      }
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${_apiService.baseUrl}/api/health-profile"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['FullName'] = fullName;
    if (age != null) request.fields['Age'] = age.toString();
    if (gender != null) request.fields['Gender'] = gender;
    if (location != null) request.fields['Location'] = location;

    // 🔥 Đảm bảo `height` và `weight` được gửi đúng dạng số
    if (height != null) request.fields['Height'] = height.toString();
    if (weight != null) request.fields['Weight'] = weight.toString();

    if (activityLevel != null) request.fields['ActivityLevel'] = activityLevel;
    if (aisuggestion != null) request.fields['Aisuggestion'] = aisuggestion;

    for (var i = 0; i < allergies.length; i++) {
      request.fields['AllergyNames[$i]'] = allergies[i];
    }
    for (var i = 0; i < diseases.length; i++) {
      request.fields['DiseaseNames[$i]'] = diseases[i];
    }

    // 🔍 Log request để debug
    print("🔹 Sending updateHealthProfile request:");
    print("Headers: ${request.headers}");
    print("Fields: ${jsonEncode(request.fields)}");

    final response = await request.send();
    final httpResponse = await http.Response.fromStream(response);

    // 🔥 Log response để debug
    print("🔹 Response status: ${httpResponse.statusCode}");
    print("🔹 Response body: ${httpResponse.body}");

    if (httpResponse.statusCode != 200) {
      throw Exception("❌ Cập nhật hồ sơ thất bại: ${httpResponse.body}");
    }

    return httpResponse;
  }
}
