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

  Future<String?> EnableReminder(BuildContext context) async{
    try{
      final fcmToken = await _getFcmToken();
      if(fcmToken == null){
        return null;
      }
      final token = await _apiService.getAccessToken(context);
      if(token == null){
        return null;
      }
      final response = await _apiService.postRaw(
          "api/firebase/enable-reminder",
          body: jsonEncode(fcmToken), // mã hóa token thành json rồi gửi đi
          token: token
      );
      if(response.statusCode == 200){

        return response.body;

      }
      else{
        debugPrint('Lỗi khi gọi API enable-reminder: ${response.body}');
        return null;
      }

    }
    catch (e) {
      debugPrint("lỗi EnableRemider: $e");
      return null;
    }
  }
}