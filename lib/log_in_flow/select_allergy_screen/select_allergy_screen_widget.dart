import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SelectAllergyScreenWidget extends StatefulWidget {
  const SelectAllergyScreenWidget({super.key});

  @override
  State<SelectAllergyScreenWidget> createState() =>
      _SelectAllergyScreenWidgetState();
}

class _SelectAllergyScreenWidgetState extends State<SelectAllergyScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Set<String> selectedAllergies = {};

  final List<String> allergies = [
    "Peanuts",
    "Seafood",
    "Dairy",
    "Gluten",
    "Soy",
    "Eggs",
    "Tree Nuts",
    "Shellfish",
    "Sesame",
    "Wheat",
    "Corn"
  ];

  void toggleSelection(String allergy) {
    setState(() {
      if (selectedAllergies.contains(allergy)) {
        selectedAllergies.remove(allergy);
      } else {
        selectedAllergies.add(allergy);
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
              const AppbarWidget(title: 'Select Allergies'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scrollbar(
                    thickness: 4.0, // Độ dày thanh cuộn
                    radius: const Radius.circular(10), // Bo góc thanh cuộn
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 10.0),
                      itemCount: allergies.length,
                      itemBuilder: (context, index) {
                        final allergy = allergies[index];
                        final isSelected = selectedAllergies.contains(allergy);

                        return CheckboxListTile(
                          title: Text(allergy,
                              style: FlutterFlowTheme.of(context).bodyMedium),
                          value: isSelected,
                          activeColor: FlutterFlowTheme.of(context).primary,
                          onChanged: (bool? value) {
                            toggleSelection(allergy);
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
                    context.pushNamed('Select_disease_screen');
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
