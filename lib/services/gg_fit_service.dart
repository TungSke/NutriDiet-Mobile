import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class GGFitService {
  final Health _health = Health();

  Future<Map<String, dynamic>> fetchStepsAndHealthData(DateTime startDate, DateTime endDate) async {
    try {
      // Kiểm tra tính khả dụng của Health Connect (Android)
      if (!kIsWeb && Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          await _health.installHealthConnect();
          return {
            "steps": 0,
            "caloriesBurned": 0,
            "error": "Health Connect không khả dụng hoặc chưa được cài đặt.",
          };
        }
      }

      // Cấu hình Health
      await _health.configure();

      // Kiểm tra quyền trước khi lấy dữ liệu
      final types = [
        HealthDataType.STEPS,
        HealthDataType.TOTAL_CALORIES_BURNED,
      ];
      final permissions = [HealthDataAccess.READ,HealthDataAccess.READ];
      bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

      if (hasPermission == null || !hasPermission) {
        final authorized = await _health.requestAuthorization(types, permissions: permissions);
        if (!authorized) {
          return {
            "steps": 0,
            "caloriesBurned": 0,
            "error": "Người dùng từ chối cấp quyền Health Connect.",
          };
        }
      }

      // Lấy số bước chân
      final steps = await _health.getTotalStepsInInterval(startDate, endDate) ?? 0;

      // Lấy calories đốt cháy
      final caloriesBurnedData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.TOTAL_CALORIES_BURNED],
        startTime: startDate,
        endTime: endDate,
      );

      double caloriesBurned = 0;
      if (caloriesBurnedData.isNotEmpty) {
        caloriesBurned = caloriesBurnedData
            .map((data) => (data.value as NumericHealthValue).numericValue)
            .reduce((a, b) => a + b)
            .toDouble();
      }

      return {
        "steps": steps,
        "caloriesBurned": caloriesBurned,
        "error": null,
      };
    } catch (e) {
      return {
        "steps": 0,
        "caloriesBurned": 0,
        "error": "Đã xảy ra lỗi khi lấy dữ liệu: $e",
      };
    }
  }
}
