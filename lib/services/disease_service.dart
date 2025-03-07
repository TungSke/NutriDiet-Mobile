import 'dart:convert';

import 'package:diet_plan_app/services/models/disease.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class DiseaseService {
  final ApiService _apiService = ApiService();

  Future<http.Response> getAllDiseases({
    required int pageIndex,
    required int pageSize,
  }) async {
    try {
      final response = await _apiService
          .get("api/disease?pageIndex=$pageIndex&pageSize=$pageSize");

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error fetching disease: $e");
      throw Exception("Không thể lấy danh sách dị ứng.");
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
        'Lỗi lấy danh sách dị ứng: ${response.statusCode}, ${response.body}');
  }

  /// 🔹 **Hàm mới**: Lấy danh sách dị ứng dưới dạng `Map` để hiển thị UI
  Future<List<Map<String, dynamic>>> fetchDiseaseLevelsData() async {
    try {
      final response = await getAllDiseases(pageIndex: 1, pageSize: 20);
      final List<Disease> diseases = await parseDiseases(response);

      return diseases.map((disease) {
        return {
          'id': disease.diseaseId ?? -1,
          'title': disease.diseaseName ?? "Không xác định",
          'notes': disease.description ?? "Không có mô tả"
        };
      }).toList();
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách dị ứng: $e");
      return [];
    }
  }
}
