import 'package:diet_plan_app/services/food_service.dart';
import 'package:diet_plan_app/services/models/food.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_widget.dart' show FoodListComponentWidget;

class FoodListComponentModel extends FlutterFlowModel<FoodListComponentWidget> {
  final FoodService _foodService = FoodService();
  Future<List<Food>> foodList = Future.value([]);
  List<int> favoriteFoodIds = [];

  Future<void> fetchFoods({String? search, required BuildContext context}) async {
    search = search?.isEmpty ?? true ? "" : search;

    try {
      // Đồng bộ hóa việc lấy dữ liệu từ getAllFoods và getFavoriteFoods
      final results = await Future.wait([
        _foodService.getAllFoods(pageIndex: 1, pageSize: 50, search: search),
        _foodService.getFavoriteFoods(pageIndex: 0, pageSize: 100, context: context),
      ]);

      foodList = Future.value(results[0]);
      favoriteFoodIds = (results[1] as List<Food>).map((food) => food.foodId).toList();
    } catch (e) {
      print("Error fetching food data: $e");
      foodList = Future.value([]);
      favoriteFoodIds = [];
    }
  }

  Future<bool> addFavoriteFood(int foodId, BuildContext context) async {
    final success = await _foodService.addFavoriteFood(foodId: foodId, context: context);
    if (success) {
      favoriteFoodIds.add(foodId);
    }
    return success;
  }

  Future<bool> removeFavoriteFood(int foodId, BuildContext context) async {
    final success = await _foodService.removeFavoriteFood(foodId: foodId, context: context);
    if (success) {
      favoriteFoodIds.remove(foodId);
    }
    return success;
  }

  bool isFavorite(int foodId) => favoriteFoodIds.contains(foodId);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}