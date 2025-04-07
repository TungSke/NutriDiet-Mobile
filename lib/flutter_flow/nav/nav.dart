import 'dart:async';

import 'package:diet_plan_app/components/barcode_scanner_widget.dart';
import 'package:diet_plan_app/components/ingredient_component_widget.dart';
import 'package:diet_plan_app/components/quick_add_widget.dart';
import 'package:diet_plan_app/components/serch_data_widget.dart';
import 'package:diet_plan_app/log_in_flow/Ingredient_avoid_screen/ingredient_avoid_screen_widget.dart';
import 'package:diet_plan_app/log_in_flow/profile_enter_screen/profile_enter_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

export 'package:go_router/go_router.dart';

export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => const SplaceScrenWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const SplaceScrenWidget(),
        ),
        FFRoute(
          name: 'splace_scren',
          path: '/splaceScren',
          builder: (context, params) => const SplaceScrenWidget(),
        ),
        FFRoute(
          name: 'ingredient_avoid_screen',
          path: '/ingredientAvoidScreen',
          builder: (context, params) => const IngredientAvoidScreenWidget(),
        ),
        FFRoute(
          name: 'buy_premium_package',
          path: '/buyPremiumPackage',
          builder: (context, params) => const BuyPremiumPackageScreenWidget(),
        ),
        FFRoute(
          name: 'checkout_success_screen',
          path: '/checkoutSuccessScreen',
          builder: (context, params) => const CheckoutSuccessScreenWidget(),
        ),
        FFRoute(
          name: 'checkout_fail_screen',
          path: '/checkoutFailScreen',
          builder: (context, params) => const CheckoutFailScreenWidget(),
        ),
        FFRoute(
          name: 'onbodying_screen',
          path: '/onbodyingScreen',
          builder: (context, params) => const OnbodyingScreenWidget(),
        ),
        FFRoute(
          name: 'health_indicator_screen',
          path: '/healthIndicatorScreen',
          builder: (context, params) => const HealthIndicatorScreenWidget(),
        ),
        FFRoute(
          name: 'ai_suggestion_screen',
          path: '/aiSuggestionScreen',
          builder: (context, params) => const AiSuggestionScreenWidget(),
        ),
        FFRoute(
          name: 'diet_style_screen',
          path: '/dietStyleScreen',
          builder: (context, params) => const DietStyleScreenWidget(),
        ),
        FFRoute(
          name: 'login_screen',
          path: '/loginScreen',
          builder: (context, params) => const LoginScreenWidget(),
        ),
        FFRoute(
          name: 'login_intro_screen',
          path: '/loginIntroScreen',
          builder: (context, params) => const LoginIntroScreenWidget(),
        ),
        FFRoute(
          name: 'Sign_up_screen',
          path: '/signUpScreen',
          builder: (context, params) => const SignUpScreenWidget(),
        ),
        FFRoute(
          name: 'forget_screen',
          path: '/forgetScreen',
          builder: (context, params) => const ForgetScreenWidget(),
        ),
        FFRoute(
          name: 'verification_screen',
          path: '/verificationScreen',
          builder: (context, params) => const VerificationScreenWidget(),
        ),
        FFRoute(
          name: 'reset_password_screen',
          path: '/resetPasswordScreen',
          builder: (context, params) => const ResetPasswordScreenWidget(),
        ),
        FFRoute(
          name: 'Whats_your_goal',
          path: '/whatsYourGoal',
          builder: (context, params) => const WhatsYourGoalWidget(),
        ),
        FFRoute(
          name: 'Tell_us_about_yourself',
          path: '/tellUsAboutYourself',
          builder: (context, params) => const TellUsAboutYourselfWidget(),
        ),
        FFRoute(
          name: 'Which_diet_do_you_prefer',
          path: '/whichDietDoYouPrefer',
          builder: (context, params) => const WhichDietDoYouPreferWidget(),
        ),
        FFRoute(
          name: 'Which_cuisines_include_diet',
          path: '/whichCuisinesIncludeDiet',
          builder: (context, params) => const WhichCuisinesIncludeDietWidget(),
        ),
        FFRoute(
          name: 'Notification_screen',
          path: '/notificationScreen',
          builder: (context, params) => const NotificationScreenWidget(),
        ),
        FFRoute(
          name: 'breskfast_screen',
          path: '/breskfastScreen',
          builder: (context, params) => const BreskfastScreenWidget(),
        ),
        // FFRoute(
        //   name: 'brek_fast_iIngredients',
        //   path: '/brekFastIIngredients',
        //   builder: (context, params) => const BrekFastIIngredientsWidget(),
        // ),
        FFRoute(
          name: 'brek_fast_iIngredients',
          path: '/breakfast-ingredients/:foodId',
          builder: (context, params) {
            final foodId =
                params.getParam('foodId', ParamType.int) ?? 'unknown';
            return BrekFastIIngredientsWidget(foodId: foodId);
          },
        ),
        FFRoute(
          name: 'Search_result_screen',
          path: '/searchResultScreen',
          builder: (context, params) => const SearchResultScreenWidget(),
        ),
        FFRoute(
          name: 'my_profile',
          path: '/myProfile',
          builder: (context, params) => const MyProfileWidget(),
        ),
        FFRoute(
          name: 'edit_profile_screen',
          path: '/editProfileScreen',
          builder: (context, params) => const EditProfileScreenWidget(),
        ),
        FFRoute(
          name: 'target_weight_screen',
          path: '/targetWeightScreen',
          builder: (context, params) => const TargetWeightScreenWidget(),
        ),
        FFRoute(
          name: 'security_screen',
          path: '/securityScreen',
          builder: (context, params) => const SecurityScreenWidget(),
        ),
        FFRoute(
          name: 'change_password_screen',
          path: '/changePasswordScreen',
          builder: (context, params) => const ChangePasswordScreenWidget(),
        ),
        FFRoute(
          name: 'Setting_screen',
          path: '/settingScreen',
          builder: (context, params) => const SettingScreenWidget(),
        ),
        FFRoute(
          name: 'About_us_screen',
          path: '/aboutUsScreen',
          builder: (context, params) => const AboutUsScreenWidget(),
        ),
        FFRoute(
          name: 'help_screen',
          path: '/helpScreen',
          builder: (context, params) => const HelpScreenWidget(),
        ),
        FFRoute(
          name: 'serch_data_screen',
          path: '/serchdataScreen',
          builder: (context, params) => const SerchDataWidget(),
        ),
        FFRoute(
          name: 'feedback_screen',
          path: '/feedbackScreen',
          builder: (context, params) => const FeedbackScreenWidget(),
        ),
        FFRoute(
          name: 'privcy_policy_screen',
          path: '/privcyPolicyScreen',
          builder: (context, params) => const PrivcyPolicyScreenWidget(),
        ),
        FFRoute(
          name: 'bottom_navbar_screen',
          path: '/bottomNavbarScreen',
          builder: (context, params) => const BottomNavbarScreenWidget(),
        ),
        FFRoute(
          name: 'Select_date_of_birth',
          path: '/selectDateOfBirth',
          builder: (context, params) => const SelectDateOfBirthWidget(),
        ),
        FFRoute(
          name: 'ingredient_screen',
          path: '/ingredient_screen',
          builder: (context, params) => const IngredientListScreen(),
        ),
        FFRoute(
          name: 'Select_allergy_screen',
          path: '/selectAllergyScreen',
          builder: (context, params) => const SelectAllergyScreenWidget(),
        ),
        FFRoute(
          name: 'Select_disease_screen',
          path: '/selectDiseaseScreen',
          builder: (context, params) => const SelectDiseaseScreenWidget(),
        ),
        FFRoute(
          name: 'hight_Enter_screen',
          path: '/hightEnterScreen',
          builder: (context, params) => const HightEnterScreenWidget(),
        ),
        FFRoute(
          name: 'fav_screen',
          path: '/favScreen',
          builder: (context, params) => const FavScreenWidget(),
        ),
        FFRoute(
          name: 'frequency_exercise_screen',
          path: '/frequencyExerciseScreen',
          builder: (context, params) => const FrequencyExerciseScreenWidget(),
        ),
        FFRoute(
          name: 'increase_weight_goal_screen',
          path: '/increaseWeightGoalScreen',
          builder: (context, params) => const IncreaseWeightGoalScreenWidget(),
        ),
        FFRoute(
          name: 'decrease_weight_goal_screen',
          path: '/decreaseWeightGoalScreen',
          builder: (context, params) => const DecreaseWeightGoalScreenWidget(),
        ),
        FFRoute(
          name: 'decrease_weight_change_rate_screen',
          path: '/decreaseWeightChangeRateScreen',
          builder: (context, params) =>
              const DecreaseWeightChangeRateScreenWidget(),
        ),
        FFRoute(
          name: 'increase_weight_change_rate_screen',
          path: '/increaseWeightChangeRateScreen',
          builder: (context, params) =>
              const IncreaseWeightChangeRateScreenWidget(),
        ),
        FFRoute(
          name: 'weight_Enter_screen',
          path: '/weightEnterScreen',
          builder: (context, params) => const WeightEnterScreenWidget(),
        ),
        FFRoute(
          name: 'profile_enter_screen',
          path: '/profileEnterScreen',
          builder: (context, params) => const ProfileEnterWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
