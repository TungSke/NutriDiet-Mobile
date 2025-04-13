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
  bool isLoadingMore = false; // Trạng thái tải thêm
  String? errorMessage;
  int currentPage = 1; // Trang hiện tại
  int pageSize = 10;
  bool hasMore = true; // Còn dữ liệu để tải không
  Map<String, dynamic>? mealTotals;

  void setExistingMeals(List<MealPlanDetail> meals) {
    existingMeals = meals;
    notifyListeners();
  }

  Future<void> fetchFoods({String? search, int pageIndex = 1, bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore = true;
      } else {
        isLoading = true;
        foods.clear(); // Xóa danh sách cũ khi tải lại từ đầu
        currentPage = 1;
        hasMore = true;
      }
      errorMessage = null;
      notifyListeners();

      final query = (search == null || search.isEmpty) ? "" : search;
      final newFoods = await foodService.getAllFoods(
        pageIndex: pageIndex,
        pageSize: pageSize,
        search: query,
      );

      if (loadMore) {
        foods.addAll(newFoods);
      } else {
        foods = newFoods;
      }

      // Kiểm tra xem còn dữ liệu để tải không
      if (newFoods.length < pageSize) {
        hasMore = false;
      }

      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isLoadingMore = false;
      errorMessage = "Lỗi khi tải danh sách món ăn: $e";
      notifyListeners();
    }
  }

  Future<void> loadMoreFoods({String? search}) async {
    if (!hasMore || isLoadingMore) return;
    currentPage++;
    await fetchFoods(search: search, pageIndex: currentPage, loadMore: true);
  }

  // Hàm mới để lấy totalByMealType
  Future<void> fetchMealTotals(int mealPlanId, int dayNumber, String mealType) async {
    try {
      final totals = await _mealPlanService.getMealPlanDetailTotals(mealPlanId);
      if (totals != null && totals['totalByMealType'] != null) {
        final mealTotals = (totals['totalByMealType'] as List).firstWhere(
              (meal) => meal['dayNumber'] == dayNumber && meal['mealType'] == mealType,
          orElse: () => null,
        );
        this.mealTotals = mealTotals;
      } else {
        this.mealTotals = null;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = "Lỗi khi tải thông số dinh dưỡng: $e";
      this.mealTotals = null;
      notifyListeners();
    }
  }

  // Hàm lấy giá trị dinh dưỡng cụ thể
  Map<String, double> getNutrientTotals() {
    if (mealTotals == null) {
      return {'calories': 0.0, 'carbs': 0.0, 'fat': 0.0, 'protein': 0.0};
    }
    return {
      'calories': (mealTotals!['totalCalories'] ?? 0.0).toDouble(),
      'carbs': (mealTotals!['totalCarbs'] ?? 0.0).toDouble(),
      'fat': (mealTotals!['totalFat'] ?? 0.0).toDouble(),
      'protein': (mealTotals!['totalProtein'] ?? 0.0).toDouble(),
    };
  }

  Future<bool> addFoodToMealPlan({
    required int mealPlanId,
    required int dayNumber,
    required String mealType,
    required int foodId,
    required double quantity,
    required BuildContext context,
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
        final mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
        if (mealPlan != null && mealPlan.mealPlanDetails != null) {
          existingMeals = mealPlan.mealPlanDetails!
              .where((detail) => detail.mealType == mealType && detail.dayNumber == dayNumber)
              .toList();
        } else {
          errorMessage = "Không thể tải danh sách món ăn sau khi thêm";
          isLoading = false;
          notifyListeners();
          return false;
        }
        // Cập nhật lại mealTotals sau khi thêm món ăn
        await fetchMealTotals(mealPlanId, dayNumber, mealType);
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

  Future<bool> removeFoodFromMealPlan(int mealPlanDetailId, int mealPlanId, int dayNumber, String mealType) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final success = await _mealPlanService.deleteMealPlanDetail(mealPlanDetailId);

      if (success) {
        existingMeals.removeWhere((meal) => meal.mealPlanDetailId == mealPlanDetailId);
        // Cập nhật lại mealTotals sau khi xóa món ăn
        await fetchMealTotals(mealPlanId, dayNumber, mealType);
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