import 'package:diet_plan_app/services/disease_service.dart';
import 'package:diet_plan_app/services/models/disease.dart';
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
  final DiseaseService _diseaseService = DiseaseService();

  Set<int> selectedDiseaseIds = {};
  List<Disease> diseases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    try {
      final data =
          await _diseaseService.getAllDiseases(pageIndex: 1, pageSize: 20);
      setState(() {
        diseases = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading diseases: $e");
    }
  }

  void toggleSelection(int diseaseId) {
    setState(() {
      if (selectedDiseaseIds.contains(diseaseId)) {
        selectedDiseaseIds.remove(diseaseId);
      } else {
        selectedDiseaseIds.add(diseaseId);
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
              const AppbarWidget(title: 'Bạn mắc bệnh gì?'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Scrollbar(
                          thickness: 4.0,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(right: 10.0),
                            itemCount: diseases.length,
                            itemBuilder: (context, index) {
                              final disease = diseases[index];
                              final isSelected = selectedDiseaseIds
                                  .contains(disease.diseaseId);

                              return CheckboxListTile(
                                title: Text(
                                  disease.diseaseName,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                value: isSelected,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                onChanged: (bool? value) {
                                  toggleSelection(disease.diseaseId);
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
                child: Column(
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        if (selectedDiseaseIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Bạn cần chọn ít nhất một loại bệnh!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          context.pushNamed('Which_diet_do_you_prefer');
                        }
                      },
                      text: 'Tiếp tục',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 54.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'figtree',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                        elevation: 0.0,
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FFButtonWidget(
                      onPressed: () async {
                        print("Selected Disease IDs: $selectedDiseaseIds");
                        // context.pushNamed('Which_diet_do_you_prefer');
                        context.pushNamed('Whats_your_goal');
                      },
                      text: 'Bỏ qua',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 54.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        color: Colors.grey,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'figtree',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                        elevation: 0.0,
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.0),
                        borderRadius: BorderRadius.circular(16.0),
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
