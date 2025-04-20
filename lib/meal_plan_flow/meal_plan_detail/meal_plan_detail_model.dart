import 'dart:convert';

import 'package:flutter/material.dart';
import '../../services/mealplan_service.dart';
import '../../services/models/mealplan.dart';
import '../../services/models/mealplandetail.dart';
import '../../services/user_service.dart';

class MealPlanDetailModel extends ChangeNotifier {
  final MealPlanService _mealPlanService = MealPlanService();
  final UserService _userService = UserService();
  MealPlan? mealPlan;
  Map<String, dynamic>? mealPlanTotals;
  Map<String, double>? userGoals;
  bool isLoading = false;
  String? errorMessage;
  String? aiWarning;

  static const List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  Future<void> fetchMealPlanById(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
      mealPlanTotals = await _mealPlanService.getMealPlanDetailTotals(mealPlanId);
      aiWarning = mealPlan?.aiWarning;

      final response = await _userService.getPersonalGoal();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        userGoals = {
          'calories': (data['dailyCalories'] as num?)?.toDouble() ?? 2000.0,
          'carbs': (data['dailyCarb'] as num?)?.toDouble() ?? 250.0,
          'fat': (data['dailyFat'] as num?)?.toDouble() ?? 70.0,
          'protein': (data['dailyProtein'] as num?)?.toDouble() ?? 100.0,
        };
      } else {
        userGoals = {'calories': 2000.0, 'carbs': 250.0, 'fat': 70.0, 'protein': 100.0};
        errorMessage = "Không thể lấy mục tiêu cá nhân: ${response.body}";
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkPremiumStatus() async {
    return await _userService.isPremium();
  }

  Future<void> createAIWarning(int mealPlanId) async {
    try{

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _mealPlanService.createAIWarning(mealPlanId);
      isLoading = false;

      if (result['success']) {
        aiWarning = result['aiWarning']; // Lưu AIWarning từ response
        mealPlan = await _mealPlanService.getMealPlanById(mealPlanId); // gọi lại mealplan
        errorMessage = null;
      } else {
        aiWarning = null;
        errorMessage = result['message'];
        if (result['requiresPremium'] == true) {
          errorMessage = "Chỉ tài khoản Premium mới sử dụng được tính năng này";
        }
      }
      notifyListeners();
    }catch (e){
      isLoading = false;
      aiWarning = null;
      errorMessage = "Lỗi khi lấy cảnh báo AI: $e";
      notifyListeners();
    }
  }

  Future<bool> cloneSampleMealPlan(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.cloneSampleMealPlan(mealPlanId);
      isLoading = false;
      if (success) {
        errorMessage = null;
      } else {
        errorMessage = "Không thể sao chép thực đơn";
      }
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi sao chép: $e";
      notifyListeners();
      return false;
    }
  }

  Future<bool> applyMealPlan(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _mealPlanService.applyMealPlan(mealPlanId);
      isLoading = false;
      if (result['success']) {
        errorMessage = null;
        await fetchMealPlanById(mealPlanId);
      } else {
        errorMessage = result['errorMessage'];
      }
      notifyListeners();
      return result['success'];
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMealPlan(String planName, String healthGoal) async {
    try {
      if (mealPlan == null || mealPlan!.mealPlanId == null) {
        errorMessage = "Không tìm thấy MealPlan để cập nhật";
        notifyListeners();
        return false;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final updatedMealPlan = MealPlan(
        mealPlanId: mealPlan!.mealPlanId,
        planName: planName,
        healthGoal: healthGoal,
        mealPlanDetails: mealPlan!.mealPlanDetails,
      );

      final success = await _mealPlanService.updateMealPlan(updatedMealPlan);
      if (success) {
        await fetchMealPlanById(mealPlan!.mealPlanId!);
      } else {
        errorMessage = "Không thể cập nhật thực đơn";
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi cập nhật thực đơn: $e";
      notifyListeners();
      return false;
    }
  }

  Future<bool> copyMealPlanDetail(int mealPlanId, int dayNumberFrom, int dayNumberTo, BuildContext context) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.copyMealPlanDetail(mealPlanId, dayNumberFrom, dayNumberTo, context);
      if (success) {
        await fetchMealPlanById(mealPlanId);
        errorMessage = null;
      } else {
        errorMessage = "Không thể sao chép chi tiết thực đơn";
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi sao chép chi tiết thực đơn: $e";
      notifyListeners();
      return false;
    }
  }

  Future<void> addNewDay(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (mealPlan == null) {
        errorMessage = "Không tìm thấy MealPlan";
        isLoading = false;
        notifyListeners();
        return;
      }

      await fetchMealPlanById(mealPlanId);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi thêm ngày mới: $e";
      notifyListeners();
    }
  }

  Map<String, double> getNutrientTotalsForDay(int dayNumber) {
    if (mealPlanTotals == null || mealPlanTotals!['totalByDayNumber'] == null) {
      return {"calories": 0, "carbs": 0, "fat": 0, "protein": 0};
    }

    final dayTotals = (mealPlanTotals!['totalByDayNumber'] as List)
        .firstWhere((day) => day['dayNumber'] == dayNumber, orElse: () => null);

    if (dayTotals == null) {
      return {"calories": 0, "carbs": 0, "fat": 0, "protein": 0};
    }

    return {
      "calories": (dayTotals['totalCalories'] ?? 0).toDouble(),
      "carbs": (dayTotals['totalCarbs'] ?? 0).toDouble(),
      "fat": (dayTotals['totalFat'] ?? 0).toDouble(),
      "protein": (dayTotals['totalProtein'] ?? 0).toDouble(),
    };
  }

  double getCaloriesForMealType(int dayNumber, String mealType) {
    if (mealPlanTotals == null || mealPlanTotals!['totalByMealType'] == null) {
      return 0.0;
    }

    final mealTotals = (mealPlanTotals!['totalByMealType'] as List).firstWhere(
          (meal) => meal['dayNumber'] == dayNumber && meal['mealType'] == mealType,
      orElse: () => null,
    );

    return mealTotals != null ? (mealTotals['totalCalories'] ?? 0.0).toDouble() : 0.0;
  }

  Map<String, List<MealPlanDetail>> getMealsForDay(int dayNumber) {
    if (mealPlan == null) return {};

    var meals = mealPlan!.mealPlanDetails.where((detail) => detail.dayNumber == dayNumber).toList();
    Map<String, List<MealPlanDetail>> groupMeals = {};
    for (var meal in meals) {
      final mealType = meal.mealType ?? "không xác định";
      if (!groupMeals.containsKey(mealType)) {
        groupMeals[mealType] = [];
      }
      groupMeals[mealType]!.add(meal);
    }
    return groupMeals;
  }

  // Lấy danh sách các ngày thực tế có món ăn
  List<int> getActiveDays() {
    if (mealPlan == null || mealPlan!.mealPlanDetails.isEmpty) return [1];
    final days = mealPlan!.mealPlanDetails.map((detail) => detail.dayNumber).toSet().toList();
    days.sort(); // Sắp xếp theo thứ tự tăng dần
    return days;
  }

  int getTotalDays() {
    if (mealPlanTotals == null || mealPlanTotals!['totalByDayNumber'] == null) return 1;
    return (mealPlanTotals!['totalByDayNumber'] as List)
        .map((day) => day['dayNumber'] as int)
        .reduce((a, b) => a > b ? a : b);
  }

  int getTotalActiveDays() {
    if (mealPlan == null || mealPlan!.mealPlanDetails.isEmpty) return 1;
    return mealPlan!.mealPlanDetails
        .map((detail) => detail.dayNumber)
        .toSet()
        .reduce((a, b) => a > b ? a : b);
  }

  bool isDayEmpty(int dayNumber) {
    return mealPlan?.mealPlanDetails.every((detail) => detail.dayNumber != dayNumber) ?? true;
  }
}