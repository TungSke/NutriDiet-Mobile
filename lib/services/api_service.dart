import 'dart:convert';
import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://nutridietapi-be.azurewebsites.net";
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> getAccessToken(BuildContext context) async {
    String? token = await storage.read(key: "accessToken");

    if (token == null || token.isEmpty) {
      _showLoginRequiredDialog(context);
      return null;
    }

    return token;
  }

  Future<String?> getRefreshToken(BuildContext context) async {
    String? token = await storage.read(key: "refreshToken");

    if (token == null || token.isEmpty) {
      _showLoginRequiredDialog(context);
      return null;
    }

    return token;
  }

  void _showLoginRequiredDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Yêu cầu đăng nhập"),
          content: const Text("Bạn cần đăng nhập để thực hiện hành động này."),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pushNamed("login_screen");
              },
              child: const Text("Đăng nhập"),
            ),
          ],
        ),
      );
    });
  }

  /// Hàm GET - Đọc dữ liệu
  Future<http.Response> get(String endpoint, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    );
    return response;
  }

  /// Hàm POST - Tạo mới dữ liệu
  Future<http.Response> post(String endpoint, {required Map<String, dynamic> body, String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return response;
  }

  /// Hàm PUT - Cập nhật dữ liệu
  Future<http.Response> put(String endpoint, {required Map<String, dynamic> body, String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return response;
  }

  /// Hàm DELETE - Xóa dữ liệu
  Future<http.Response> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    );
    return response;
  }

  /// Tạo headers kèm Authorization nếu có token
  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Xử lý response chung cho GET
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }
}