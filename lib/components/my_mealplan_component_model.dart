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

      if (_updateCallback != null) {
        _updateCallback!();
      }
      final fetchedMealPlans = await _mealPlanService.getMyMealPlan(
        pageIndex: pageIndex,
        pageSize: pageSize,
      );

      debugPrint("Fetched meal plans: ${fetchedMealPlans.map((m) => m.planName).toList()}");
      mealPlans = fetchedMealPlans;
    } catch (e) {
      debugPrint("Error fetching meal plans: $e");
      mealPlans = [];
    } finally {
      isLoading = false;
      if (_updateCallback != null) { // Kiểm tra null trước khi gọi
        _updateCallback!();
      } else {
        debugPrint("Lỗi: _updateCallback là null");
      }
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
        // Xóa mealPlan khỏi danh sách cục bộ
        mealPlans.removeWhere((mealPlan) => mealPlan.mealPlanId == mealPlanId);
        debugPrint("Đã xóa Meal Plan $mealPlanId khỏi danh sách cục bộ");
        isLoading = false;
        if (_updateCallback != null) _updateCallback!();
        return true;
      } else {
        throw Exception("Không thể xóa Meal Plan");
      }
    } catch (e) {
      debugPrint("Lỗi khi xóa Meal Plan: $e");
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