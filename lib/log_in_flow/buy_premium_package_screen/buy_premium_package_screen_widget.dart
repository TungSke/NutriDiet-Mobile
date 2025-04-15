import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_model.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/web_view_page.dart';
import 'package:diet_plan_app/services/package_service.dart';

class BuyPremiumPackageScreenWidget extends StatefulWidget {
  const BuyPremiumPackageScreenWidget({Key? key}) : super(key: key);

  @override
  State<BuyPremiumPackageScreenWidget> createState() =>
      _BuyPremiumPackageScreenWidgetState();
}

class _BuyPremiumPackageScreenWidgetState
    extends State<BuyPremiumPackageScreenWidget>
    with SingleTickerProviderStateMixin {
  late BuyPremiumPackageScreenModel _model;

  late AnimationController _animationController;
  late Animation<Offset> _textOffsetAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _rotatingImageAnimation;

  @override
  void initState() {
    super.initState();
    _model = BuyPremiumPackageScreenModel();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _rotatingImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    try {
      final response = await PackageService().fetchPackagePayment(
        packageId: "1",
        cancelUrl: "https://yourapp.com/checkoutFailScreen",
        returnUrl: "https://yourapp.com/checkoutSuccessScreen",
      );
      if (response != null && response["data"] != null) {
        final String paymentUrl = response["data"];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: paymentUrl),
          ),
        );
      } else {
        Navigator.pushNamed(context, '/checkoutFailScreen');
      }
    } catch (e) {
      print("❌ Lỗi khi thanh toán: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bạn đã là thành viên trả phí!"),
          backgroundColor: Colors.amber,
        ),
      );
      Navigator.pushNamed(context, '/checkoutFailScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDFFFD7),
                  Color(0xFFA0F0B1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 2. Rotating header image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: AnimatedBuilder(
              animation: _rotatingImageAnimation,
              builder: (context, child) => Transform.rotate(
                angle: _rotatingImageAnimation.value * 0.2,
                child: child,
              ),
              child: Image.asset(
                "assets/images/package.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 3. Main scrollable content
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    constraints: BoxConstraints(minHeight: size.height),
                    color: Colors.white.withOpacity(0.85),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with fade-in
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.9),
                            ),
                            child: Image.asset(
                              'assets/images/app_launcher_icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Slide-in text
                        SlideTransition(
                          position: _textOffsetAnimation,
                          child: Column(
                            children: [
                              Text(
                                "Chương trình đã sẵn sàng!",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Đạt ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "mục tiêu cân nặng",
                                      style: GoogleFonts.roboto(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF388E3C),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " nhanh hơn",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "với một kế hoạch cá nhân bằng",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " AI",
                                      style: GoogleFonts.roboto(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Pay button with fade-in
                        FadeTransition(
                          opacity: _buttonOpacityAnimation,
                          child: FFButtonWidget(
                            onPressed: _handlePayment,
                            text: 'Thanh toán',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 60,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Terms & Privacy
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: mở Điều khoản sử dụng
                              },
                              child: Text(
                                "Điều khoản sử dụng",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WebViewPage(
                                      url: 'https://yourapp.com/privacy-policy',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Chính sách bảo mật",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // 4. Close button on top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.8),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
