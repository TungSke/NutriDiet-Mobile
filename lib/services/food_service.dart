import 'dart:convert';

import 'api_service.dart';
import 'models/food.dart';
import 'package:http/http.dart' as http;

class FoodService {
  final ApiService _apiService = ApiService();

  Future<List<Food>> getAllFoods(
      {required int pageIndex, required int pageSize}) async {
    try {
      final response = await _apiService
          .get("api/food?pageIndex=$pageIndex&pageSize=$pageSize");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        return data.map((e) => Food.fromJson(e)).toList();
      }

      if (response.statusCode == 204) return [];

      throw Exception(
          'Failed to load allergies: ${response.statusCode}, ${response.body}');
    } catch (e) {
      print("Error fetching allergies: $e");
      return [];
    }
  }

  Future<http.Response> getFoodById({required int foodId}) async {
      final response = await _apiService.get("api/food/$foodId");
      return response;
  }
}
