import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../components/appbar_widget.dart';

class DecreaseWeightChangeRateScreenWidget extends StatefulWidget {
  const DecreaseWeightChangeRateScreenWidget({super.key});

  @override
  State<DecreaseWeightChangeRateScreenWidget> createState() =>
      _DecreaseWeightChangeRateScreenWidgetState();
}

class _DecreaseWeightChangeRateScreenWidgetState
    extends State<DecreaseWeightChangeRateScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double selectedKgPerWeek = 0.25; // Giá trị mặc định
  final List<double> kgPerWeekOptions = [0.25, 0.5, 0.75, 1.0]; // 0.25 - 1 kg

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
                          print('Người dùng chọn: $selectedKgPerWeek kg/tuần');

                          // Chuyển sang trang tiếp theo
                          context.pushNamed('health_indicator_screen');
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
