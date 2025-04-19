import 'dart:convert';

import 'package:diet_plan_app/log_in_flow/ai_suggestion_screen/ai_suggestion_screen_widget.dart';
import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_model.dart';

class AiSuggestion {
  final String content;
  final String type;
  final String createdAt;

  AiSuggestion(
      {required this.content, required this.createdAt, required this.type});

  // Phương thức để khởi tạo đối tượng từ dữ liệu JSON
  factory AiSuggestion.fromJson(Map<String, dynamic> json) {
    return AiSuggestion(
        content: json['content'],
        type: json['type'],
        createdAt: json['createdAt']);
  }
}

class AiSuggestionScreenModel extends FlutterFlowModel<AiSuggestionScreenWidget>
    with ChangeNotifier {
  final UserService _userService = UserService();
  String aisuggestion = '';
  List<AiSuggestion> aisuggestions = [];

  late AppbarModel appbarModel;

  @override
  void initState(BuildContext context) {}

  Future<void> fetchHealthProfile() async {
    try {
      final response = await _userService.getHealthProfile();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Ánh xạ aisuggestions từ dữ liệu JSON
        aisuggestions = (data['data']['aisuggestions'] as List)
            .map((item) => AiSuggestion.fromJson(item))
            .toList();

        print(aisuggestions);
      } else {
        throw Exception('Failed to load target weight');
      }
    } catch (e) {
      print('Error fetching target weight: $e');
    }
  }

  Future<void> createAiSuggestion(String category) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final String? token = await flutterSecureStorage.read(key: 'accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("⚠ Access token không hợp lệ, vui lòng đăng nhập lại.");
    }

    try {
      // Gọi API với tham số cate từ category
      final response = await _userService.createAiSuggestion(
        token,
        category, // Truyền category vào API
      );

      if (response.statusCode == 200) {
        print("Lời khuyên AI đã được tạo thành công.");
        await fetchHealthProfile();
      } else {
        print('Lỗi khi tạo lời khuyên AI: ${response.body}');
        throw Exception('Lỗi khi tạo lời khuyên AI: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating AI suggestion: $e');
      throw Exception("Không thể kết nối đến server.");
    }
  }

  @override
  void dispose() {}
}
