import '../../services/mealplan_service.dart';
import '../../services/models/mealplan.dart';
import '../../services/models/mealplandetail.dart';

class MealPlanDetailModel {
  final MealPlanService _mealPlanService = MealPlanService();
  MealPlan? mealPlan;
  Map<String, dynamic>? mealPlanTotals; // Lưu trữ dữ liệu từ API mới
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchMealPlanById(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;

      // Gọi cả hai API
      mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
      mealPlanTotals = await _mealPlanService.getMealPlanDetailTotals(mealPlanId);

      isLoading = false;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
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