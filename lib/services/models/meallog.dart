class MealLog {
  final int mealLogId;
  final DateTime logDate;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final List<MealLogDetail> mealLogDetails;

  MealLog({
    required this.mealLogId,
    required this.logDate,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.mealLogDetails,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      mealLogId: json['mealLogId'] ?? 0,
      logDate: DateTime.parse(json['logDate']),
      totalCalories: json['totalCalories'] ?? 0,
      totalProtein: json['totalProtein'] ?? 0,
      totalCarbs: json['totalCarbs'] ?? 0,
      totalFat: json['totalFat'] ?? 0,
      mealLogDetails: (json['mealLogDetails'] as List<dynamic>? ?? [])
          .map((e) => MealLogDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MealLogDetail {
  final String foodName;
  final String mealType;
  final String? servingSize;
  final int quantity;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  MealLogDetail({
    required this.foodName,
    required this.mealType,
    this.servingSize,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MealLogDetail.fromJson(Map<String, dynamic> json) {
    return MealLogDetail(
      foodName: json['foodName'] ?? '',
      mealType: json['mealType'] ?? '',
      servingSize: json['servingSize']?.toString(),
      quantity: json['quantity'] ?? 0,
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fat: json['fat'] ?? 0,
    );
  }
}
