import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import '../../services/mealplan_service.dart';
import '../../services/models/mealplan.dart';


class SampleMealPlanModel extends ChangeNotifier {
  final MealPlanService _mealPlanService = MealPlanService();
  List<MealPlan> _mealPlans = [];
  List<MealPlan> _filteredMealPlans = [];
  bool _isLoading = false;
  String _searchQuery = "";
  String? _selectedFilter;

  List<MealPlan> get mealPlans => _mealPlans;
  List<MealPlan> get filteredMealPlans => _filteredMealPlans;
  String? get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  Future<void> fetchSampleMealPlans({int pageIndex = 1, int pageSize = 10, String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _mealPlans = await _mealPlanService.getSampleMealPlan(
          pageIndex: pageIndex, pageSize: pageSize, search: search);
      _applyFilters();
    } catch (e) {
      debugPrint("Lỗi khi lấy dữ liệu: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateFilter(String? filter) {
    if (_selectedFilter == filter) {
      _selectedFilter = null; // Nếu chọn lại filter cũ => clear filter
    } else {
      _selectedFilter = filter;
    }
    _applyFilters();
  }

  void _applyFilters() {
    String searchQueryNoDiacritics = removeDiacritics(_searchQuery.toLowerCase());

    _filteredMealPlans = _mealPlans.where((plan) {
      String planNameNoDiacritics = removeDiacritics(plan.planName?.trim().toLowerCase() ?? "");
      final matchesSearch = _searchQuery.isEmpty || planNameNoDiacritics.contains(searchQueryNoDiacritics);

      final matchesFilter = _selectedFilter == null ||
          (plan.healthGoal?.trim().toLowerCase().contains(_selectedFilter!.trim().toLowerCase()) ?? false);

      return matchesSearch && matchesFilter;
    }).toList();

    notifyListeners();
  }
}