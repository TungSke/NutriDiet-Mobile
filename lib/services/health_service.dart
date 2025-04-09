import 'dart:convert';
import 'dart:io';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/user_service.dart';

class HealthService {
  final ApiService _apiService = ApiService();

  static Future<Map<String, dynamic>> fetchHealthData() async {
    try {
      // Gọi hai API cùng lúc bằng Future.wait()
      final responses = await Future.wait([
        UserService().getHealthProfile(),
        UserService().getPersonalGoal(),
      ]);

      final healthResponse = responses[0];
      final goalResponse = responses[1];

      // Log dữ liệu trả về để kiểm tra
      print("healthResponse: ${healthResponse.body}");
      print("goalResponse: ${goalResponse.body}");

      final healthData =
          json.decode(healthResponse.body)['data'] as Map<String, dynamic>?;
      final personalGoal =
          json.decode(goalResponse.body)['data'] as Map<String, dynamic>?;

      // Kiểm tra dữ liệu trả về
      if (healthData == null) {
        print("❌ Dữ liệu sức khỏe không hợp lệ.");
        return {
          "healthData": null,
          "personalGoal": null,
          "errorMessage": "Dữ liệu sức khỏe không hợp lệ",
        };
      }

      // Xử lý dữ liệu BMI & TDEE
      final healthcareIndicators = healthData["healthcareIndicators"] ?? [];

      String? parseValue(String? value) {
        if (value == null) return null;
        return double.parse(value).toStringAsFixed(2);
      }

      final bmiIndicator = healthcareIndicators.firstWhere(
        (indicator) => indicator["code"] == "BMI",
        orElse: () => null,
      );

      final tdeeIndicator = healthcareIndicators.firstWhere(
        (indicator) => indicator["code"] == "TDEE",
        orElse: () => null,
      );

      // Trả về dữ liệu hợp lệ với các giá trị BMI & TDEE
      return {
        "healthData": {
          ...healthData,
          "BMI": parseValue(bmiIndicator?["currentValue"]) ?? "N/A",
          "BMIType": bmiIndicator?["type"] ?? "N/A",
          "TDEE": parseValue(tdeeIndicator?["currentValue"]) ?? "N/A",
        },
        "personalGoal": personalGoal ??
            {}, // Nếu personalGoal là null, trả về một đối tượng rỗng
        "errorMessage": "",
      };
    } catch (e) {
      print("Lỗi khi fetch dữ liệu: $e");
      return {
        "healthData": null,
        "personalGoal": null,
        "errorMessage": e.toString(),
      };
    }
  }

  Future<bool> addImageToHealthProfile({
    required int profileId,
    required File imageFile,
  }) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      // Nếu cần truyền thêm các trường form-data, thêm vào đây
      final fields = <String, String>{
        // 'key1': 'value1',
        // 'key2': 'value2',
      };

      final response = await _apiService.postMultipartWithFile(
        'api/health-profile/$profileId/image',
        fields: fields,
        fileFieldName: 'Image',
        filePath: imageFile.path,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Upload thành công
      } else {
        throw Exception(
          'Lỗi upload ảnh: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error during image upload: $e');
      return false;
    }
  }

  Future<bool> deleteHealthProfile({required int profileId}) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final response = await _apiService.delete(
        'api/health-profile/$profileId',
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      print(
          'Lỗi delete health profile: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Error deleting health profile: $e');
      return false;
    }
  }

  /// Xóa ảnh Health Profile (ví dụ: DELETE api/health-profile/{profileId}/image)
  Future<bool> deleteHealthProfileImage({required int profileId}) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'accessToken');

    try {
      final response = await _apiService.delete(
        'api/health-profile/$profileId/image',
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      print(
          'Lỗi delete health profile image: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Error deleting health profile image: $e');
      return false;
    }
  }
}
