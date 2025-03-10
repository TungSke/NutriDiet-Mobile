import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../components/appbar_widget.dart';
import '../../services/models/personal_goal_provider.dart'; // ✅ Import PersonalGoalProvider
import '../../services/user_service.dart';

class TargetWeightScreenWidget extends StatefulWidget {
  const TargetWeightScreenWidget({super.key});

  @override
  State<TargetWeightScreenWidget> createState() =>
      _TargetWeightScreenWidgetState();
}

class _TargetWeightScreenWidgetState extends State<TargetWeightScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedKg = 60;
  int currentWeight = 60;
  List<int> kgOptions = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentWeight();
  }

  Future<void> fetchCurrentWeight() async {
    try {
      final response = await UserService().getHealthProfile();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> healthData = responseData['data'];

        int apiWeight = int.tryParse(healthData['weight'].toString()) ?? 0;
        if (apiWeight > 0) {
          setState(() {
            currentWeight = apiWeight;
            updateKgOptions(); // Cập nhật danh sách trọng lượng
          });
          print("🔹 Lấy cân nặng hiện tại thành công: $currentWeight kg");
        }
      }
    } catch (e) {
      print("❌ Lỗi lấy cân nặng từ API: $e");
    }
  }

  void updateKgOptions() {
    final personalGoalProvider = context.read<PersonalGoalProvider>();

    if (personalGoalProvider.goalType == "GainWeight") {
      kgOptions = List.generate(50, (index) => currentWeight + index);
    } else if (personalGoalProvider.goalType == "LoseWeight") {
      kgOptions = List.generate(50, (index) => currentWeight - index)
          .where((kg) => kg > 30)
          .toList();
    } else {
      kgOptions = List.generate(100, (index) => index + 30);
    }

    selectedKg = currentWeight;

    setState(() {});
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
                      'Mục tiêu cân nặng của bạn là bao nhiêu kg?',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cân nặng hiện tại: $currentWeight kg',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            fontSize: 16.0,
                            color: FlutterFlowTheme.of(context).grey,
                          ),
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
                            selectedKg = kgOptions[index];
                          });

                          print(
                              "🔹 Người dùng đã chọn targetWeight: $selectedKg kg");
                        },
                        children: kgOptions.map((kg) {
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
                          personalGoalProvider
                              .setTargetWeight(selectedKg.toDouble());

                          print(
                              "🔹 Xác nhận targetWeight: ${personalGoalProvider.targetWeight}");

                          // ✅ Điều hướng đến màn hình tiếp theo dựa vào goalType
                          if (personalGoalProvider.goalType == "GainWeight") {
                            context.pushNamed(
                                'increase_weight_change_rate_screen');
                          } else if (personalGoalProvider.goalType ==
                              "LoseWeight") {
                            context.pushNamed(
                                'decrease_weight_change_rate_screen');
                          } else {
                            showSnackbar(
                                context, 'Lỗi: Mục tiêu không hợp lệ.');
                          }
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
