import 'dart:async';
import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reset_password_screen_model.dart';
export 'reset_password_screen_model.dart';

class ResetPasswordScreenWidget extends StatefulWidget {
  const ResetPasswordScreenWidget({super.key});

  @override
  State<ResetPasswordScreenWidget> createState() => _ResetPasswordScreenWidgetState();
}

class _ResetPasswordScreenWidgetState extends State<ResetPasswordScreenWidget> {
  late ResetPasswordScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResetPasswordScreenModel());
    debugPrint("Email from FFAppState: ${FFAppState().email}");
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: GestureDetector(
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
                    title: 'Đặt lại mật khẩu',
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                        scrollDirection: Axis.vertical,
                        children: [
                          Text(
                            'Nhập mã OTP và mật khẩu mới để đặt lại mật khẩu',
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                              lineHeight: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.otpController,
                              focusNode: _model.otpFocusNode,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Mã OTP',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                hintText: 'Nhập mã OTP (6 chữ số)',
                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).borderColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primaryText,
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
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'figtree',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                              cursorColor: FlutterFlowTheme.of(context).primaryText,
                              keyboardType: TextInputType.number,
                              validator: _model.otpValidator.asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.passwordController,
                              focusNode: _model.passwordFocusNode,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              obscureText: !_model.passwordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu mới',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                hintText: 'Nhập mật khẩu mới',
                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).borderColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primaryText,
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
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                        () => _model.passwordVisibility = !_model.passwordVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'figtree',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                              cursorColor: FlutterFlowTheme.of(context).primaryText,
                              validator: _model.passwordValidator.asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.confirmPasswordController,
                              focusNode: _model.confirmPasswordFocusNode,
                              autofocus: false,
                              textInputAction: TextInputAction.done,
                              obscureText: !_model.confirmPasswordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Xác nhận mật khẩu',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                hintText: 'Nhập lại mật khẩu',
                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'figtree',
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).borderColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primaryText,
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
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                        () => _model.confirmPasswordVisibility = !_model.confirmPasswordVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.confirmPasswordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'figtree',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                              cursorColor: FlutterFlowTheme.of(context).primaryText,
                              validator: _model.confirmPasswordValidator.asValidator(context),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                              child: Consumer<ResetPasswordScreenModel>(
                                builder: (context, model, child) => GestureDetector(
                                  onTap: model.countdown == 0
                                      ? () {
                                    model.resendOtp(context);
                                  }
                                      : null,
                                  child: RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Không nhận được mã?',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'figtree',
                                            color: FlutterFlowTheme.of(context).grey,
                                            fontSize: 17.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                            lineHeight: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: model.countdown > 0
                                              ? '  Gửi lại sau ${model.countdown} giây'
                                              : '  Gửi lại mã',
                                          style: TextStyle(
                                            color: model.countdown > 0
                                                ? Colors.grey
                                                : FlutterFlowTheme.of(context).primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: Consumer<ResetPasswordScreenModel>(
                              builder: (context, model, child) => FFButtonWidget(
                                onPressed: model.isLoading
                                    ? null
                                    : () async {
                                  final success = await model.resetPassword(context);
                                  if (success) {
                                    context.pushNamed('login_screen');
                                  }
                                },
                                text: model.isLoading ? 'Đang xử lý...' : 'Đặt lại mật khẩu',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 54.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
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
      ),
    );
  }
}