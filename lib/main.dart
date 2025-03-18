// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:diet_plan_app/components/mealLog_component_model.dart';
import 'package:diet_plan_app/services/models/health_profile_provider.dart';
import 'package:diet_plan_app/services/models/personal_goal_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_model.dart';
import 'firebase_options.dart';

void main() async {
  // Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFCM();
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
        ChangeNotifierProvider(create: (context) => MealLogComponentModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true, announcement: false);

  // Lấy và in ra FCM token
  // String? token = await messaging.getToken();
  // print("FCM Token: $token");

  // Lắng nghe sự kiện thay đổi token
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("FCM Token mới: $newToken");
  });

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("Người dùng từ chối nhận thông báo.");
    return;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
