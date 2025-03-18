import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/models/meallog.dart';
import '../services/meallog_service.dart';

import 'mealLog_component_widget.dart';

class MealLogComponentModel extends FlutterFlowModel with ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  // Dữ liệu lấy từ API
  List<MealLog> mealLogs = [];

  // Ví dụ set cứng, tuỳ bạn thay đổi logic
  int calorieGoal = 1300;
  int foodCalories = 0;
  int exerciseCalories = 0;

  // Các bữa
  final List<String> mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Exercise'
  ];

  // Tính Remaining (Goal - Food + Exercise)
  int get remainingCalories => calorieGoal - foodCalories + exerciseCalories;

  /// Gọi API để lấy meal log của ngày [selectedDate].
  Future<void> fetchMealLogs() async {
    try {
      // Định dạng ngày thành yyyy-MM-dd
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Gọi service để fetch Meal Logs
      final service = MeallogService(); // Hoặc MealPlanService
      mealLogs = await service.getMealLogs(logDate: dateString);

      // Tính tổng calories từ các MealLog (nếu API trả về nhiều MealLog cho 1 ngày, cộng lại)
      int sumCalories = 0;
      for (final log in mealLogs) {
        sumCalories += log.totalCalories;
      }
      foodCalories = sumCalories;

      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi fetch Meal Logs: $e');
      mealLogs = [];
      foodCalories = 0;
      notifyListeners();
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate = newDate;
    mealLogs = [];
    foodCalories = 0;

    fetchMealLogs();
  }

  void updateCalorieGoal(int newGoal) {
    calorieGoal = newGoal;
    notifyListeners();
  }

  void updateFoodCalories(int newCalories) {
    foodCalories = newCalories;
    notifyListeners();
  }

  void updateExerciseCalories(int newCalories) {
    exerciseCalories = newCalories;
    notifyListeners();
  }

  @override
  void initState(BuildContext context) {
    fetchMealLogs();
  }
}
