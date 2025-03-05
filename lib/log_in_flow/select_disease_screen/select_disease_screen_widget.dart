import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'select_disease_screen_model.dart';

class SelectDiseaseScreenWidget extends StatelessWidget {
  const SelectDiseaseScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectDiseaseModel(),
      child: Consumer<SelectDiseaseModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: SafeArea(
                child: Column(
                  children: [
                    const AppbarWidget(title: 'Bạn mắc bệnh gì?'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: model.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                padding: const EdgeInsets.only(right: 10.0),
                                itemCount: model.diseases.length,
                                itemBuilder: (context, index) {
                                  final disease = model.diseases[index];
                                  final isSelected = model.selectedDiseaseIds
                                      .contains(disease.diseaseId);
                                  return CheckboxListTile(
                                    title: Text(
                                      disease.diseaseName,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                    value: isSelected,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    onChanged: (bool? value) {
                                      model.toggleSelection(disease.diseaseId);
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 20.0),
                      child: Column(
                        children: [
                          FFButtonWidget(
                            onPressed: () {
                              if (model.selectedDiseaseIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Bạn cần chọn ít nhất một loại bệnh!"),
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
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
                              print(
                                  "Selected Disease IDs: ${model.selectedDiseaseIds}");
                              context.pushNamed('Whats_your_goal');
                            },
                            text: 'Bỏ qua',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 54.0,
                              color: Colors.grey,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
        },
      ),
    );
  }
}
