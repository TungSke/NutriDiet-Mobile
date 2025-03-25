import 'package:diet_plan_app/profile_flow/edit_daily_macronutrients/edit_daily_macronutrients_screen_widget.dart';
import 'package:diet_plan_app/profile_flow/edit_health_profile_screen/edit_health_profile_screen_widget.dart';
import 'package:diet_plan_app/profile_flow/edit_personal_goal_screen/edit_personal_goal_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../edit_profile_screen/edit_profile_screen_widget.dart';
import 'my_profile_model.dart';

export 'my_profile_model.dart';

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  late MyProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyProfileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _model.fetchUserProfile();

      await _model.fetchHealthProfile();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 79.0,
                decoration: const BoxDecoration(),
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20.0, 0.0, 20.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.push("/bottomNavbarScreen");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).lightGrey,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: SvgPicture.asset(
                                  'assets/images/appbar-arroew.svg',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Thông tin cá nhân',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'figtree',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   focusColor: Colors.transparent,
                        //   hoverColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onTap: () async {
                        //     context.pushNamed('edit_profile_screen');
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: FlutterFlowTheme.of(context).lightGrey,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(0.0),
                        //         child: SvgPicture.asset(
                        //           'assets/images/pen.svg',
                        //           width: 24.0,
                        //           height: 24.0,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (FFAppState().isLogin == false) {
                                      return Container(
                                        decoration: const BoxDecoration(),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.asset(
                                            'assets/images/dummy_profile.png', // Avatar mặc định
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: _model.avatar.isNotEmpty
                                                  ? Image.network(
                                                      // Nếu có avatar từ API, sử dụng Image.network
                                                      _model.avatar,
                                                      width: 80.0,
                                                      height: 80.0,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      // Nếu không có avatar, sử dụng hình mặc định
                                                      'assets/images/dummy_profile.png',
                                                      width: 80.0,
                                                      height: 80.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Column(
                                                children: [
                                                  Text(_model.name,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  Text(
                                                      "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 12,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ].divide(const SizedBox(width: 16.0)),
                            ),
                          ),
                        ].addToStart(const SizedBox(height: 16.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hồ sơ cá nhân ",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreenWidget(),
                                ),
                              );

                              if (result == true) {
                                await _model
                                    .fetchUserProfile(); // ✅ Fetch lại dữ liệu mới nhất
                                setState(() {}); // ✅ Cập nhật UI ngay
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Cập nhật",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tên',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _model.name,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Giới tính',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _model.gender,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Số điện thoại',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _model.phoneNumber,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nơi sinh sống',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _model.location,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hồ sơ sức khỏe ",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditHealthProfileScreenWidget(),
                                ),
                              );

                              if (result == true) {
                                await _model.fetchHealthProfile();
                                setState(() {});
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Cập nhật",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Chiều cao',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.height} cm",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cân nặng',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "${_model.weight} kg",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tần suất vận động ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _model.activityLevel,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dị ứng',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _model.allergies.isNotEmpty
                                      ? Text(
                                          _model.allergies.join(', '),
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        )
                                      : Text(
                                          "Không có dị ứng",
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bệnh nền',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _model.diseases.isNotEmpty
                                      ? Text(
                                          _model.diseases.join(', '),
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        )
                                      : Text(
                                          "Không có bệnh nền",
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mục tiêu sức khỏe ",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Gọi lại API để cập nhật mục tiêu sức khỏe
                              await _model
                                  .fetchHealthProfile(); // Gọi lại API khi cập nhật
                              setState(() {}); // Cập nhật UI ngay
                              // Chuyển đến màn hình chỉnh sửa mục tiêu sức khỏe
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPersonalGoalScreenWidget(),
                                ),
                              );

                              if (result == true) {
                                // Nếu có kết quả trả về từ màn hình chỉnh sửa, gọi lại API
                                await _model.fetchHealthProfile();
                                setState(() {}); // Cập nhật lại UI
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Cập nhật",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mục tiêu (gần đây) ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    _model.goalType,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mục tiêu cân nặng (gần đây)',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.targetWeight} kg",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mức độ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.weightChangeRate} kg",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Hoàn thành',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.progressPercentage ?? ''} % ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dinh dưỡng cần nạp mỗi ngày ",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditDailyMacronutrientsScreenWidget(),
                                ),
                              );

                              if (result == true) {
                                await _model
                                    .fetchHealthProfile(); // ✅ Fetch lại dữ liệu mới nhất
                                setState(() {}); // ✅ Cập nhật UI ngay
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Cập nhật",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Calories',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.dailyCalories ?? ''} kcal",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fat',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.dailyFat ?? ''} g ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Protein',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.dailyProtein ?? ''} g ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Carb',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text(
                                    "${_model.dailyCarb ?? ''} g",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
