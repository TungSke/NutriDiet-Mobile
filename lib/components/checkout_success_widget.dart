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
        body: Stack(
      children: [
        // Hình ảnh package.png phóng to khi cuộn (Lớp dưới cùng)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/images/package.png", // Set your image here
            height: 200, // Initial height of the image
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500, // Nội dung dưới hình ảnh
              color: Colors.white.withOpacity(0.3),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Spacer(),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: Image.asset(
                        'assets/images/app_launcher_icon.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 80,
                          color: Colors.green,
                        ),
                        Text("Cảm ơn đã thanh toán!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Bạn đã thanh toán ",
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal)),
                          TextSpan(
                              text: "thành công ",
                              style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ])),
                      ],
                    ),
                    Spacer(),
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
          top: 40, // Đặt ở góc trên bên phải
          right: 20,
          child: ClipOval(
            child: FloatingActionButton(
              onPressed: () {
                context.push("/bottomNavbarScreen");
              },
              backgroundColor: Colors.white.withOpacity(0.7),
              child: Icon(Icons.close, color: Colors.black),
            ),
          ),
        ),
      ],
    ));
  }
}
