import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_model.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

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
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 1000, // Nội dung dưới hình ảnh
                    color: Colors.white.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
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
                          Column(
                            children: [
                              Text("Chương trình đã sẵn sàng!",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "Đạt ",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "mục tiêu cân nặng",
                                    style: GoogleFonts.roboto(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                                TextSpan(
                                    text: " nhanh hơn",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ])),
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "với một kế hoạch cá nhân bằng",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: " AI",
                                    style: GoogleFonts.roboto(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ])),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 36, bottom: 20),
                            child: Column(
                              spacing: 20,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        'assets/images/healsuggestion.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Lời khuyên dinh dưỡng",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Tạo lời khuyên dựa vào bệnh dị ứng để giúp bạn cải thiện bệnh"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        'assets/images/ai.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Thực đơn AI",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Tạo thực đơn nhanh chóng dựa vào mục tiêu cá nhân của bạn"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        'assets/images/recipe.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Công thức nấu ăn AI",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Cung cấp cho bạn vô vàng công thức nấu ăn hấp dẫn vào vùng miền"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        'assets/images/exchange.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Thay đổi linh hoạt",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Thay đổi thực đơn, công thức linh hoạt phù hợp với nhu cầu ăn uống")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text("Miễn phí 3 ngày, sau đó 100.000 đ/ tháng",
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: FFButtonWidget(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewPage()));
                              },
                              // onPressed: () async {
                              //   try {
                              //     // Gọi phương thức BuyPremiumPackage với packageId là "1"
                              //     final response = await PackageService()
                              //         .BuyPremiumPackage(
                              //             packageId: "1", context: context);
                              //
                              //     if (response.statusCode == 200 ||
                              //         response.statusCode == 204) {
                              //       // Nếu thanh toán thành công, chuyển đến màn hình checkout success
                              //       // context.push('/checkoutSuccessScreen');
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   WebViewPage()));
                              //     } else {
                              //       context.push('/checkoutFailScreen');
                              //     }
                              //   } catch (e) {
                              //     print("❌ Lỗi khi thanh toán: $e");
                              //     // Hiển thị thông báo lỗi trong SnackBar
                              //   }
                              // },
                              text: 'Thanh toán',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " Điều khoản sử dung",
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).grey),
                              ),
                              Text(
                                " Chính sách bảo mật",
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).grey),
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
        Positioned(
          top: 40, // Đặt ở góc trên bên phải
          right: 20,
          child: ClipOval(
            child: FloatingActionButton(
              onPressed: () {
                context.pop(context);
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
