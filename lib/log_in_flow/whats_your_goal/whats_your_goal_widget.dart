import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/appbar_widget.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../services/models/personal_goal_provider.dart';
import '../../services/user_service.dart';

class WhatsYourGoalWidget extends StatefulWidget {
  const WhatsYourGoalWidget({super.key});

  @override
  State<WhatsYourGoalWidget> createState() => _WhatsYourGoalWidgetState();
}

final List<Map<String, String>> goalLevels = [
  {
    'title': 'Giữ cân',
    'description': 'Duy trì cân nặng hiện tại của bạn.',
    'value': 'Maintain',
    'image': 'assets/images/whta,s-2.png',
  },
  {
    'title': 'Giảm cân',
    'description': 'Giảm mỡ trong khi vẫn duy trì khối lượng cơ.',
    'value': 'LoseWeight',
    'image': 'assets/images/what,s_-1.png',
  },
  {
    'title': 'Tăng cân',
    'description': 'Tăng cơ, tăng mỡ và trở nên khỏe mạnh hơn.',
    'value': 'GainWeight',
    'image': 'assets/images/whats,s-3.png',
  },
];

class _WhatsYourGoalWidgetState extends State<WhatsYourGoalWidget> {
  int? selectedGoalIndex;

  Future<void> handleMaintainWeight(BuildContext context) async {
    final personalGoalProvider = context.read<PersonalGoalProvider>();

    try {
      final response = await UserService().getHealthProfile();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> healthData =
            responseData['data']; // ✅ Đúng cấu trúc JSON

        // ✅ Lấy cân nặng hiện tại từ API
        double currentWeight =
            double.tryParse(healthData['weight'].toString()) ?? 0.0;

        if (currentWeight == 0.0) {
          showSnackbar(context, "⚠️ Không thể lấy cân nặng hiện tại.");
          return;
        }

        // ✅ Lưu vào Provider
        personalGoalProvider.setGoalType("Maintain");
        personalGoalProvider.setTargetWeight(currentWeight);
        personalGoalProvider.setWeightChangeRate("MaintainWeight");

        print("🔹 Đã lưu mục tiêu 'Giữ cân':");
        print("   - GoalType: ${personalGoalProvider.goalType}");
        print("   - TargetWeight: ${personalGoalProvider.targetWeight}");
        print(
            "   - WeightChangeRate: ${personalGoalProvider.weightChangeRate}");

        // ✅ Gửi API khi bấm "Tiếp tục"
        final updateResponse = await UserService().updatePersonalGoal(
          goalType: personalGoalProvider.goalType!,
          targetWeight: personalGoalProvider.targetWeight!,
          weightChangeRate: personalGoalProvider.weightChangeRate!,
          goalDescription: "Duy trì cân nặng hiện tại",
          notes: "Không có ghi chú",
        );

        if (updateResponse.statusCode == 200 ||
            updateResponse.statusCode == 204) {
          showSnackbar(context, "🎉 Gửi mục tiêu thành công!");
          context.pushNamed('health_indicator_screen');
        } else {
          showSnackbar(context, "⚠️ Gửi thất bại: ${updateResponse.body}");
        }
      } else {
        throw Exception("Không thể lấy dữ liệu cân nặng.");
      }
    } catch (e) {
      print("❌ Lỗi khi gửi mục tiêu 'Giữ cân': $e");
      showSnackbar(context, "⚠️ Lỗi khi gửi mục tiêu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalGoalProvider = context.watch<PersonalGoalProvider>();

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            const AppbarWidget(title: 'Mục tiêu của bạn là gì?'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  itemCount: goalLevels.length,
                  itemBuilder: (context, index) {
                    final level = goalLevels[index];
                    final isSelected = selectedGoalIndex == index;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedGoalIndex = index;
                          personalGoalProvider.setGoalType(level['value']!);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                          border: isSelected
                              ? Border.all(
                                  color: FlutterFlowTheme.of(context).primary)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: const EdgeInsets.all(13.0),
                                child: Image.asset(
                                  level['image']!,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 18.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      level['title']!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      level['description']!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            fontSize: 16.0,
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
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
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: FFButtonWidget(
                onPressed: () async {
                  final personalGoalProvider =
                      context.read<PersonalGoalProvider>();

                  if (personalGoalProvider.goalType == null) {
                    showSnackbar(context, 'Vui lòng chọn một mục tiêu.');
                    return;
                  }

                  // ✅ Nếu chọn "Giữ cân", gọi API khi bấm "Tiếp tục"
                  if (personalGoalProvider.goalType == "Maintain") {
                    await handleMaintainWeight(context);
                  } else {
                    // ✅ Nếu chọn "Tăng cân" hoặc "Giảm cân", chuyển màn hình tiếp theo
                    context.pushNamed('target_weight_screen');
                  }
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
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
