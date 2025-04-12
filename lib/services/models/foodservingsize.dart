class FoodServingSize {
  final int servingSizeId;
  final int quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double glucid;
  final double fiber;

  FoodServingSize({
    required this.servingSizeId,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.glucid,
    required this.fiber,
  });

  factory FoodServingSize.fromJson(Map<String, dynamic> json) {
    return FoodServingSize(
      servingSizeId: json['servingSizeId'] as int,
      quantity: json['quantity'] as int,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      glucid: (json['glucid'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servingSizeId': servingSizeId,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'glucid': glucid,
      'fiber': fiber,
    };
  }
}