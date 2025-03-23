import 'package:diet_plan_app/components/ingredient_component_widget.dart';
import 'package:diet_plan_app/services/ingredient_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IngredientComponentModel extends FlutterFlowModel<IngredientComponentWidget> {
  DateTimeRange? calendarSelectedDay;
  List<Map<String, dynamic>> ingredients = [];
  IngredientService _service = IngredientService();
  bool _isLoading = false;
  VoidCallback? _updateCallback;
  String _searchQuery = '';

  bool get isLoading => _isLoading;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  Future<void> fetchIngredients({String? search}) async {
    try {
      _isLoading = true;
      _updateCallback?.call();

      final response = await _service.getAllAllergies(
        pageIndex: 1,
        pageSize: 10,
        search: _searchQuery,
      );
      final responseBody = jsonDecode(response.body);
      ingredients = List<Map<String, dynamic>>.from(responseBody["data"] ?? []);

      _isLoading = false;
      _updateCallback?.call(); // Gọi callback khi hoàn tất
    } catch (e) {
      _isLoading = false;
      _updateCallback?.call();
      print('Error fetching ingredients: $e');
    }
  }

  void searchIngredients(String query) {
    _searchQuery = query.trim();
    fetchIngredients(search: _searchQuery);
  }

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    fetchIngredients();
  }

  @override
  void dispose() {
    _updateCallback = null;
    ingredients = [];
  }
}