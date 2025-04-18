import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import '../../services/mealplan_service.dart';
import '../../services/models/mealplan.dart';

class SampleMealPlanModel extends ChangeNotifier {
  final MealPlanService _mealPlanService = MealPlanService();
  List<MealPlan> _mealPlans = [];
  List<MealPlan> _filteredMealPlans = [];
  bool _isLoading = false;
  bool _isLoadingMore = false; // Trạng thái tải thêm
  String _searchQuery = "";
  String? _selectedFilter;
  int _currentPage = 1; // Trang hiện tại
  bool _hasMore = true; // Còn dữ liệu để tải không
  final int _pageSize = 10;

  List<MealPlan> get mealPlans => _mealPlans;
  List<MealPlan> get filteredMealPlans => _filteredMealPlans;
  String? get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchSampleMealPlans({bool reset = false, String? search}) async {
    if (reset) {
      _currentPage = 1;
      _mealPlans = [];
      _hasMore = true;
    }

    if (!_hasMore || _isLoading || _isLoadingMore) return;

    _isLoading = reset;
    _isLoadingMore = !reset;
    notifyListeners();

    try {
      final newMealPlans = await _mealPlanService.getSampleMealPlan(
        pageIndex: _currentPage,
        pageSize: _pageSize,
        search: search ?? _searchQuery,
      );

      _mealPlans = reset ? newMealPlans : [..._mealPlans, ...newMealPlans];
      _hasMore = newMealPlans.length == _pageSize; // Còn dữ liệu nếu nhận đủ pageSize
      _currentPage++;
      _applyFilters();
    } catch (e) {
      debugPrint("Lỗi khi lấy dữ liệu: $e");
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    fetchSampleMealPlans(reset: true, search: query); // Reset khi tìm kiếm
  }

  void updateFilter(String? filter) {
    if (_selectedFilter == filter) {
      _selectedFilter = null;
    } else {
      _selectedFilter = filter;
    }
    _applyFilters();
  }

  void _applyFilters() {
    String searchQueryNoDiacritics = removeDiacritics(_searchQuery.toLowerCase());

    _filteredMealPlans = _mealPlans.where((plan) {
      String planNameNoDiacritics = removeDiacritics(plan.planName.trim().toLowerCase() ?? "");
      final matchesSearch = _searchQuery.isEmpty || planNameNoDiacritics.contains(searchQueryNoDiacritics);

      final matchesFilter = _selectedFilter == null ||
          (plan.healthGoal?.trim().toLowerCase().contains(_selectedFilter!.trim().toLowerCase()) ?? false);

      return matchesSearch && matchesFilter;
    }).toList();

    notifyListeners();
  }
}