import 'dart:convert';

import 'package:diet_plan_app/services/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final ApiService _apiService = ApiService();

  // Lấy FCM token từ Firebase Messaging
  Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Lỗi khi lấy FCM token: $e');
      return null;
    }
  }

  Future<String?> enableReminder(BuildContext context) async {
    try {
      // Lấy access token
      final token = await _apiService.getAccessToken(context);
      if (token == null) {
        return null;
      }

      // Gửi yêu cầu POST tới endpoint /api/firebase/enable-reminder
      final response = await _apiService.post(
        "api/firebase/enable-reminder",
        body: {}, // Không cần body vì backend lấy userId từ token
        token: token,
      );

      if (response.statusCode == 200) {
        return response.body; // "Reminder enabled" hoặc "Reminder disabled"
      } else {
        debugPrint('Lỗi khi gọi API enable-reminder: ${response.body}');
        if (response.statusCode == 400 &&
            response.body.contains("FCM token is required")) {
          return "FCM token is required";
        }
        return null;
      }
    } catch (e) {
      debugPrint("Lỗi enableReminder: $e");
      return null;
    }
  }
}