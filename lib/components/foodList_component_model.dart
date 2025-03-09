import 'package:diet_plan_app/services/food_service.dart';
import 'package:diet_plan_app/services/models/food.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'foodList_component_widget.dart' show FoodListComponentWidget;

class FoodListComponentModel extends FlutterFlowModel<FoodListComponentWidget> {
  final FoodService _foodService = FoodService();
  late Future<List<Food>> foodList;

  Future<void> fetchFoods({String? search}) async {
    search = search?.isEmpty ?? true ? "" : search;

    try {
      foodList = _foodService.getAllFoods(pageIndex: 1, pageSize: 30, search: search);
      print("Fetching foods with search query: $search");
    } catch (e) {
      print("Error fetching food data: $e");
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
