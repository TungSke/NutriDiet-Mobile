import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'frequency_exercise_screen_model.dart';

export 'frequency_exercise_screen_model.dart';

class FrequencyExerciseScreenWidget extends StatefulWidget {
  const FrequencyExerciseScreenWidget({super.key});

  @override
  State<FrequencyExerciseScreenWidget> createState() =>
      _FrequencyExerciseScreenWidgetState();
}

final List<Map<String, String>> exerciseLevels = [
  {
    'title': 'Ít vận động',
    'description': 'Công việc văn phòng, ít tập thể dục.',
    'image': 'assets/images/exercise-2.png'
  },
  {
    'title': 'Vận động nhẹ',
    'description': 'Tập thể dục nhẹ hoặc đi bộ mỗi ngày 30 phút.',
    'image': 'assets/images/exercise-6.png'
  },
  {
    'title': 'Vận động vừa phải',
    'description': 'Tập thể dục 1 giờ (3-5 lần/tuần).',
    'image': 'assets/images/exercise-3.png'
  },
  {
    'title': 'Vận động nhiều',
    'description': 'Tập luyện cường độ cao 5-7 lần/tuần.',
    'image': 'assets/images/exercise-4.png'
  },
  {
    'title': 'Cường độ rất cao',
    'description': 'Thể thao chuyên nghiệp hoặc tập luyện cường độ rất cao.',
    'image': 'assets/images/exercise-5.png'
  }
];

class _FrequencyExerciseScreenWidgetState
    extends State<FrequencyExerciseScreenWidget> {
  late FrequencyExerciseScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FrequencyExerciseScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: 'Tần suất vận động của bạn?',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  itemCount: exerciseLevels.length,
                  itemBuilder: (context, index) {
                    final level = exerciseLevels[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: FlutterFlowTheme.of(context)
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
                  await _model.updateActivityLevel(context);
                  context.pushNamed('Select_allergy_screen');
                },
                text: 'Tiếp tục',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 54.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'figtree',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                  elevation: 0.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
