import 'package:diet_plan_app/components/activity_component_model.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../flutter_flow/flutter_flow_model.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../services/user_service.dart';
import 'chart_weight_widget.dart';

class ActivityComponentWidget extends StatefulWidget {
  const ActivityComponentWidget({super.key});

  @override
  State<ActivityComponentWidget> createState() =>
      _ActivityComponentWidgetState();
}

class _ActivityComponentWidgetState extends State<ActivityComponentWidget> {
  late ActivityComponentModel _model;
  final UserService _userService = UserService();
  void _refreshChart() {
    setState(() {
      // Gọi lại hàm làm mới biểu đồ khi có thay đổi
    });
  }

  final animationsMap = <String, AnimationInfo>{};

  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityComponentModel());
    _model.fetchUserProfile();
    _model.fetchHealthProfile();
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

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 63.0, 20.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 16.0),
                    child: Text(
                      'Hoạt động',
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'figtree',
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: false,
                            lineHeight: 1.5,
                          ),
                    ).animateOnPageLoad(
                        animationsMap['textOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
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
                            Text(_model.name,
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Text(
                              "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
                              style: GoogleFonts.roboto(
                                  fontSize: 12, color: Colors.grey),
                            ),
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
                        _model.goalType,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Cân nặng ban đầu: ",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  Text(
                                    "${_model.weight} kg",
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
                                  Text("Cân nặng mục tiêu:",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  Text(
                                    "${_model.targetWeight} kg",
                                    style: TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            backgroundColor: Colors.green,
                            elevation: 4.0,
                            shape: CircleBorder(),
                            mini: true,
                            heroTag: null,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Đã hoàn thành ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: FlutterFlowTheme.of(context).primary)),
                          Text(
                            "${_model.progressPercentage}/100 %",
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SingleChildScrollView(
                    child: Container(
                      height: 400,
                      child: WeightLineChart(
                        refreshChart:
                            _refreshChart, // Truyền callback refreshChart vào đây
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tình trạng hiện tại:",
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _model.bmiType,
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
                              _model.bmi,
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
                              _model.tdee,
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

  void _showBottomSheet(BuildContext context) async {
    double currentWeight = _model.weight;
    double currentHeight = _model.height;
    String currentActivityLevel = _model.activityLevel;
    List<int> currentAllergies =
        _model.allergies; // Using the existing allergies list
    List<int> currentDiseases =
        _model.diseases; // Using the existing diseases list

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: StatefulBuilder(
            builder: (context, setStateForBottomSheet) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cập nhật cân nặng',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${currentWeight.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setStateForBottomSheet(() {
                            currentWeight -= 0.1;
                            // Làm tròn giá trị cân nặng sau khi thay đổi
                            currentWeight =
                                double.parse(currentWeight.toStringAsFixed(1));
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setStateForBottomSheet(() {
                            currentWeight += 0.1;
                            // Làm tròn giá trị cân nặng sau khi thay đổi
                            currentWeight =
                                double.parse(currentWeight.toStringAsFixed(1));
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Cập nhật giá trị mới cho _model
                      _model.weight = currentWeight;

                      // Gọi updateHealthProfile và cập nhật lại trọng lượng trong _model
                      await _model.updateHealthProfile(context);

                      setState(() {
                        _model.weight =
                            currentWeight; // Cập nhật weight trong _model
                      });
                      _refreshChart();
                      // Thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Cập nhật cân nặng thành công!')),
                      );

                      // Đóng bottom sheet sau khi lưu
                    },
                    child: Text('Lưu'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
