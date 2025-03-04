import 'package:diet_plan_app/services/food_service.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'brek_fast_i_ingredients_widget.dart' show BrekFastIIngredientsWidget;
import 'package:flutter/material.dart';

class BrekFastIIngredientsModel
    extends FlutterFlowModel<BrekFastIIngredientsWidget> {
  ///  Local state fields for this page.

  int tabar = 0;
  Map<String, dynamic>? food;
  FoodService _foodService = FoodService();

  Future<void> loadFood(int foodId) async {
    final response = await _foodService.getFoodById(foodId: foodId);
    final responseBody = jsonDecode(response.body);
    food = responseBody["data"];
  }
  @override
  void initState(BuildContext context){}

  @override
  void dispose() {}
}
