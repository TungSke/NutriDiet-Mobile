import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/meallog_service.dart';
import '../services/models/meallog.dart';
import '../services/user_service.dart';
import 'home_componet_widget.dart' show HomeComponetWidget;

class HomeComponetModel extends FlutterFlowModel<HomeComponetWidget> {
  ///  State fields for stateful widgets in this component.
  DateTime selectedDate = DateTime.now();

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;

  // Dữ liệu lấy từ API
  List<MealLog> mealLogs = [];
  bool isLoading = true;
  int calorieGoal = 1300; // Giá trị mặc định, sẽ được cập nhật từ API
  int foodCalories = 0;
  int exerciseCalories = 0;
  final UserService _userService = UserService();

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

  String name = "Chưa đăng nhập"; // Giá trị mặc định
  String email = "@gmail.com"; // Giá trị mặc định
  // Trạng thái loading
  String avatar = "";
  // Các bữa

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = data["name"] ?? "Unknown User";
        email = data["email"] ?? "No Email";
        avatar = data["avatar"] ?? "";
      } else {
        debugPrint("Lỗi khi gọi API: ${response.body}");
      }
    } catch (e) {
      debugPrint("Lỗi khi lấy thông tin người dùng: $e");
    }

    isLoading = false;
  }

  Future<void> fetchMealLogs() async {
    try {
      isLoading = true;
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);

      final service = MeallogService();
      _updateCallback?.call();
      mealLogs = await service.getMealLogs(logDate: dateString);

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

  void changeDate(DateTime newDate) {
    selectedDate = newDate;
    calendarSelectedDay = DateTimeRange(
      start: newDate.startOfDay,
      end: newDate.endOfDay,
    );
    mealLogs = [];
    foodCalories = 0;
    fetchMealLogs();
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

  void updateCalorieGoal(int newGoal) {
    calorieGoal = newGoal;
  }

  void updateFoodCalories(int newCalories) {
    foodCalories = newCalories;
  }

  void updateExerciseCalories(int newCalories) {
    exerciseCalories = newCalories;
  }

  // @override
  // void initState(BuildContext context) {
  //   calendarSelectedDay = DateTimeRange(
  //     start: DateTime.now().startOfDay,
  //     end: DateTime.now().endOfDay,
  //   );
  //   fetchUserProfile();
  //   fetchMealLogs();
  // }
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
