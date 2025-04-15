import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

// Singleton pattern cho GGFitService
class GGFitService {
  static final GGFitService _instance = GGFitService._internal();
  factory GGFitService() => _instance;
  GGFitService._internal();

  final Health _health = Health();
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  int _realTimeSteps = 0;
  int _lastReportedSteps = 0;
  StreamController<int>? _stepsController;
  StreamController<bool>? _runningController;
  DateTime? _lastStepTime;
  bool _isInitialized = false;
  bool _isDisposed = false;

  Future<bool> _checkActivityRecognitionPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    bool granted = await Permission.activityRecognition.isGranted;
    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }
    return granted;
  }

  void _initPedometer() async {
    if (_isInitialized || _isDisposed) {
      print("Pedometer đã được khởi tạo hoặc đã dispose, bỏ qua.");
      return;
    }

    try {
      // Kiểm tra quyền Activity Recognition
      bool granted = await _checkActivityRecognitionPermission();
      if (!granted) {
        print("Quyền Activity Recognition không được cấp.");
        if (!_stepsController!.isClosed) _stepsController?.add(0);
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      // Khởi tạo StreamController
      _stepsController ??= StreamController<int>.broadcast();
      _runningController ??= StreamController<bool>.broadcast();
      resetSteps();
      _isInitialized = true;

      // Khởi tạo stream bước chân
      _stepCountStream = Pedometer.stepCountStream;
      if (_stepCountStream == null) {
        print("Pedometer.stepCountStream không khả dụng trên thiết bị này.");
        if (!_stepsController!.isClosed) _stepsController?.add(0);
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      // Lắng nghe bước chân
      _stepCountStream!.listen(
            (StepCount event) {
          if (_isDisposed) return;
          int currentSteps = event.steps;
          DateTime currentTime = event.timeStamp;
          print("Pedometer step event: steps=$currentSteps, time=$currentTime");

          // Cập nhật bước chân nếu có thay đổi đáng kể
          if (currentSteps >= _lastReportedSteps + 1 || _lastReportedSteps == 0) {
            _realTimeSteps = currentSteps;
            _lastReportedSteps = currentSteps;
            _lastStepTime = currentTime;
            if (!_stepsController!.isClosed) {
              _stepsController?.add(_realTimeSteps);
              print("Steps emitted: $_realTimeSteps");
            }
          }
        },
        onError: (error) {
          if (_isDisposed) return;
          print("Pedometer Step Stream Error: $error");
          if (!_stepsController!.isClosed) _stepsController?.add(0);
        },
      );

      // Khởi tạo stream trạng thái di chuyển
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      if (_pedestrianStatusStream == null) {
        print("Pedometer.pedestrianStatusStream không khả dụng trên thiết bị này.");
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      // Lắng nghe trạng thái di chuyển
      _pedestrianStatusStream!.listen(
            (PedestrianStatus event) {
          if (_isDisposed) return;
          bool isRunning = event.status == 'walking';
          print("Pedestrian status: ${event.status}, isRunning=$isRunning");
          if (!_runningController!.isClosed) {
            _runningController?.add(isRunning);
          }
        },
        onError: (error) {
          if (_isDisposed) return;
          print("Pedometer Status Stream Error: $error");
          if (!_runningController!.isClosed) _runningController?.add(false);
        },
      );
    } catch (e) {
      print("Failed to initialize pedometer: $e");
      _stepsController ??= StreamController<int>.broadcast();
      _runningController ??= StreamController<bool>.broadcast();
      if (!_stepsController!.isClosed) _stepsController?.add(0);
      if (!_runningController!.isClosed) _runningController?.add(false);
    }
  }

  Stream<int> get stepsStream {
    if (_stepsController == null || _stepsController!.isClosed) {
      _stepsController = StreamController<int>.broadcast();
      if (!_isInitialized && !_isDisposed) _initPedometer();
      _stepsController!.add(0);
    }
    return _stepsController!.stream;
  }

  Stream<bool> get runningStream {
    if (_runningController == null || _runningController!.isClosed) {
      _runningController = StreamController<bool>.broadcast();
      if (!_isInitialized && !_isDisposed) _initPedometer();
      _runningController!.add(false);
    }
    return _runningController!.stream;
  }

  Future<bool> writeStepsToHealthConnect(int steps, DateTime startTime, DateTime endTime) async {
    if (_isDisposed) return false;
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          await _health.installHealthConnect();
          return false;
        }
      }

      await _health.configure();

      final types = [HealthDataType.STEPS];
      final permissions = [HealthDataAccess.READ_WRITE];
      bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

      if (hasPermission == null || !hasPermission) {
        final authorized = await _health.requestAuthorization(types, permissions: permissions);
        if (!authorized) {
          print("Không có quyền ghi vào Health Connect.");
          return false;
        }
      }

      final success = await _health.writeHealthData(
        value: steps.toDouble(),
        type: HealthDataType.STEPS,
        startTime: startTime,
        endTime: endTime,
      );

      return success ?? false;
    } catch (e) {
      print("Lỗi khi ghi dữ liệu vào Health Connect: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchStepsAndHealthData(DateTime startDate, DateTime endDate) async {
    if (_isDisposed) {
      return {
        "steps": 0,
        "caloriesBurned": 0,
        "error": "Dịch vụ đã bị dispose",
      };
    }
    try {
      if (_lastStepTime != null && _realTimeSteps > 0) {
        await writeStepsToHealthConnect(_realTimeSteps, startDate, endDate);
      }

      bool useHealthConnect = true;
      if (!kIsWeb && Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          useHealthConnect = false;
        }
      }

      if (useHealthConnect) {
        await _health.configure();

        final types = [
          HealthDataType.STEPS,
          HealthDataType.TOTAL_CALORIES_BURNED,
        ];
        final permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];
        bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

        if (hasPermission == null || !hasPermission) {
          final authorized = await _health.requestAuthorization(types, permissions: permissions);
          if (!authorized) {
            return {
              "steps": _realTimeSteps,
              "caloriesBurned": 0,
              "error": "Người dùng từ chối cấp quyền Health Connect. Dữ liệu từ cảm biến sẽ được sử dụng.",
            };
          }
        }

        final steps = await _health.getTotalStepsInInterval(startDate, endDate) ?? _realTimeSteps;

        if (steps > _realTimeSteps) {
          _realTimeSteps = steps;
          _lastReportedSteps = steps;
          if (!_stepsController!.isClosed) _stepsController?.add(_realTimeSteps);
        }

        final caloriesBurnedData = await _health.getHealthDataFromTypes(
          types: [HealthDataType.TOTAL_CALORIES_BURNED],
          startTime: startDate,
          endTime: endDate,
        );

        double caloriesBurned = 0;
        if (caloriesBurnedData.isNotEmpty) {
          caloriesBurned = caloriesBurnedData
              .map((data) => (data.value as NumericHealthValue).numericValue)
              .reduce((a, b) => a + b)
              .toDouble();
        }

        return {
          "steps": steps,
          "caloriesBurned": caloriesBurned,
          "error": null,
        };
      } else {
        return {
          "steps": _realTimeSteps,
          "caloriesBurned": 0,
          "error": "Health Connect không khả dụng, sử dụng dữ liệu từ cảm biến.",
        };
      }
    } catch (e) {
      return {
        "steps": _realTimeSteps,
        "caloriesBurned": 0,
        "error": "Đã xảy ra lỗi khi lấy dữ liệu: $e",
      };
    }
  }

  int getRealTimeSteps() => _realTimeSteps;

  void resetSteps() {
    if (_isDisposed) return;
    _realTimeSteps = 0;
    _lastReportedSteps = 0;
    _lastStepTime = null;
    if (!_stepsController!.isClosed) _stepsController?.add(_realTimeSteps);
    if (!_runningController!.isClosed) _runningController?.add(false);
    print("Steps and running status reset");
  }

  void dispose() {
    if (_isDisposed) return;
    _stepsController?.close();
    _runningController?.close();
    _isInitialized = false;
    _isDisposed = true;
    print("GGFitService disposed");
  }
}