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
      return [];
    }
  }

  Future<MealPlan?> getMealPlanById(int mealPlanId) async {
    try {
      String endpoint = "api/meal-plan/$mealPlanId";
      final response = await _apiService.get(endpoint);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MealPlan.fromJson(data['data']);
      }
      if (response.statusCode == 404) {
        return null;
      }
      throw Exception('Lỗi lấy Meal Plan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return null;
    }
  }

  Future<List<MealPlan>> getMyMealPlan({required int pageIndex, required int pageSize, String? search}) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

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
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  Future<Map<String, dynamic>?> getMealPlanDetailTotals(int mealPlanId) async {
    try {
      String endpoint = "api/meal-plan-detail/meal-plan-detail-total/$mealPlanId";
      final response = await _apiService.get(endpoint);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Trả về phần "data" chứa totalByMealType và totalByDayNumber
      }

      if (response.statusCode == 404) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  Future<bool> deleteMealPlan(int mealPlanId) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    try {
      String endpoint = "api/meal-plan/$mealPlanId";
      final response = await _apiService.delete(endpoint, token: token);
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Lỗi xóa Meal Plan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return false;
    }
  }
  Future<bool> cloneSampleMealPlan(int mealPlanId) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');
    try {
      String endpoint = "api/meal-plan/clone?mealPlanId=$mealPlanId";
      final response = await _apiService.post(endpoint,body: {}, token: token);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['Message'] ?? 'Lỗi không xác định từ server';
        throw Exception('Lỗi sao chép Meal Plan: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      return false;
    }
  }
  Future<Map<String, dynamic>> applyMealPlan(int mealPlanId) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');
    try {
      String endpoint = "api/meal-plan/apply-mealplan/$mealPlanId";
      final response = await _apiService.put(endpoint, body: {}, token: token);
      if (response.statusCode == 201) {
        return {'success': true, 'errorMessage': null};
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Lỗi không xác định từ server';
        return {'success': false, 'errorMessage': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'errorMessage': e.toString()};
    }
  }
}
