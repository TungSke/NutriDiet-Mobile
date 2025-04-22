import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PackageService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  // Lấy danh sách gói Premium
  Future<List<dynamic>> getPackages() async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final response = await _apiService.get(
      'api/package',
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Lỗi khi lấy danh sách gói: ${response.statusCode} - ${response.body}");
    }
  }

  // Lấy thông tin gói người dùng đang sử dụng
  Future<Map<String, dynamic>?> getMyUserPackage() async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final response = await _apiService.get(
      'api/package/my-package',
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else if (response.statusCode == 404) {
      // Không tìm thấy gói, trả về null
      return null;
    } else {
      throw Exception("Lỗi khi lấy thông tin gói người dùng: ${response.statusCode} - ${response.body}");
    }
  }

  // Kiểm tra trạng thái Premium
  Future<Map<String, dynamic>> isPremium() async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final response = await _apiService.get(
      'api/user/is-advanced-premium',
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Lỗi khi kiểm tra trạng thái Premium: ${response.statusCode} - ${response.body}");
    }
  }

  // Thanh toán gói mới
  Future<dynamic> fetchPackagePayment({
    required int packageId,
    String cancelUrl = "https://yourapp.com/checkoutFailScreen",
    String returnUrl = "https://yourapp.com/checkoutSuccessScreen",
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

  // Nâng cấp gói
  Future<dynamic> upgradePackage({
    required int packageId,
    String cancelUrl = "https://yourapp.com/checkoutFailScreen",
    String returnUrl = "https://yourapp.com/checkoutSuccessScreen",
  }) async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final Uri url = Uri.parse(
      "${_apiService.baseUrl}/api/package/payment-upgrade?cancelUrl=${Uri.encodeComponent(cancelUrl)}&returnUrl=${Uri.encodeComponent(returnUrl)}&packageId=$packageId",
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

  // Callback thanh toán PayOS
  Future<http.Response> payosCallback(String status) async {
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token không hợp lệ");
    }

    final Uri url = Uri.parse(
      "${_apiService.baseUrl}/api/package/payos-callback?status=$status",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
        body: '',
      );
      print("payosCallback response: ${response.statusCode} ${response.body}");
      return response;
    } catch (e) {
      print("Error in payosCallback: $e");
      rethrow;
    }
  }
}