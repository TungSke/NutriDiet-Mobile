import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../components/appbar_widget.dart';
import '../../services/models/personal_goal_provider.dart';
import '../../services/user_service.dart'; // ✅ Import API service

class DecreaseWeightChangeRateScreenWidget extends StatefulWidget {
  const DecreaseWeightChangeRateScreenWidget({super.key});

  @override
  State<DecreaseWeightChangeRateScreenWidget> createState() =>
      _DecreaseWeightChangeRateScreenWidgetState();
}

class _DecreaseWeightChangeRateScreenWidgetState
    extends State<DecreaseWeightChangeRateScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double selectedKgPerWeek = 0.25;
  final List<double> kgPerWeekOptions = [0.25, 0.5, 0.75, 1.0];

  // ✅ Hàm ánh xạ giá trị kg/tuần sang API
  String getWeightChangeRateValue(double kgPerWeek) {
    switch (kgPerWeek) {
      case 0.25:
        return "Lose025KgPerWeek";
      case 0.5:
        return "Lose05KgPerWeek";
      case 0.75:
        return "Lose075KgPerWeek";
      case 1.0:
        return "Lose1KgPerWeek";
      default:
        return "Lose025KgPerWeek";
    }
  }

  Future<void> submitGoal(BuildContext context) async {
    final personalGoalProvider = context.read<PersonalGoalProvider>();

    // ✅ Lưu weightChangeRate vào Provider
    String weightChangeRate = getWeightChangeRateValue(selectedKgPerWeek);
    personalGoalProvider.setWeightChangeRate(weightChangeRate);

    print("🔹 Đang gửi dữ liệu lên API:");
    print("   - GoalType: ${personalGoalProvider.goalType}");
    print("   - TargetWeight: ${personalGoalProvider.targetWeight}");
    print("   - WeightChangeRate: ${personalGoalProvider.weightChangeRate}");
    print("   - GoalDescription: ${personalGoalProvider.goalDescription}");
    print("   - Notes: ${personalGoalProvider.notes}");

    try {
      final response = await UserService().createPersonalGoal(
          goalType: personalGoalProvider.goalType!,
          targetWeight: personalGoalProvider.targetWeight!,
          weightChangeRate: personalGoalProvider.weightChangeRate!,
          goalDescription:
              personalGoalProvider.goalDescription ?? "Mục tiêu mặc định",
          notes: personalGoalProvider.notes ?? "Không có ghi chú",
          context: context);

      print("🔹 API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnackbar(context, "🎉 Gửi mục tiêu thành công!");
        context.pushNamed('health_indicator_screen');
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['Message'] ?? 'Cập nhật thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red, // Nền đỏ
          ),
        );
      }
    } catch (e) {
      print("❌ Lỗi khi gửi API: $e");
      showSnackbar(context, "⚠️ Lỗi khi gửi mục tiêu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalGoalProvider = context.watch<PersonalGoalProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const AppbarWidget(title: 'Mục tiêu của bạn'),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn muốn giảm bao nhiêu kg mỗi tuần?',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: CupertinoPicker(
                        itemExtent: 40,
                        magnification: 1.2,
                        squeeze: 1.2,
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedKgPerWeek = kgPerWeekOptions[index];
                          });
                        },
                        children: kgPerWeekOptions.map((kg) {
                          return Center(
                            child: Text(
                              '$kg kg',
                              style: FlutterFlowTheme.of(context).bodyLarge,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FFButtonWidget(
                        onPressed: () {
                          // ✅ Gọi API ngay sau khi chọn tốc độ giảm cân
                          submitGoal(context);
                        },
                        text: 'Xác nhận',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 54.0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
