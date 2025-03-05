import 'package:diet_plan_app/services/allergy_service.dart';
import 'package:diet_plan_app/services/models/allergy.dart';
import 'package:flutter/material.dart';

class SelectAllergyModel extends ChangeNotifier {
  final AllergyService _allergyService = AllergyService();
  List<Allergy> allergies = [];
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
    } catch (e) {
      print("Error loading allergies: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(int allergyId) {
    if (selectedAllergyIds.contains(allergyId)) {
      selectedAllergyIds.remove(allergyId);
    } else {
      selectedAllergyIds.add(allergyId);
    }
    notifyListeners();
  }
}
