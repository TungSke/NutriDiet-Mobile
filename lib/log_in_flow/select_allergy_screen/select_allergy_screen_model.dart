import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../services/allergy_service.dart';
import '../../services/models/allergy.dart';

class SelectAllergyModel extends ChangeNotifier {
  final AllergyService _allergyService = AllergyService();
  List<Allergy> allergies = [];
  List<Map<String, String?>> allergyLevelsData = [];
  Set<int> selectedAllergyIds = {};
  bool isLoading = true;

  SelectAllergyModel() {
    fetchAllergies();
  }

  Future<void> fetchAllergies() async {
    try {
      final response =
          await _allergyService.getAllAllergies(pageIndex: 1, pageSize: 20);
      final List<Allergy> parsedData =
          await _allergyService.parseAllergies(response);
      allergies = parsedData;

      // 🔹 Lấy danh sách dị ứng dạng Map để hiển thị UI
      allergyLevelsData = await _allergyService.fetchAllergyLevelsData();
    } catch (e) {
      print("Error loading allergies: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(int allergyId) async {
    if (selectedAllergyIds.contains(allergyId)) {
      selectedAllergyIds.remove(allergyId);
    } else {
      selectedAllergyIds.add(allergyId);
    }

    notifyListeners();

    try {
      // 🔹 Gửi danh sách dị ứng dưới dạng `List<int>`
      await UserService()
          .updateHealthProfile(allergies: selectedAllergyIds.toList());
      print("✅ Cập nhật dị ứng thành công!");
    } catch (e) {
      print("❌ Lỗi cập nhật dị ứng: $e");
    }
  }
}
