import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Import file model meal_log.dart
import 'models/meallog.dart';

class MeallogService {
  final ApiService _apiService = ApiService();
  Future<List<MealLog>> getMealLogs({
    String? logDate,
    String? fromDate,
    String? toDate,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Tạo endpoint base
      String endpoint = "api/meal-log?";

      // Gắn tham số logDate, fromDate, toDate nếu có
      if (logDate != null && logDate.isNotEmpty) {
        endpoint += "logDate=$logDate&";
      }
      if (fromDate != null && fromDate.isNotEmpty) {
        endpoint += "fromDate=$fromDate&";
      }
      if (toDate != null && toDate.isNotEmpty) {
        endpoint += "toDate=$toDate&";
      }

      if (endpoint.endsWith('&') || endpoint.endsWith('?')) {
        endpoint = endpoint.substring(0, endpoint.length - 1);
      }
      final response = await _apiService.get(endpoint, token: token);

      debugPrint(
          "API getMealLogs: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> logsJson = data['data'] ?? [];
        return logsJson.map((e) => MealLog.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        debugPrint("No meal logs found (204).");
        return [];
      }

      throw Exception(
          'Lỗi lấy Meal Logs: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API getMealLogs: $e");
      return [];
    }
  }

  Future<bool> createMealLog({
    required String logDate,
    required String mealType,
    required String servingSize,
    required int foodId,
    required int quantity,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Chuẩn bị dữ liệu dạng form-data dưới dạng Map<String, String>
      Map<String, String> formData = {
        'LogDate': logDate,
        'MealType': mealType,
        'ServingSize': servingSize,
        'FoodId': foodId.toString(),
        'Quantity': quantity.toString(),
      };

      // Gọi API POST bằng postMultipart
      final response = await _apiService.postMultipart("api/meal-log",
          body: formData, token: token);
      debugPrint(
          "API createMealLog: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Lỗi tạo Meal Log: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API createMealLog: $e");
      return false;
    }
  }

  Future<bool> deleteMealLogDetail({
    required int mealLogId,
    required int detailId,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final endpoint = 'api/meal-log/$mealLogId/detail/$detailId';

      // Gọi hàm delete trong ApiService
      final response = await _apiService.delete(endpoint, token: token);

      debugPrint(
          "API deleteMealLogDetail: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Lỗi xóa Meal Log Detail: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API deleteMealLogDetail: $e");
      return false;
    }
  }
}
