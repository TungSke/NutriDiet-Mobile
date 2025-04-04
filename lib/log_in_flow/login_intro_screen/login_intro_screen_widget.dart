import 'dart:ui';

import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../login_screen/login_screen_model.dart';

class LoginIntroScreenWidget extends StatefulWidget {
  const LoginIntroScreenWidget({super.key});

  @override
  State<LoginIntroScreenWidget> createState() => _LoginIntroScreenWidgetState();
}

class _LoginIntroScreenWidgetState extends State<LoginIntroScreenWidget>
    with TickerProviderStateMixin {
  late LoginScreenModel _model;

  @override
  void initState() {
    super.initState();
    _model = LoginScreenModel(); // Khởi tạo model
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Ảnh nền với hiệu ứng mờ
            Positioned.fill(
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Image.asset(
                      'assets/images/bg1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo + Tiêu đề
                  Image.asset(
                    'assets/images/app_launcher_icon.png',
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "NutriDiet",
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your Personal Nutrition",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Nút Đăng nhập
                  SizedBox(
                    width: 260,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed("login_screen");
                      },
                      child: Text(
                        "Đăng nhập",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Dòng "Hoặc tiếp tục với"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white60)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Hoặc tiếp tục với",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white60)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nút đăng nhập Google
                  SizedBox(
                    width: 260,
                    height: 50,
                    child: SignInButton(
                      Buttons.google,
                      onPressed: () async {
                        await _model.loginGoogle(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Nút đăng nhập Facebook
                  SizedBox(
                    width: 260,
                    height: 50,
                    child: SignInButton(
                      Buttons.facebookNew,
                      onPressed: () async {
                        await _model.loginFaceBook(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Dòng "Bạn chưa có tài khoản?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn chưa có tài khoản?",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed("Sign_up_screen");
                        },
                        child: Text(
                          "Đăng ký",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
