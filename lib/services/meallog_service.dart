import 'dart:convert';
import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/meallog.dart';

class MeallogService {
  final ApiService _apiService = ApiService();

  // Hàm GET MealLogs (đã có)
  Future<List<MealLog>> getMealLogs({
    String? logDate,
    String? fromDate,
    String? toDate,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      String endpoint = "api/meal-log?";
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

  // Hàm POST tạo mới Meal Log (đã có)
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
      Map<String, String> formData = {
        'LogDate': logDate,
        'MealType': mealType,
        'ServingSize': servingSize,
        'FoodId': foodId.toString(),
        'Quantity': quantity.toString(),
      };
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

  // Hàm DELETE Meal Log Detail (đã có)
  Future<bool> deleteMealLogDetail({
    required int mealLogId,
    required int detailId,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final endpoint = 'api/meal-log/$mealLogId/detail/$detailId';
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

  Future<bool> quickAddMeal({
    required DateTime logDate,
    required String mealType,
    required int calories,
    required int carbohydrates,
    required int fats,
    required int protein,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Dữ liệu form-data
      Map<String, String> formData = {
        'LogDate': logDate.toIso8601String(), // "2025-03-19T05:37:48.444Z"
        'MealType': mealType, // "Breakfast", "Lunch", ...
        'Calories': calories.toString(),
        'Carbohydrates': carbohydrates.toString(),
        'Fats': fats.toString(),
        'Protein': protein.toString(),
      };

      final response = await _apiService.postMultipart(
        "api/meal-log/quick",
        body: formData,
        token: token,
      );

      debugPrint(
          "API quickAddMeal: Status ${response.statusCode}, Body: ${response.body}");

      // Thành công có thể là 200 hoặc 201, tùy backend
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Lỗi quickAddMeal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API quickAddMeal: $e");
      return false;
    }
  }

  Future<bool> transferMealLogDetail({
    required int detailId,
    required String targetMealType,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Xây dựng endpoint với query parameter targetMealType
      final String endpoint =
          'api/meal-log/detail/transfer/$detailId?targetMealType=$targetMealType';

      // Vì API không cần body nên ta truyền {}.
      final response = await _apiService.put(endpoint, body: {}, token: token);
      debugPrint(
          "API transferMealLogDetail: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
            'Lỗi transferMealLogDetail: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API transferMealLogDetail: $e");
      return false;
    }
  }

  Future<bool> addMealToMultipleDays({
    required List<DateTime> dates,
    required int foodId,
    required double quantity,
    required String mealType,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Tạo danh sách fields
      final fields = <MapEntry<String, String>>[];

      // Thay vì encode JSON, ta gán dạng "Dates[0]", "Dates[1]", ...
      // để server parse thành List<DateTime> (nếu dùng ASP.NET)
      for (int i = 0; i < dates.length; i++) {
        final key = 'Dates[$i]';
        final value = dates[i].toIso8601String();
        fields.add(MapEntry(key, value));
      }

      // Thêm các trường khác
      fields.add(MapEntry('FoodId', foodId.toString()));
      fields.add(MapEntry('Quantity', quantity.toString()));
      fields.add(MapEntry('MealType', mealType));

      // Gọi hàm postMultipartWithList
      final response = await _apiService.postMultipartWithList(
        "api/meal-log/multiple-days",
        fields: fields,
        token: token,
      );

      debugPrint("API addMealToMultipleDays: "
          "Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Lỗi addMealToMultipleDays: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API addMealToMultipleDays: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getNutritionSummary({
    required String date, // VD: "2025-3-20"
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Xây dựng endpoint với query parameter date
      final String endpoint = 'api/meal-log/nutrition?date=$date';
      final response = await _apiService.get(endpoint, token: token);
      debugPrint(
          "API getNutritionSummary: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception(
            "Lỗi khi lấy nutrition summary: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Lỗi trong getNutritionSummary: $e");
      throw Exception("Lỗi trong getNutritionSummary: $e");
    }
  }
}
