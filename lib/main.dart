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
import 'package:showcaseview/showcaseview.dart';

import 'firebase_options.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  final appState = FFAppState();
  await appState.initializePersistedState();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupPermissions();

  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "523734217385588",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(ShowCaseWidget(
    builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appState),
        ChangeNotifierProvider(create: (context) => PersonalGoalProvider()),
        ChangeNotifierProvider(create: (context) => HealthProfileProvider()),
        ChangeNotifierProvider(create: (context) => SampleMealPlanModel()),
      ],
      child: const MyApp(),
    ),
  ));
}

Future<void> setupPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final Health health = Health();

  // Notification permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true, badge: true, sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground notification: ${message.notification?.title}");
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("User denied notification permission.");
  } else {
    print("Notification permission granted: ${settings.authorizationStatus}");
  }

  // Activity Recognition permission
  if (defaultTargetPlatform == TargetPlatform.android) {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      print("Activity Recognition permission not granted.");
    }
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      print("Location permission not granted.");
    } else {
      print("Location permission granted.");
    }
  }

  // Health Connect permissions
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      final sdkStatus = await health.getHealthConnectSdkStatus();
      if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
        print("Health Connect not available. Attempting install...");
        await health.installHealthConnect();
        if (await health.getHealthConnectSdkStatus() != HealthConnectSdkStatus.sdkAvailable) {
          print("Failed to install Health Connect.");
          return;
        }
      }

      await health.configure();

      final types = [
        HealthDataType.STEPS,
        HealthDataType.TOTAL_CALORIES_BURNED,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];
      final permissions = List.filled(types.length, HealthDataAccess.READ_WRITE);

      bool? hasPermission = await health.hasPermissions(types, permissions: permissions);
      if (hasPermission != true) {
        final authorized = await health.requestAuthorization(types, permissions: permissions);
        if (authorized) {
          print("Health Connect permissions granted.");
        } else {
          print("Health Connect permission denied.");
        }
      } else {
        print("Health Connect permissions already granted.");
      }
    } catch (e) {
      print("Error checking Health Connect permission: $e");
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background notification: ${message.notification?.title}");
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

  void setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

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
      theme: ThemeData(brightness: Brightness.light),
      themeMode: _themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}