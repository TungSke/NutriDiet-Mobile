class MealPlanDetail {
  final int mealPlanDetailId;
  final int mealPlanId;
  final int? foodId;
  final String? foodName;
  final double? quantity;
  final String? mealType;
  final int dayNumber;
  final double? totalCalories;
  final double? totalCarbs;
  final double? totalFat;
  final double? totalProtein;

  MealPlanDetail({
    required this.mealPlanDetailId,
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
    if (json['mealPlanDetailId'] == null || json['dayNumber'] == null) {
      throw Exception("Required fields (mealPlanDetailId, dayNumber) cannot be null");
    }
    return MealPlanDetail(
      mealPlanDetailId: json['mealPlanDetailId'] as int,
      mealPlanId: mealPlanId, // Sử dụng mealPlanId từ đối số
      foodId: json['foodId'],
      foodName: json['foodName'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      mealType: json['mealType'],
      dayNumber: json['dayNumber'] as int,
      totalCalories: (json['totalCalories'] as num?)?.toDouble(),
      totalCarbs: (json['totalCarbs'] as num?)?.toDouble(),
      totalFat: (json['totalFat'] as num?)?.toDouble(),
      totalProtein: (json['totalProtein'] as num?)?.toDouble(),
    );
  }
}