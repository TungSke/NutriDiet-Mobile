import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'models/mealplan.dart';

class MealPlanService{
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

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

  Future<Map<String, dynamic>> createSuitableMealPlanByAI() async {
    try {
      final String? token = await flutterSecureStorage.read(key: 'accessToken');
      if (token == null) {
        return {
          'success': false,
          'mealPlan': null,
          'message': 'No access token found'
        };
      }
      const String endpoint = "api/meal-plan/suitable-meal-plan-by-AI";
      final response = await _apiService.post(
        endpoint,
        body: {},
        token: token,
      ).timeout(const Duration(seconds: 45), onTimeout: () {
        throw Exception("Request timed out after 30 seconds");
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final mealPlan = MealPlan.fromJson(data['data']);
        return {
          'success': true,
          'mealPlan': mealPlan,
          'message': data['message'] ?? 'Meal plan created successfully'
        };
      }
      return {
        'success': false,
        'mealPlan': null,
        'message': data['message'] ?? 'Failed to create meal plan (Status: ${response.statusCode})'
      };
    } catch (e) {
      return {
        'success': false,
        'mealPlan': null,
        'message': 'Error creating AI meal plan: $e'
      };
    }
  }

  Future<Map<String, dynamic>> rejectMealPlan(String rejectReason) async {
    try {
      final String? token = await flutterSecureStorage.read(key: 'accessToken');
      if (token == null) {
        debugPrint("Error: No access token found");
        return {
          'success': false,
          'mealPlan': null,
          'message': 'No access token found'
        };
      }
      const String endpoint = "api/meal-plan/reject-mealplan-AI";
      final uri = Uri.parse('${_apiService.baseUrl}/$endpoint');
      // Sử dụng MultipartRequest để gửi multipart/form-data
      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['rejectReason'] = rejectReason;
      final response = await http.Response.fromStream(await request.send());
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'mealPlan': data['data'] != null ? MealPlan.fromJson(data['data']) : null,
          'message': data['message'] ?? 'Meal plan rejected successfully'
        };
      }
      return {
        'success': false,
        'mealPlan': null,
        'message': data['message'] ?? 'Failed to reject meal plan (Status: ${response.statusCode})'
      };
    } catch (e) {
      return {
        'success': false,
        'mealPlan': null,
        'message': 'Error rejecting meal plan: $e'
      };
    }
  }

  Future<Map<String, dynamic>> saveMealPlanAI({String? feedback}) async {
    try {
      final String? token = await flutterSecureStorage.read(key: 'accessToken');
      const String endpoint = "api/meal-plan/save-mealplan-AI";

      final Map<String, dynamic> body = {};
      if (feedback != null && feedback.isNotEmpty) {
        body['feedback'] = feedback;
      }

      final response = await _apiService.put(
        endpoint,
        body: body,
        token: token,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Meal plan saved successfully'
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Failed to save meal plan'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error saving meal plan: $e'
      };
    }
  }

  Future<bool> createMealPlan(MealPlan mealPlan) async{
    try{
      final String? token = await flutterSecureStorage.read(key:'accessToken');
      if(token==null){
        debugPrint("No access Token found");
        return false;
      }
      const String endpoint = "api/meal-plan";
      final Map<String, dynamic> body = {
        'planName': mealPlan.planName,
        'healthGoal': mealPlan.healthGoal,
        'mealPlanDetails': mealPlan.mealPlanDetails.map((detail)=>{
          'foodId': detail.foodId,
          'quantity': detail.quantity,
          'mealType': detail.mealType,
          'dayNumber': detail.dayNumber,
        }).toList(),
      };
      final response = await _apiService.post(endpoint, body: body, token: token);
      if(response.statusCode == 200) return true;
      else{
        throw Exception('Lỗi khi tạo: ${response.statusCode}, ${response.body}');
      }

    }catch(e){
      debugPrint("Lỗi khi gọi API createMealPlan: $e");
      return false;
    }
  }

  Future<bool> updateMealPlan(MealPlan mealPlan) async {
    try {
      final String? token = await flutterSecureStorage.read(key: 'accessToken');
      if (token == null) {
        debugPrint("No access token found");
        return false;
      }
      if (mealPlan.mealPlanId == null) {
        debugPrint('MealPlan ID is required for update');
        return false;
      }
      final String endpoint = "api/meal-plan/${mealPlan.mealPlanId}";
      final Map<String, dynamic> body = {
        'mealPlanRequest': {
          'planName': mealPlan.planName,
          'healthGoal': mealPlan.healthGoal,
          'mealPlanDetails': mealPlan.mealPlanDetails.map((detail) => {
            'mealPlanDetailId': detail.mealPlanDetailId,
            'foodId': detail.foodId ?? 0, // Xử lý null cho foodId
            'quantity': detail.quantity,
            'mealType': detail.mealType,
            'dayNumber': detail.dayNumber,
          }).toList(),
        }
      };
      debugPrint("Endpoint: $endpoint, Body: $body"); // Log để kiểm tra
      final response = await _apiService.put(endpoint, body: body, token: token);
      debugPrint("Response: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) return true;
      throw Exception('Lỗi khi cập nhật: ${response.statusCode}, ${response.body}');
    } catch (e) {
      debugPrint("Lỗi khi gọi API updateMealPlan: $e");
      return false;
    }
  }

}
