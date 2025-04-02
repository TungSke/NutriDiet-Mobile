import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'appbar_model.dart';

export 'appbar_model.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({
    super.key,
    required this.title,
  });

  final String? title;

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  late AppbarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 79.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 21.0, 16.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).lightGrey,
                      shape: BoxShape.circle,
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: SvgPicture.asset(
                          'assets/images/appbar-arrow-back.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.contain,
                          alignment: const Alignment(0.0, 0.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Text(
                        valueOrDefault<String>(
                          widget.title,
                          '0',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.roboto(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
