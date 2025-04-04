import 'dart:convert';
import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/models/meallog.dart';
import '../services/meallog_service.dart';
import 'package:http/http.dart' as http;

class MealLogComponentModel extends FlutterFlowModel {
  DateTime selectedDate = DateTime.now();

  // Dữ liệu lấy từ API
  List<MealLog> mealLogs = [];
  List<MealLogDetail> mealLogAis = [];
  bool isLoading = true;
  int calorieGoal = 1300; // Giá trị mặc định, sẽ được cập nhật từ API
  int foodCalories = 0;
  int exerciseCalories = 0;

  // Các bữa
  final List<String> mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Exercise'
  ];

  VoidCallback? _updateCallback;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  // Tính Remaining (Goal - Food + Exercise)
  int get remainingCalories => calorieGoal - foodCalories + exerciseCalories;

  /// Gọi API lấy personal goal và cập nhật calorieGoal
  Future<void> fetchPersonalGoal() async {
    try {
      isLoading = true;
      final service = UserService();
      // Gọi hàm getPersonalGoal đã được định nghĩa ở MeallogService
      final http.Response response = await service.getPersonalGoal();
      if (response.statusCode == 200) {
        // Giả sử API trả về JSON với cấu trúc { "calorieGoal": number }
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> goalData = responseData['data'];
        calorieGoal = goalData['dailyCalories'] ?? calorieGoal;
        debugPrint('Fetched personal goal: $calorieGoal');
      } else {
        debugPrint('Lỗi khi lấy personal goal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in fetchPersonalGoal: $e');
    } finally {
      isLoading = false;
      _updateCallback?.call();
    }
  }

  /// Gọi API để lấy meal log của ngày [selectedDate].
  Future<void> fetchMealLogs() async {
    try {
      isLoading = true;
      // Định dạng ngày thành yyyy-MM-dd
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Gọi service để fetch Meal Logs
      final service = MeallogService();
      _updateCallback?.call();
      mealLogs = await service.getMealLogs(logDate: dateString);

      // Tính tổng calories từ các MealLog
      int sumCalories = 0;
      for (final log in mealLogs) {
        sumCalories += log.totalCalories;
      }
      foodCalories = sumCalories;
    } catch (e) {
      debugPrint('Lỗi khi fetch Meal Logs: $e');
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
      final message = await firebaseService.EnableReminder(context);
      if (message != null) {
        String dialogMessage;
        if (message == "Reminder enabled") {
          dialogMessage = "Thông báo nhắc bữa ăn đã được bật";
        } else if (message == "Reminder disabled") {
          dialogMessage = "Thông báo nhắc bữa ăn đã được tắt";
        } else {
          dialogMessage = "Có lỗi xảy ra khi thay đổi cài đặt nhắc nhở";
        }

        // Hiển thị dialog
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

  void updateExerciseCalories(int newCalories) {
    exerciseCalories = newCalories;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
