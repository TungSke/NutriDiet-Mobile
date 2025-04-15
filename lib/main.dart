// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:diet_plan_app/services/models/health_profile_provider.dart';
import 'package:diet_plan_app/services/models/personal_goal_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_model.dart';
import 'firebase_options.dart'; // Tùy chọn Firebase (tự động tạo khi cấu hình Firebase)


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  final appState = FFAppState();
  await appState.initializePersistedState();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupPermissions();

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


Future<void> setupPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Yêu cầu quyền thông báo
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
  );

  // Lắng nghe thông báo khi ứng dụng đang hoạt động
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Nhận thông báo khi đang hoạt động: ${message.notification?.title}");
  });

  // Đăng ký hàm xử lý khi ứng dụng nhận thông báo ở chế độ nền
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Kiểm tra trạng thái quyền thông báo
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("Người dùng từ chối nhận thông báo.");
  } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Quyền thông báo được cấp.");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("Quyền thông báo được cấp tạm thời.");
  }

  // Yêu cầu quyền Activity Recognition
  if (defaultTargetPlatform == TargetPlatform.android) {
    PermissionStatus activityRecognitionStatus =
    await Permission.activityRecognition.request();
    if (!activityRecognitionStatus.isGranted) {
      print("Quyền Activity Recognition không được cấp.");
    }
  }
}

// Hàm xử lý thông báo ở chế độ nền
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Nhận thông báo khi ở chế độ nền: ${message.notification?.title}");
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
      debugShowCheckedModeBanner: false,
    );
  }
}