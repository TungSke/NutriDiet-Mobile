import 'dart:convert';

import '../services/user_service.dart';

class HealthService {
  static Future<Map<String, dynamic>> fetchHealthData() async {
    try {
      final healthResponse = await UserService().getHealthProfile();
      final goalResponse = await UserService().getPersonalGoal();

      return {
        "healthData": json.decode(healthResponse.body)['data'],
        "personalGoal": json.decode(goalResponse.body)['data'],
        "errorMessage": "",
      };
    } catch (e) {
      return {
        "healthData": null,
        "personalGoal": null,
        "errorMessage": e.toString(),
      };
    }
  }
}
