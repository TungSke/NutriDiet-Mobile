import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/models/meallog.dart';
import '../services/meallog_service.dart';

class MealLogComponentModel extends FlutterFlowModel {
  DateTime selectedDate = DateTime.now();

  // Dữ liệu lấy từ API
  List<MealLog> mealLogs = [];
  bool isLoading = true;
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
  VoidCallback? _updateCallback;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  // Tính Remaining (Goal - Food + Exercise)
  int get remainingCalories => calorieGoal - foodCalories + exerciseCalories;

  /// Gọi API để lấy meal log của ngày [selectedDate].
  Future<void> fetchMealLogs() async {
    try {
      isLoading = true;
      // Định dạng ngày thành yyyy-MM-dd
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Gọi service để fetch Meal Logs
      final service = MeallogService(); // Hoặc MealPlanService
      if (_updateCallback != null) {
        _updateCallback!();
      }
      mealLogs = await service.getMealLogs(logDate: dateString);

      // Tính tổng calories từ các MealLog (nếu API trả về nhiều MealLog cho 1 ngày, cộng lại)
      int sumCalories = 0;
      for (final log in mealLogs) {
        sumCalories += log.totalCalories;
      }
      foodCalories = sumCalories;
    } catch (e) {
      debugPrint('Lỗi khi fetch Meal Logs: $e');
      mealLogs = [];
      foodCalories = 0;
    } finally {
      isLoading = false;
      if (_updateCallback != null) {
        _updateCallback!();
      } else {
        debugPrint("Lỗi: _updateCallback là null");
      }
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
  }

  void updateFoodCalories(int newCalories) {
    foodCalories = newCalories;
  }

  void updateExerciseCalories(int newCalories) {
    exerciseCalories = newCalories;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
