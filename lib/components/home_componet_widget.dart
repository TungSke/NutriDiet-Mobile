import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/health_service.dart';
import 'home_componet_model.dart';

export 'home_componet_model.dart';

class HomeComponetWidget extends StatefulWidget {
  const HomeComponetWidget({super.key});

  @override
  State<HomeComponetWidget> createState() => _HomeComponetWidgetState();
}

class _HomeComponetWidgetState extends State<HomeComponetWidget>
    with SingleTickerProviderStateMixin {
  late HomeComponetModel _model;
  final ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  bool _showcaseShown = false;
  late AnimationController _animationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _calendarScaleAnimation;
  late Animation<double> _contentFadeAnimation;
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _calendar = GlobalKey();
  final GlobalKey _step = GlobalKey();
  final GlobalKey _calories = GlobalKey();
  final GlobalKey _caloDaily = GlobalKey();
  final GlobalKey _addMeal = GlobalKey();
  final GlobalKey _mealPlan = GlobalKey();

  @override
  void initState() {
    super.initState();

    loadData();
    _checkShowcaseStatus();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context).startShowCase([
    //     _notificationKey,
    //     _calendar,
    //     _step,
    //     _calories,
    //     _caloDaily,
    //     _mealPlan,
    //   ]);
    // });
    _model = createModel(context, () => HomeComponetModel());
    _model.setUpdateCallback(() {
      if (mounted) {
        setState(() {
          print(
              "setState called: steps=${_model.steps}, isRunning=${_model.isRunning}");
        });
      }
    });
    _model.initState(context);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _headerFadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    _calendarScaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.elasticOut),
    ));

    _contentFadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    _animationController.forward().then((_) {
      print("Animations completed");
    });
  }

  Future<void> _checkShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final showcaseShown = prefs.getBool('showcase_shown') ?? false;
    if (!showcaseShown) {
      Future.delayed(const Duration(milliseconds: 500), () {
        ShowCaseWidget.of(context).startShowCase([
          _notificationKey,
          _calendar,
          _step,
          _calories,
          _caloDaily,
          _mealPlan,
        ]);
        prefs.setBool('showcase_shown', true); // Đánh dấu showcase đã hiển thị
      });
    }
  }

  @override
  void dispose() {
    selectedDateNotifier.dispose();
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Map<String, dynamic>? healthData;
  Map<String, dynamic>? personalGoal;
  bool isLoading = true;
  String errorMessage = "";

  Future<void> loadData() async {
    final result = await HealthService.fetchHealthData();
    if (mounted) {
      setState(() {
        healthData = result["healthData"];
        personalGoal = result["personalGoal"];
        errorMessage = result["errorMessage"];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 25.0, 20.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào ngày mới !',
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'figtree',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: false,
                                      lineHeight: 1.5,
                                    ),
                              ),
                              if (FFAppState().isLogin == true)
                                Text(
                                  _model.name,
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 25.0,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: false,
                                        lineHeight: 1.5,
                                      ),
                                ),
                            ],
                          ),
                          Showcase(
                            key: _notificationKey,
                            description:
                                'Mọi thông báo bạn nhận được sẽ hiện ở đây',
                            targetShapeBorder: const CircleBorder(),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed('Notification_screen');
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0x3CF5F5F5),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ClipRRect(
                                    child: SvgPicture.asset(
                                      'assets/images/notification.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: _calendarScaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).lightGrey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Showcase(
                      key: _calendar,
                      overlayOpacity: 0.5,
                      description:
                          'Lịch biểu này cho phép bạn chọn một ngày cụ thể để theo dõi lịch sử ăn uống của bạn .',
                      child: FlutterFlowCalendar(
                        color: FlutterFlowTheme.of(context).primary,
                        iconColor: FlutterFlowTheme.of(context).secondaryText,
                        weekFormat: true,
                        weekStartsMonday: true,
                        rowHeight: 64.0,
                        onChange: (DateTimeRange? newSelectedDate) async {
                          if (newSelectedDate != null) {
                            setState(() {
                              _model.selectedDate = newSelectedDate.start;
                              _model.calendarSelectedDay = newSelectedDate;
                            });
                            _model.changeDate(newSelectedDate.start);
                          }
                        },
                        titleStyle:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'figtree',
                                  fontSize: 18.0,
                                  useGoogleFonts: false,
                                ),
                        dayOfWeekStyle:
                            FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: 'figtree',
                                  fontSize: 13.0,
                                  useGoogleFonts: false,
                                ),
                        dateStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'figtree',
                                  fontSize: 16.0,
                                  useGoogleFonts: false,
                                ),
                        selectedDateStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'figtree',
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: false,
                                ),
                        inactiveDateStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  fontSize: 16.0,
                                  useGoogleFonts: false,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: RefreshIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      await loadData();
                      _model.changeDate(_model.selectedDate);
                      await _model.fetchUserProfile();
                      setState(() {});
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/main_bg.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 24.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Hoạt động hôm nay',
                              maxLines: 1,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Hiển thị số bước chân bất kể _model.activityError
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Showcase(
                                        key: _step,
                                        enableAutoScroll: true,
                                        description: 'Số bước bạn đã đi',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Column(
                                            children: [
                                              CircularPercentIndicator(
                                                percent: _model.stepProgress
                                                    .clamp(0.0, 1.0),
                                                radius: 50.0,
                                                lineWidth: 8.0,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor:
                                                    Colors.blueAccent,
                                                backgroundColor:
                                                    Colors.grey[300]!,
                                                center: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.directions_walk,
                                                      color: Colors.blueAccent,
                                                      size: 24.0,
                                                    ),
                                                    Text(
                                                      '${_model.steps}',
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Bước chân',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts: false,
                                                        ),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Showcase(
                                        key: _calories,
                                        enableAutoScroll: true,
                                        description:
                                            'Calories bạn đã đốt cháy sẽ hiện ở đây',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Column(
                                            children: [
                                              CircularPercentIndicator(
                                                percent: _model
                                                    .caloriesBurnedProgress
                                                    .clamp(0.0, 1.0),
                                                radius: 50.0,
                                                lineWidth: 8.0,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor: Colors.redAccent,
                                                backgroundColor:
                                                    Colors.grey[300]!,
                                                center: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      color: Colors.redAccent,
                                                      size: 24.0,
                                                    ),
                                                    Text(
                                                      '${_model.caloriesBurned}',
                                                      style: const TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Calories đốt cháy',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts: false,
                                                        ),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                                    .divide(const SizedBox(width: 16.0))
                                    .addToStart(const SizedBox(width: 20.0))
                                    .addToEnd(const SizedBox(width: 20.0)),
                              ),

                              // Hiển thị thông báo lỗi nếu có
                              if (_model.activityError != null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 16.0, 20.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 24.0,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Text(
                                              _model.activityError!,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 16.0, 20.0, 0.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: _model.isRunning
                                        ? Colors.green[100]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.directions_run,
                                          color: _model.isRunning
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 24.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          _model.isRunning
                                              ? 'Đang chạy'
                                              : 'Không chạy',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: _model.isRunning
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: FFAppState().isLogin ? 1.0 : 0.3,
                          child: GestureDetector(
                            onTap: () {
                              if (FFAppState().isLogin == false) {
                                _showLoginModal(context);
                              }
                            },
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Showcase(
                                      key: _caloDaily,
                                      enableAutoScroll: true,
                                      title: "Thông tin dinh dưỡng",
                                      description:
                                          'thể xem thông tin dinh dưỡng mỗi ngày ở đây',
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 24.0, 20.0, 16.0),
                                            child: Text(
                                              'Calories hôm nay',
                                              maxLines: 1,
                                              style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Stack(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.0),
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 24.0),
                                                  child:
                                                      CircularPercentIndicator(
                                                    percent: (_model.mealLogs
                                                                .isNotEmpty &&
                                                            personalGoal !=
                                                                null &&
                                                            personalGoal![
                                                                    'dailyCalories'] >
                                                                0)
                                                        ? (_model.mealLogs[0]
                                                                    .totalCalories
                                                                    .toDouble() /
                                                                personalGoal![
                                                                        'dailyCalories']
                                                                    .toDouble())
                                                            .clamp(0.0, 1.0)
                                                        : 0.0,
                                                    radius: 75.0,
                                                    lineWidth: 12.0,
                                                    animation: true,
                                                    animateFromLastPercent:
                                                        true,
                                                    progressColor: (_model
                                                                .mealLogs
                                                                .isNotEmpty &&
                                                            _model.mealLogs[0]
                                                                    .totalCalories >
                                                                personalGoal![
                                                                    'dailyCalories'])
                                                        ? Colors.red
                                                        : Colors.green,
                                                    backgroundColor:
                                                        const Color(0x33808080),
                                                    center: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalCalories : 0}/',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'figtree',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "${personalGoal?['dailyCalories'] ?? "N/A"}",
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0.0, 1.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 20.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Kcal',
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .grey,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: false,
                                                          lineHeight: 1.5,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 24.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircularPercentIndicator(
                                                  percent: _model
                                                          .mealLogs.isNotEmpty
                                                      ? (_model.mealLogs[0]
                                                                  .totalCarbs /
                                                              personalGoal?[
                                                                  'dailyCarb'])
                                                          .clamp(0.0, 1.0)
                                                      : 0.0,
                                                  radius: 50.0,
                                                  lineWidth: 8.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.teal,
                                                  backgroundColor:
                                                      Colors.grey[200]!,
                                                  center: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalCarbs : 0}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        '/${personalGoal?['dailyCarb'] ?? "N/A"}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  footer: const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text('Carbs'),
                                                  ),
                                                ),
                                                CircularPercentIndicator(
                                                  percent: _model
                                                          .mealLogs.isNotEmpty
                                                      ? (_model.mealLogs[0]
                                                                  .totalProtein /
                                                              personalGoal?[
                                                                  'dailyProtein'])
                                                          .clamp(0.0, 1.0)
                                                      : 0.0,
                                                  radius: 50.0,
                                                  lineWidth: 8.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.orange,
                                                  backgroundColor:
                                                      Colors.grey[200]!,
                                                  center: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalProtein : 0}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        '/${personalGoal?['dailyProtein'] ?? "N/A"}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  footer: const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text('Protein'),
                                                  ),
                                                ),
                                                CircularPercentIndicator(
                                                  percent: _model
                                                          .mealLogs.isNotEmpty
                                                      ? (_model.mealLogs[0]
                                                                  .totalFat /
                                                              personalGoal?[
                                                                  'dailyFat'])
                                                          .clamp(0.0, 1.0)
                                                      : 0.0,
                                                  radius: 50.0,
                                                  lineWidth: 8.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.purple,
                                                  backgroundColor:
                                                      Colors.grey[200]!,
                                                  center: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalFat : 0}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        '/${personalGoal?['dailyFat'] ?? "N/A"}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  footer: const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text('Fat'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Showcase(
                                    //   key: _mealPlan,
                                    //   enableAutoScroll: true,
                                    //   description:
                                    //       'Dưới đây là thông tin bữa ăn của bạn. Hãy bắt đầu bữa ăn bằng việc thêm món',
                                    //   child: Padding(
                                    //     padding: const EdgeInsetsDirectional
                                    //         .fromSTEB(20.0, 24.0, 20.0, 16.0),
                                    //     child: Text(
                                    //       'Bữa ăn hằng ngày',
                                    //       maxLines: 1,
                                    //       style: GoogleFonts.roboto(
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.w600,
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // for (final category
                                    //     in _model.mealCategories) ...[
                                    //   _buildMealCategoryCard(context, category),
                                    //   Container(
                                    //     height: 10.0,
                                    //     color: Colors.white,
                                    //   ),
                                    // ],
                                  ],
                                ),
                                if (FFAppState().isLogin == false)
                                  const Positioned(
                                    top: 10.0,
                                    right: 10.0,
                                    child: Icon(
                                      Icons.lock,
                                      size: 40.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mapCategoryToVietnamese(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return 'Bữa sáng';
      case 'lunch':
        return 'Bữa trưa';
      case 'dinner':
        return 'Bữa tối';
      case 'snacks':
        return 'Bữa phụ';
      default:
        return category;
    }
  }
  //
  // Widget _buildMealCategoryCard(BuildContext context, String category) {
  //   final vietnameseCategory = _mapCategoryToVietnamese(category);
  //   final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;
  //
  //   return Padding(
  //     padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: FlutterFlowTheme.of(context).lightGrey,
  //               borderRadius: BorderRadius.circular(16.0),
  //             ),
  //             child: Padding(
  //               padding:
  //                   const EdgeInsetsDirectional.fromSTEB(16, 16.0, 16, 16.0),
  //               child: _buildMealCategoryContent(
  //                 context,
  //                 mealLog,
  //                 category,
  //                 vietnameseCategory,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ]
  //           .divide(const SizedBox(width: 16.0))
  //           .addToStart(const SizedBox(width: 20.0))
  //           .addToEnd(const SizedBox(width: 20.0)),
  //     ),
  //   );
  // }

  Color _getMealProgressColor(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.blue;
      case 'snacks':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Widget _buildMealCategoryContent(
  //   BuildContext context,
  //   mealLog,
  //   String category,
  //   String vietnameseCategory,
  // ) {
  //   if (mealLog == null) {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildMealHeader(vietnameseCategory, null),
  //         ListTile(
  //           title: const Text(
  //             'Thêm',
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Colors.green,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => MealLogComponentWidget(),
  //               ),
  //             ).then((result) {
  //               if (result == true) _model.fetchMealLogs();
  //             });
  //           },
  //         ),
  //       ],
  //     );
  //   }
  //
  //   final details = mealLog.mealLogDetails
  //       .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
  //       .toList();
  //
  //   final bool hasAnyFood = details.isNotEmpty;
  //   final mealCals = details.fold(0, (sum, d) => sum + d.calories);
  //   final mealCarbs = details.fold(0, (sum, d) => sum + d.carbs);
  //   final mealFat = details.fold(0, (sum, d) => sum + d.fat);
  //   final mealProtein = details.fold(0, (sum, d) => sum + d.protein);
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildMealHeader(vietnameseCategory, hasAnyFood ? mealCals : null),
  //       if (hasAnyFood)
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //           child: Text(
  //             'Carbs $mealCarbs (g) • Fat $mealFat (g) • Protein $mealProtein (g)',
  //             style: const TextStyle(
  //               fontFamily: 'Figtree',
  //               fontSize: 14,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //         child: LinearProgressIndicator(
  //           value: mealCals > 0 ? (mealCals / 1000) : 0,
  //           backgroundColor: Colors.grey[300],
  //           valueColor:
  //               AlwaysStoppedAnimation<Color>(_getMealProgressColor(category)),
  //         ),
  //       ),
  //       for (int i = 0; i < details.length; i++) ...[
  //         GestureDetector(
  //           onLongPress: () {
  //             showDialog(
  //               context: context,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text('Nhật ký'),
  //                   content: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       ListTile(
  //                         title: const Text('Chuyển đến...'),
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                           showDialog(
  //                             context: context,
  //                             builder: (BuildContext context) {
  //                               return AlertDialog(
  //                                 title: const Text('Chuyển đến...'),
  //                                 content: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     for (final mealType in [
  //                                       'Breakfast',
  //                                       'Lunch',
  //                                       'Dinner',
  //                                       'Snacks'
  //                                     ])
  //                                       ListTile(
  //                                         title: Text(mealType),
  //                                         onTap: () async {
  //                                           Navigator.pop(context);
  //                                           await _model
  //                                               .transferMealLogDetailEntry(
  //                                             detailId: details[i].detailId,
  //                                             targetMealType: mealType,
  //                                           );
  //                                         },
  //                                       ),
  //                                   ],
  //                                 ),
  //                               );
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //           child: Padding(
  //             padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         CircleAvatar(
  //                           radius: 3,
  //                           backgroundColor: Colors.orange,
  //                         ),
  //                         const SizedBox(width: 8.0),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               details[i].foodName,
  //                               style: const TextStyle(fontSize: 14),
  //                             ),
  //                             Text(
  //                               "(x${details[i].quantity})",
  //                               style: const TextStyle(
  //                                   fontSize: 14, color: Colors.grey),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Text("${details[i].calories} kcal"),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //       ListTile(
  //         title: const Text(
  //           'Thêm',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.green,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => MealLogComponentWidget(),
  //             ),
  //           ).then((result) {
  //             if (result == true) _model.fetchMealLogs();
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMealHeader(String category, int? mealCals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          mealCals == null
              ? const SizedBox.shrink()
              : Text(
                  '${mealCals.toString()} kcal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}

void _showLoginModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Vui lòng đăng nhập để xem'),
        content: Text('Bạn cần đăng nhập để xem thông tin này.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Hủy',
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  FlutterFlowTheme.of(context).primary),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed('login_intro_screen');
            },
            child: const Text(
              'Đăng nhập',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
