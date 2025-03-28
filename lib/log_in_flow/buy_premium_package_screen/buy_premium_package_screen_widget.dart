import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_model.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import các thư viện, service liên quan
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:diet_plan_app/services/package_service.dart';

class BuyPremiumPackageScreenWidget extends StatefulWidget {
  const BuyPremiumPackageScreenWidget({super.key});

  @override
  State<BuyPremiumPackageScreenWidget> createState() =>
      _BuyPremiumPackageScreenWidgetState();
}

class _BuyPremiumPackageScreenWidgetState
    extends State<BuyPremiumPackageScreenWidget> {
  late BuyPremiumPackageScreenModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BuyPremiumPackageScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Hàm xử lý thanh toán
  Future<void> _handlePayment() async {
    try {
      // Gọi API để lấy link thanh toán với packageId = "1"
      final response =
          await PackageService().fetchPackagePayment(packageId: "1");

      // Kiểm tra xem API có trả về "data" hay không
      if (response != null && response["data"] != null) {
        final String paymentUrl = response["data"];

        // Nếu thành công, chuyển hướng sang WebViewPage với link trả về
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: paymentUrl),
          ),
        );
      } else {
        // Nếu không có link, chuyển hướng sang màn hình thất bại (hoặc tự xử lý)
        Navigator.pushNamed(context, '/checkoutFailScreen');
      }
    } catch (e) {
      print("❌ Lỗi khi thanh toán: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Có lỗi xảy ra trong quá trình thanh toán"),
        ),
      );
      Navigator.pushNamed(context, '/checkoutFailScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình ảnh background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/package.png",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 1000,
                      color: Colors.white.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo hoặc icon app
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
                                width: 200,
                                height: 200,
                              ),
                            ),
                            // Tiêu đề, mô tả
                            Column(
                              children: [
                                const Text(
                                  "Chương trình đã sẵn sàng!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Đạt ",
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "mục tiêu cân nặng",
                                        style: GoogleFonts.roboto(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " nhanh hơn",
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "với một kế hoạch cá nhân bằng",
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " AI",
                                        style: GoogleFonts.roboto(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Nút Thanh toán
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: FFButtonWidget(
                                onPressed: _handlePayment,
                                text: 'Thanh toán',
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
                            ),
                            // Điều khoản, chính sách
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " Điều khoản sử dụng",
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context).grey,
                                  ),
                                ),
                                Text(
                                  " Chính sách bảo mật",
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context).grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Nút đóng (x)
          Positioned(
            top: 40,
            right: 20,
            child: ClipOval(
              child: FloatingActionButton(
                onPressed: () {
                  context.pop(context);
                },
                backgroundColor: Colors.white.withOpacity(0.7),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
