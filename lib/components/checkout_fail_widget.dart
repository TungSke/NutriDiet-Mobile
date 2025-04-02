import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class CheckoutFailScreenWidget extends StatefulWidget {
  const CheckoutFailScreenWidget({super.key});

  @override
  State<CheckoutFailScreenWidget> createState() =>
      _CheckoutFailScreenWidgetState();
}

class _CheckoutFailScreenWidgetState extends State<CheckoutFailScreenWidget> {
  // late BuyPremiumPackageScreenModel _model;

  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => BuyPremiumPackageScreenModel());
  }

  @override
  void dispose() {
    // _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea để tránh nội dung đè lên thanh trạng thái
      body: SafeArea(
        child: Stack(
          children: [
            // Cột chính chứa hình ảnh trên và nội dung dưới
            Column(
              children: [
                // Hình ảnh trên cùng
                Image.asset(
                  "assets/images/package.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Phần nội dung bên dưới, chiếm toàn bộ không gian còn lại
                Expanded(
                  child: Container(
                    color: Colors.white, // Không còn mờ
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo app (hoặc icon)
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

                          // Icon thông báo thất bại
                          ClipOval(
                            child: Icon(
                              Icons.close,
                              size: 80,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tiêu đề
                          Text(
                            "Bạn chưa thanh toán!",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Mô tả
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
                                  text: "thất bại ",
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Nút Thử lại
                          FFButtonWidget(
                            onPressed: () {
                              context.push('/buyPremiumPackage');
                            },
                            text: 'Thử lại',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 70,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Nút đóng (X) nổi ở góc trên bên phải
            Positioned(
              top: 10,
              right: 20,
              child: ClipOval(
                child: FloatingActionButton(
                  onPressed: () {
                    context.push("/bottomNavbarScreen");
                  },
                  backgroundColor: Colors.white, // Không còn mờ
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
