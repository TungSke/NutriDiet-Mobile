import 'mealplandetail.dart';

class MealPlan {
  final int? mealPlanId;
  final String planName;
  final String? healthGoal;
  final int? duration;
  final String? status;
  final String? aiWarning;
  final String? startAt;
  final String? createdBy;
  final DateTime? createdAt;
  final List<MealPlanDetail> mealPlanDetails;

  MealPlan({
    this.mealPlanId, // Không còn required
    required this.planName,
    this.healthGoal,
    this.duration,
    this.status,
    this.aiWarning,
    this.startAt,
    this.createdBy,
    this.createdAt,
    required this.mealPlanDetails,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    final mealPlanId = json['mealPlanId'] as int?; // Cho phép null
    return MealPlan(
      mealPlanId: mealPlanId,
      planName: json['planName'] as String,
      healthGoal: json['healthGoal'] as String?,
      duration: json['duration'] as int?,
      status: json['status'] as String?,
      aiWarning: json['aiwarning'] as String?,
      startAt: json['startAt'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      mealPlanDetails: (json['mealPlanDetails'] as List<dynamic>?)
          ?.map((e) => MealPlanDetail.fromJson(e, mealPlanId ?? 0)) // Dùng 0 nếu null
          .toList() ??
          [],
    );
  }
}