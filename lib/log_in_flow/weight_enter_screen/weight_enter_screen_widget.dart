import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'weight_enter_screen_model.dart';

export 'weight_enter_screen_model.dart';

class WeightEnterScreenWidget extends StatefulWidget {
  const WeightEnterScreenWidget({super.key});

  @override
  State<WeightEnterScreenWidget> createState() =>
      _WeightEnterScreenWidgetState();
}

class _WeightEnterScreenWidgetState extends State<WeightEnterScreenWidget> {
  late WeightEnterScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeightEnterScreenModel());

    _model.lbTextController ??= TextEditingController(text: FFAppState().lb);
    _model.lbFocusNode ??= FocusNode();

    _model.kgTextController ??=
        TextEditingController(text: FFAppState().kgvalue);
    _model.kgFocusNode ??= FocusNode();
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
              wrapWithModel(
                model: _model.appbarModel,
                updateCallback: () => safeSetState(() {}),
                child: const AppbarWidget(
                  title: 'Enter weight',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  if (FFAppState().selected == 0) {
                                    return TextFormField(
                                      controller: _model.lbTextController,
                                      focusNode: _model.lbFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.lbTextController',
                                        const Duration(milliseconds: 2000),
                                        () async {
                                          FFAppState().lb =
                                              _model.lbTextController.text;
                                          safeSetState(() {});
                                          FFAppState().kgvalue =
                                              functions.lbtokg(
                                                  _model.lbTextController.text);
                                          safeSetState(() {});

                                          FFAppState().update(() {});
                                        },
                                      ),
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grey,
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                        hintText: 'Enter Lb',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grey,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .borderColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                      keyboardType: TextInputType.number,
                                      cursorColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      validator: _model
                                          .lbTextControllerValidator
                                          .asValidator(context),
                                    );
                                  } else {
                                    return TextFormField(
                                      controller: _model.kgTextController,
                                      focusNode: _model.kgFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.kgTextController',
                                        const Duration(milliseconds: 2000),
                                        () async {
                                          FFAppState().kgvalue =
                                              _model.kgTextController.text;
                                          safeSetState(() {});
                                          FFAppState().lb = functions.kgtolb(
                                              _model.kgTextController.text);
                                          FFAppState().update(() {});

                                          FFAppState().update(() {});
                                        },
                                      ),
                                      autofocus: false,
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                        hintText: 'Enter kg',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grey,
                                              fontSize: 17.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                        errorStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'figtree',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                              lineHeight: 1.2,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                16.0, 13.0, 16.0, 13.0),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 17.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                      keyboardType: TextInputType.number,
                                      cursorColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      validator: _model
                                          .kgTextControllerValidator
                                          .asValidator(context),
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 68.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondary,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  FFAppState().selected == 0 ? 'Lb' : 'Kg',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 17.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(width: 16.0)),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(1.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (FFAppState().selected == 0) {
                                FFAppState().selected = 1;
                                FFAppState().update(() {});
                                safeSetState(() {
                                  _model.kgTextController?.text =
                                      FFAppState().kgvalue;
                                  _model.kgTextController?.selection =
                                      TextSelection.collapsed(
                                          offset: _model
                                              .kgTextController!.text.length);
                                });
                                safeSetState(() {
                                  _model.lbTextController?.text =
                                      FFAppState().lb;
                                });
                              } else {
                                FFAppState().selected = 0;
                                FFAppState().update(() {});
                                safeSetState(() {
                                  _model.kgTextController?.text =
                                      FFAppState().lb;
                                  _model.kgTextController?.selection =
                                      TextSelection.collapsed(
                                          offset: _model
                                              .kgTextController!.text.length);
                                });
                                safeSetState(() {
                                  _model.kgTextController?.text =
                                      FFAppState().kgvalue;
                                });
                              }

                              FFAppState().update(() {});
                            },
                            child: Container(
                              width: 68.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).lightGrey,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  FFAppState().selected == 0 ? 'Kg' : 'Lb',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 17.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                        lineHeight: 1.5,
                                      ),
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
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('Whats_your_goal');
                  },
                  text: 'Next',
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
