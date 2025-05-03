import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../services/systemconfiguration_service.dart';
import 'edit_personal_goal_screen_model.dart';

class EditPersonalGoalScreenWidget extends StatefulWidget {
  const EditPersonalGoalScreenWidget({super.key});

  @override
  State<EditPersonalGoalScreenWidget> createState() =>
      _EditPersonalGoalScreenWidgetState();
}

class _EditPersonalGoalScreenWidgetState
    extends State<EditPersonalGoalScreenWidget> {
  late EditPersonalGoalScreenModel _model;
  bool isEdited = false;
  String _tempSelectedValue = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = EditPersonalGoalScreenModel();

    Future.delayed(Duration.zero, () async {
      await _model.fetchUserProfile();
      await _model.fetchPersonalGoal();
      await _model.fetchHealthProfile();
      await _getConfigValuesFromApi();
      setState(() {});
    });
  }

  late double minTargetWeight = 30.0; // Mặc định minHeight
  late double maxTargetWeight = 250.0; // Mặc định maxHeight

  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();
  Future<void> _getConfigValuesFromApi() async {
    try {
      // Lấy min/max height từ API
      final responseHeight = await _systemConfigService.getSystemConfigById(4);
      final targetWeightConfig = responseHeight['data'];
      minTargetWeight = targetWeightConfig['minValue']?.toDouble() ?? 30.0;
      maxTargetWeight = targetWeightConfig['maxValue']?.toDouble() ?? 250.0;

      setState(() {}); // Cập nhật UI sau khi lấy dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy cấu hình: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: _model.avatar.isNotEmpty
                    ? Image.network(
                        _model.avatar,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/dummy_profile.png',
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(_model.name,
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Text(
                        "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            _model.isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 15),
              child: Text(
                (_model.evaluate),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    bool canUpdate = _model.goalType.isNotEmpty &&
        (_model.goalType == 'Giữ cân' ||
            (_model.targetWeight != 0 &&
                _model.weightChangeRate.isNotEmpty &&
                _model.targetWeight >= minTargetWeight &&
                _model.targetWeight <=
                    maxTargetWeight)); // Thêm điều kiện check valid target weight

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.arrow_back, size: 28),
          ),
          Flexible(
            child: const Text(
              'Chỉnh sửa mục tiêu cá nhân',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: isEdited && canUpdate
                ? () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        final response =
                            await _model.validateBMIGoalBeforeUpdate();

                        if (response != null && response.statusCode == 200) {
                          final responseData = jsonDecode(response.body);
                          final message = responseData['message'] ??
                              'Mục tiêu không hợp lệ.';
                          final continueUpdate = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Cảnh báo",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(message),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    "Hủy",
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "Tiếp tục",
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (continueUpdate != true) return;
                        }

                        await _model.updatePersonalGoal(context);
                        setState(() {
                          isEdited = false;
                        });
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Lỗi"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Đóng"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
                : null,
            child: Icon(
              Icons.check,
              color: isEdited && canUpdate ? Colors.green : Colors.grey,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Expanded(child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildProfileForm() {
    return Expanded(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildPickerRow(
              'Mục tiêu',
              _model.goalType,
              ['Giữ cân', 'Tăng cân', 'Giảm cân'],
              (val) {
                setState(() {
                  _model.goalType = val;
                  isEdited = true;
                });
              },
            ),
            if (_model.goalType != 'Giữ cân') ...[
              _buildTargetWeightRow(
                  'Mục tiêu cân nặng (kg)', _model.targetWeight, (val) {
                setState(() {
                  _model.targetWeight = double.tryParse(val) ?? 0.0;
                  isEdited = true;
                });
              }),
              _buildPickerweightChangeRateRow(
                'Mức độ thay đổi',
                _model.weightChangeRate,
                [
                  'Giữ cân',
                  'Tăng 0.25kg/1 tuần',
                  'Tăng 0.5kg/1 tuần',
                  'Giảm 0.25Kg/1 tuần',
                  'Giảm 0.5Kg/1 tuần',
                  'Giảm 0.75Kg/1 tuần',
                  'Giảm 1Kg/1 tuần'
                ],
                (val) {
                  setState(() {
                    _model.weightChangeRate = val;
                    isEdited = true;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPickerRow(String title, String value, List<String> options,
      Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(
            onTap: () =>
                _showCupertinoPicker(title, options, value, onSelected),
            child: Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerweightChangeRateRow(String title, String value,
      List<String> options, Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          InkWell(
            onTap: () =>
                _showCupertinoPicker(title, options, value, onSelected),
            child: Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWeightRow(
      String title, double value, Function(String) onChanged) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              width: 150,
              child: TextFormField(
                initialValue: value.toString(),
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập cân nặng (kg)',
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    height: 1.2, // Điều chỉnh chiều cao dòng để tránh cắt xén
                  ),
                  errorMaxLines: 2,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10), // Thêm padding
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Vui lòng nhập mục tiêu cân nặng';
                  }
                  final targetWeight = double.tryParse(val);
                  if (targetWeight == null ||
                      targetWeight < minTargetWeight ||
                      targetWeight > maxTargetWeight) {
                    return 'Mục tiêu cân nặng phải từ $minTargetWeight - $maxTargetWeight kg';
                  }
                  return null;
                },
                onChanged: (val) {
                  onChanged(val);
                  _formKey.currentState
                      ?.validate(); // Kích hoạt validation ngay lập tức
                },
              ),
            ),
          ],
        ));
  }

  void _showCupertinoPicker(String title, List<String> options,
      String currentValue, Function(String) onSelected) {
    int selectedIndex = options.indexOf(currentValue);
    _tempSelectedValue = currentValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedIndex),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  _tempSelectedValue = options[index];
                },
                children: options
                    .map((e) => Center(
                        child: Text(e, style: const TextStyle(fontSize: 16))))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  onSelected(_tempSelectedValue);
                  setState(() {
                    isEdited = true;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Xác nhận",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _generateWeightList() {
    return List.generate(91, (index) => '${10 + index}');
  }
}
