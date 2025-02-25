import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://nutridietapi-be.azurewebsites.net";

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