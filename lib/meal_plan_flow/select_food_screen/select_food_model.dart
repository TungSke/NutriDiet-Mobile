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

  Future<bool> addFoodToMealPlan({
    required int mealPlanId,
    required int dayNumber,
    required String mealType,
    required int foodId,
    required double quantity,
    required BuildContext context, // thêm context để thực hiện cho check avoidance
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