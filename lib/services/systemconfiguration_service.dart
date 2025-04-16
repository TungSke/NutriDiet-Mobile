import 'dart:convert';
import 'package:diet_plan_app/services/api_service.dart';

class SystemConfigurationService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getSystemConfig({
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      final queryParameters = {
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiService.get(
        'api/system-configuration?${Uri(queryParameters: queryParameters).query}',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to load system configurations: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching system configurations: $e');
    }
  }

  Future<Map<String, dynamic>> getSystemConfigById(int configId) async {
    try {
      final response = await _apiService.get('api/system-configuration/$configId');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData as Map<String, dynamic>;
      } else {
        throw Exception(
            'Không thể tải cấu hình hệ thống: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy cấu hình hệ thống: $e');
    }
  }

}