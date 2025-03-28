import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PackageService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  Future<http.Response> BuyPremiumPackage({
    required String packageId,
    required BuildContext context, // Thêm BuildContext vào tham số
  }) async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      print("❌ Access token không hợp lệ, vui lòng đăng nhập lại.");
      // Hiển thị snackbar khi token không hợp lệ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Access token không hợp lệ, vui lòng đăng nhập lại."),
          duration: Duration(seconds: 3),
        ),
      );
      return http.Response('', 400); // Trả về HTTP response lỗi
    }

    try {
      // Sử dụng http.post thay vì http.MultipartRequest
      final response = await http.post(
        Uri.parse(
            "${_apiService.baseUrl}/api/user/upgrade-package/${packageId}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
              'application/json', // Chỉ cần Content-Type là application/json
        },
        body: jsonEncode({
          'packageId': packageId,
        }),
      );

      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Hiển thị SnackBar thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thanh toán thành công!"),
            backgroundColor: Colors.green, // Màu xanh cho thành công
            duration: Duration(seconds: 3),
          ),
        );
        return response;
      } else {
        // Xử lý lỗi khi mã lỗi không phải là 200 hoặc 204
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody["message"] ?? "Thanh toán thất bại.";
        print("❌ Lỗi khi thanh toán: $errorMessage");

        // Hiển thị SnackBar với thông báo lỗi từ API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red, // Hiển thị thông báo lỗi từ API
            duration: Duration(seconds: 3),
          ),
        );

        return response; // Trả về HTTP response lỗi mà không cần ném lỗi
      }
    } catch (e) {
      // In ra lỗi chi tiết nếu có
      print("❌ Lỗi khi thanh toán: $e");

      // Hiển thị thông báo lỗi mặc định nếu không có lỗi từ API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã xảy ra lỗi, vui lòng thử lại."),
          duration: Duration(seconds: 3),
        ),
      );

      return http.Response(
          "Không thể thanh toán.", 500); // Trả về HTTP response lỗi
    }
  }

  Future<dynamic> fetchPackagePayment({
    String packageId = "1",
    String cancelUrl = "http://localhost:52060/checkoutFailScreen",
    String returnUrl = "http://localhost:52060/checkoutSuccessScreen",
  }) async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final Uri url = Uri.parse(
      "${_apiService.baseUrl}/api/package/payment?cancelUrl=${Uri.encodeComponent(cancelUrl)}&returnUrl=${Uri.encodeComponent(returnUrl)}&packageId=$packageId",
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
      body: '',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception("Lỗi API: ${response.statusCode} - ${response.body}");
    }
  }
}
