import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class CheckoutSuccessScreenWidget extends StatefulWidget {
  const CheckoutSuccessScreenWidget({super.key});

  @override
  State<CheckoutSuccessScreenWidget> createState() =>
      _CheckoutSuccessScreenWidgetState();
}

class _CheckoutSuccessScreenWidgetState
    extends State<CheckoutSuccessScreenWidget> {
  late BuyPremiumPackageScreenModel _model;

  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => BuyPremiumPackageScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Cột chính gồm hình ảnh ở trên và nội dung bên dưới
            Column(
              children: [
                // Hình ảnh package.png ở phần trên
                Image.asset(
                  "assets/images/package.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Phần nội dung bên dưới chiếm phần còn lại của màn hình
                Expanded(
                  child: Container(
                    color: Colors.white, // Màu nền rõ ràng
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo ứng dụng
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/images/app_launcher_icon.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Icon thông báo thanh toán thành công
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 80,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        // Tiêu đề
                        Text(
                          "Cảm ơn đã thanh toán!",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Nội dung mô tả
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Bạn đã thanh toán ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: "thành công ",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Nút "Bắt đầu"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FFButtonWidget(
                            onPressed: () {
                              context.push("/bottomNavbarScreen");
                            },
                            text: 'Bắt đầu ',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 70,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: GoogleFonts.roboto(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 20,
              child: ClipOval(
                child: FloatingActionButton(
                  onPressed: () {
                    context.push("/bottomNavbarScreen");
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
