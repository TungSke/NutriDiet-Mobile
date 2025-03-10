import 'mealplandetail.dart';

class MealPlan {
  final int mealPlanId;
  final String planName;
  final String? healthGoal;
  final int? duration;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;
  final List<MealPlanDetail> mealPlanDetails;

  MealPlan({
    required this.mealPlanId,
    required this.planName,
    this.healthGoal,
    this.duration,
    this.status,
    this.createdBy,
    this.createdAt,
    required this.mealPlanDetails,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    if (json['mealPlanId'] == null) {
      throw Exception("mealPlanId cannot be null");
    }
    final mealPlanId = json['mealPlanId'] as int;
    return MealPlan(
      mealPlanId: mealPlanId,
      planName: json['planName'],
      healthGoal: json['healthGoal'],
      duration: json['duration'],
      status: json['status'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      mealPlanDetails: (json['mealPlanDetails'] as List<dynamic>?)
          ?.map((e) => MealPlanDetail.fromJson(e, mealPlanId)) // Truyền mealPlanId vào
          .toList() ??
          [],
    );
  }
}