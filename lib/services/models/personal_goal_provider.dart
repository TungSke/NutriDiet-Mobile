import 'package:flutter/material.dart';

class PersonalGoalProvider extends ChangeNotifier {
  String? goalType;
  double? targetWeight;
  String? weightChangeRate;
  String goalDescription = "Mục tiêu mặc định"; // ✅ Giá trị mặc định
  String notes = "Không có ghi chú"; // ✅ Giá trị mặc định

  void setGoalType(String value) {
    goalType = value;
    notifyListeners();
  }

  void setTargetWeight(double value) {
    targetWeight = value;
    notifyListeners();
  }

  void setWeightChangeRate(String value) {
    weightChangeRate = value;
    notifyListeners();
  }

  void setGoalDescription(String value) {
    goalDescription = value;
    notifyListeners();
  }

  void setNotes(String value) {
    notes = value;
    notifyListeners();
  }

  bool isComplete() {
    return goalType != null && targetWeight != null && weightChangeRate != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'GoalType': goalType,
      'TargetWeight': targetWeight,
      'WeightChangeRate': weightChangeRate,
      'GoalDescription': goalDescription,
      'Notes': notes,
    };
  }
}
