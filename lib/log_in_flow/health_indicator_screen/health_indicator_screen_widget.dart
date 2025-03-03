import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class HealthIndicatorScreenWidget extends StatelessWidget {
  const HealthIndicatorScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Màu nền xám nhạt
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Thêm cuộn khi nội dung quá dài
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo và hình ảnh
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Logo NutriDiet (chiếm 1 phần)
                          Expanded(
                            flex: 1, // Chia theo tỷ lệ 1
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/app_launcher_icon.png', // Thay bằng logo
                                    height: 40,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "NutriDiet",
                                    style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black, // Màu trắng theo thiết kế
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Hình ảnh món ăn (chiếm 1 phần)
                          Expanded(
                            flex: 2, // Chia theo tỷ lệ 1
                            child: ClipOval(
                              child: Image.asset(
                                'images/healthIndicator.png', // Hình ảnh món ăn
                                height: 100, // Giữ tỉ lệ ảnh tròn đẹp
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Chỉ số của bạn:",
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Hiển thị chỉ số BMI, BMR, TDEE
                _buildIndicator(
                    "BMI", "30.4", "Chỉ số BMI cho thấy bạn bị béo phì độ I"),
                _buildIndicator("BMR", "564", "Calo cần nạp mỗi ngày"),
                _buildIndicator("TDEE", "1072", "Calo một ngày"),

                const SizedBox(height: 20),
                Text(
                  "Lượng calo cần thiết để tăng cân:",
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),

                // Ô hiển thị calo cần thiết để tăng cân
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "1286\ncalo một ngày",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),

                const SizedBox(height: 20.0),
                FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('bottom_navbar_screen');
                  },
                  text: 'Tiếp tục',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'figtree',
                          color: Colors.white,
                          fontSize: 18.0,
                          useGoogleFonts: false,
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
    );
  }

  // Widget tạo từng chỉ số BMI, BMR, TDEE
  Widget _buildIndicator(String title, String value, String description) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Container(
          width: 90,
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Text(
            value,
            style: GoogleFonts.roboto(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(fontSize: 10, color: Colors.black54),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
