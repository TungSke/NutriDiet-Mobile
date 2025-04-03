import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    debugPrint("fcmToken: ${fcmToken}");
    return response;
  }

  Future<http.Response> loginWithGoogle(String? fcmToken) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      await googleSignIn.signOut();
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      if (signInAccount == null) {
        throw Exception("Đăng nhập Google đã bị hủy");
      }
      final GoogleSignInAuthentication googleAuth =
          await signInAccount.authentication;
      final response = await _apiService.post(
          "api/user/login-with-google?idToken=${googleAuth.idToken}&fcmToken=$fcmToken",
          body: {});

      //print("response: ${response.body}");
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
    final response = await _apiService.get("api/user/whoami", token: token);
    return response;
  }

  // Future<http.Response> updateUser({
  //   required String fullName,
  //   required int age,
  //   required String gender,
  //   required String location,
  // }) async {
  //   final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  //   final String? token = await flutterSecureStorage.read(key: 'accessToken');
  //
  //   if (token == null || token.isEmpty) {
  //     throw Exception("Access token not found.");
  //   }
  //
  //   final Map<String, dynamic> body = {
  //     "fullName": fullName,
  //     "age": age,
  //     "gender": gender,
  //     "location": location,
  //   };
  //   print("Request body: ${jsonEncode(body)}");
  //
  //   final response = await _apiService.put(
  //     "/api/user",
  //     token: token,
  //     body: body,
  //   );
  //
  //   return response;
  // }
  Future<http.Response> updateUser({
    required String fullName,
    required int age,
    required String gender,
    required String location,
    required String avatar, // Sửa: avatar giờ sẽ là đường dẫn file
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${_apiService.baseUrl}/api/user"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // ✅ Thêm các dữ liệu vào Form-Data
      request.fields['FullName'] = fullName;
      request.fields['Age'] = age.toString();
      request.fields['Gender'] = gender;
      request.fields['Location'] = location;

      // ✅ Nếu có avatar, gửi nó dưới dạng file
      if (avatar.isNotEmpty) {
        var avatarFile = await http.MultipartFile.fromPath(
          'Avatar',
          avatar, // Đây là đường dẫn đến file
          contentType: MediaType('image',
              'png'), // Nếu là ảnh PNG, bạn có thể thay đổi theo loại ảnh bạn có
        );
        request.files.add(avatarFile); // Thêm avatar vào request
      }

      print("🔹 Sending update user request: ${jsonEncode(request.fields)}");

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      print("🔹 Response status: ${httpResponse.statusCode}");
      print("🔹 Response body: ${httpResponse.body}");

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 204) {
        return httpResponse;
      } else {
        throw Exception(
            "Cập nhật mục tiêu cá nhân thất bại: ${httpResponse.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật người dùng: $e");
      throw Exception("Không thể cập nhật người dùng.");
    }
  }

  Future<http.Response> getHealthProfileReport() async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      final response = await _apiService
          .get("api/health-profile/reports?field=Weight", token: token);

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
    double? height, // Use double instead of int
    double? weight, // Use double instead of int
    String? activityLevel,
    String? aisuggestion,
    String? dietStyle,
    List<dynamic>? allergies,
    List<dynamic>? diseases,
  }) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠️ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      // If any value is null, fetch data from health-profile
      if ([
        height,
        weight,
        activityLevel,
        dietStyle,
        aisuggestion,
        allergies,
        diseases
      ].any((e) => e == null)) {
        final healthProfileResponse = await getHealthProfile();
        if (healthProfileResponse.statusCode == 200) {
          final Map<String, dynamic> healthProfile =
              jsonDecode(healthProfileResponse.body);

          height ??= double.tryParse(healthProfile['height']?.toString() ?? '');
          weight ??= double.tryParse(healthProfile['weight']?.toString() ?? '');
          activityLevel ??= healthProfile['activityLevel']?.toString();
          aisuggestion ??= healthProfile['aisuggestion']?.toString();
          dietStyle ??= healthProfile['dietStyle']?.toString();
          allergies ??= (healthProfile['allergies'] as List?)
                  ?.map((e) => int.tryParse(e['allergyId'].toString()) ?? 0)
                  .where((e) => e > 0)
                  .toList() ??
              [];

          diseases ??= (healthProfile['diseases'] as List?)
                  ?.map((e) => int.tryParse(e['diseaseId'].toString()) ?? 0)
                  .where((e) => e > 0)
                  .toList() ??
              [];
        }
      }

      // Create the update request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${_apiService.baseUrl}/api/health-profile"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add fields if not null
      if (height != null) request.fields['Height'] = height.toString();
      if (weight != null) request.fields['Weight'] = weight.toString();
      if (activityLevel != null)
        request.fields['ActivityLevel'] = activityLevel;
      if (dietStyle != null) request.fields['DietStyle'] = dietStyle;
      if (aisuggestion != null) request.fields['Aisuggestion'] = aisuggestion;

      // Add allergies and diseases if not empty
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

      // Debug log before sending request
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

  // Cập nhật mục tiêu cá nhân
  Future<http.Response> updatePersonalGoal({
    required String goalType,
    required double targetWeight, // Sử dụng double thay vì int
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
      request.fields['TargetWeight'] =
          targetWeight.toString(); // Chuyển double thành String
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
      final response = await _apiService.get("api/personal-goal", token: token);

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

  Future<http.Response> updateDailyMacronutrients({
    required double dailyCarb,
    required double dailyFat,
    required double dailyProtein,
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
        Uri.parse(
            "${_apiService.baseUrl}/api/personal-goal/daily-macronutrients"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Thêm dữ liệu vào Form-Data
      request.fields['DailyCarb'] = dailyCarb.toString();
      request.fields['DailyFat'] =
          dailyFat.toString(); // Chuyển double thành String
      request.fields['DailyProtein'] = dailyProtein.toString();

      print(
          "🔹 Sending updateDailyMacronutrients request: ${jsonEncode(request.fields)}");

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
      print("❌ Lỗi khi cập nhật dinh dưỡng: $e");

      // Chỉ hiển thị thông báo lỗi mặc định nếu không có lỗi từ API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Đã xảy ra lỗi, vui lòng thử lại."), // Thông báo lỗi mặc định
          duration: Duration(seconds: 3),
        ),
      );

      return http.Response(
          "Không thể cập nhật dinh dưỡng", 500); // Trả về HTTP response lỗi
    }
  }

  Future<http.Response> createAiSuggestion(String token) async {
    try {
      final response = await http.post(
        Uri.parse("${_apiService.baseUrl}/api/health-profile/ai-suggestion"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

  Future<bool> isPremium() async {
    try {
      final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      final String? accessToken =
          await flutterSecureStorage.read(key: 'accessToken');

      if (accessToken == null) {
        throw Exception("No access token available");
      }
      final response =
          await _apiService.get("api/user/is-premium", token: accessToken);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        bool isPremium = responseData['data'] as bool;
        return isPremium;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Please log in again.");
      } else {
        throw Exception(
            "Failed to check premium status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
