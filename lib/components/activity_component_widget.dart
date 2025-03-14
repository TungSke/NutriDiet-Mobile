import 'package:diet_plan_app/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/health_service.dart';
import '../services/user_service.dart';
import 'activity_component_model.dart';
import 'chart_weight_widget.dart';

export 'home_componet_model.dart';

class ActivityComponentWidget extends StatefulWidget {
  const ActivityComponentWidget({super.key});

  @override
  State<ActivityComponentWidget> createState() =>
      _ActivityComponentWidgetState();
}

class _ActivityComponentWidgetState extends State<ActivityComponentWidget> {
  late ActivityComponentModel _model;

  // Khai báo _userService
  final _userService = UserService();
  String name = '';
  String age = '';
  String phoneNumber = '';
  String location = '';
  String email = '';
  int height = 0;
  int weight = 0;
  String activityLevel = '';
  String userId = '';
  bool isLoading = true;
  String errorMessage = "";
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    fetchUserProfile(); // Gọi API để lấy thông tin người dùng
    _model = createModel(context, () => ActivityComponentModel());
    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.linear,
            delay: 50.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, -20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? "Chưa cập nhật";
          age = data['age']?.toString() ?? "0";
          phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
          location = data['address'] ?? "Chưa cập nhật";
          email = data["email"] ?? "Chưa cập nhật";
          userId = data['id']?.toString() ?? "";
          isLoading = false; // Đặt trạng thái không còn loading
        });
      } else {
        setState(() {
          errorMessage = '❌ Failed to fetch user profile';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "❌ Lỗi khi lấy thông tin người dùng: $e";
        isLoading = false;
      });
    }
  }

  // Future<void> fetchHealthProfile() async {
  //   try {
  //     final response = await _userService.getHealthProfile();
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         weight = data['weight'] ?? "Chưa cập nhật";
  //         height = data['age']?.toString() ?? "0";
  //         phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
  //         location = data['address'] ?? "Chưa cập nhật";
  //         email = data["email"] ?? "Chưa cập nhật";
  //         userId = data['id']?.toString() ?? "";
  //         isLoading = false; // Đặt trạng thái không còn loading
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = '❌ Failed to fetch user profile';
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = "❌ Lỗi khi lấy thông tin người dùng: $e";
  //       isLoading = false;
  //     });
  //   }
  // }

  Map<String, dynamic>? healthData;
  Map<String, dynamic>? personalGoal;

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
  void dispose() {
    _model.maybeDispose();
    super.dispose();
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
            height: 119.0,
            decoration: const BoxDecoration(),
            child: Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Text(
                  'Hoạt động',
                  maxLines: 1,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'figtree',
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                        lineHeight: 1.5,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: Image.asset(
                          'assets/images/jamekooper_.png',
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text(name,
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Text(
                                "• $age tuổi • ${healthData?['height']} cm • ${healthData?['weight']} kg",
                                style: GoogleFonts.roboto(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 24.0, 20.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mục tiêu gần đây:',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${personalGoal?['goalType'] ?? "N/A"}",
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Cân nặng ban đầu: ",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            "${healthData?['weight'] ?? "N/A"} kg",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Cân nặng mục tiêu:",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            "${personalGoal?['targetWeight'] ?? "N/A"} kg",
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Đã hoàn thành ",
                            style: TextStyle(
                                fontSize: 14,
                                color: FlutterFlowTheme.of(context).primary),
                          ),
                          Text(
                            "${personalGoal?['progressPercentage'] ?? "N/A"}/100 %",
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      WeightProgressChart(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 24.0, 20.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tình trạng hiện tại:",
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${healthData?['BMIType']}",
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primary),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "BMI",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 12.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            center: Text(
                              "${healthData?['BMI'] ?? "N/A"}",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Figtree',
                                    color: FlutterFlowTheme.of(context).grey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                        Text("Chỉ số cơ thể")
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "TDEE",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 12.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            center: Text(
                              "${healthData?['TDEE'] ?? "N/A"}",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Figtree',
                                    color: FlutterFlowTheme.of(context).grey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                        Text("Năng lượng cần tiêu thụ")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
