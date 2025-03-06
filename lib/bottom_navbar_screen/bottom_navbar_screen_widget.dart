import 'package:diet_plan_app/components/my_mealplan_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/components/home_componet_widget.dart';
import '/components/profile_componet_widget.dart';
import '/components/recipe_compnoet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../components/food_screen_widget.dart';
import 'bottom_navbar_screen_model.dart';

export 'bottom_navbar_screen_model.dart';

class BottomNavbarScreenWidget extends StatefulWidget {
  const BottomNavbarScreenWidget({super.key});

  @override
  State<BottomNavbarScreenWidget> createState() =>
      _BottomNavbarScreenWidgetState();
}

class _BottomNavbarScreenWidgetState extends State<BottomNavbarScreenWidget> {
  late BottomNavbarScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  void changePage(int index) {
    setState(() {
      _model.bottomadd = index;
      _model.pageViewController?.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomNavbarScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _model.pageViewController ??=
                    PageController(initialPage: 0),
                onPageChanged: (_) => safeSetState(() {}),
                scrollDirection: Axis.horizontal,
                children: [
                  wrapWithModel(
                    model: _model.homeComponetModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const HomeComponetWidget(),
                  ),
                  wrapWithModel(
                    model: _model.foodScreenModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const FoodScreenWidget(),
                  ),
                  wrapWithModel(
                    model: _model.recipeCompnoetModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const RecipeCompnoetWidget(),
                  ),
                  wrapWithModel(
                    model: _model
                        .mymealplanComponentModel, // <-- Thêm model mới ở đây
                    updateCallback: () => safeSetState(() {}),
                    child:
                        const MyMealPlanScreenWidget(), // <-- Thêm widget mới ở đây
                  ),
                  wrapWithModel(
                    model: _model.profileComponetModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const ProfileComponetWidget(),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.bottomadd = 0;
                          safeSetState(() {});
                          await _model.pageViewController?.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                if (_model.bottomadd == 0) {
                                  return Container(
                                    width: 59.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/BLACK-HOME-FILL.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: SvgPicture.asset(
                                      'assets/images/GREY-BOTTOM-HOME.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'Trang chủ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.bottomadd == 0
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ].divide(SizedBox(
                              height: _model.bottomadd == 0 ? 4.0 : 8.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.bottomadd = 1;
                          safeSetState(() {});
                          await _model.pageViewController?.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                if (_model.bottomadd == 1) {
                                  return Container(
                                    width: 59.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/BLACK-BOTTOM-SERCH-FILL.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: SvgPicture.asset(
                                      'assets/images/SERCH-GREY-BOTTOM.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'Tìm kiếm',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.bottomadd == 1
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ].divide(SizedBox(
                              height: _model.bottomadd == 1 ? 4.0 : 8.0)),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: InkWell(
                    //     splashColor: Colors.transparent,
                    //     focusColor: Colors.transparent,
                    //     hoverColor: Colors.transparent,
                    //     highlightColor: Colors.transparent,
                    //     onTap: () async {
                    //       _model.bottomadd = 2;
                    //       safeSetState(() {});
                    //       await _model.pageViewController?.animateToPage(
                    //         2,
                    //         duration: const Duration(milliseconds: 500),
                    //         curve: Curves.ease,
                    //       );
                    //     },
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.max,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Builder(
                    //           builder: (context) {
                    //             if (_model.bottomadd == 2) {
                    //               return Container(
                    //                 width: 59.0,
                    //                 height: 32.0,
                    //                 decoration: BoxDecoration(
                    //                   color:
                    //                       FlutterFlowTheme.of(context).bottom,
                    //                   borderRadius: BorderRadius.circular(30.0),
                    //                 ),
                    //                 alignment:
                    //                     const AlignmentDirectional(0.0, 0.0),
                    //                 child: ClipRRect(
                    //                   borderRadius: BorderRadius.circular(0.0),
                    //                   child: SvgPicture.asset(
                    //                     'assets/images/BALCK-FILL-RECIPE-BOTTOM.svg',
                    //                     width: 24.0,
                    //                     height: 24.0,
                    //                     fit: BoxFit.contain,
                    //                   ),
                    //                 ),
                    //               );
                    //             } else {
                    //               return ClipRRect(
                    //                 borderRadius: BorderRadius.circular(0.0),
                    //                 child: SvgPicture.asset(
                    //                   'assets/images/GREY-RECPIT-BOTTOM.svg',
                    //                   width: 24.0,
                    //                   height: 24.0,
                    //                   fit: BoxFit.contain,
                    //                 ),
                    //               );
                    //             }
                    //           },
                    //         ),
                    //         Text(
                    //           'Công thức',
                    //           style: FlutterFlowTheme.of(context)
                    //               .bodyMedium
                    //               .override(
                    //                 fontFamily: 'figtree',
                    //                 color: _model.bottomadd == 2
                    //                     ? FlutterFlowTheme.of(context)
                    //                         .primaryText
                    //                     : FlutterFlowTheme.of(context).grey,
                    //                 fontSize: 13.0,
                    //                 letterSpacing: 0.0,
                    //                 useGoogleFonts: false,
                    //                 lineHeight: 1.5,
                    //               ),
                    //         ),
                    //       ].divide(SizedBox(
                    //           height: _model.bottomadd == 2 ? 4.0 : 8.0)),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.bottomadd = 3; // Cập nhật vị trí index
                          safeSetState(() {});
                          await _model.pageViewController?.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                if (_model.bottomadd == 3) {
                                  return Container(
                                    width: 59.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).bottom,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/BLACK-FILL-MEALPLAN-BOTTOM.svg', // Icon Meal Plan
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: SvgPicture.asset(
                                      'assets/images/GREY-MEALPLAN-BOTTOM.svg', // Icon khi không chọn
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'Thực đơn',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.bottomadd == 3
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ].divide(SizedBox(
                              height: _model.bottomadd == 3 ? 4.0 : 8.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.bottomadd = 4;
                          safeSetState(() {});
                          await _model.pageViewController?.animateToPage(
                            4,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                if (_model.bottomadd == 4) {
                                  return Container(
                                    width: 59.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).bottom,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/BALCK-FILL-BOTTOM-PERSON.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: SvgPicture.asset(
                                      'assets/images/PROFILE-GRY-BOTTOM.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'Hồ sơ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.bottomadd == 4
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ].divide(SizedBox(
                              height: _model.bottomadd == 3 ? 4.0 : 8.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
