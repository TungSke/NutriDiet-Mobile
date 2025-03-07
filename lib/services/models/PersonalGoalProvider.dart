import 'package:flutter/material.dart';

import '../user_service.dart';

class PersonalGoalModel extends ChangeNotifier {
  String? goalType;
  double? targetWeight;
  String? weightChangeRate;
  String? goalDescription;
  String? notes;

  // Cập nhật từng trường một
  void updateGoalType(String value) {
    goalType = value;
    notifyListeners();
  }

  void updateTargetWeight(double value) {
    targetWeight = value;
    notifyListeners();
  }

  void updateWeightChangeRate(String value) {
    weightChangeRate = value;
    notifyListeners();
  }

  void updateGoalDescription(String value) {
    goalDescription = value;
    notifyListeners();
  }

  void updateNotes(String value) {
    notes = value;
    notifyListeners();
  }

  // Gửi API khi hoàn tất tất cả các bước
  Future<void> submitGoal() async {
    if (goalType == null ||
        targetWeight == null ||
        weightChangeRate == null ||
        goalDescription == null ||
        notes == null) {
      print("⚠️ Vui lòng nhập đầy đủ thông tin trước khi gửi.");
      return;
    }

    try {
      final response = await UserService().createPersonalGoal(
        goalType: goalType!,
        targetWeight: targetWeight!,
        weightChangeRate: weightChangeRate!,
        goalDescription: goalDescription!,
        notes: notes!,
      );

      if (response.statusCode == 200) {
        print("✅ Cập nhật mục tiêu cá nhân thành công!");
      } else {
        print("❌ Lỗi cập nhật: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi gửi API: $e");
    }
  }
}
