import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'models/allergy.dart';

class AllergyService {
  final ApiService _apiService = ApiService();

  Future<http.Response> getAllAllergies({
    required int pageIndex,
    required int pageSize,
  }) async {
    try {
      final response = await _apiService
          .get("api/allergy?pageIndex=$pageIndex&pageSize=$pageSize");

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error fetching allergies: $e");
      throw Exception("Không thể lấy danh sách dị ứng.");
    }
  }

  Future<List<Allergy>> parseAllergies(http.Response response) async {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => Allergy.fromJson(e)).toList();
    }

    if (response.statusCode == 204) {
      return [];
    }

    throw Exception(
        'Lỗi lấy danh sách dị ứng: ${response.statusCode}, ${response.body}');
  }

  /// 🔹 **Hàm mới**: Lấy danh sách dị ứng dưới dạng `Map` để hiển thị UI
  Future<List<Map<String, dynamic>>> fetchAllergyLevelsData() async {
    try {
      final response = await getAllAllergies(pageIndex: 1, pageSize: 20);
      final List<Allergy> allergies = await parseAllergies(response);

      return allergies.map((allergy) {
        return {
          'id': allergy.allergyId ?? -1,
          'title': allergy.allergyName ?? "Không xác định",
          'notes': allergy.notes ?? "Không có mô tả"
        };
      }).toList();
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách dị ứng: $e");
      return [];
    }
  }
}
