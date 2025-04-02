import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PackageService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  Future<dynamic> fetchPackagePayment({
    String packageId = "1",
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
