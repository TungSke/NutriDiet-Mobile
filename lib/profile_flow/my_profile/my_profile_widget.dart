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

class _MyProfileWidgetState extends State<MyProfileWidget>
    with SingleTickerProviderStateMixin {
  late MyProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyProfileModel());

    // Khởi tạo AnimationController và các animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _model.fetchUserProfile();
      await _model.fetchHealthProfile();
      setState(() {});
      // Bắt đầu animation sau khi dữ liệu đã được tải
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          // Áp dụng FadeTransition cho toàn bộ nội dung trang
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Header với Gradient và animation
                Container(
                  height: 79.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF04B155),
                        Color(0xFF2ED47A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
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
                              style: GoogleFonts.lato(
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Phần cập nhật profile (đã comment ở đoạn code gốc) có thể thêm animation nếu cần
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
                                            // Áp dụng ScaleTransition cho ảnh đại diện
                                            ScaleTransition(
                                              scale: _scaleAnimation,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                  child:
                                                      _model.avatar.isNotEmpty
                                                          ? Image.network(
                                                              _model.avatar,
                                                              width: 80.0,
                                                              height: 80.0,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              'assets/images/dummy_profile.png',
                                                              width: 80.0,
                                                              height: 80.0,
                                                              fit: BoxFit.cover,
                                                            ),
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
                                                    Text(
                                                      _model.name,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
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
                              "Hồ sơ cá nhân",
                              style: GoogleFonts.lato(
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
                                  await _model.fetchUserProfile();
                                  setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Cập nhật",
                                  style: GoogleFonts.lato(
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
                      // Card thông tin hồ sơ cá nhân
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      _model.name,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Giới tính',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      _model.gender,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tuổi',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      _model.age,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Nơi sinh sống',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      _model.location,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(const SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      // Phần hồ sơ sức khỏe
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hồ sơ sức khỏe",
                              style: GoogleFonts.lato(
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
                                  style: GoogleFonts.lato(
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
                      // Card hồ sơ sức khỏe
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                    Expanded(
                                      child: Text(
                                        'Chiều cao',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${_model.height} cm",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Cân nặng',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${_model.weight} kg",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Tần suất vận động',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _model.activityLevel,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Thói quen ăn uống',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _model.dietStyle,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dị ứng',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _model.allergies.isNotEmpty
                                        ? Text(
                                            _model.allergies.join(', '),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Text(
                                            "Không có dị ứng",
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bệnh nền',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _model.diseases.isNotEmpty
                                        ? Text(
                                            _model.diseases.join(', '),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Text(
                                            "Không có bệnh nền",
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ],
                                ),
                              ].divide(const SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      // Phần mục tiêu sức khỏe
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Mục tiêu sức khỏe",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _model.fetchHealthProfile();
                                setState(() {});
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditPersonalGoalScreenWidget(),
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
                                  style: GoogleFonts.lato(
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
                      // Card mục tiêu sức khỏe
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                    Expanded(
                                      child: Text(
                                        'Mục tiêu (gần đây)',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _model.goalType,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Mục tiêu cân nặng (gần đây)',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${_model.targetWeight} kg",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Mức độ',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${_model.weightChangeRate} ",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hoàn thành',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "${_model.progressPercentage ?? ''} % ",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(const SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      // Phần dinh dưỡng cần nạp hàng ngày
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Dinh dưỡng cần nạp mỗi ngày",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                  await _model.fetchHealthProfile();
                                  setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                // child: Text(
                                //   "Cập nhật",
                                //   style: GoogleFonts.lato(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.bold,
                                //     color: FlutterFlowTheme.of(context).primary,
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Card thông tin dinh dưỡng
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                      'Calories',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "${_model.dailyCalories ?? ''} kcal",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fat',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "${_model.dailyFat ?? ''} g",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Protein',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "${_model.dailyProtein ?? ''} g",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Carb',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "${_model.dailyCarb ?? ''} g",
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
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
      ),
    );
  }
}
