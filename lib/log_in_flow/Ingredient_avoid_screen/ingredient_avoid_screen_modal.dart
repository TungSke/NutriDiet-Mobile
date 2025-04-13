import 'package:diet_plan_app/log_in_flow/Ingredient_avoid_screen/ingredient_avoid_screen_widget.dart';
import 'package:flutter/material.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../services/health_service.dart';
import '../../services/user_service.dart';

class IngredientAvoidScreenModel
    extends FlutterFlowModel<IngredientAvoidScreenWidget> with ChangeNotifier {
  ///  Local state fields for this page.
  List<String> allergies = []; // ✅ Dị ứng
  List<String> diseases = [];
  final UserService _userService = UserService();
  String aisuggestion = '';

  ///  State fields for stateful widgets in this page.
  late AppbarModel appbarModel;

  @override
  void initState(BuildContext context) {}

  Future<void> fetchHealthProfile() async {
    try {
      print("🔄 Đang lấy thông tin sức khỏe từ API...");
      final healthData = await HealthService.fetchHealthData();

      if (healthData["healthData"] != null) {
        final data = healthData["healthData"];
        // Lấy danh sách dị ứng
        allergies = data["allergies"] != null
            ? (data["allergies"] as List).map((allergy) {
                // Lấy tên dị ứng
                String allergyName = allergy["allergyName"].toString();

                // Lấy danh sách các thành phần của dị ứng (ingredients)
                List<String> ingredients = allergy["ingredients"] != null
                    ? (allergy["ingredients"] as List)
                        .map((ingredient) =>
                            ingredient["ingredientName"].toString())
                        .toList()
                    : [];

                // Thêm thành phần vào danh sách
                return "$allergyName: ${ingredients.join(", ")}";
              }).toList()
            : [];

        // Lấy danh sách bệnh nền (nếu có ingredients)
        diseases = data["diseases"] != null
            ? (data["diseases"] as List).map((disease) {
                // Lấy tên bệnh
                String diseaseName = disease["diseaseName"].toString();

                // Lấy danh sách thành phần của bệnh (nếu có)
                List<String> ingredients = disease["ingredients"] != null
                    ? (disease["ingredients"] as List)
                        .map((ingredient) =>
                            ingredient["ingredientName"].toString())
                        .toList()
                    : [];

                // Trả về tên bệnh và các thành phần (nếu có)
                return "$diseaseName: ${ingredients.join(", ")}";
              }).toList()
            : [];

        notifyListeners();
      } else {
        print("❌ Lỗi khi lấy dữ liệu sức khỏe: ${healthData["errorMessage"]}");
      }
    } catch (e) {
      print("❌ Lỗi khi fetch dữ liệu sức khỏe: $e");
    }
  }

  // Future<void> createAiSuggestion() async {
  //   final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  //   final String? token = await flutterSecureStorage.read(key: 'accessToken');
  //
  //   if (token == null || token.isEmpty) {
  //     throw Exception("⚠ Access token không hợp lệ, vui lòng đăng nhập lại.");
  //   }
  //
  //   try {
  //     final response = await _userService.createAiSuggestion(token);
  //
  //     if (response.statusCode == 200) {
  //       print("Lời khuyên AI đã được tạo thành công.");
  //       await fetchHealthProfile();
  //     } else {
  //       print('Lỗi khi tạo lời khuyên AI: ${response.body}');
  //       throw Exception('Lỗi khi tạo lời khuyên AI: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error creating AI suggestion: $e');
  //     throw Exception("Không thể kết nối đến server.");
  //   }
  // }

  Future<bool> checkPremiumStatus() async {
    return await _userService.isPremium();
  }

  @override
  void dispose() {}
}
