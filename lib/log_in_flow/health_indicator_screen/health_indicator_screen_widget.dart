import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../services/health_service.dart';

class HealthIndicatorScreenWidget extends StatefulWidget {
  const HealthIndicatorScreenWidget({super.key});

  @override
  State<HealthIndicatorScreenWidget> createState() =>
      _HealthIndicatorScreenWidgetState();
}

class _HealthIndicatorScreenWidgetState
    extends State<HealthIndicatorScreenWidget> {
  Map<String, dynamic>? healthData;
  Map<String, dynamic>? personalGoal;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await HealthService.fetchHealthData();
    setState(() {
      healthData = result["healthData"];
      personalGoal = result["personalGoal"];
      errorMessage = result["errorMessage"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text("Lỗi: $errorMessage"))
                : buildContent(),
      ),
    );
  }

  // Create a mapping for bmiType to a description

  Widget buildContent() {
    if (healthData == null || healthData!['healthcareIndicators'] == null) {
      return const Center(child: Text("Không có dữ liệu."));
    }

    String bmi = "";
    String tdee = "";
    String bmiType = "";
    String bmiDescription = "";
    Color bmiColor = Colors.black;
    for (var indicator in healthData!['healthcareIndicators']) {
      if (indicator['code'] == 'BMI') {
        bmi = double.parse(indicator['currentValue']).toStringAsFixed(1);
        bmiType = indicator['type'];
      } else if (indicator['code'] == 'TDEE') {
        tdee = double.parse(indicator['currentValue']).toStringAsFixed(1);
      }
    }
    switch (bmiType) {
      case 'Gầy':
        bmiDescription = "BMI của bạn thấp hơn 18.5";
        bmiColor = Colors.blue; // Màu xanh dương cho Gầy
        break;
      case 'Thừa cân':
        bmiDescription = "BMI của bạn trong khoảng từ 25 đến 29.9";
        bmiColor = Colors.orange.shade300; // Màu vàng cho Thừa cân
        break;
      case 'Bình thường':
        bmiDescription = "BMI của bạn trong khoảng từ 18.5 đến 24.9";
        bmiColor = Colors.green; // Màu xanh lá cho Bình thường
        break;
      case 'Béo phì độ 1':
        bmiDescription = "BMI của bạn trong khoảng từ 30 đến 34.9";
        bmiColor = Colors.orange.shade500; // Màu cam nhạt cho Béo phì độ 1
        break;
      case 'Béo phì độ 2':
        bmiDescription = "BMI của bạn trong khoảng từ 35 đến 39.9";
        bmiColor = Colors.orange.shade900; // Màu cam đậm cho Béo phì độ 2
        break;
      case 'Béo phì độ 3':
        bmiDescription = "BMI của bạn lớn hơn 40";
        bmiColor = Colors.red; // Màu đỏ cho Béo phì độ 3
        break;
      default:
        bmiDescription = "Không có thông tin BMI hợp lệ.";
        bmiColor = Colors.black; // Nếu không có loại nào, để màu đen
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Text("Chỉ số của bạn:",
                style: GoogleFonts.roboto(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Tình trạng: ",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(bmiType,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: bmiColor)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              ('($bmiDescription)'), // Hiển thị mô tả về tình trạng BMI
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            Text(
              (healthData?['evaluate'].toString() ?? "N/A"),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 10),
            _buildIndicator("BMI", bmi, "Chỉ số BMI của bạn"),
            _buildIndicator("TDEE", tdee, "Tổng năng lượng tiêu hao mỗi ngày"),

            const SizedBox(height: 20),
            // Text("Mục tiêu: ${personalGoal?['goalType'] ?? "N/A"}",
            //     style: GoogleFonts.roboto(
            //         fontSize: 16, fontWeight: FontWeight.bold)),
            _buildIndicator(
                "Cân nặng mục tiêu",
                personalGoal?['targetWeight'].toString() ?? "N/A",
                "Mục tiêu cân nặng"),

            _buildIndicator(
                "Calo hàng ngày",
                personalGoal?['dailyCalories'].toString() ?? "N/A",
                "Lượng calo cần nạp mỗi ngày"),
            const SizedBox(height: 20.0),
            FFButtonWidget(
              onPressed: () => context.pushNamed('ingredient_avoid_screen'),
              text: 'Tiếp tục',
              options: FFButtonOptions(
                width: double.infinity,
                height: 54.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: GoogleFonts.roboto(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Image.asset('assets/images/app_launcher_icon.png', height: 40),
            const SizedBox(height: 4),
            Text("NutriDiet",
                style: GoogleFonts.roboto(
                    fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        ClipOval(
          child: Image.asset(
            'assets/images/healthIndicator.png',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(String title, String value, String description) {
    return Column(
      children: [
        Text(title,
            style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary)),
        const SizedBox(height: 4),
        Container(
          width: 90,
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: FlutterFlowTheme.of(context).primary, width: 2),
          ),
          child: Text(value,
              style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primary)),
        ),
        const SizedBox(height: 4),
        Text(description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontSize: 10, color: Colors.black54)),
        const SizedBox(height: 10),
      ],
    );
  }
}
