import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'select_date_of_birth_model.dart';

export 'select_date_of_birth_model.dart';

class SelectDateOfBirthWidget extends StatefulWidget {
  const SelectDateOfBirthWidget({super.key});

  @override
  State<SelectDateOfBirthWidget> createState() =>
      _SelectDateOfBirthWidgetState();
}

class _SelectDateOfBirthWidgetState extends State<SelectDateOfBirthWidget> {
  late SelectDateOfBirthModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectDateOfBirthModel());
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
                  title: 'Chọn ngày sinh của bạn',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Text(
                          'Chọn ngày sinh của bạn',
                          maxLines: 1,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'figtree',
                                    color: FlutterFlowTheme.of(context).grey,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: FlutterFlowCalendar(
                          color: FlutterFlowTheme.of(context).primary,
                          iconColor: FlutterFlowTheme.of(context).secondaryText,
                          weekFormat: false,
                          weekStartsMonday: false,
                          rowHeight: 64.0,
                          onChange: (DateTimeRange? newSelectedDate) {
                            safeSetState(() =>
                                _model.calendarSelectedDay = newSelectedDate);
                          },
                          titleStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'figtree',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                                lineHeight: 1.0,
                              ),
                          dayOfWeekStyle:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'figtree',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                    lineHeight: 1.0,
                                  ),
                          dateStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'figtree',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                          selectedDateStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'figtree',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                          inactiveDateStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'figtree',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('hight_Enter_screen');
                  },
                  text: 'Tiếp tục',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
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
      ),
    );
  }
}
