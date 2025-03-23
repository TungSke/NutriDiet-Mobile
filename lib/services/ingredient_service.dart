import 'package:diet_plan_app/services/api_service.dart';
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

}
