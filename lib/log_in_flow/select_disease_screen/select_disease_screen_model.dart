import 'package:diet_plan_app/services/disease_service.dart';
import 'package:diet_plan_app/services/models/disease.dart';
import 'package:flutter/material.dart';

class SelectDiseaseModel extends ChangeNotifier {
  final DiseaseService _diseaseService = DiseaseService();
  List<Disease> diseases = [];
  Set<int> selectedDiseaseIds = {};
  bool isLoading = true;

  SelectDiseaseModel() {
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    try {
      final response =
          await _diseaseService.getAllDiseases(pageIndex: 1, pageSize: 20);
      final List<Disease> parsedData =
          await _diseaseService.parseDiseases(response);
      diseases = parsedData;
    } catch (e) {
      print("Error loading diseases: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(int diseaseId) {
    if (selectedDiseaseIds.contains(diseaseId)) {
      selectedDiseaseIds.remove(diseaseId);
    } else {
      selectedDiseaseIds.add(diseaseId);
    }
    notifyListeners();
  }
}
