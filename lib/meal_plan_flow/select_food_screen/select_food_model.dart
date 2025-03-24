import 'package:flutter/material.dart';
import '../../services/food_service.dart';
import '../../services/models/food.dart';
import '../../services/models/mealplandetail.dart';
import '../../services/mealplan_service.dart';

class SelectFoodModel extends ChangeNotifier {
  final FoodService foodService = FoodService();
  final MealPlanService _mealPlanService = MealPlanService();
  List<Food> foods = [];
  List<MealPlanDetail> existingMeals = [];
  bool isLoading = false;
  String? errorMessage;

  void setExistingMeals(List<MealPlanDetail> meals) {
    existingMeals = meals;
    notifyListeners();
  }

  Future<void> fetchFoods({String? search, int pageIndex = 1, int pageSize = 50}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final query = (search == null || search.isEmpty) ? "" : search;
      foods = await foodService.getAllFoods(pageIndex: pageIndex, pageSize: pageSize, search: query);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi tải danh sách món ăn: $e";
      notifyListeners();
    }
  }

  Future<bool> addFoodToMealPlan({
    required int mealPlanId,
    required int dayNumber,
    required String mealType,
    required int foodId,
    required double quantity,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.createMealPlanDetail(
        mealPlanId: mealPlanId,
        foodId: foodId,
        quantity: quantity,
        mealType: mealType,
        dayNumber: dayNumber,
      );

      if (success) {
        // Lấy thông tin MealPlan từ server để đồng bộ existingMeals
        final mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
        if (mealPlan != null && mealPlan.mealPlanDetails != null) {
          // Lọc các MealPlanDetail theo mealType và dayNumber
          existingMeals = mealPlan.mealPlanDetails!
              .where((detail) => detail.mealType == mealType && detail.dayNumber == dayNumber)
              .toList();
        } else {
          errorMessage = "Không thể tải danh sách món ăn sau khi thêm";
          isLoading = false;
          notifyListeners();
          return false;
        }
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi thêm món ăn: $e";
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFoodFromMealPlan(int mealPlanDetailId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.deleteMealPlanDetail(mealPlanDetailId);

      if (success) {
        existingMeals.removeWhere((meal) => meal.mealPlanDetailId == mealPlanDetailId);
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi xóa món ăn: $e";
      notifyListeners();
      return false;
    }
  }
}