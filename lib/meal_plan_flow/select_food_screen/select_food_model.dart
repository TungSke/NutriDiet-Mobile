import 'package:flutter/material.dart';
import '../../services/food_service.dart';
import '../../services/models/food.dart';
import '../../services/models/mealplandetail.dart';
import '../../services/mealplan_service.dart';

class SelectFoodModel extends ChangeNotifier {
  final FoodService foodService = FoodService();
  final MealPlanService _mealPlanService = MealPlanService();
  List<Food> foods = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchFoods(
      {String? search, int pageIndex = 1, int pageSize = 50}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final query = (search == null || search.isEmpty) ? "" : search;
      foods = await foodService.getAllFoods(
          pageIndex: pageIndex, pageSize: pageSize, search: query);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Lỗi khi tải danh sách món ăn: $e";
      notifyListeners();
    }
  }

  // Future<bool> addFoodToMealPlan({
  //   required int mealPlanId,
  //   required int dayNumber,
  //   required String mealType,
  //   required int foodId,
  //   required double quantity,
  // }) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     notifyListeners();
  //
  //     // Gọi API createMealPlanDetail (giả định, bạn sẽ implement sau)
  //     final success = await _mealPlanService.createMealPlanDetail(
  //       mealPlanId: mealPlanId,
  //       dayNumber: dayNumber,
  //       mealType: mealType,
  //       foodId: foodId,
  //       quantity: quantity,
  //     );
  //
  //     isLoading = false;
  //     if (!success) {
  //       errorMessage = "Không thể thêm món ăn vào thực đơn";
  //     }
  //     notifyListeners();
  //     return success;
  //   } catch (e) {
  //     isLoading = false;
  //     errorMessage = "Lỗi khi thêm món ăn: $e";
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> removeFoodFromMealPlan(int mealPlanDetailId) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     notifyListeners();
  //
  //     // Gọi API deleteMealPlanDetail (giả định, bạn sẽ implement sau)
  //     final success = await _mealPlanService.deleteMealPlanDetail(mealPlanDetailId);
  //
  //     isLoading = false;
  //     if (!success) {
  //       errorMessage = "Không thể xóa món ăn khỏi thực đơn";
  //     }
  //     notifyListeners();
  //     return success;
  //   } catch (e) {
  //     isLoading = false;
  //     errorMessage = "Lỗi khi xóa món ăn: $e";
  //     notifyListeners();
  //     return false;
  //   }
  // }
}
