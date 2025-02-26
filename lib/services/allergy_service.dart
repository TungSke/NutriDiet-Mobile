import 'dart:convert';

import 'api_service.dart';
import 'models/allergy.dart';

class AllergyService {
  final ApiService _apiService = ApiService();

  Future<List<Allergy>> getAllAllergies(
      {required int pageIndex, required int pageSize}) async {
    try {
      final response = await _apiService
          .get("api/allergy?pageIndex=$pageIndex&pageSize=$pageSize");

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        return data.map((e) => Allergy.fromJson(e)).toList();
      }

      if (response.statusCode == 204) return [];

      throw Exception(
          'Failed to load allergies: ${response.statusCode}, ${response.body}');
    } catch (e) {
      print("Error fetching allergies: $e");
      return [];
    }
  }
}
