// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'splace_scren_model.dart';

export 'splace_scren_model.dart';

class SplaceScrenWidget extends StatefulWidget {
  const SplaceScrenWidget({super.key});

  @override
  State<SplaceScrenWidget> createState() => _SplaceScrenWidgetState();
}

class _SplaceScrenWidgetState extends State<SplaceScrenWidget>
    with TickerProviderStateMixin {
  late SplaceScrenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplaceScrenModel());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _handleSplashNavigation();
    });

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.ms,
            duration: 2000.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.ms,
            duration: 2000.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'subtitleOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.ms,
            duration: 2000.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  Future<void> _handleSplashNavigation() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'accessToken');

    final bool isLoggedIn = FFAppState().isLogin;

    print('🔐 isLogin: $isLoggedIn');
    print('🔑 accessToken: $token');

    if (isLoggedIn && token != null && token.isNotEmpty) {
      context.goNamed('bottom_navbar_screen');
    } else {
      context.goNamed('login_intro_screen');
    }
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
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: Image.asset(
                      'assets/images/splace_.png',
                      width: 116.0,
                      height: 116.0,
                      fit: BoxFit.contain,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation']!),
                ),
                Text(
                  'NutriDiet',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'figtree',
                    fontSize: 28.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: false,
                  ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
                const SizedBox(height: 8.0),
                Text(
                  'Hệ thống đề xuất chế độ ăn uống lành mạnh',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'figtree',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                    useGoogleFonts: false,
                  ),
                ).animateOnPageLoad(
                    animationsMap['subtitleOnPageLoadAnimation']!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
