import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'api_service.dart';
import 'models/food.dart';
import 'package:http/http.dart' as http;

class FoodService {
  final ApiService _apiService = ApiService();

  Future<List<Food>> getAllFoods(
      {required int pageIndex, required int pageSize, String? search}) async {
    try {
      final response = await _apiService
          .get(
          "api/food?pageIndex=$pageIndex&pageSize=$pageSize&search=$search");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        return data.map((e) => Food.fromJson(e)).toList();
      }

      if (response.statusCode == 204) return [];

      throw Exception(
          'Failed to load allergies: ${response.statusCode}, ${response.body}');
    } catch (e) {
      print("Error fetching allergies: $e");
      return [];
    }
  }

  Future<http.Response> getFoodById({required int foodId}) async {
    final response = await _apiService.get("api/food/$foodId");
    return response;
  }

  Future<http.Response> getFoodRecipe(
      {required int foodId, required BuildContext context}) async {
    String? accessToken = await _apiService.getAccessToken(context);
    final response =
    await _apiService.get("api/food/recipe/$foodId", token: accessToken);
    return response;
  }

  Future<http.Response> createFoodRecipeAI({required int foodId,
    required int cusineId,
    required BuildContext context}) async {
    String? accessToken = await _apiService.getAccessToken(context);

    final response = await _apiService.post("api/food/recipe/$foodId/$cusineId",
        body: {}, token: accessToken);
    return response;
  }

  Future<http.Response> RejectRecipeAI(
      {required int foodId, required String rejectionReason, required BuildContext context}) async {
    String? accessToken = await _apiService.getAccessToken(context);

    final response = await _apiService.post("/api/food/reject-recipe",
        body: {'foodId': foodId, 'rejectionReason': rejectionReason},
        token: accessToken);
    return response;
  }

  Future<http.Response> checkFoodAvoidance(
      {required int foodId, required BuildContext context}) async {
    String? accessToken = await _apiService.getAccessToken(context);

    final response = await _apiService.get(
      "api/food/avoidance/$foodId",
      token: accessToken,
    );

    return response;
  }

  Future<List<Food>> getFavoriteFoods({
    required int pageIndex,
    required int pageSize,
    required BuildContext context,
  }) async {
    try {
      String? accessToken = await _apiService.getAccessToken(context);
      if (accessToken == null) {
        throw Exception("No access token available");
      }
      final response = await _apiService.get(
        "api/food/user-food-preference?pageIndex=$pageIndex&pageSize=$pageSize",
        token: accessToken,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'] as List<dynamic>;
        return data.map((e) =>
            Food(
              foodId: e['foodId'],
              foodName: e['foodName'],
            )).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Failed to load favorite foods: ${response.statusCode}, ${response
                .body}');
      }
    } catch (e) {
      print("Error fetching favorite foods: $e");
      rethrow;
    }
  }

  Future<bool> addFavoriteFood({
    required int foodId,
    required BuildContext context,
  }) async {
    try {
      String? accessToken = await _apiService.getAccessToken(context);
      if (accessToken == null) {
        throw Exception("No access token available");
      }
      final response = await _apiService.post(
        "api/food/user-food-preference/$foodId",
        body: {},
        token: accessToken,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error adding favorite food: $e");
      return false;
    }
  }

  Future<bool> removeFavoriteFood({
    required int foodId,
    required BuildContext context,
  }) async {
    try {
      String? accessToken = await _apiService.getAccessToken(context);
      if (accessToken == null) {
        throw Exception("No access token available");
      }
      final response = await _apiService.delete(
        "api/food/user-food-preference/$foodId",
        token: accessToken,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error removing favorite food: $e");
      return false;
    }
  }
}