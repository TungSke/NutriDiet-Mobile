import 'package:diet_plan_app/services/allergy_service.dart';
import 'package:diet_plan_app/services/models/allergy.dart';
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
  final AllergyService _allergyService = AllergyService();

  Set<int> selectedAllergyIds = {};
  List<Allergy> allergies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllergies();
  }

  Future<void> fetchAllergies() async {
    try {
      final data =
          await _allergyService.getAllAllergies(pageIndex: 1, pageSize: 20);
      setState(() {
        allergies = data as List<Allergy>;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading allergies: $e");
    }
  }

  void toggleSelection(int allergyId) {
    setState(() {
      if (selectedAllergyIds.contains(allergyId)) {
        selectedAllergyIds.remove(allergyId);
      } else {
        selectedAllergyIds.add(allergyId);
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
                  child: isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Hiển thị loading khi đang tải API
                      : Scrollbar(
                          thickness: 4.0,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(right: 10.0),
                            itemCount: allergies.length,
                            itemBuilder: (context, index) {
                              final allergy = allergies[index];
                              final isSelected = selectedAllergyIds
                                  .contains(allergy.allergyId);

                              return CheckboxListTile(
                                title: Text(
                                  allergy.allergyName,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                value: isSelected,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                onChanged: (bool? value) {
                                  toggleSelection(allergy.allergyId);
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
                    print("Selected Allergy IDs: $selectedAllergyIds");
                    context.pushNamed('Select_disease_screen');
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
