import 'dart:async';
import 'package:diet_plan_app/services/gg_fit_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/meallog_service.dart';
import '../services/models/meallog.dart';
import '../services/user_service.dart';
import 'home_componet_widget.dart' show HomeComponetWidget;
import 'dart:convert';

class HomeComponetModel extends FlutterFlowModel<HomeComponetWidget> {
  DateTime selectedDate = DateTime.now();
  DateTimeRange? calendarSelectedDay;
  List<MealLog> mealLogs = [];
  bool isLoading = true;
  int calorieGoal = 1300;
  int foodCalories = 0;
  int steps = 0;
  int caloriesBurned = 0;
  String? activityError;
  bool isRunning = false;
  final UserService _userService = UserService();
  StreamSubscription<int>? _stepsSubscription;
  StreamSubscription<bool>? _runningSubscription;
  StreamSubscription<double>? _caloriesBurnedSubscription;

  double stepProgress = 0.0;
  double caloriesBurnedProgress = 0.0;

  final List<String> mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  VoidCallback? _updateCallback;
  bool _isMounted = true;

  void setUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
    print("Update callback set");
  }

  int get remainingCalories => calorieGoal - foodCalories;

  String name = "Chưa đăng nhập";
  String email = "@gmail.com";
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
    if (_isMounted) _updateCallback?.call();
  }

  Future<void> fetchMealLogs() async {
    try {
      isLoading = true;
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      final service = MeallogService();
      if (_isMounted) _updateCallback?.call();
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
      if (_isMounted) _updateCallback?.call();
    }
  }

  Future<void> fetchActivityData() async {
    if (!_isMounted) return;
    try {
      final startDate =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endDate =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

      final result = await GGFitService().fetchStepsAndHealthData(startDate, endDate);
      steps = (result['steps'] is int)
          ? result['steps'] as int
          : (result['steps'] as double).toInt();
      caloriesBurned = (result['caloriesBurned'] is double)
          ? (result['caloriesBurned'] as double).toInt()
          : result['caloriesBurned'] as int;
      activityError = result['error'] as String?;

      // Tính toán lại stepProgress và caloriesBurnedProgress
      stepProgress = (steps / 10000).clamp(0.0, 1.0);
      caloriesBurnedProgress = (caloriesBurned / 500).clamp(0.0, 1.0);
      print("Fetched activity data: steps=$steps, caloriesBurned=$caloriesBurned, stepProgress=$stepProgress");

      // Nếu là ngày hiện tại, đảm bảo đồng bộ với dữ liệu thời gian thực
      if (isSameDay(selectedDate, DateTime.now())) {
        steps = GGFitService().getRealTimeSteps();
        caloriesBurned = GGFitService().getCaloriesBurned().toInt();
        stepProgress = (steps / 10000).clamp(0.0, 1.0);
        caloriesBurnedProgress = (caloriesBurned / 500).clamp(0.0, 1.0);
        print("Synced with real-time data for today: steps=$steps, caloriesBurned=$caloriesBurned");
      }
    } catch (e) {
      debugPrint('Lỗi khi fetch Activity Data: $e');
      steps = GGFitService().getRealTimeSteps();
      caloriesBurned = GGFitService().getCaloriesBurned().toInt();
      activityError = "Đã xảy ra lỗi khi lấy dữ liệu hoạt động: $e";
      stepProgress = (steps / 10000).clamp(0.0, 1.0);
      caloriesBurnedProgress = (caloriesBurned / 500).clamp(0.0, 1.0);
    } finally {
      if (_isMounted) _updateCallback?.call();
    }
  }

  void startListeningToStepsAndCalories() {
    if (!_isMounted) return;
    _stepsSubscription?.cancel();
    _runningSubscription?.cancel();
    _caloriesBurnedSubscription?.cancel();
    print("Starting step, running, and calories burned subscriptions");
    try {
      _stepsSubscription = GGFitService().stepsStream.listen(
            (newSteps) {
          if (!_isMounted) return;
          steps = newSteps;
          stepProgress = (steps / 10000).clamp(0.0, 1.0);
          print("Steps updated from stream: $steps");
          if (_isMounted) {
            _updateCallback?.call();
          }
        },
        onError: (error) {
          if (!_isMounted) return;
          print("Steps Stream Error: $error");
          activityError = "Không thể lấy dữ liệu bước chân thời gian thực: $error";
          if (_isMounted) _updateCallback?.call();
        },
      );

      _runningSubscription = GGFitService().runningStream.listen(
            (isRunningNow) {
          if (!_isMounted) return;
          isRunning = isRunningNow;
          print("Running status updated: $isRunning");
          if (_isMounted) {
            _updateCallback?.call();
          }
        },
        onError: (error) {
          if (!_isMounted) return;
          print("Running Stream Error: $error");
          isRunning = false;
          activityError = "Không thể lấy dữ liệu trạng thái chạy: $error";
          if (_isMounted) _updateCallback?.call();
        },
      );

      _caloriesBurnedSubscription = GGFitService().caloriesBurnedStream.listen(
            (newCaloriesBurned) {
          if (!_isMounted) return;
          caloriesBurned = newCaloriesBurned.toInt();
          caloriesBurnedProgress = (caloriesBurned / 500).clamp(0.0, 1.0);
          print("Calories burned updated from stream: $caloriesBurned");
          if (_isMounted) {
            _updateCallback?.call();
          }
        },
        onError: (error) {
          if (!_isMounted) return;
          print("Calories Burned Stream Error: $error");
          activityError = "Không thể lấy dữ liệu calories burned thời gian thực: $error";
          if (_isMounted) _updateCallback?.call();
        },
      );
    } catch (e) {
      print("Error starting subscriptions: $e");
      activityError = "Không thể khởi tạo dữ liệu hoạt động: $e";
      isRunning = false;
      if (_isMounted) _updateCallback?.call();
    }
  }

  void changeDate(DateTime newDate) async {
    if (!_isMounted) return;
    selectedDate = newDate;
    calendarSelectedDay = DateTimeRange(
      start: newDate.startOfDay,
      end: newDate.endOfDay,
    );

    mealLogs = [];
    foodCalories = 0;
    steps = 0;
    caloriesBurned = 0;
    activityError = null;
    isRunning = false;

    // Hủy lắng nghe tất cả các stream trước khi lấy dữ liệu mới
    _stepsSubscription?.cancel();
    _runningSubscription?.cancel();
    _caloriesBurnedSubscription?.cancel();

    if (!isSameDay(newDate, DateTime.now())) {
      GGFitService().resetSteps();
      print("Steps and calories reset for new date: $newDate");
    } else {
      // Khi chuyển về ngày hiện tại, reset để đồng bộ với dữ liệu thời gian thực
      GGFitService().resetSteps();
      print("Steps and calories reset for current date to sync with real-time data");
    }

    isLoading = true;
    if (_isMounted) _updateCallback?.call();

    // Lấy dữ liệu mới
    await Future.wait([
      fetchMealLogs(),
      fetchActivityData(),
    ]);

    // Sau khi lấy dữ liệu, nếu là ngày hiện tại thì bắt đầu lắng nghe stream
    if (isSameDay(newDate, DateTime.now())) {
      startListeningToStepsAndCalories();
    }

    isLoading = false;
    if (_isMounted) _updateCallback?.call();
  }

  Future<void> transferMealLogDetailEntry({
    required int detailId,
    required String targetMealType,
  }) async {
    if (!_isMounted) return;
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
    if (!_isMounted) return;
    calorieGoal = newGoal;
    if (_isMounted) _updateCallback?.call();
  }

  void updateFoodCalories(int newCalories) {
    if (!_isMounted) return;
    foodCalories = newCalories;
    if (_isMounted) _updateCallback?.call();
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
    startListeningToStepsAndCalories();
  }

  @override
  void dispose() {
    _isMounted = false;
    _updateCallback = null;
    _stepsSubscription?.cancel();
    _runningSubscription?.cancel();
    _caloriesBurnedSubscription?.cancel();
    mealLogs = [];
    steps = 0;
    caloriesBurned = 0;
    foodCalories = 0;
    print("Model disposed");
  }
}