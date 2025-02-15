import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'about_us_screen_model.dart';
export 'about_us_screen_model.dart';

class AboutUsScreenWidget extends StatefulWidget {
  const AboutUsScreenWidget({super.key});

  @override
  State<AboutUsScreenWidget> createState() => _AboutUsScreenWidgetState();
}

class _AboutUsScreenWidgetState extends State<AboutUsScreenWidget>
    with TickerProviderStateMixin {
  late AboutUsScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutUsScreenModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 800.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
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
                  title: 'About us',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      0,
                      16.0,
                      0,
                      16.0,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/about_us.png',
                          width: double.infinity,
                          height: 168.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'What do you mean by diet?',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
                            ),
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                      ),
                      Text(
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                      ),
                      Text(
                        'In a laoreet purus. Integer turpis quam, laoreet id orci nec, ultrices lacinia nunc. Aliquam erat volutpat. Curabitur fringilla in purus eget egestas. Etiam quis.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                      ),
                      Text(
                        'IVorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                            ),
                      ),
                      Text(
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                      ),
                    ].divide(const SizedBox(height: 16.0)),
                  ).animateOnPageLoad(
                      animationsMap['listViewOnPageLoadAnimation']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
