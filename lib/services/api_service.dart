import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
  Future<http.Response> post(String endpoint,
      {required Map<String, dynamic> body, String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return response;
  }

  // Hàm postMultipart dùng cho multipart/form-data
  Future<http.Response> postMultipart(String endpoint,
      {required Map<String, String> body, String? token}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('POST', uri);
    // Set header Authorization nếu có
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    // Thêm các field vào request
    request.fields.addAll(body);
    // Gửi request và chuyển đổi stream về Response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<http.Response> postMultipartWithFile(
    String endpoint, {
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // Nếu có token thì set vào header
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields.addAll(fields);
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final mimeSplit = mimeType.split('/');
    request.files.add(
      await http.MultipartFile.fromPath(
        fileFieldName,
        filePath,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      ),
    );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  /// Hàm PUT - Cập nhật dữ liệu
  Future<http.Response> put(String endpoint,
      {required Map<String, dynamic> body, String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> putMultipart(
    String endpoint, {
    required Map<String, String> fields,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('PUT', uri);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.fields.addAll(fields);
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
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
      throw Exception(
          'Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }

  Future<http.Response> postMultipartWithList(
    String endpoint, {
    required List<MapEntry<String, String>> fields,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('POST', uri);

    // Thêm header Authorization
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Ở đây, mỗi key (kể cả 'Dates[0]', 'Dates[1]', ...) sẽ được thêm vào request.fields
    // do request.fields là 1 Map, nếu có key trùng thì sẽ bị overwrite;
    // NHƯNG ta đã xử lý ở trên, mỗi ngày là 1 key riêng biệt => không bị ghi đè.
    for (final entry in fields) {
      request.fields[entry.key] = entry.value;
    }

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }
}
