import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class IngredientService{

  final ApiService _apiService = ApiService();

  Future<http.Response> getAllAllergies({
    required int pageIndex,
    required int pageSize,
    String? search
  }) async {
    try {
      final response = await _apiService
          .get("api/ingredient?pageIndex=$pageIndex&pageSize=$pageSize&search=$search");

      return response;
    } catch (e) {
      print("Error fetching allergies: $e");
      throw Exception("Không thể lấy danh sách dị ứng.");
    }
  }

  Future<http.Response> updateIngreDientPreference({required int ingredientId, required String preferenceLevel,required BuildContext context}) async{
    final accessToken = await _apiService.getAccessToken(context);
    final response = await _apiService.put("api/ingredient/$ingredientId/preference?preferenceLevel=$preferenceLevel", body: {},token: accessToken);
    return response;
  }

  Future<http.Response> getIngreDientPreference({required BuildContext context}) async{
    final accessToken = await _apiService.getAccessToken(context);
    final response = await _apiService.get("api/ingredient/preference", token: accessToken);
    return response;
  }

}
