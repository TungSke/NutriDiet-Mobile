import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../services/models/health_profile_provider.dart';
import '../../services/systemconfiguration_service.dart';
import 'select_disease_screen_model.dart';

class SelectDiseaseScreenWidget extends StatefulWidget {
  const SelectDiseaseScreenWidget({super.key});

  @override
  _SelectDiseaseScreenWidgetState createState() =>
      _SelectDiseaseScreenWidgetState();
}

class _SelectDiseaseScreenWidgetState extends State<SelectDiseaseScreenWidget> {
  late SelectDiseaseScreenModel model;
  late int minDisease = 0; // Mặc định minHeight
  late int maxDisease = 5;
  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();
  Future<void> _getConfigValuesFromApi() async {
    try {
      final responseDisease = await _systemConfigService.getSystemConfigById(6);
      final diseaseConfig = responseDisease['data'];
      minDisease = diseaseConfig['minValue']?.toDouble() ?? 0;
      maxDisease = diseaseConfig['maxValue']?.toDouble() ?? 5;

      setState(() {}); // Cập nhật UI sau khi lấy dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy cấu hình: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    model = SelectDiseaseScreenModel();
    model.fetchDiseaseLevels();

    // Gọi async method sau 1 frame
    Future.delayed(Duration.zero, () async {
      await _getConfigValuesFromApi();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectDiseaseScreenModel>(
      create: (_) => model,
      child: Consumer<SelectDiseaseScreenModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: SafeArea(
                child: Column(
                  children: [
                    const AppbarWidget(title: 'Bạn bị bệnh gì?'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: model.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                padding: const EdgeInsets.only(right: 10.0),
                                itemCount: model.diseaseLevelsData.length,
                                itemBuilder: (context, index) {
                                  final disease =
                                      model.diseaseLevelsData[index];
                                  final diseaseId = disease['id'] as int;
                                  final title =
                                      disease['title'] ?? "Không xác định";
                                  final notes =
                                      disease['notes'] ?? "Không có mô tả";
                                  final isSelected = model.selectedDiseaseIds
                                      .contains(diseaseId);

                                  return CheckboxListTile(
                                    title: Text(title,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium),
                                    subtitle: Text(notes),
                                    value: isSelected,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    onChanged: (bool? value) {
                                      model.toggleSelection(diseaseId);
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
                            onPressed: () async {
                              if (model.selectedDiseaseIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Bạn cần chọn ít nhất một loại bệnh hoặc bấm 'Bỏ qua'!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (model.selectedDiseaseIds.length >
                                      maxDisease ||
                                  model.selectedDiseaseIds.length <
                                      minDisease) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Bạn chỉ có thể chọn bệnh trong khoảng $minDisease - $maxDisease bệnh!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // Cập nhật diseases vào provider (sử dụng List<int> thay vì List<String>)
                                context
                                    .read<HealthProfileProvider>()
                                    .setDiseases(model.selectedDiseaseIds);

                                // Kiểm tra xem diseases đã được lưu vào provider chưa
                                print(
                                    "Bệnh đã lưu vào HealthProfileProvider: ${context.read<HealthProfileProvider>().diseases}");

                                // Cập nhật bệnh và gửi lên API
                                await model.updateDisease(
                                    context); // Đợi updateDisease thực thi xong

                                // Kiểm tra xem quá trình gửi bệnh có thành công không (isLoading == false)
                                if (!model.isLoading) {
                                  if (model.isDiseaseUpdated) {
                                    // Kiểm tra xem cập nhật bệnh có thành công không
                                    showSnackbar(
                                        context, 'Cập nhật bệnh thành công!');
                                    // Chuyển sang màn hình Whats Your Goal sau khi cập nhật thành công
                                    context.pushNamed("Whats_your_goal");
                                  } else {
                                    showSnackbar(
                                        context, 'Cập nhật bệnh thất bại!');
                                  }
                                }
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
                            onPressed: () async {
                              // Cập nhật diseases vào provider (sử dụng List<int> thay vì List<String>)
                              context
                                  .read<HealthProfileProvider>()
                                  .setDiseases(model.selectedDiseaseIds);

                              await model.updateDisease(
                                  context); // Đợi updateDisease thực thi xong

                              // Kiểm tra xem quá trình gửi bệnh có thành công không (isLoading == false)
                              if (!model.isLoading) {
                                if (model.isDiseaseUpdated) {
                                  // Kiểm tra xem cập nhật bệnh có thành công không

                                  // Chuyển sang màn hình Whats Your Goal sau khi cập nhật thành công
                                  context.pushNamed("Whats_your_goal");
                                } else {
                                  showSnackbar(
                                      context, 'Cập nhật bệnh thất bại!');
                                }
                              }
                            },
                            child: Text(
                              'Bỏ qua',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
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

  void showSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
