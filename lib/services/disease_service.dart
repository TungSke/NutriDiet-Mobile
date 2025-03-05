import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'models/disease.dart';

class DiseaseService {
  final ApiService _apiService = ApiService();

  Future<http.Response> getAllDiseases({
    required int pageIndex,
    required int pageSize,
  }) async {
    try {
      final response = await _apiService
          .get("api/disease?pageIndex=$pageIndex&pageSize=$pageSize");

      print("API Response Status: \${response.statusCode}");
      print("API Response Body: \${response.body}");

      return response;
    } catch (e) {
      print("Error fetching diseases: \$e");
      throw Exception("Không thể lấy danh sách bệnh.");
    }
  }

  Future<List<Disease>> parseDiseases(http.Response response) async {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => Disease.fromJson(e)).toList();
    }

    if (response.statusCode == 204) {
      return [];
    }

    throw Exception(
        'Lỗi lấy danh sách bệnh: \${response.statusCode}, \${response.body}');
  }
}
