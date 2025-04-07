import 'package:diet_plan_app/services/gg_fit_service.dart';
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
  int steps = 0; // Số bước chân
  int caloriesBurned = 0; // Calories đốt cháy
  String? activityError; // Lưu thông báo lỗi từ GGFitService
  final UserService _userService = UserService();
  final GGFitService _ggFitService = GGFitService();

  double stepProgress = 50;
  double caloriesBurnedProgress = 10;

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

  int get remainingCalories => calorieGoal - foodCalories;

  String name = "Chưa đăng nhập"; // Giá trị mặc định
  String email = "@gmail.com"; // Giá trị mặc định
  String avatar = "";

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

  // Sửa phương thức để lấy dữ liệu từ GGFitService
  Future<void> fetchActivityData() async {
    try {
      // Xác định khoảng thời gian cho ngày được chọn
      final startDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

      // Gọi GGFitService để lấy dữ liệu
      final result =
          await _ggFitService.fetchStepsAndHealthData(startDate, endDate);
      print(result);
      steps = (result['steps'] is int)
          ? result['steps'] as int
          : (result['steps'] as double).toInt();

      caloriesBurned = (result['caloriesBurned'] is double)
          ? (result['caloriesBurned'] as double).toInt()
          : result['caloriesBurned'] as int;
      activityError = result['error'] as String?;
    } catch (e) {
      debugPrint('Lỗi khi fetch Activity Data: $e');
      steps = 0;
      caloriesBurned = 0;
      activityError = "Đã xảy ra lỗi khi lấy dữ liệu hoạt động: $e";
    } finally {
      _updateCallback?.call();
    }
  }

  void changeDate(DateTime newDate) async {
    selectedDate = newDate;
    calendarSelectedDay = DateTimeRange(
      start: newDate.startOfDay,
      end: newDate.endOfDay,
    );

    // Reset dữ liệu trước khi fetch
    mealLogs = [];
    foodCalories = 0;
    steps = 0;
    caloriesBurned = 0;
    activityError = null;

    isLoading = true;
    _updateCallback?.call();

    // Fetch dữ liệu đồng bộ
    await Future.wait([
      fetchMealLogs(),
      fetchActivityData(),
    ]);

    isLoading = false;
    _updateCallback?.call(); // Cập nhật giao diện sau khi fetch xong
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

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    fetchUserProfile();
    fetchMealLogs();
    fetchActivityData();
  }

  @override
  void dispose() {}
}
