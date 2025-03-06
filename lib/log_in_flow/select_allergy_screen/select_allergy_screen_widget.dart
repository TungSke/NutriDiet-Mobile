import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'select_allergy_screen_model.dart';

class SelectAllergyScreenWidget extends StatelessWidget {
  const SelectAllergyScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectAllergyModel(),
      child: Consumer<SelectAllergyModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: SafeArea(
                child: Column(
                  children: [
                    const AppbarWidget(title: 'Bạn bị dị ứng với?'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: model.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                padding: const EdgeInsets.only(right: 10.0),
                                itemCount: model.allergyLevelsData.length,
                                itemBuilder: (context, index) {
                                  final allergy =
                                      model.allergyLevelsData[index];
                                  final title =
                                      allergy['title'] ?? "Không xác định";
                                  final notes =
                                      allergy['notes'] ?? "Không có mô tả";

                                  final isSelected = model.selectedAllergyIds
                                      .contains(index + 1);

                                  return CheckboxListTile(
                                    title: Text(
                                      title,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                    subtitle: Text(notes),
                                    value: isSelected,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    onChanged: (bool? value) {
                                      model.toggleSelection(index + 1);
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
                              if (model.selectedAllergyIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Bạn cần chọn ít nhất một loại dị ứng!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                context.pushNamed('Select_disease_screen');
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
                                  "Selected Allergy IDs: ${model.selectedAllergyIds}");
                              context.pushNamed('Select_disease_screen');
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
