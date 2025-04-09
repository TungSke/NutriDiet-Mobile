class MealLog {
  final int mealLogId;
  final DateTime logDate;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final int dailyCalories;
  final List<MealLogDetail> mealLogDetails;

  MealLog({
    required this.mealLogId,
    required this.logDate,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.dailyCalories,
    required this.mealLogDetails,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      mealLogId: json['mealLogId'] ?? 0,
      logDate: DateTime.parse(json['logDate']),
      totalCalories: json['totalCalories'] ?? 0,
      totalProtein: (json['totalProtein'] as num?)?.toInt() ?? 0,
      totalCarbs: (json['totalCarbs'] as num?)?.toInt() ?? 0,
      totalFat: (json['totalFat'] as num?)?.toInt() ?? 0,
      dailyCalories: json['dailyCalories'] ?? 0,
      mealLogDetails: (json['mealLogDetails'] as List<dynamic>? ?? [])
          .map((e) => MealLogDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MealLogDetail {
  final int detailId;
  final String foodName;
  final String mealType;
  final String? servingSize;
  final int quantity;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String? imageUrl;

  MealLogDetail({
    required this.detailId,
    required this.foodName,
    required this.mealType,
    this.servingSize,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
  });

  factory MealLogDetail.fromJson(Map<String, dynamic> json) {
    return MealLogDetail(
      detailId: (json['detailId'] as num?)?.toInt() ?? 0,
      foodName: json['foodName'] ?? '',
      mealType: json['mealType'] ?? '',
      servingSize: json['servingSize']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
