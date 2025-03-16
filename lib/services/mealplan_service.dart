import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<MealPlan?> getMealPlanById(int mealPlanId) async {
    try {
      String endpoint = "api/meal-plan/$mealPlanId";
      final response = await _apiService.get(endpoint);

      print("API Response for mealPlanId $mealPlanId: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Parsed data: ${data['data']}");
        return MealPlan.fromJson(data['data']);
      }

      if (response.statusCode == 404) {
        debugPrint("Meal Plan không tồn tại.");
        return null;
      }

      throw Exception('Lỗi lấy Meal Plan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API GetMealPlanById: $e");
      return null;
    }
  }

  Future<List<MealPlan>> getMyMealPlan({required int pageIndex, required int pageSize, String? search}) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    // Nếu accessToken null -> Trả về danh sách rỗng ngay lập tức
    if (token == null) {
      debugPrint("Access token null, trả về danh sách rỗng.");
      return [];
    }

    try {
      String endpoint = "api/meal-plan/my-mealplan?pageIndex=$pageIndex&pageSize=$pageSize";
      if (search != null && search.isNotEmpty) {
        endpoint += "&search=${Uri.encodeComponent(search)}";
      }

      final response = await _apiService.get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> mealPlansJson = data['data'] ?? [];
        final mealPlans = mealPlansJson.map((e) => MealPlan.fromJson(e)).toList();
        return mealPlans;
      } else {
        debugPrint("API trả về lỗi: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API GetMyMealPlan: $e");
      return [];
    }
  }


  Future<Map<String, dynamic>?> getMealPlanDetailTotals(int mealPlanId) async {
    try {
      String endpoint = "api/meal-plan-detail/meal-plan-detail-total/$mealPlanId";
      final response = await _apiService.get(endpoint);

      print("API Response for mealPlanDetailTotals $mealPlanId: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Trả về phần "data" chứa totalByMealType và totalByDayNumber
      }

      if (response.statusCode == 404) {
        debugPrint("Meal Plan totals không tồn tại.");
        return null;
      }

      throw Exception('Lỗi lấy Meal Plan Totals: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API GetMealPlanDetailTotals: $e");
      return null;
    }
  }
  Future<bool> deleteMealPlan(int mealPlanId) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    try {
      String endpoint = "api/meal-plan/$mealPlanId";
      final response = await _apiService.delete(endpoint, token: token);

      print("API Response for deleteMealPlan $mealPlanId: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("Xóa Meal Plan $mealPlanId thành công");
        return true;
      }

      throw Exception('Lỗi xóa Meal Plan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API DeleteMealPlan: $e");
      return false;
    }
  }
}
