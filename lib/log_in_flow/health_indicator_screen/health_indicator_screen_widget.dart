import 'dart:convert';

import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../services/user_service.dart';

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
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final healthResponse = await UserService().getHealthProfile();
      final goalResponse = await UserService().getPersonalGoal();

      setState(() {
        healthData = json.decode(healthResponse.body)['data'];
        personalGoal = json.decode(goalResponse.body)['data'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
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

  Widget buildContent() {
    if (healthData == null || healthData!['healthcareIndicators'] == null) {
      return const Center(child: Text("Không có dữ liệu."));
    }

    String bmi = "N/A";
    String tdee = "N/A";

    for (var indicator in healthData!['healthcareIndicators']) {
      if (indicator['code'] == 'BMI') {
        bmi = double.parse(indicator['currentValue']).toStringAsFixed(1);
      } else if (indicator['code'] == 'TDEE') {
        tdee = indicator['currentValue'].toString();
      }
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
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildIndicator("BMI", bmi, "Chỉ số BMI của bạn"),
            _buildIndicator("TDEE", tdee, "Tổng năng lượng tiêu hao mỗi ngày"),
            const SizedBox(height: 20.0),
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
              onPressed: () => context.pushNamed('bottom_navbar_screen'),
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
