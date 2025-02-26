import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class FrequencyExerciseScreenWidget extends StatefulWidget {
  const FrequencyExerciseScreenWidget({super.key});

  @override
  State<FrequencyExerciseScreenWidget> createState() =>
      _FrequencyExerciseScreenWidgetState();
}

class _FrequencyExerciseScreenWidgetState
    extends State<FrequencyExerciseScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int? selectedFrequency;
  final List<Map<String, dynamic>> frequencies = [
    {
      "label": "Không có",
      "description": "Công việc, hoạt động sinh hoạt hằng ngày",
      "icon": Icons.bed,
    },
    {
      "label": "Nhẹ",
      "description": "Tập thể dục hoặc đi bộ mỗi ngày 30 phút",
      "icon": Icons.directions_walk,
    },
    {
      "label": "Bình thường",
      "description": "Tập thể dục 1 giờ (3-5 lần/ 1 tuần)",
      "icon": Icons.fitness_center,
    },
    {
      "label": "Thường xuyên",
      "description": "Thể dục cường độ cao 5-7 lần/ 1 tuần",
      "icon": Icons.run_circle,
    },
    {
      "label": "Năng nổ",
      "description":
          "Phần lớn thời gian trong ngày để hoạt động thể chất cường độ cao",
      "icon": Icons.sports,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              const AppbarWidget(title: 'Tần suất vận động của bạn'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scrollbar(
                    thickness: 4.0,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 10.0),
                      itemCount: frequencies.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<int>(
                          title: Row(
                            children: [
                              Icon(
                                frequencies[index]["icon"],
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      frequencies[index]["label"],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                    Text(
                                      frequencies[index]["description"],
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          value: index,
                          groupValue: selectedFrequency,
                          activeColor: FlutterFlowTheme.of(context).primary,
                          onChanged: (int? value) {
                            setState(() {
                              selectedFrequency = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                child: FFButtonWidget(
                  onPressed: selectedFrequency == null
                      ? null
                      : () {
                          print(
                              "Selected Frequency: ${frequencies[selectedFrequency!]["label"]}");
                          context.pushNamed('bottom_navbar_screen');
                        },
                  text: 'Next',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'figtree',
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                    elevation: 0.0,
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
