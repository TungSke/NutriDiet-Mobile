import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/material.dart';
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

  Future<http.Response> loginWithFacebook(String? fcmToken) async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    final AccessToken accessToken = result.accessToken!;

    final response = await _apiService.post(
        "api/user/login-with-facebook?idToken=${accessToken.tokenString}&fcmToken=$fcmToken",
        body: {});
    return response;
  }

  Future<http.Response> login(
      String email, String password, String? fcmToken) async {
    final response = await _apiService.post(
      "api/user/login",
      body: {'email': email, 'password': password, 'fcmToken': fcmToken},
    );
    return response;
  }

  Future<http.Response> loginWithGoogle(String? fcmToken) async {
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
          "api/user/login-with-google?idToken=${googleAuth.idToken}&fcmToken=$fcmToken",
          body: {});

      return response;
    } catch (e) {
      throw Exception("Google login failed: $e");
    }
  }

  Future<http.Response> whoAmI() async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    final String? token = await flutterSecureStorage.read(key: 'accessToken');
    if (token == null || token.isEmpty) {
      throw Exception("Access token not found.");
    }
    final response = await _apiService.get("/api/user/whoami", token: token);
    return response;
  }

  Future<http.Response> updateUser({
    required String fullName,
    required int age,
    required String gender,
    required String location,
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

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

  Future<http.Response> getHealthProfileReport() async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      final response = await _apiService
          .get("/api/health-profile/reports?field=Weight", token: token);

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Lỗi lấy health profile report: ${response.body}');
        throw Exception(
            'Lỗi lấy health profile report: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối API: $e');
      throw Exception("Không thể kết nối đến server.");
    }
  }

  Future<http.Response> getHealthProfile() async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

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
    int? height,
    int? weight,
    String? activityLevel,
    String? aisuggestion,
    List<int>? allergies,
    List<int>? diseases,
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      // 🔹 Lấy thông tin user nếu thiếu

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

          allergies ??= (healthProfile['allergies'] as List?)
                  ?.map((e) => int.tryParse(e['allergyId'].toString()) ?? 0)
                  .where((e) => e > 0) // Lọc giá trị hợp lệ
                  .toList() ??
              [];

          diseases ??= (healthProfile['diseases'] as List?)
                  ?.map((e) => int.tryParse(e['diseaseId'].toString()) ?? 0)
                  .where((e) => e > 0)
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

      if (height != null) request.fields['Height'] = height.toString();
      if (weight != null) request.fields['Weight'] = weight.toString();
      if (activityLevel != null) {
        request.fields['ActivityLevel'] = activityLevel;
      }
      if (aisuggestion != null) request.fields['Aisuggestion'] = aisuggestion;

      // ✅ Sửa lỗi gửi danh sách `allergies` và `diseases`
      // ✅ Gửi đúng định dạng `multipart/form-data`
      if (allergies != null && allergies.isNotEmpty) {
        for (int i = 0; i < allergies.length; i++) {
          request.fields['AllergyIds[$i]'] = allergies[i].toString();
        }
      }
      if (diseases != null && diseases.isNotEmpty) {
        for (int i = 0; i < diseases.length; i++) {
          request.fields['DiseaseIds[$i]'] = diseases[i].toString();
        }
      }

      // 🛠 Debug log trước khi gửi request
      print("🔹 Request updateHealthProfile: ${jsonEncode(request.fields)}");

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

  Future<http.Response> createPersonalGoal({
    required String goalType,
    required double targetWeight,
    required String weightChangeRate,
    String goalDescription = "Mục tiêu mặc định",
    String notes = "Không có ghi chú",
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      var request = http.MultipartRequest(
        'POST', // ✅ Chuyển từ POST sang PUT

        Uri.parse("${_apiService.baseUrl}/api/personal-goal"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // ✅ Thêm dữ liệu vào Form-Data
      request.fields['GoalType'] = goalType;
      request.fields['TargetWeight'] = targetWeight.toString();
      request.fields['WeightChangeRate'] = weightChangeRate;

      // ✅ Kiểm tra và gửi `GoalDescription` và `Notes`
      if (goalDescription.isNotEmpty) {
        request.fields['GoalDescription'] = goalDescription;
      } else {
        request.fields['GoalDescription'] = "Mục tiêu mặc định";
      }

      if (notes.isNotEmpty) {
        request.fields['Notes'] = notes;
      } else {
        request.fields['Notes'] = "Không có ghi chú";
      }

      print(
          "🔹 Sending updatePersonalGoal request: ${jsonEncode(request.fields)}");

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      print("🔹 Response status: ${httpResponse.statusCode}");
      print("🔹 Response body: ${httpResponse.body}");

      if (httpResponse.statusCode == 201 || httpResponse.statusCode == 204) {
        return httpResponse;
      } else {
        throw Exception(
            "Cập nhật mục tiêu cá nhân thất bại: ${httpResponse.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật mục tiêu cá nhân: $e");
      throw Exception("Không thể cập nhật mục tiêu cá nhân.");
    }
  }

  Future<http.Response> updatePersonalGoal({
    required String goalType,
    required int targetWeight,
    required String weightChangeRate,
    String goalDescription = "Mục tiêu mặc định",
    String notes = "Không có ghi chú",
    required BuildContext context, // Thêm context vào tham số
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      print("❌ Access token không hợp lệ, vui lòng đăng nhập lại.");
      // Hiển thị snackbar khi token không hợp lệ, và không cần ném lỗi nữa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Access token không hợp lệ, vui lòng đăng nhập lại."),
          duration: Duration(seconds: 3),
        ),
      );
      return http.Response('', 400); // Trả về HTTP response lỗi
    }

    try {
      var request = http.MultipartRequest(
        'PUT', // Sử dụng PUT để cập nhật
        Uri.parse("${_apiService.baseUrl}/api/personal-goal"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Thêm dữ liệu vào Form-Data
      request.fields['GoalType'] = goalType;
      request.fields['TargetWeight'] = targetWeight.toString();
      request.fields['WeightChangeRate'] = weightChangeRate;

      // Kiểm tra và gửi `GoalDescription` và `Notes`
      request.fields['GoalDescription'] =
          goalDescription.isNotEmpty ? goalDescription : "Mục tiêu mặc định";
      request.fields['Notes'] = notes.isNotEmpty ? notes : "Không có ghi chú";

      print(
          "🔹 Sending updatePersonalGoal request: ${jsonEncode(request.fields)}");

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      print("🔹 Response status: ${httpResponse.statusCode}");
      print("🔹 Response body: ${httpResponse.body}");

      // Kiểm tra trạng thái mã phản hồi
      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 204) {
        // Hiển thị SnackBar thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Cập nhật thành công!"), // Hiển thị thông báo thành công
            backgroundColor: Colors.green, // Màu xanh cho thành công
            duration: Duration(seconds: 3),
          ),
        );
        return httpResponse;
      } else {
        // Xử lý lỗi khi mã lỗi không phải là 200 hoặc 204
        final responseBody = jsonDecode(httpResponse.body);
        String errorMessage = responseBody["message"] ?? "Cập nhật thất bại.";
        print("❌ Lỗi khi cập nhật mục tiêu cá nhân: $errorMessage");

        // Hiển thị Snackbar với thông báo lỗi từ API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, // Hiển thị thông báo lỗi từ API
            duration: Duration(seconds: 3),
          ),
        );

        return httpResponse; // Trả về HTTP response lỗi mà không cần ném lỗi
      }
    } catch (e) {
      // In ra lỗi chi tiết nếu có
      print("❌ Lỗi khi cập nhật mục tiêu cá nhân: $e");

      // Chỉ hiển thị thông báo lỗi mặc định nếu không có lỗi từ API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Đã xảy ra lỗi, vui lòng thử lại."), // Thông báo lỗi mặc định
          duration: Duration(seconds: 3),
        ),
      );

      return http.Response("Không thể cập nhật mục tiêu cá nhân.",
          500); // Trả về HTTP response lỗi
    }
  }

  Future<http.Response> getPersonalGoal() async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

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
}
