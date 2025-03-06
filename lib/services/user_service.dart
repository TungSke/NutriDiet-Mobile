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
      body: body,
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

  Future<http.Response> getHealthProfile() async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      final response =
          await _apiService.get("/api/health-profile", token: token);

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Lỗi lấy health profile: ${response.body}');
        throw Exception('Lỗi lấy health profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối API: $e');
      throw Exception("Không thể kết nối đến server.");
    }
  }

  Future<http.Response> updateHealthProfile({
    String? fullName,
    int? age,
    String? gender,
    String? location,
    int? height,
    int? weight,
    String? activityLevel,
    String? aisuggestion,
    List<String>? allergies,
    List<String>? diseases,
  }) async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      // 🔹 Lấy thông tin user nếu thiếu
      if ([fullName, age, gender, location].any((e) => e == null)) {
        final userResponse = await whoAmI();
        if (userResponse.statusCode == 200) {
          final Map<String, dynamic> userData = jsonDecode(userResponse.body);
          fullName ??= userData['name'];
          age ??= int.tryParse(userData['age']?.toString() ?? '0');
          gender ??=
              userData['gender'] == "not specified" ? null : userData['gender'];
          location ??= userData['address'];
        }
      }

      // 🔹 Nếu có giá trị nào bị null, lấy dữ liệu từ health-profile
      if ([height, weight, activityLevel, aisuggestion, allergies, diseases]
          .any((e) => e == null)) {
        final healthProfileResponse = await getHealthProfile();
        if (healthProfileResponse.statusCode == 200) {
          final Map<String, dynamic> healthProfile =
              jsonDecode(healthProfileResponse.body);

          height ??= int.tryParse(healthProfile['height']?.toString() ?? '');
          weight ??= int.tryParse(healthProfile['weight']?.toString() ?? '');
          activityLevel ??= healthProfile['activityLevel']?.toString();
          aisuggestion ??= healthProfile['aisuggestion']?.toString();

          // ✅ Chắc chắn lấy danh sách dị ứng nếu chưa có
          allergies ??= (healthProfile['allergies'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          diseases ??= (healthProfile['diseases'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
        }
      }

      // 🔹 Tạo request cập nhật
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${_apiService.baseUrl}/api/health-profile"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      if (fullName != null) request.fields['FullName'] = fullName;
      if (age != null) request.fields['Age'] = age.toString();
      if (gender != null) request.fields['Gender'] = gender;
      if (location != null) request.fields['Location'] = location;
      if (height != null) request.fields['Height'] = height.toString();
      if (weight != null) request.fields['Weight'] = weight.toString();
      if (activityLevel != null)
        request.fields['ActivityLevel'] = activityLevel;
      if (aisuggestion != null) request.fields['Aisuggestion'] = aisuggestion;

      // 🔹 Gửi allergies và diseases dưới dạng JSON string
      if (allergies != null && allergies.isNotEmpty) {
        request.fields['AllergyNames'] = jsonEncode(allergies);
      }

      if (diseases != null && diseases.isNotEmpty) {
        request.fields['DiseasesNames'] = jsonEncode(diseases);
      }
      print(
          "🔹 Sending updateHealthProfile request: ${jsonEncode(request.fields)}");

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      print("🔹 Response status: ${httpResponse.statusCode}");
      print("🔹 Response body: ${httpResponse.body}");

      if (httpResponse.statusCode != 200) {
        throw Exception("Cập nhật hồ sơ thất bại: ${httpResponse.body}");
      }

      return httpResponse;
    } catch (e) {
      print("❌ Lỗi khi cập nhật hồ sơ sức khỏe: $e");
      throw Exception("Không thể cập nhật hồ sơ sức khỏe.");
    }
  }

  Future<http.Response> getPersonalGoal() async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      final response =
          await _apiService.get("/api/personal-goal", token: token);

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Lỗi lấy personal-goal: ${response.body}');
        throw Exception('Lỗi lấy health profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối API: $e');
      throw Exception("Không thể kết nối đến server.");
    }
  }

  Future<http.Response> createPersonalGoal({
    String? goalType,
    double? targetWeight,
    String? weightChangeRate,
    String? goalDescription,
    String? notes,
  }) async {
    final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    final String? token = await _flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${_apiService.baseUrl}/api/personal-goal"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      if (goalType != null) request.fields['GoalType'] = goalType;
      if (targetWeight != null)
        request.fields['TargetWeight'] = targetWeight.toString();
      if (weightChangeRate != null)
        request.fields['WeightChangeRate'] = weightChangeRate;
      if (goalDescription != null)
        request.fields['GoalDescription'] = goalDescription;
      if (notes != null) request.fields['Notes'] = notes;

      print(
          "🔹 Sending createPersonalGoal request: ${jsonEncode(request.fields)}");

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      print("🔹 Response status: ${httpResponse.statusCode}");
      print("🔹 Response body: ${httpResponse.body}");

      if (httpResponse.statusCode != 200) {
        throw Exception("Tạo mục tiêu cá nhân thất bại: ${httpResponse.body}");
      }

      return httpResponse;
    } catch (e) {
      print("❌ Lỗi khi tạo mục tiêu cá nhân: $e");
      throw Exception("Không thể tạo mục tiêu cá nhân.");
    }
  }
}
