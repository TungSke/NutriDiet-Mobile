import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';

import 'models/mealplan.dart';

class MealPlanService{
  final ApiService _apiService = ApiService();

  Future<List<MealPlan>> getSampleMealPlan({required int pageIndex, required int pageSize, String? search}) async {
    try {
      String endpoint = "api/meal-plan/sample-mealplan?pageIndex=$pageIndex&pageSize=$pageSize";
      if (search != null && search.isNotEmpty) {
        endpoint += "&search=${Uri.encodeComponent(search)}";
      }

      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> mealPlansJson = data['data'] ?? [];
        return mealPlansJson.map((e) => MealPlan.fromJson(e)).toList();
      }

      if (response.statusCode == 204) return [];

      throw Exception('Lỗi lấy danh sách Meal Plan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API GetSampleMealPlan: $e");
      return [];
    }
  }
}