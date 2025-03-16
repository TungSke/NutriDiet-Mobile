import 'package:diet_plan_app/components/mealLog_component_widget.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MealLogComponentModel extends FlutterFlowModel<MealLogComponentWidget> with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  int calorieGoal = 1300;
  int foodCalories = 259;
  int exerciseCalories = 3;

  int get remainingCalories => calorieGoal - foodCalories + exerciseCalories;

  final List<String> mealCategories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Exercise'];

  void changeDate(DateTime newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void updateCalorieGoal(int newGoal) {
    calorieGoal = newGoal;
    notifyListeners();
  }

  void updateFoodCalories(int newCalories) {
    foodCalories = newCalories;
    notifyListeners();
  }

  void updateExerciseCalories(int newCalories) {
    exerciseCalories = newCalories;
    notifyListeners();
  }

  @override
  void initState(BuildContext context) {}

}