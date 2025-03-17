import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/mealplan_service.dart';
import '../../services/models/mealplan.dart';
import '../../services/models/mealplandetail.dart';

class MealPlanDetailModel extends ChangeNotifier {
  final MealPlanService _mealPlanService = MealPlanService();
  MealPlan? mealPlan;
  Map<String, dynamic>? mealPlanTotals;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchMealPlanById(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
      mealPlanTotals = await _mealPlanService.getMealPlanDetailTotals(mealPlanId);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> cloneSampleMealPlan(int mealPlanId) async{
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.cloneSampleMealPlan(mealPlanId);
      isLoading = false;
      if(success){
        errorMessage = null;
      }else{
        errorMessage = "Không thể sao chép thực đơn";
      }
      notifyListeners();
      return success;
    }catch (e){
      isLoading = false;
      errorMessage = "Lỗi khi sao chép: $e";
      notifyListeners();
      return false;
    }
  }

  Future<bool> applyMealPlan(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null; // Reset errorMessage
      notifyListeners();

      final result = await _mealPlanService.applyMealPlan(mealPlanId);
      isLoading = false;
      if (result['success']) {
        errorMessage = null;
        await fetchMealPlanById(mealPlanId); // Cập nhật trạng thái từ server
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

  // Hàm lấy tổng dinh dưỡng cho ngày cụ thể từ totalByDayNumber
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

  // Lấy danh sách bữa ăn theo ngày (giữ nguyên)
  List<MealPlanDetail> getMealsForDay(int dayNumber) {
    if (mealPlan == null) return [];
    return mealPlan!.mealPlanDetails.where((detail) => detail.dayNumber == dayNumber).toList();
  }

  // Lấy số ngày tối đa từ totalByDayNumber
  int getTotalDays() {
    if (mealPlanTotals == null || mealPlanTotals!['totalByDayNumber'] == null) return 1;
    return (mealPlanTotals!['totalByDayNumber'] as List)
        .map((day) => day['dayNumber'] as int)
        .reduce((a, b) => a > b ? a : b);
  }
}