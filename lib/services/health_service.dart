import 'dart:convert';

import '../services/user_service.dart';

class HealthService {
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
          json.decode(healthResponse.body)['data'] as Map<String, dynamic>;
      final personalGoal =
          json.decode(goalResponse.body)['data'] as Map<String, dynamic>;

      // Lọc chỉ số BMI & TDEE
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

// Cập nhật lại healthData với BMI & TDEE (làm tròn 2 chữ số)
      return {
        "healthData": {
          ...healthData,
          "BMI": parseValue(bmiIndicator?["currentValue"]) ?? "N/A",
          "TDEE": parseValue(tdeeIndicator?["currentValue"]) ?? "N/A",
        },
        "personalGoal": personalGoal,
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
}
