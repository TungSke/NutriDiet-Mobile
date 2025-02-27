import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/components/comon_componet_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recipe_compnoet_model.dart';

export 'recipe_compnoet_model.dart';

class RecipeCompnoetWidget extends StatefulWidget {
  const RecipeCompnoetWidget({super.key});

  @override
  State<RecipeCompnoetWidget> createState() => _RecipeCompnoetWidgetState();
}

class _RecipeCompnoetWidgetState extends State<RecipeCompnoetWidget>
    with TickerProviderStateMixin {
  late RecipeCompnoetModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipeCompnoetModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 119.0,
          decoration: const BoxDecoration(),
          child: Align(
            alignment: const AlignmentDirectional(0.0, 1.0),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
              child: Text(
                'Recipe',
                maxLines: 1,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'figtree',
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: false,
                      lineHeight: 1.5,
                    ),
              ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 8.0),
          child: TextFormField(
            controller: _model.textController,
            focusNode: _model.textFieldFocusNode,
            onFieldSubmitted: (_) async {
              context.pushNamed('Search_result_screen');
            },
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'figtree',
                    color: FlutterFlowTheme.of(context).grey,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              hintText: 'Tìm kiếm',
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'figtree',
                    color: FlutterFlowTheme.of(context).grey,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).lightGrey,
              prefixIcon: const Icon(
                Icons.search_sharp,
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'figtree',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
            cursorColor: FlutterFlowTheme.of(context).primaryText,
            validator: _model.textControllerValidator.asValidator(context),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                0,
                8.0,
                0,
                16.0,
              ),
              scrollDirection: Axis.vertical,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('brek_fast_iIngredients');
                  },
                  child: wrapWithModel(
                    model: _model.comonComponetModel1,
                    updateCallback: () => safeSetState(() {}),
                    child: const ComonComponetWidget(),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('brek_fast_iIngredients');
                  },
                  child: wrapWithModel(
                    model: _model.comonComponetModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: const ComonComponetWidget(),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('brek_fast_iIngredients');
                  },
                  child: wrapWithModel(
                    model: _model.comonComponetModel3,
                    updateCallback: () => safeSetState(() {}),
                    child: const ComonComponetWidget(),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('brek_fast_iIngredients');
                  },
                  child: wrapWithModel(
                    model: _model.comonComponetModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: const ComonComponetWidget(),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('brek_fast_iIngredients');
                  },
                  child: wrapWithModel(
                    model: _model.comonComponetModel5,
                    updateCallback: () => safeSetState(() {}),
                    child: const ComonComponetWidget(),
                  ),
                ),
              ].divide(const SizedBox(height: 16.0)),
            ),
          ),
        ),
      ],
    );
  }
}
