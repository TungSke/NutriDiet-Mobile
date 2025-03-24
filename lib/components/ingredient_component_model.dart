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

  Future<void> fetchIngredients({String? search,required BuildContext context}) async {
    try {
      _isLoading = true;
      _updateCallback?.call();

      // Gọi API lấy danh sách ingredient
      final response = await _service.getAllAllergies(
        pageIndex: 1,
        pageSize: 10,
        search: _searchQuery,
      );
      final responseBody = jsonDecode(response.body);
      ingredients = List<Map<String, dynamic>>.from(responseBody["data"] ?? []);

      // Gọi API lấy danh sách preference
      final preferenceResponse = await _service.getIngreDientPreference(context: context);
      final preferenceBody = jsonDecode(preferenceResponse.body);
      final preferences = preferenceBody['data'] ?? [];

      // Áp dụng preference vào danh sách ingredients
      for (var ingredient in ingredients) {
        final preference = preferences.firstWhere(
              (pref) => pref['ingredientId'] == ingredient['ingredientId'],
          orElse: () => null,
        );
        ingredient['preference'] = preference != null
            ? (preference['level'] == 1
            ? 'Like'
            : preference['level'] == -1
            ? 'Dislike'
            : 'Neutral')
            : 'Neutral';
      }

      _isLoading = false;
      _updateCallback?.call();
    } catch (e) {
      _isLoading = false;
      _updateCallback?.call();
      print('Error fetching ingredients: $e');
    }
  }

  void searchIngredients(String query, BuildContext context) {
    _searchQuery = query.trim();
    fetchIngredients(search: _searchQuery, context: context);
  }

  Future<void> updateIngredientPreference(int ingredientId, String preference, BuildContext context) async {
    try {
      await _service.updateIngreDientPreference(ingredientId: ingredientId, preferenceLevel: preference, context: context);
    } catch (e) {
      print('Error updating ingredient preference: $e');
    }
  }

  Future<void> getIngredientPreference(BuildContext context) async{
    try {
      await _service.getIngreDientPreference(context: context);
    } catch (e) {
      print('Error get ingredient preference: $e');
    }
  }

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    fetchIngredients(context: context);
  }

  @override
  void dispose() {
    _updateCallback = null;
    ingredients = [];
  }
}