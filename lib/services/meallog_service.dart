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
}
