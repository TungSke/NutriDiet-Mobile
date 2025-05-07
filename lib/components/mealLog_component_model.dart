import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/flutter_flow/flutter_flow_util.dart';
import '../services/firebase_service.dart';
import '../services/meallog_service.dart';
import '../services/models/meallog.dart';

class MealLogComponentModel extends FlutterFlowModel {
  DateTime selectedDate = DateTime.now();
  bool isPlanApplied = false;
  // Dữ liệu lấy từ API
  List<MealLog> mealLogs = [];
  List<MealLogDetail> mealLogAis = [];
  bool isLoading = true;
  int calorieGoal = 1500;
  int foodCalories = 0;

  // Các bữa
  final List<String> mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  VoidCallback? _updateCallback;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  // Tính Remaining (Goal - Food + Exercise)
  int get remainingCalories => calorieGoal - foodCalories;

  /// Gọi API để lấy meal log của ngày [selectedDate].
  Future<void> fetchMealLogs() async {
    try {
      isLoading = true;
      _updateCallback?.call();

      // 1. Gọi fetchMealLogs
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      final mealLogService = MeallogService();
      mealLogs = await mealLogService.getMealLogs(logDate: dateString);

      // Tính tổng calories của ngày
      int sumCalories = 0;
      for (final log in mealLogs) {
        sumCalories += log.totalCalories;
      }
      foodCalories = sumCalories;

      // 2. Gọi fetchPersonalGoal
      final userService = UserService();
      final http.Response response = await userService.getPersonalGoal();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> goalData = responseData['data'];

        // 3. Kiểm tra mealLogs.first.dailyCalories
        final double? logDailyCalories =
            mealLogs.isNotEmpty ? mealLogs.first.dailyCalories : null;
        if (logDailyCalories != null && logDailyCalories > 0) {
          calorieGoal = logDailyCalories.round();
        } else {
          calorieGoal = goalData['dailyCalories'] ?? calorieGoal;
        }

        debugPrint('Final calorieGoal: $calorieGoal');
      } else {
        debugPrint('Lỗi khi lấy personal goal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Lỗi khi fetchMealLogsAndGoal: $e');
      mealLogs = [];
      foodCalories = 0;
    } finally {
      isLoading = false;
      _updateCallback?.call();
    }
  }

  /// Tạo mới Meal Log (Create)
  Future<void> createMealLogEntry({
    required String mealType,
    required String servingSize,
    required int foodId,
    required int quantity,
  }) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      final service = MeallogService();

      final bool success = await service.createMealLog(
        logDate: dateString,
        mealType: mealType,
        servingSize: servingSize,
        foodId: foodId,
        quantity: quantity,
      );

      if (success) {
        debugPrint('Tạo Meal Log thành công');
        // Sau khi tạo thành công, fetch lại danh sách
        await fetchMealLogs();
      } else {
        debugPrint('Tạo Meal Log thất bại');
      }
    } catch (e) {
      debugPrint('Lỗi khi tạo Meal Log: $e');
    }
  }

  Future<void> transferMealLogDetailEntry({
    required int detailId,
    required String targetMealType,
  }) async {
    try {
      final service = MeallogService();
      final bool success = await service.transferMealLogDetail(
        detailId: detailId,
        targetMealType: targetMealType,
      );

      if (success) {
        debugPrint('Chuyển bữa thành công');
        await fetchMealLogs();
      } else {
        debugPrint('Chuyển bữa thất bại');
      }
    } catch (e) {
      debugPrint('Lỗi khi chuyển bữa: $e');
    }
  }

  /// Xóa chi tiết Meal Log (Delete)
  Future<void> deleteMealLogDetailEntry({
    required int mealLogId,
    required int detailId,
  }) async {
    try {
      final service = MeallogService();
      final bool success = await service.deleteMealLogDetail(
        mealLogId: mealLogId,
        detailId: detailId,
      );

      if (success) {
        debugPrint('Xóa Meal Log Detail thành công');
        await fetchMealLogs();
      } else {
        debugPrint('Xóa Meal Log Detail thất bại');
      }
    } catch (e) {
      debugPrint('Lỗi khi xóa Meal Log Detail: $e');
    }
  }

  // check premium
  Future<bool> checkPremiumStatus() async {
    final userService = UserService();
    return await userService.isPremium();
  }

  /// Gọi API để lấy Meal Log gợi ý từ AI
  Future<void> fetchMealLogsAI() async {
    try {
      isLoading = true;
      _updateCallback?.call();

      final service = MeallogService();
      mealLogAis = await service.getMealLogAI();
      debugPrint('Fetched AI Meal Logs: ${mealLogs.length} logs');
    } catch (e) {
      debugPrint('Lỗi khi fetch Meal Logs AI: $e');
    } finally {
      isLoading = false;
      _updateCallback?.call();
    }
  }

  Future<void> sendAIChosenMealFeedback(String feedback) async {
    try {
      final service = MeallogService();
      final success = await service.saveMealLogAI(feedback: feedback);
      if (success) {
        debugPrint('Gửi feedback MealLogAI thành công');
      } else {
        debugPrint('Gửi feedback MealLogAI thất bại');
      }
    } catch (e) {
      debugPrint('Lỗi khi gửi feedback MealLogAI: $e');
    }
  }

  Future<void> deleteMealLogEntry({
    required int mealLogId,
  }) async {
    try {
      final service = MeallogService();
      final bool success = await service.deleteMealLog(mealLogId: mealLogId);
      if (success) {
        debugPrint('Xóa Meal Log thành công');
        await fetchMealLogs();
      } else {
        debugPrint('Xóa Meal Log thất bại');
      }
    } catch (e) {
      debugPrint('Lỗi khi xóa Meal Log: $e');
    }
  }

  Future<void> toggleReminder(BuildContext context) async {
    try {
      final firebaseService = FirebaseService();
      final message = await firebaseService.enableReminder(context);
      if (message != null) {
        String dialogMessage;
        if (message == "Reminder enabled") {
          dialogMessage = "Thông báo nhắc bữa ăn đã được bật";
        } else if (message == "Reminder disabled") {
          dialogMessage = "Thông báo nhắc bữa ăn đã được tắt";
        } else if (message == "FCM token is required") {
          _showPermissionRequiredDialog(context);
          return;
        } else {
          dialogMessage = "Có lỗi xảy ra khi thay đổi cài đặt nhắc nhở";
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Thông báo"),
            content: Text(dialogMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi bật/tắt nhắc nhở: $e');
    }
  }

  void _showPermissionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yêu cầu quyền thông báo"),
        content: const Text(
            "Bạn cần cho phép ứng dụng gửi thông báo để bật nhắc nhở."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
        ],
      ),
    );
  }

  Future<String?> fetchAnalyzeMealLog() async {
    try {
      // Định dạng ngày theo kiểu "yyyy-M-d" (ví dụ: "2025-4-4")
      final String formattedDate = DateFormat('yyyy-M-d').format(selectedDate);
      final service = MeallogService();

      // Gọi API phân tích Meal Log
      final String? result =
          await service.analyzeMealLog(logDate: formattedDate);

      if (result != null) {
        String processedResult = result.trim();

        return processedResult;
      }
      return null;
    } catch (e) {
      debugPrint('Error in fetchAnalyzeMealLog: $e');
      return null;
    }
  }

  Future<bool> checkPlanApplied() async {
    try {
      final service = MeallogService();
      final dateParam = DateFormat('yyyy-M-d').format(selectedDate);
      final applied = await service.isMealPlanApplied(date: dateParam);

      isPlanApplied = applied;
      debugPrint('Plan applied on $dateParam: $isPlanApplied');
      // Cập nhật UI nếu có callback
      _updateCallback?.call();
      return applied;
    } catch (e) {
      debugPrint('Error in checkPlanApplied: $e');
      isPlanApplied = false;
      _updateCallback?.call();
      return false;
    }
  }

  Future<void> cloneMealLogEntry({
    required DateTime sourceDate,
  }) async {
    try {
      final service = MeallogService();
      // Format the source date from the parameter.
      final String sourceDateString = DateFormat('yyyy-M-d').format(sourceDate);
      // Use the model's selectedDate as target date.
      final String targetDateString =
          DateFormat('yyyy-M-d').format(selectedDate);

      final bool success = await service.cloneMealLog(
        sourceDate: sourceDateString,
        targetDate: targetDateString,
      );

      if (success) {
        debugPrint('Clone Meal Log successful');
        // Optionally, refresh your meal logs to reflect the cloned data.
        await fetchMealLogs();
      } else {
        debugPrint('Clone Meal Log failed');
      }
    } catch (e) {
      debugPrint('Error in cloneMealLogEntry: $e');
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate = newDate;
    mealLogs = [];
    foodCalories = 0;
    fetchMealLogs();
  }

  void updateCalorieGoal(int newGoal) {
    calorieGoal = newGoal;
  }

  void updateFoodCalories(int newCalories) {
    foodCalories = newCalories;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
