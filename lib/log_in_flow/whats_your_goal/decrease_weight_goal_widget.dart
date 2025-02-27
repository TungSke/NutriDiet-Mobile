import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../components/appbar_widget.dart';

class DecreaseWeightGoalScreenWidget extends StatefulWidget {
  const DecreaseWeightGoalScreenWidget({super.key});

  @override
  State<DecreaseWeightGoalScreenWidget> createState() =>
      _DecreaseWeightGoalScreenWidgetState();
}

class _DecreaseWeightGoalScreenWidgetState
    extends State<DecreaseWeightGoalScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>(); // 🔹 Thêm GlobalKey

  int selectedKg = 0; // Giá trị mặc định
  final List<int> kgOptions = List.generate(31, (index) => index); // 0 - 30 kg

  @override
  Widget build(BuildContext context) {
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
              const AppbarWidget(
                  title: 'Mục tiêu của bạn'), // 🔹 Sửa lỗi AppbarWidget
              Expanded(
                // 🔹 Đúng cú pháp
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn muốn giảm bao nhiêu kg?',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: CupertinoPicker(
                        itemExtent: 40, // Chiều cao mỗi item
                        magnification: 1.2, // Phóng to khi chọn
                        squeeze: 1.2, // Hiệu ứng bóp
                        useMagnifier: true,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedKg = kgOptions[index];
                          });
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
                          print('Người dùng chọn: $selectedKg kg');

                          // Chuyển sang trang Select_allergy_screen
                          context.pushNamed('decrease_weight_change_rate_screen');
                        },
                        text: 'Xác nhận',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 54.0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.copyWith(
                                    // 🔹 Sửa lỗi override
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
