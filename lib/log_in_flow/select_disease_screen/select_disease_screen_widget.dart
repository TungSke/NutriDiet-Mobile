import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SelectDiseaseScreenWidget extends StatefulWidget {
  const SelectDiseaseScreenWidget({super.key});

  @override
  State<SelectDiseaseScreenWidget> createState() =>
      _SelectDiseaseScreenWidgetState();
}

class _SelectDiseaseScreenWidgetState extends State<SelectDiseaseScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Set<String> selectedDiseases = {};

  final List<String> diseases = [
    "Diabetes",
    "Hypertension",
    "Heart Disease",
    "Asthma",
    "Arthritis",
    "Cancer",
    "Obesity",
    "Kidney Disease",
    "Liver Disease",
    "Alzheimer's",
    "Stroke"
  ];

  void toggleSelection(String disease) {
    setState(() {
      if (selectedDiseases.contains(disease)) {
        selectedDiseases.remove(disease);
      } else {
        selectedDiseases.add(disease);
      }
    });
  }

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
              const AppbarWidget(title: 'Select Diseases'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scrollbar(
                    thickness: 4.0,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 10.0),
                      itemCount: diseases.length,
                      itemBuilder: (context, index) {
                        final disease = diseases[index];
                        final isSelected = selectedDiseases.contains(disease);

                        return CheckboxListTile(
                          title: Text(disease,
                              style: FlutterFlowTheme.of(context).bodyMedium),
                          value: isSelected,
                          activeColor: FlutterFlowTheme.of(context).primary,
                          onChanged: (bool? value) {
                            toggleSelection(disease);
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
                  onPressed: () async {
                    context.pushNamed('Which_diet_do_you_prefer');
                  },
                  text: 'Next',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'figtree',
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
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
