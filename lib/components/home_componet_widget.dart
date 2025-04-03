import 'package:diet_plan_app/index.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

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

class _HomeComponetWidgetState extends State<HomeComponetWidget> {
  late HomeComponetModel _model;
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier<DateTime>(
      DateTime.now()); // Thêm ValueNotifier để theo dõi ngày

  @override
  void initState() {
    super.initState();
    loadData();

    _model = createModel(context, () => HomeComponetModel());
    _model.setUpdateCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
    _model.fetchMealLogs();
    _model.fetchUserProfile();
  }

  @override
  void dispose() {
    selectedDateNotifier.dispose(); // Đừng quên dispose ValueNotifier
    _model.dispose();
    super.dispose();
  }

  Map<String, dynamic>? healthData;
  Map<String, dynamic>? personalGoal;
  bool isLoading = true;
  String errorMessage = "";

  Future<void> loadData() async {
    final result = await HealthService.fetchHealthData();
    setState(() {
      healthData = result["healthData"];
      personalGoal = result["personalGoal"];
      errorMessage = result["errorMessage"];
      isLoading = false;
    });
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
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 63.0, 20.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào ngày mới !',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                      ),
                      if (FFAppState().isLogin == true)
                        Text(
                          _model.name,
                          maxLines: 1,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'figtree',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                        ),
                    ],
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
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
                          borderRadius: BorderRadius.circular(0.0),
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
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).lightGrey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: FlutterFlowCalendar(
                      color: FlutterFlowTheme.of(context).primary,
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      weekFormat: true,
                      weekStartsMonday: true,
                      rowHeight: 64.0,
                      onChange: (DateTimeRange? newSelectedDate) async {
                        if (newSelectedDate != null) {
                          setState(() {
                            _model.selectedDate =
                                newSelectedDate.start; // Lưu ngày đã chọn
                            _model.calendarSelectedDay =
                                newSelectedDate; // Lưu lại phạm vi ngày đã chọn
                          });

                          // Fetch lại meal logs ngay khi thay đổi ngày
                          _model.changeDate(newSelectedDate.start);
                          setState(() {});
                        }
                      },
                      titleStyle:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'figtree',
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      dayOfWeekStyle:
                          FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: 'figtree',
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      dateStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'figtree',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      selectedDateStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'figtree',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: false,
                              ),
                      inactiveDateStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'figtree',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                    )),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              color: FlutterFlowTheme.of(context).primary,
              backgroundColor: Colors.white,
              onRefresh: () async {
                // Fetch data again when pulling to refresh
                await loadData(); // Call loadData() to fetch health data
                await _model.fetchMealLogs(); // Fetch meal logs
                await _model.fetchUserProfile(); // Fetch user profile data
                setState(() {}); // Trigger a rebuild after data is refreshed
              },
              child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/main_bg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    //UI số bước chân
                    // Thay thế phần "Hoạt động hôm nay" trong build()
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 24.0),
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
                    if (_model.activityError != null ||
                        kIsWeb) // Sử dụng kIsWeb thay vì Platform.isWeb
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kIsWeb
                                      ? 'Không hỗ trợ trên web'
                                      : 'Lỗi lấy dữ liệu hoạt động',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  kIsWeb
                                      ? 'Dữ liệu hoạt động không khả dụng trên trình duyệt web.'
                                      : _model.activityError!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[800],
                                  ),
                                ),
                                if (!kIsWeb &&
                                    _model.activityError!
                                        .contains("từ chối cấp quyền"))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Gọi lại fetchActivityData để yêu cầu quyền lần nữa (chỉ trên mobile)
                                        await _model.fetchActivityData();
                                        setState(
                                            () {}); // Rebuild sau khi thử lại
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                      child: const Text(
                                        'Thử lại',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_model.activityError == null &&
                        !kIsWeb) // Chỉ hiển thị dữ liệu nếu không có lỗi và không chạy trên web
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Thẻ hiển thị số bước chân
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).lightGrey,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CircularPercentIndicator(
                                        percent:
                                            _model.stepProgress.clamp(0.0, 1.0),
                                        radius: 50.0,
                                        lineWidth: 8.0,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        progressColor: Colors.blueAccent,
                                        backgroundColor: Colors.grey[300]!,
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
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Bước chân',
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            // Thẻ hiển thị calories đốt cháy
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).lightGrey,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CircularPercentIndicator(
                                        percent: _model.caloriesBurnedProgress
                                            .clamp(0.0, 1.0),
                                        radius: 50.0,
                                        lineWidth: 8.0,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        progressColor: Colors.redAccent,
                                        backgroundColor: Colors.grey[300]!,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              color: Colors.redAccent,
                                              size: 24.0,
                                            ),
                                            Text(
                                              '${_model.caloriesBurned}',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Calories đốt cháy',
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ]
                              .divide(const SizedBox(width: 16.0))
                              .addToStart(const SizedBox(width: 20.0))
                              .addToEnd(const SizedBox(width: 20.0)),
                        ),
                      ),
                    Opacity(
                      opacity: FFAppState().isLogin
                          ? 1.0
                          : 0.3, // Làm mờ khi chưa đăng nhập
                      child: GestureDetector(
                        onTap: () {
                          if (FFAppState().isLogin == false) {
                            _showLoginModal(
                                context); // Hiển thị modal đăng nhập nếu chưa đăng nhập
                          }
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 24.0, 20.0, 16.0),
                                  child: Text(
                                    'Calories hôm nay',
                                    maxLines: 1,
                                    style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                Stack(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  children: [
                                    Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 24.0),
                                          child: CircularPercentIndicator(
                                            percent: (_model
                                                        .mealLogs.isNotEmpty &&
                                                    personalGoal != null &&
                                                    personalGoal![
                                                            'dailyCalories'] >
                                                        0)
                                                ? (_model.mealLogs[0]
                                                            .totalCalories
                                                            .toDouble() /
                                                        personalGoal![
                                                                'dailyCalories']
                                                            .toDouble())
                                                    .clamp(0.0,
                                                        1.0) // Giới hạn tỷ lệ trong khoảng 0.0 - 1.0
                                                : 0.0,
                                            radius: 75.0,
                                            lineWidth: 12.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor: (_model
                                                        .mealLogs.isNotEmpty &&
                                                    _model.mealLogs[0]
                                                            .totalCalories >
                                                        personalGoal![
                                                            'dailyCalories'])
                                                ? Colors
                                                    .red // Nếu totalCalories > dailyCalories, set màu đỏ
                                                : Colors
                                                    .green, // Nếu không, set màu xanhu không, set màu xanh// Nếu không, set màu xanhhông, set màu xanh
                                            backgroundColor:
                                                const Color(0x33808080),
                                            center: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalCalories : 0}/',
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
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${personalGoal?['dailyCalories'] ?? "N/A"}",
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.0, 1.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Text(
                                          'Kcal',
                                          maxLines: 1,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'figtree',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .grey,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: false,
                                                lineHeight: 1.5,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 24.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
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
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 16.0, 0.0, 16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalCarbs : 0}/',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'figtree',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${personalGoal?['dailyCarb'] ?? "N/A"}",
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Carbs',
                                                  maxLines: 1,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'figtree',
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
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
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 16.0, 0.0, 16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalProtein : 0}/',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'figtree',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${personalGoal?['dailyProtein'] ?? "N/A"}",
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Protein',
                                                  maxLines: 1,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'figtree',
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
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
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 16.0, 0.0, 16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${_model.mealLogs.isNotEmpty ? _model.mealLogs[0].totalFat : 0}/',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'figtree',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${personalGoal?['dailyFat'] ?? "N/A"}",
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'figtree',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Fat',
                                                  maxLines: 1,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'figtree',
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
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
                                    ]
                                        .divide(const SizedBox(width: 16.0))
                                        .addToStart(const SizedBox(width: 20.0))
                                        .addToEnd(const SizedBox(width: 20.0)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 24.0, 20.0, 16.0),
                                  child: Text(
                                    'Bữa ăn hằng ngày',
                                    maxLines: 1,
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                for (final category
                                    in _model.mealCategories) ...[
                                  _buildMealCategoryCard(context, category),
                                  Container(
                                    height: 10.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ],
                            ),
                            // Hiển thị icon ổ khóa nếu chưa đăng nhập
                            if (FFAppState().isLogin == false)
                              Positioned(
                                top: 10.0,
                                right: 10.0,
                                child: Icon(
                                  Icons.lock,
                                  size: 40.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
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
      case 'exercise':
        return 'Tập luyện';
      default:
        return category;
    }
  }

  Widget _buildMealCategoryCard(BuildContext context, String category) {
    final vietnameseCategory = _mapCategoryToVietnamese(category);

    final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;

    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .lightGrey, // Thay màu sắc nếu cần
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16, 16.0, 16, 16.0),
                child: _buildMealCategoryContent(
                  context,
                  mealLog,
                  category,
                  vietnameseCategory,
                ),
              ),
            ))
          ]
              .divide(const SizedBox(width: 16.0))
              .addToStart(const SizedBox(width: 20.0))
              .addToEnd(const SizedBox(width: 20.0)),
        ));
  }

  Color _getMealProgressColor(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.orange; // Màu cho bữa sáng
      case 'lunch':
        return Colors.green; // Màu cho bữa trưa
      case 'dinner':
        return Colors.blue; // Màu cho bữa tối
      case 'snacks':
        return Colors.purple; // Màu cho bữa phụ
      case 'exercise':
        return Colors.red; // Màu cho tập luyện
      default:
        return Colors.grey; // Màu mặc định cho các bữa khác
    }
  }

  Widget _buildMealCategoryContent(
    BuildContext context,
    mealLog,
    String category,
    String vietnameseCategory,
  ) {
    // Nếu chưa có mealLog => bữa này chưa có gì
    if (mealLog == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(vietnameseCategory, null),
          ListTile(
            title: const Text(
              'Thêm',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealLogComponentWidget(),
                ),
              ).then((result) {
                if (result == true) {
                  _model.fetchMealLogs();
                }
              });
            },
          ),
        ],
      );
    }

    // Nếu đã có mealLog, ta lọc các chi tiết thuộc bữa này
    final details = mealLog.mealLogDetails
        .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
        .toList();

    // Kiểm tra bữa này có món không
    final bool hasAnyFood = details.isNotEmpty;

    // Tính tổng Calories & macro
    final mealCals = details.fold(0, (sum, d) => sum + d.calories);
    final mealCarbs = details.fold(0, (sum, d) => sum + d.carbs);
    final mealFat = details.fold(0, (sum, d) => sum + d.fat);
    final mealProtein = details.fold(0, (sum, d) => sum + d.protein);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMealHeader(vietnameseCategory, hasAnyFood ? mealCals : null),
        if (hasAnyFood)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Carbs $mealCarbs (g) • Fat $mealFat (g) • Protein $mealProtein (g)',
              style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: LinearProgressIndicator(
            value: mealCals > 0
                ? (mealCals / 1000)
                : 0, // Tính tỷ lệ phần trăm calo
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getMealProgressColor(
                category)), // Chọn màu tùy vào loại bữa ăn
          ),
        ),
        for (int i = 0; i < details.length; i++) ...[
          GestureDetector(
            onLongPress: () {
              // Dialog thao tác: chuyển bữa hoặc xóa món
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Nhật ký'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Chuyển đến...'),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Chuyển đến...'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Liệt kê các bữa
                                      for (final mealType in [
                                        'Breakfast',
                                        'Lunch',
                                        'Dinner',
                                        'Snacks'
                                      ])
                                        ListTile(
                                          title: Text(mealType),
                                          onTap: () async {
                                            // Khi user chọn bữa, đóng popup
                                            Navigator.pop(context);
                                            // Gọi hàm transferMealLogDetailEntry
                                            await _model
                                                .transferMealLogDetailEntry(
                                              detailId: details[i].detailId,
                                              targetMealType: mealType,
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 3, // Kích thước dấu chấm tròn
                            backgroundColor: Colors.orange,
                          ),
                          SizedBox(width: 8.0),
                          Row(
                            spacing: 8,
                            children: [
                              Text(details[i].foodName,
                                  style: TextStyle(fontSize: 14)),
                              Text(
                                "(x${details[i].quantity})",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text("${details[i].calories} kcal"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ListTile(
          title: const Text(
            'Thêm',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealLogComponentWidget(),
              ),
            ).then((result) {
              if (result == true) {
                _model.fetchMealLogs();
              }
            });
          },
        ),
      ],
    );
  }

  /// Header cho mỗi bữa (hiển thị tên bữa & tổng calo bữa)
  Widget _buildMealHeader(String category, int? mealCals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tên bữa (Bữa sáng, Bữa trưa, ...)
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Nếu mealCals == null => ẩn, còn != null => hiển thị
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
              Navigator.pop(context); // Đóng modal
            },
            child: Text(
              'Hủy',
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  FlutterFlowTheme.of(context).primary), // Chỉnh màu nền
            ),
            onPressed: () {
              Navigator.pop(context); // Đóng modal
              // Điều hướng tới trang đăng nhập
              context.pushNamed('login_intro_screen');
            },
            child: Text(
              'Đăng nhập',
              style: TextStyle(color: Colors.white), // Chỉnh màu chữ
            ),
          ),
        ],
      );
    },
  );
}
