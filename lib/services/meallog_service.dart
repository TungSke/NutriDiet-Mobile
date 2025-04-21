import 'dart:convert';
import 'dart:io';
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
        'FoodName': "string",
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
    required String foodName,
    required int carbohydrates,
    required int fats,
    required int protein,
    required File? imageFile,
  }) async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');

    try {
      // 1. Chuẩn bị các field text
      final fields = <String, String>{
        'LogDate': logDate.toIso8601String(),
        'MealType': mealType,
        'Calories': calories.toString(),
        'FoodName': foodName,
        'Carbohydrates': carbohydrates.toString(),
        'Fats': fats.toString(),
        'Protein': protein.toString(),
      };

      // 2. Gọi ApiService.postMultipartWithFile
      final response = imageFile != null
          ? await _apiService.postMultipartWithFile(
              'api/meal-log/quick',
              fields: fields,
              fileFieldName: 'Image',
              filePath: imageFile.path,
              token: token,
            )
          : await _apiService.postMultipart(
              'api/meal-log/quick',
              body: fields,
              token: token,
            );

      debugPrint(
          'API quickAddMeal: Status ${response.statusCode}, Body: ${response.body}');

      // 3. Xử lý kết quả
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Lỗi quickAddMeal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi API quickAddMeal: $e');
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

  Future<List<MealLogDetail>> getMealLogAI() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      const String endpoint = 'api/meal-log/meallogai';
      final response = await _apiService.get(endpoint, token: token);

      debugPrint(
          "API getMealLogAI: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> logsJson = data['data'] ?? [];
        return logsJson.map((e) => MealLogDetail.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        debugPrint("No AI meal logs found (204).");
        return [];
      } else {
        throw Exception(
            'Lỗi lấy Meal Log AI: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API getMealLogAI: $e");
      return [];
    }
  }

  Future<bool> saveMealLogAI({required String feedback}) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final Map<String, String> formData = {
        'feedback': feedback,
      };

      final response = await _apiService.postMultipart(
        'api/meal-log/savemeallogai',
        body: formData,
        token: token,
      );

      debugPrint(
          "API saveMealLogAI: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Lỗi saveMealLogAI: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API saveMealLogAI: $e");
      return false;
    }
  }

  Future<MealLogDetail?> getMealLogDetail({
    required int detailId,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final String endpoint = 'api/meal-log/detail/$detailId';
      final response = await _apiService.get(endpoint, token: token);
      debugPrint(
          "API getMealLogDetail: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final dynamic detailData = jsonResponse['data'];
        if (detailData != null) {
          return MealLogDetail.fromJson(detailData);
        }
        return null;
      }
      throw Exception(
          'Lỗi getMealLogDetail: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API getMealLogDetail: $e");
      return null;
    }
  }

  Future<bool> updateMealLogDetailNutrition({
    required int detailId,
    required int calorie,
    required int protein,
    required int carbs,
    required int fat,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final String endpoint = 'api/meal-log/detail/$detailId/nutrition';
      // Các trường theo yêu cầu của API
      final Map<String, String> fields = {
        'Calorie': calorie.toString(),
        'Protein': protein.toString(),
        'Carbs': carbs.toString(),
        'Fat': fat.toString(),
      };

      final response = await _apiService.putMultipart(
        endpoint,
        fields: fields,
        token: token,
      );

      debugPrint(
          "API updateMealLogDetailNutrition: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      throw Exception(
          'Lỗi updateMealLogDetailNutrition: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API updateMealLogDetailNutrition: $e");
      return false;
    }
  }

  Future<bool> addImageToMealLogDetail({
    required int detailId,
    required File imageFile,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Nếu cần truyền thêm trường form-data, bạn thêm vào đây
      final fields = <String, String>{
        // 'key1': 'value1',
        // 'key2': 'value2',
        // ...
      };

      final response = await _apiService.postMultipartWithFile(
        'api/meal-log/detail/$detailId/image',
        fields: fields,
        fileFieldName: 'Image',
        filePath: imageFile.path,
        token: token,
      );

      debugPrint("Status: ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Upload thành công
      } else {
        throw Exception(
            'Lỗi upload ảnh: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API addImageToMealLogDetail: $e");
      return false;
    }
  }

  Future<bool> deleteMealLog({
    required int mealLogId,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final String endpoint = 'api/meal-log/$mealLogId';
      final response = await _apiService.delete(endpoint, token: token);
      debugPrint(
          "API deleteMealLog: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Lỗi xóa Meal Log: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API deleteMealLog: $e");
      return false;
    }
  }

  Future<String?> analyzeMealLog({required String logDate}) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Xây dựng endpoint với query parameter logDate
      final String endpoint = 'api/meal-log/analyze?logDate=$logDate';
      final response = await _apiService.get(endpoint, token: token);
      debugPrint(
          "API analyzeMealLog: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        // Giả sử API trả về một JSON có key 'data' chứa thông tin phân tích
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'] as String;
      } else {
        throw Exception(
            'Lỗi khi fetch analyze meal log: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API analyzeMealLog: $e");
      return null;
    }
  }

  Future<bool> calorieEstimator({
    required String logDate,
    required int additionalCalories,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Xây dựng endpoint với query parameters logdate và additionalCalories
      final String endpoint =
          'api/meal-log/calorie-estimator?logdate=$logDate&additionalCalories=$additionalCalories';
      final response = await _apiService.get(endpoint, token: token);
      debugPrint(
          "API calorieEstimator: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final bool result = jsonDecode(response.body) as bool;
        return result;
      } else {
        throw Exception(
            'Lỗi khi gọi API calorieEstimator: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Lỗi khi gọi API calorieEstimator: $e");
      return false;
    }
  }

  Future<bool> cloneMealLog({
    required String sourceDate,
    required String targetDate,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Build the form data fields (matching the cURL -F parameters)
      Map<String, String> formData = {
        'SourceDate': sourceDate,
        'TargetDate': targetDate,
      };

      // POST the multipart form-data request using your ApiService
      final response = await _apiService.postMultipart("api/meal-log/clone",
          body: formData, token: token);

      debugPrint(
          "API cloneMealLog: Status ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Error cloning Meal Log: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Error calling API cloneMealLog: $e");
      return false;
    }
  }

  Future<bool> isMealPlanApplied({required String date}) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final String endpoint = 'api/meal-log/plan-applied?date=$date';
      final response = await _apiService.get(endpoint, token: token);
      debugPrint(
          'API isMealPlanApplied: Status ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // API trả về: { "isApplied": true }
        return jsonResponse['isApplied'] as bool;
      } else {
        // Không tìm thấy hoặc lỗi, coi như chưa áp dụng
        debugPrint(
            'Lỗi isMealPlanApplied: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception in isMealPlanApplied: $e');
      return false;
    }
  }
}
