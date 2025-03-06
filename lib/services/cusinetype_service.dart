import 'package:diet_plan_app/services/api_service.dart';
import 'package:http/http.dart' as http;

class CusinetypeService {
  final ApiService _apiService = ApiService();

  Future<http.Response> getAllCuisineType() async {
    final response = await _apiService.get("/api/cusine-type");
    return response;
  }
}