import 'dart:async';
import 'package:diacritic/diacritic.dart' as diacritic;
import '../services/models/mealplan.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_mealplan_component_widget.dart';
import 'package:flutter/material.dart';
import '../services/mealplan_service.dart';

class MyMealPlanComponentModel extends FlutterFlowModel<MyMealPlanScreenWidget> {
  final MealPlanService _mealPlanService = MealPlanService();
  List<MealPlan> mealPlans = [];
  bool isLoading = true;
  int pageIndex = 1;
  int pageSize = 10;
  String searchQuery = "";
  String? selectedFilter;

  VoidCallback? _updateCallback;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  Future<void> fetchMealPlans({String? searchQuery}) async {
    try {
      isLoading = true;
      if (searchQuery != null) {
        this.searchQuery = searchQuery;
      }
      if (_updateCallback != null) _updateCallback!();

      final fetchedMealPlans = await _mealPlanService.getMyMealPlan(
        pageIndex: pageIndex,
        pageSize: pageSize,
      );

      mealPlans = fetchedMealPlans;
    } catch (e) {
      mealPlans = [];
    } finally {
      isLoading = false;
      if (_updateCallback != null) _updateCallback!();
    }
  }

  Future<int?> createMealPlan(String planName, String? healthGoal) async{
    try{
      isLoading = true;
      if(_updateCallback!= null) _updateCallback!();
      final newMealPlan = MealPlan(
          planName: planName,
          healthGoal: healthGoal,
          mealPlanDetails: []);
      final success = await _mealPlanService.createMealPlan(newMealPlan);
      if(success){
        await fetchMealPlans();
        final createdMealPlan = mealPlans.firstWhere(
            (meal) => meal.planName == planName && meal.healthGoal == healthGoal,
          orElse: () => throw Exception('Không tìm thấy thực đơn vừa tạo')
        );

      return createdMealPlan.mealPlanId; // trả về mealPlanId luôn để chuyển hướng

      }
      else{
        throw Exception("Không thể tạo Meal Plan");
      }
    }catch(e){
      debugPrint('Lỗi khi tạo meal plan: $e');
      return null;
    }finally{
      isLoading = false;
      if(_updateCallback!= null) _updateCallback!();
    }
  }
  Future<Map<String, dynamic>> createSuitableMealPlanByAI() async {
    try {
      isLoading = true;
      if (_updateCallback != null) _updateCallback!();

      final result = await _mealPlanService.createSuitableMealPlanByAI();

      isLoading = false;
      if (_updateCallback != null) _updateCallback!();

      return result;
    } catch (e) {
      isLoading = false;
      if (_updateCallback != null) _updateCallback!();
      return {
        'success': false,
        'mealPlan': null,
        'message': 'Error creating AI meal plan: $e'
      };
    }
  }

  List<MealPlan> getFilteredMealPlans() {
    String searchQueryNoDiacritics = removeDiacritics(searchQuery.toLowerCase());

    final filtered = mealPlans.where((plan) {
      String planNameNoDiacritics = removeDiacritics(plan.planName.trim().toLowerCase() ?? "");
      final matchesSearch = searchQuery.isEmpty || planNameNoDiacritics.contains(searchQueryNoDiacritics);
      final matchesFilter = selectedFilter == null ||
          (plan.healthGoal?.trim().toLowerCase() == selectedFilter?.trim().toLowerCase());
      return matchesSearch && matchesFilter;
    }).toList();

    return filtered;
  }

  String removeDiacritics(String str) {
    return diacritic.removeDiacritics(str);
  }

  void setFilter(String? filter) {
    selectedFilter = filter;
    if (_updateCallback != null) _updateCallback!();
  }

  Future<bool> deleteMealPlan(int mealPlanId) async {
    try {
      isLoading = true;
      if (_updateCallback != null) _updateCallback!();

      final success = await _mealPlanService.deleteMealPlan(mealPlanId);
      if (success) {
        mealPlans.removeWhere((mealPlan) => mealPlan.mealPlanId == mealPlanId);
        isLoading = false;
        if (_updateCallback != null) _updateCallback!();
        return true;
      } else {
        throw Exception("Không thể xóa Meal Plan");
      }
    } catch (e) {
      isLoading = false;
      if (_updateCallback != null) _updateCallback!();
      return false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}