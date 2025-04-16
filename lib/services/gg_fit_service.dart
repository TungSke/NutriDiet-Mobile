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
  GGFitService._internal() {
    print("GGFitService instance created");
  }

  final Health _health = Health();
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  int _realTimeSteps = 0;
  int _lastReportedSteps = 0;
  int? _initialPedometerSteps;
  StreamController<int>? _stepsController;
  StreamController<bool>? _runningController;
  DateTime? _lastStepTime;
  DateTime? _lastProcessedDate;
  bool _isInitialized = false;
  bool _isDisposed = false;
  bool _isRunning = false;

  Future<bool> _checkActivityRecognitionPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    bool granted = await Permission.activityRecognition.isGranted;
    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }
    return granted;
  }

  Future<int> _fetchStepsFromHealthConnect(DateTime startDate, DateTime endDate) async {
    try {
      bool useHealthConnect = true;
      if (!kIsWeb && Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          useHealthConnect = false;
        }
      }

      if (useHealthConnect) {
        await _health.configure();

        final types = [HealthDataType.STEPS];
        final permissions = [HealthDataAccess.READ_WRITE];
        bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

        if (hasPermission == null || !hasPermission) {
          final authorized = await _health.requestAuthorization(types, permissions: permissions);
          if (!authorized) {
            print("Không có quyền đọc từ Health Connect, trả về 0 bước.");
            return 0;
          }
        }

        int steps = await _health.getTotalStepsInInterval(startDate, endDate) ?? 0;
        print("Fetched steps from Health Connect for $startDate to $endDate: $steps");
        return steps;
      } else {
        print("Health Connect không khả dụng, trả về 0 bước.");
        return 0;
      }
    } catch (e) {
      print("Lỗi khi đọc bước chân từ Health Connect: $e");
      return 0;
    }
  }

  void _initPedometer() async {
    if (_isInitialized || _isDisposed) {
      print("Pedometer đã được khởi tạo hoặc đã dispose, bỏ qua.");
      return;
    }

    try {
      bool granted = await _checkActivityRecognitionPermission();
      if (!granted) {
        print("Quyền Activity Recognition không được cấp.");
        _stepsController ??= StreamController<int>.broadcast();
        _runningController ??= StreamController<bool>.broadcast();
        if (!_stepsController!.isClosed) _stepsController?.add(0);
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      _stepsController ??= StreamController<int>.broadcast();
      _runningController ??= StreamController<bool>.broadcast();

      // Đọc bước chân từ Health Connect cho ngày hiện tại
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final stepsFromHealth = await _fetchStepsFromHealthConnect(startOfDay, now);

      _realTimeSteps = stepsFromHealth;
      _lastProcessedDate = now;

      if (!_stepsController!.isClosed) {
        _stepsController?.add(_realTimeSteps);
        print("Initialized _realTimeSteps from Health Connect: $_realTimeSteps");
      }
      if (!_runningController!.isClosed) {
        _runningController?.add(false);
        print("Running status initialized");
      }

      _isInitialized = true;

      _stepCountStream = Pedometer.stepCountStream;
      if (_stepCountStream == null) {
        print("Pedometer.stepCountStream không khả dụng trên thiết bị này.");
        if (!_stepsController!.isClosed) _stepsController?.add(0);
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      _stepCountStream!.listen(
            (StepCount event) async {
          if (_isDisposed) return;
          int currentSteps = event.steps;
          DateTime currentTime = event.timeStamp;
          print("Pedometer step event: steps=$currentSteps, time=$currentTime");

          // Kiểm tra ngày thay đổi
          final startOfCurrentDay = DateTime(currentTime.year, currentTime.month, currentTime.day);
          if (_lastProcessedDate == null ||
              _lastProcessedDate!.year != currentTime.year ||
              _lastProcessedDate!.month != currentTime.month ||
              _lastProcessedDate!.day != currentTime.day) {
            final newStepsFromHealth = await _fetchStepsFromHealthConnect(startOfCurrentDay, currentTime);
            _realTimeSteps = newStepsFromHealth;
            _initialPedometerSteps = currentSteps;
            _lastReportedSteps = currentSteps;
            _lastProcessedDate = currentTime;
            if (!_stepsController!.isClosed) {
              _stepsController?.add(_realTimeSteps);
              print("Day changed, reset _realTimeSteps to Health Connect data: $_realTimeSteps");
            }
            return;
          }
          _lastProcessedDate = currentTime;

          if (_initialPedometerSteps == null) {
            _initialPedometerSteps = currentSteps;
            _lastReportedSteps = currentSteps;
            print("Initial pedometer steps set: $_initialPedometerSteps");
          }

          int stepsDelta = currentSteps - _initialPedometerSteps!;
          if (_isRunning) {
            _realTimeSteps = stepsFromHealth + stepsDelta;
            _lastReportedSteps = currentSteps;
            _lastStepTime = currentTime;
            if (!_stepsController!.isClosed) {
              _stepsController?.add(_realTimeSteps);
              print("Steps updated (isRunning=true): delta=$stepsDelta, total=$_realTimeSteps");
            }
            // Ghi bước chân mới vào Health Connect
            await writeHealthData(
              HealthDataType.STEPS,
              _realTimeSteps.toDouble(),
              startOfCurrentDay,
              currentTime,
            );
          } else {
            _lastReportedSteps = currentSteps;
            print("Steps not updated (isRunning=false): lastReportedSteps=$_lastReportedSteps, total=$_realTimeSteps");
          }
        },
        onError: (error) {
          if (_isDisposed) return;
          print("Pedometer Step Stream Error: $error");
          if (!_stepsController!.isClosed) _stepsController?.add(0);
        },
      );

      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      if (_pedestrianStatusStream == null) {
        print("Pedometer.pedestrianStatusStream không khả dụng trên thiết bị này.");
        if (!_runningController!.isClosed) _runningController?.add(false);
        return;
      }

      _pedestrianStatusStream!.listen(
            (PedestrianStatus event) {
          if (_isDisposed) return;
          _isRunning = event.status == 'walking';
          print("Pedestrian status: ${event.status}, isRunning=$_isRunning");
          if (!_runningController!.isClosed) {
            _runningController?.add(_isRunning);
          }
        },
        onError: (error) {
          if (_isDisposed) return;
          print("Pedometer Status Stream Error: $error");
          if (!_runningController!.isClosed) _runningController?.add(false);
          _isRunning = false;
        },
      );
    } catch (e) {
      print("Failed to initialize pedometer: $e");
      _stepsController ??= StreamController<int>.broadcast();
      _runningController ??= StreamController<bool>.broadcast();
      if (!_stepsController!.isClosed) _stepsController?.add(0);
      if (!_runningController!.isClosed) _runningController?.add(false);
      _isRunning = false;
    }
  }

  Stream<int> get stepsStream {
    if (_stepsController == null || _stepsController!.isClosed) {
      _stepsController = StreamController<int>.broadcast();
      if (!_isInitialized && !_isDisposed) _initPedometer();
      if (!_stepsController!.isClosed) _stepsController!.add(_realTimeSteps);
    }
    return _stepsController!.stream;
  }

  Stream<bool> get runningStream {
    if (_runningController == null || _runningController!.isClosed) {
      _runningController = StreamController<bool>.broadcast();
      if (!_isInitialized && !_isDisposed) _initPedometer();
      if (!_runningController!.isClosed) _runningController!.add(false);
    }
    return _runningController!.stream;
  }

  Future<bool> writeHealthData(
      HealthDataType type,
      double value,
      DateTime startTime,
      DateTime endTime,
      ) async {
    if (_isDisposed) return false;
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startDay = DateTime(startTime.year, startTime.month, startTime.day);
      final endDay = DateTime(endTime.year, endTime.month, endTime.day);

      if (startDay != today || endDay != today) {
        print("Dữ liệu không thuộc ngày hôm nay, không ghi vào Health Connect.");
        return false;
      }

      if (!kIsWeb && Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          await _health.installHealthConnect();
          return false;
        }
      }

      await _health.configure();

      final types = [type];
      final permissions = [HealthDataAccess.READ_WRITE];
      bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

      if (hasPermission == null || !hasPermission) {
        final authorized = await _health.requestAuthorization(types, permissions: permissions);
        if (!authorized) {
          print("Không có quyền ghi vào Health Connect cho $type.");
          return false;
        }
      }

      final success = await _health.writeHealthData(
        value: value,
        type: type,
        startTime: startTime,
        endTime: endTime,
      );

      print("Wrote $value $type to Health Connect from $startTime to $endTime: $success");
      return success ?? false;
    } catch (e) {
      print("Lỗi khi ghi dữ liệu $type vào Health Connect: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchStepsAndHealthData(DateTime startDate, DateTime endDate) async {
    if (_isDisposed) {
      return {
        "steps": 0,
        "caloriesBurned": 0,
        "distance": 0,
        "activeEnergyBurned": 0,
        "error": "Dịch vụ đã bị dispose",
      };
    }
    try {
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
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ];
        final permissions = List.filled(types.length, HealthDataAccess.READ_WRITE);
        bool? hasPermission = await _health.hasPermissions(types, permissions: permissions);

        if (hasPermission == null || !hasPermission) {
          final authorized = await _health.requestAuthorization(types, permissions: permissions);
          if (!authorized) {
            return {
              "steps": _realTimeSteps,
              "caloriesBurned": 0,
              "distance": 0,
              "activeEnergyBurned": 0,
              "error": "Người dùng từ chối cấp quyền Health Connect. Dữ liệu từ cảm biến sẽ được sử dụng.",
            };
          }
        }

        // Đọc bước chân
        int steps = await _health.getTotalStepsInInterval(startDate, endDate) ?? 0;
        print("Steps from Health Connect for $startDate to $endDate: $steps");

        final now = DateTime.now();
        final isToday = startDate.year == now.year &&
            startDate.month == now.month &&
            startDate.day == now.day;

        if (isToday) {
          _realTimeSteps = steps;
          if (!_stepsController!.isClosed) {
            _stepsController?.add(_realTimeSteps);
            print("Synced _realTimeSteps with Health Connect for today: $_realTimeSteps");
          }
        } else {
          _realTimeSteps = steps;
          _initialPedometerSteps = null;
          if (!_stepsController!.isClosed) {
            _stepsController?.add(_realTimeSteps);
            print("Reset pedometer steps to Health Connect data: $_realTimeSteps");
          }
        }

        // Đọc dữ liệu khác
        final healthData = await _health.getHealthDataFromTypes(
          types: [
            HealthDataType.TOTAL_CALORIES_BURNED,
            HealthDataType.ACTIVE_ENERGY_BURNED,
          ],
          startTime: startDate,
          endTime: endDate,
        );

        double caloriesBurned = 0;
        double distance = 0;
        double activeEnergyBurned = 0;

        for (var data in healthData) {
          final value = (data.value as NumericHealthValue).numericValue.toDouble();
          switch (data.type) {
            case HealthDataType.TOTAL_CALORIES_BURNED:
              caloriesBurned += value;
              break;
            case HealthDataType.ACTIVE_ENERGY_BURNED:
              activeEnergyBurned += value;
              break;
            default:
              break;
          }
        }

        return {
          "steps": steps,
          "caloriesBurned": caloriesBurned,
          "distance": distance,
          "activeEnergyBurned": activeEnergyBurned,
          "error": null,
        };
      } else {
        return {
          "steps": _realTimeSteps,
          "caloriesBurned": 0,
          "distance": 0,
          "activeEnergyBurned": 0,
          "error": "Health Connect không khả dụng, sử dụng dữ liệu từ cảm biến.",
        };
      }
    } catch (e) {
      print("Error fetching health data: $e");
      return {
        "steps": _realTimeSteps,
        "caloriesBurned": 0,
        "distance": 0,
        "activeEnergyBurned": 0,
        "error": "Đã xảy ra lỗi khi lấy dữ liệu: $e",
      };
    }
  }

  int getRealTimeSteps() => _realTimeSteps;

  void resetSteps() {
    if (_isDisposed) return;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    _fetchStepsFromHealthConnect(startOfDay, now).then((stepsFromHealth) {
      _realTimeSteps = stepsFromHealth;
      _initialPedometerSteps = null;
      _lastReportedSteps = 0;
      _lastStepTime = null;
      _lastProcessedDate = now;
      _isRunning = false;
      if (!_stepsController!.isClosed) {
        _stepsController?.add(_realTimeSteps);
        print("Steps reset to Health Connect value: $_realTimeSteps");
      }
      if (!_runningController!.isClosed) {
        _runningController?.add(false);
        print("Running status reset");
      }
    }).catchError((e) {
      print("Error resetting steps from Health Connect: $e");
      _realTimeSteps = 0;
      _initialPedometerSteps = null;
      _lastReportedSteps = 0;
      _lastStepTime = null;
      _lastProcessedDate = null;
      _isRunning = false;
      if (!_stepsController!.isClosed) {
        _stepsController?.add(_realTimeSteps);
        print("Steps reset to 0 due to error: $_realTimeSteps");
      }
      if (!_runningController!.isClosed) {
        _runningController?.add(false);
        print("Running status reset");
      }
    });
  }

  void dispose() {
    if (_isDisposed) return;
    _stepsController?.close();
    _runningController?.close();
    resetSteps();
    _isInitialized = false;
    _isDisposed = true;
    print("GGFitService disposed, steps reset to Health Connect value");
  }
}