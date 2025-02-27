import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'hight_enter_screen_model.dart';

export 'hight_enter_screen_model.dart';

class HightEnterScreenWidget extends StatefulWidget {
  const HightEnterScreenWidget({super.key});

  @override
  State<HightEnterScreenWidget> createState() => _HightEnterScreenWidgetState();
}

class _HightEnterScreenWidgetState extends State<HightEnterScreenWidget> {
  late HightEnterScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HightEnterScreenModel());
    _model.cmTextController ??=
        TextEditingController(text: FFAppState().cmvalue);
    _model.cmFocusNode ??= FocusNode();
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
              const AppbarWidget(title: 'Nhập chiều cao'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        controller: _model.cmTextController,
                        focusNode: _model.cmFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.cmTextController',
                          const Duration(milliseconds: 2000),
                          () async {
                            FFAppState().cmvalue = _model.cmTextController.text;
                            FFAppState().update(() {});
                          },
                        ),
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Nhập chiều cao (cm)',
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
                        validator: _model.cmTextControllerValidator
                            .asValidator(context),
                      ),
                      const SizedBox(height: 20.0),
                      FFButtonWidget(
                        onPressed: () async {
                          if (_model.formKey.currentState != null) {
                            _model.formKey.currentState!.validate();
                          }
                          context.pushNamed('weight_Enter_screen');
                        },
                        text: 'Tiếp tục',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 54.0,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
            ],
          ),
        ),
      ),
    );
  }
}
