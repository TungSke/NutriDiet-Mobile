import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../services/models/health_profile_provider.dart';
import '../../services/systemconfiguration_service.dart';
import 'select_allergy_screen_model.dart';

class SelectAllergyScreenWidget extends StatefulWidget {
  const SelectAllergyScreenWidget({super.key});

  @override
  _SelectAllergyScreenWidgetState createState() =>
      _SelectAllergyScreenWidgetState();
}

class _SelectAllergyScreenWidgetState extends State<SelectAllergyScreenWidget> {
  late SelectAllergyScreenModel model;

  @override
  void initState() {
    super.initState();
    model = SelectAllergyScreenModel();
    model.fetchAllergyLevels();
    Future.delayed(Duration.zero, () async {
      await _getConfigValuesFromApi();
      setState(() {});
    });
  }

  late int minAllergy = 0; // Mặc định minHeight
  late int maxAllergy = 10;
  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();
  Future<void> _getConfigValuesFromApi() async {
    try {
      // Lấy min/max height từ API

      final responseAllergy = await _systemConfigService.getSystemConfigById(5);
      final allergyConfig = responseAllergy['data'];
      minAllergy = allergyConfig['minValue']?.toDouble() ?? 0;
      maxAllergy = allergyConfig['maxValue']?.toDouble() ?? 10;

      setState(() {}); // Cập nhật UI sau khi lấy dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy cấu hình: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectAllergyScreenModel>(
      create: (_) => model,
      child: Consumer<SelectAllergyScreenModel>(
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
                            : ListView.separated(
                                padding: const EdgeInsets.only(right: 10.0),
                                itemCount: model.allergyLevelsData.length,
                                itemBuilder: (context, index) {
                                  final allergy =
                                      model.allergyLevelsData[index];
                                  final allergyId = allergy['id'] as int;
                                  final title =
                                      allergy['title'] ?? "Không xác định";
                                  final notes =
                                      allergy['notes'] ?? "Không có mô tả";
                                  final isSelected = model.selectedAllergyIds
                                      .contains(allergyId);

                                  return CheckboxListTile(
                                    title: Text(title,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium),
                                    subtitle: Text(notes),
                                    value: isSelected,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    onChanged: (bool? value) {
                                      model.toggleSelection(allergyId);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
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
                                        "Bạn cần chọn ít nhất một loại dị ứng hoặc bấm 'Bỏ qua'!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (model.selectedAllergyIds.length >
                                      maxAllergy ||
                                  model.selectedAllergyIds.length <
                                      minAllergy) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Bạn chỉ có thể chọn dị ứng trong khoảng $minAllergy - $maxAllergy dị ứng!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // Cập nhật allergies vào provider (dùng List<int>)
                                context
                                    .read<HealthProfileProvider>()
                                    .setAllergies(model.selectedAllergyIds);

                                // Kiểm tra xem allergies đã được lưu vào provider chưa
                                print(
                                    "Dị ứng đã lưu vào HealthProfileProvider: ${context.read<HealthProfileProvider>().allergies}");

                                // Chuyển đến màn hình tiếp theo
                                context.pushNamed("Select_disease_screen");
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
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),

                          const SizedBox(height: 10.0), // Khoảng cách giữa nút
                          TextButton(
                            onPressed: () {
                              context.pushNamed("Select_disease_screen");
                            },
                            child: Text(
                              'Bỏ qua',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
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
        },
      ),
    );
  }
}
