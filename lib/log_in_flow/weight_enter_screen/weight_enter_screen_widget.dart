import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
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
              const AppbarWidget(title: 'Nhập cân nặng'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _model.formKey, // Thêm formKey
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: _model.kgTextController,
                          focusNode: _model.kgFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.kgTextController',
                            const Duration(milliseconds: 2000),
                            () async {
                              FFAppState().kgvalue =
                                  _model.kgTextController.text;
                              FFAppState().update(() {});
                            },
                          ),
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Nhập cân nặng (kg)',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          keyboardType: TextInputType.number,
                          cursorColor: FlutterFlowTheme.of(context).primary,
                          validator: _model.kgTextControllerValidator
                              ?.asValidator(context),
                        ),
                        const SizedBox(height: 20.0),
                        FFButtonWidget(
                          onPressed: () async {
                            if (_model.formKey.currentState?.validate() ??
                                false) {
                              await _model.updateWeight(context);
                              // context.pushNamed('Whats_your_goal');
                              context.pushNamed('frequency_exercise_screen');
                            }
                          },
                          text: 'Tiếp tục',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 54.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'figtree',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  useGoogleFonts: false,
                                  fontWeight: FontWeight.bold,
                                ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ],
                    ),
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
