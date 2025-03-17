import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '/components/foodList_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serch_data_model.dart';

export 'serch_data_model.dart';

class SerchDataWidget extends StatefulWidget {
  const SerchDataWidget({super.key});

  @override
  State<SerchDataWidget> createState() => _SerchDataWidgetState();
}

class _SerchDataWidgetState extends State<SerchDataWidget>
    with TickerProviderStateMixin {
  late SerchDataModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SerchDataModel());

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
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
                  'Tìm kiếm',
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
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 8.0, 10.0, 0.0),
            child: TextFormField(
              controller: _model.textController,
              focusNode: _model.textFieldFocusNode,
              onFieldSubmitted: (_) async {
                if (_model.textController.text.isNotEmpty) {
                  FFAppState().addToSearchList(_model.textController.text);
                }
                _model.reslut = true;
                safeSetState(() {});
              },
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'figtree',
                      color: FlutterFlowTheme.of(context).grey,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                hintText: 'Nhập tên món cần tìm',
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'figtree',
                      color: FlutterFlowTheme.of(context).grey,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).lightGrey,
                prefixIcon: const Icon(
                  Icons.search_sharp,
                ),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'figtree',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              cursorColor: FlutterFlowTheme.of(context).primaryText,
              validator: _model.textControllerValidator.asValidator(context),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                // if ((FFAppState().searchList.isNotEmpty) == true) {
                return Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            if (FFAppState().searchList.isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().searchList.isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 16.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Tìm kiếm',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'figtree',
                                                        fontSize: 22.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        useGoogleFonts: false,
                                                        lineHeight: 1.5,
                                                      ),
                                            ),
                                          ),
                                          Text(
                                            'Clear all',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'figtree',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: false,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Builder(
                                    builder: (context) {
                                      final serchlist =
                                          FFAppState().searchList.toList();

                                      return ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          24.0,
                                          0,
                                          24.0,
                                        ),
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: serchlist.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 24.0),
                                        itemBuilder: (context, serchlistIndex) {
                                          final serchlistItem =
                                              serchlist[serchlistIndex];
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.search_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .grey,
                                                size: 24.0,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      safeSetState(() {
                                                        _model.textController
                                                                ?.text =
                                                            serchlistItem;
                                                        _model.textController
                                                                ?.selection =
                                                            TextSelection.collapsed(
                                                                offset: _model
                                                                    .textController!
                                                                    .text
                                                                    .length);
                                                      });
                                                    },
                                                    child: Text(
                                                      serchlistItem,
                                                      maxLines: 1,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'figtree',
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                false,
                                                            lineHeight: 1.5,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FFAppState()
                                                      .removeFromSearchList(
                                                          serchlistItem);
                                                  safeSetState(() {});
                                                },
                                                child: Icon(
                                                  Icons.close_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .grey,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (_model.reslut == true)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 20.0, 0.0, 0.0),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
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
                                  child: FoodListComponentWidget(
                                    searchQuery: _model.textController!
                                        .text, // Truyền trực tiếp
                                  ),
                                ),
                              ].divide(const SizedBox(height: 20.0)),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
                // } else {
                //   return Align(
                //     alignment: const AlignmentDirectional(0.0, 0.0),
                //     child: Container(
                //       width: 376.0,
                //       height: 200.0,
                //       decoration: BoxDecoration(
                //         color: FlutterFlowTheme.of(context).secondaryBackground,
                //       ),
                //       child: wrapWithModel(
                //         model: _model.searchemptyModel,
                //         updateCallback: () => safeSetState(() {}),
                //         child: const SearchEmptyWidget(),
                //       ),
                //     ),
                //   );
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
