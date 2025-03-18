class MealPlanDetail {
  int? mealPlanDetailId;
  final int mealPlanId;
  final int? foodId;
  String? foodName;
  final double? quantity;
  final String? mealType;
  final int dayNumber;
  double? totalCalories;
  double? totalCarbs;
  double? totalFat;
  double? totalProtein;

  MealPlanDetail({
    this.mealPlanDetailId,
    required this.mealPlanId,
    this.foodId,
    this.foodName,
    this.quantity,
    this.mealType,
    required this.dayNumber,
    this.totalCalories,
    this.totalCarbs,
    this.totalFat,
    this.totalProtein,
  });

  factory MealPlanDetail.fromJson(Map<String, dynamic> json, int mealPlanId) {
    if (json['dayNumber'] == null) {
      throw Exception("Required field (dayNumber) cannot be null");
    }
    return MealPlanDetail(
      mealPlanDetailId: json['mealPlanDetailId'] as int?,
      mealPlanId: mealPlanId,
      foodId: json['foodId'] as int?,
      foodName: json['foodName'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      mealType: json['mealType'] as String?,
      dayNumber: json['dayNumber'] as int,
      totalCalories: (json['totalCalories'] as num?)?.toDouble(),
      totalCarbs: (json['totalCarbs'] as num?)?.toDouble(),
      totalFat: (json['totalFat'] as num?)?.toDouble(),
      totalProtein: (json['totalProtein'] as num?)?.toDouble(),
    );
  }
}