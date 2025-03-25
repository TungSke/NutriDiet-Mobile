// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:diet_plan_app/services/models/health_profile_provider.dart';
import 'package:diet_plan_app/services/models/personal_goal_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  final appState = FFAppState();
  await appState.initializePersistedState();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFCM();
  // await _requestPermissions();
  await fetchStepsAndHealthData();

  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "523734217385588",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appState),
        ChangeNotifierProvider(create: (context) => PersonalGoalProvider()),
        ChangeNotifierProvider(create: (context) => HealthProfileProvider()),
        ChangeNotifierProvider(create: (context) => SampleMealPlanModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
  );
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("Người dùng từ chối nhận thông báo.");
  }
}

Future<void> _requestPermissions() async {
  // Kiểm tra nếu ứng dụng chạy trên Android hoặc iOS
  if (Platform.isAndroid || Platform.isIOS) {
    // Yêu cầu quyền nhận diện hoạt động
    PermissionStatus activityRecognitionStatus = await Permission.activityRecognition.request();
    if (!activityRecognitionStatus.isGranted) {
      print("Quyền Activity Recognition không được cấp.");
    }

    if (Platform.isAndroid || Platform.isIOS) {
    PermissionStatus locationStatus = await Permission.location.request();
    if (!locationStatus.isGranted) {
      print("Quyền vị trí không được cấp.");
    }
    }

    // Xử lý quyền Health Connect
    final health = Health();
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];
    bool? hasPermission = await health.hasPermissions(types, permissions: permissions);

    if (hasPermission == null || !hasPermission) {
      final authorized = await health.requestAuthorization(types, permissions: permissions);
      print("Quyền Health Connect được cấp: $authorized");
    }
  } else {
    print("Ứng dụng không chạy trên Android hoặc iOS. Bỏ qua xử lý quyền.");
  }
}

Future<void> fetchStepsAndHealthData() async {
  try {
    final health = Health();

    // Kiểm tra tính khả dụng của Health Connect
    if (!kIsWeb && Platform.isAndroid) {
      final status = await health.getHealthConnectSdkStatus();
      print("Trạng thái Health Connect: $status");

      if (status != HealthConnectSdkStatus.sdkAvailable) {
        print("Health Connect không khả dụng. Hướng dẫn cài đặt...");
        await health.installHealthConnect();
        return;
      }
    }

    // Cấu hình Health
    await health.configure();

    // Yêu cầu quyền truy cập dữ liệu Health Connect
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];
    bool? hasPermission = await health.hasPermissions(types, permissions: permissions);

    if (hasPermission == null || !hasPermission) {
      final authorized = await health.requestAuthorization(types, permissions: permissions);
      if (!authorized) {
        print("Không thể yêu cầu quyền Health Connect.");
        return;
      }
    }

    // Lấy số bước chân
    final now = DateTime.now();
    final midnightPreviousDay = DateTime(now.year, now.month, now.day - 1);
    final midnightNextDay = DateTime(now.year, now.month, now.day + 1);

    final steps = await health.getTotalStepsInInterval(midnightPreviousDay, midnightNextDay);
    if (steps != null) {
      print("Số bước chân: $steps");
    } else {
      print("Không thể lấy số bước chân. Kiểm tra dữ liệu Health Connect.");
    }
  } catch (e) {
    print("Đã xảy ra lỗi khi lấy dữ liệu từ Health Connect: $e");
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
    _themeMode = mode;
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NutriDiet',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}