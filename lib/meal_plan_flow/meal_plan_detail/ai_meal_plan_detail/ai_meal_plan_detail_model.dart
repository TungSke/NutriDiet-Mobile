import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../../../services/mealplan_service.dart';
import '../../../services/food_service.dart';
import '../../../services/models/mealplan.dart';
import '../../../services/models/mealplandetail.dart';
import '../../../services/models/food.dart';

class AIMealPlanDetailModel extends ChangeNotifier {
  final MealPlanService _mealPlanService = MealPlanService();
  final FoodService _foodService = FoodService();
  MealPlan? mealPlan;
  Map<String, dynamic>? mealPlanTotals;
  bool isLoading = false;
  String? errorMessage;
  Map<int, Food> _foodCache = {};

  void setInitialMealPlan(MealPlan initialMealPlan) async {
    isLoading = true;
    notifyListeners();

    mealPlan = initialMealPlan;
    mealPlanTotals = null;
    await _fetchFoodDetailsForMeals();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMealPlanById(int mealPlanId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      mealPlan = await _mealPlanService.getMealPlanById(mealPlanId);
      mealPlanTotals = await _mealPlanService.getMealPlanDetailTotals(mealPlanId);
      await _fetchFoodDetailsForMeals();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _fetchFoodDetailsForMeals() async {
    if (mealPlan == null || mealPlan!.mealPlanDetails.isEmpty) return;

    print("Fetching food details for ${mealPlan!.mealPlanDetails.length} meals");
    try {
      for (var detail in mealPlan!.mealPlanDetails) {
        if (detail.foodId != null && _foodCache[detail.foodId] == null) {
          final response = await _foodService.getFoodById(foodId: detail.foodId!);
          if (response.statusCode == 200) {
            final json = jsonDecode(response.body) as Map<String, dynamic>;
            final foodData = json['data'] as Map<String, dynamic>;

            foodData['calories'] = _convertToInt(foodData['calories']);
            foodData['protein'] = _convertToInt(foodData['protein']);
            foodData['carbs'] = _convertToInt(foodData['carbs']);
            foodData['fat'] = _convertToInt(foodData['fat']);
            foodData['glucid'] = _convertToInt(foodData['glucid']);
            foodData['fiber'] = _convertToInt(foodData['fiber']);

            final food = Food.fromJson(foodData);
            _foodCache[detail.foodId!] = food;
            detail.foodName = food.foodName;
            final quantity = detail.quantity ?? 1;
            detail.totalCalories = (food.calories ?? 0) * quantity;
            detail.totalCarbs = (food.carbs ?? 0) * quantity;
            detail.totalFat = (food.fat ?? 0) * quantity;
            detail.totalProtein = (food.protein ?? 0) * quantity;
          } else {
            detail.foodName = "Món ăn ID: ${detail.foodId} (Không tải được)";
          }
        } else if (detail.foodId != null) {
          final food = _foodCache[detail.foodId!]!;
          detail.foodName = food.foodName;
          final quantity = detail.quantity ?? 1;
          detail.totalCalories = (food.calories ?? 0) * quantity;
          detail.totalCarbs = (food.carbs ?? 0) * quantity;
          detail.totalFat = (food.fat ?? 0) * quantity;
          detail.totalProtein = (food.protein ?? 0) * quantity;
        }
      }
    } catch (e) {
      for (var detail in mealPlan!.mealPlanDetails) {
        if (detail.foodName == null) {
          detail.foodName = "Món ăn ID: ${detail.foodId} (Lỗi: $e)";
        }
      }
    }
    notifyListeners();
  }

  int? _convertToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<Map<String, dynamic>> createSuitableMealPlanByAI() async {
    return await _mealPlanService.createSuitableMealPlanByAI();
  }

  Future<Map<String, dynamic>> rejectMealPlan(String reason) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _mealPlanService.rejectMealPlan(reason);
      if (result['success'] && result['mealPlan'] != null) {
        mealPlan = result['mealPlan'] as MealPlan;
        await _fetchFoodDetailsForMeals();
      }

      isLoading = false;
      errorMessage = result['success'] ? null : result['message'];
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveMealPlanAI({String? feedback}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _mealPlanService.saveMealPlanAI(feedback: feedback);
      if (result['success']) {}

      isLoading = false;
      errorMessage = result['success'] ? null : result['message'];
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  Map<String, double> getNutrientTotalsForDay(int dayNumber) {
    final meals = getMealsForDay(dayNumber);
    double calories = 0, carbs = 0, fat = 0, protein = 0;

    if (mealPlanTotals != null && mealPlanTotals!['totalByDayNumber'] != null) {
      final dayTotals = (mealPlanTotals!['totalByDayNumber'] as List)
          .firstWhere((day) => day['dayNumber'] == dayNumber, orElse: () => null);
      if (dayTotals != null) {
        return {
          "calories": (dayTotals['totalCalories'] ?? 0).toDouble(),
          "carbs": (dayTotals['totalCarbs'] ?? 0).toDouble(),
          "fat": (dayTotals['totalFat'] ?? 0).toDouble(),
          "protein": (dayTotals['totalProtein'] ?? 0).toDouble(),
        };
      }
    }
    for (var mealList in meals.values) {
      for (var meal in mealList) {
        calories += meal.totalCalories ?? 0;
        carbs += meal.totalCarbs ?? 0;
        fat += meal.totalFat ?? 0;
        protein += meal.totalProtein ?? 0;
      }
    }
    return {
      "calories": calories,
      "carbs": carbs,
      "fat": fat,
      "protein": protein,
    };
  }

  Map<String, List<MealPlanDetail>> getMealsForDay(int dayNumber) {
    if (mealPlan == null) return {};
    final meals = mealPlan!.mealPlanDetails.where((detail) => detail.dayNumber == dayNumber).toList();

    // group food have the same mealtype
    Map<String, List<MealPlanDetail>> groupMeals = {};
    for(var meal in meals){
      final mealType = meal.mealType ?? "không xác định";
      if(!groupMeals.containsKey(mealType)){
        groupMeals[mealType] = [];
      }
      groupMeals[mealType]!.add(meal);
    }
    return groupMeals;
  }

  int getTotalDays() {
    if (mealPlanTotals != null && mealPlanTotals!['totalByDayNumber'] != null) {
      return (mealPlanTotals!['totalByDayNumber'] as List)
          .map((day) => day['dayNumber'] as int)
          .reduce((a, b) => a > b ? a : b);
    }
    if (mealPlan == null || mealPlan!.mealPlanDetails.isEmpty) return 1;
    return mealPlan!.mealPlanDetails
        .map((detail) => detail.dayNumber)
        .reduce((a, b) => a > b ? a : b);
  }
}