import 'package:diet_plan_app/services/models/foodservingsize.dart';
import 'package:diet_plan_app/services/models/ingredient.dart';

class Food {
  final int foodId;
  final String foodName;
  final String? mealType;
  final String? imageUrl;
  final String? foodType;
  final String? description;
  final int? servingSizeId;
  final List<FoodServingSize> foodServingSizes; // Bỏ nullable vì có giá trị mặc định
  final List<Ingredient> ingredients; // Thêm ingredients

  Food({
    required this.foodId,
    required this.foodName,
    this.mealType,
    this.imageUrl,
    this.foodType,
    this.description,
    this.servingSizeId,
    this.foodServingSizes = const [], // Giá trị mặc định
    this.ingredients = const [], // Giá trị mặc định
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['foodId'] as int,
      foodName: json['foodName'] as String,
      mealType: json['mealType'] as String?,
      imageUrl: json['imageUrl'] as String?,
      foodType: json['foodType'] as String?,
      description: json['description'] as String?,
      servingSizeId: json['servingSizeId'] as int?,
      foodServingSizes: (json['foodServingSizes'] as List<dynamic>?)
          ?.map((e) => FoodServingSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'foodId': foodId,
    'foodName': foodName,
    'mealType': mealType,
    'imageUrl': imageUrl,
    'foodType': foodType,
    'description': description,
    'servingSizeId': servingSizeId,
    'foodServingSizes': foodServingSizes.map((e) => e.toJson()).toList(),
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    };
  }
}