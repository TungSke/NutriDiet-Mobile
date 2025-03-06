import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'whats_your_goal_model.dart';

export 'whats_your_goal_model.dart';

class WhatsYourGoalWidget extends StatefulWidget {
  const WhatsYourGoalWidget({super.key});

  @override
  State<WhatsYourGoalWidget> createState() => _WhatsYourGoalWidgetState();
}

final List<Map<String, String>> goalLevels = [
  {
    'title': 'Giữ cân',
    'description': 'Duy trì cân nặng hiện tại của bạn.',
    'image': 'assets/images/whta,s-2.png'
  },
  {
    'title': 'Giảm cân',
    'description': 'Giảm mỡ trong khi vẫn duy trì khối lượng cơ.',
    'image': 'assets/images/what,s_-1.png'
  },
  {
    'title': 'Tăng cân',
    'description': 'Tăng cơ, tăng mỡ và trở nên khỏe mạnh hơn',
    'image': 'assets/images/whats,s-3.png'
  },
];

class _WhatsYourGoalWidgetState extends State<WhatsYourGoalWidget> {
  late WhatsYourGoalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WhatsYourGoalModel());
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.appbarModel,
                updateCallback: () => safeSetState(() {}),
                child: const AppbarWidget(
                  title: 'Mục tiêu của bạn là gì?',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    itemCount: goalLevels.length,
                    itemBuilder: (context, index) {
                      final level = goalLevels[index];
                      final isSelected = _model.select == index;

                      return InkWell(
                        onTap: () {
                          setState(() => _model.select = index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? FlutterFlowTheme.of(context).secondary
                                : FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                            border: isSelected
                                ? Border.all(
                                    color: FlutterFlowTheme.of(context).primary)
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    level['image']!,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 18.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        level['title']!,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .copyWith(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              // useGoogleFonts: false,
                                            ),
                                      ),
                                      Text(
                                        level['description']!,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .copyWith(
                                              fontSize: 16.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grey,
                                              // useGoogleFonts: false,
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
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    await _model.updateGoalLevel(context);
                    if (_model.select == 0) {
                      // Nếu chọn "Fat loss", điều hướng sang DecreaseWeightGoalScreen
                      context.pushNamed('health_indicator_screen');
                    } else if (_model.select == 1) {
                      context.pushNamed('target_weight_screen');
                    } else if (_model.select == 2)
                      context.pushNamed('target_weight_screen');
                  },
                  text: 'Tiếp tục',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'figtree',
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
