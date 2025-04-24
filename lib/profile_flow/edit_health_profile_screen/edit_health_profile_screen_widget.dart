// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
// import 'package:multi_select_flutter/util/multi_select_item.dart';
//
// import 'edit_health_profile_screen_model.dart';
//
// class EditHealthProfileScreenWidget extends StatefulWidget {
//   const EditHealthProfileScreenWidget({super.key});
//
//   @override
//   State<EditHealthProfileScreenWidget> createState() =>
//       _EditHealthProfileScreenWidgetState();
// }
//
// class _EditHealthProfileScreenWidgetState
//     extends State<EditHealthProfileScreenWidget> {
//   late EditHealthProfileScreenModel _model;
//   bool isEdited = false;
//   String _tempSelectedValue = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _model = EditHealthProfileScreenModel();
//
//     // Debugging: Kiểm tra giá trị ban đầu của selectedAllergyIds
//     print('Selected Allergies at init: ${_model.selectedAllergyIds}');
//
//     Future.delayed(Duration.zero, () async {
//       await _model.fetchHealthProfile();
//       await _model.fetchUserProfile();
//       await _model.fetchAllergyLevelsData();
//       await _model.fetchDiseaseLevelsData();
//       // Debugging: Kiểm tra giá trị sau khi fetch dữ liệu
//       print('Selected Allergies after fetch: ${_model.selectedAllergyIds}');
//       setState(() {}); // 🚀 Cập nhật UI ngay sau khi fetch dữ liệu
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildProfilePhoto(),
//             _model.isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () {
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             },
//             child: Icon(Icons.arrow_back, size: 28),
//           ),
//           Text(
//             'Chỉnh sửa hồ sơ sức khỏe',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           InkWell(
//             onTap: isEdited // Điều kiện bật nút màu xanh khi có thay đổi
//                 ? () async {
//                     await _model
//                         .updateHealthProfile(context); // Pass context here
//                     setState(() {
//                       isEdited = false;
//                     });
//                   }
//                 : null,
//             child: Icon(
//               Icons.check,
//               color: isEdited
//                   ? Colors.green
//                   : Colors.grey, // Nút check màu xanh khi có thay đổi
//               size: 28,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Kiểm tra trạng thái "isEdited" khi có bất kỳ thay đổi nào
//   void _handleChange() {
//     setState(() {
//       isEdited = true;
//     });
//   }
//
//   Widget _buildProfilePhoto() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.only(top: 30),
//             decoration: BoxDecoration(),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(0.0),
//               child: Image.asset(
//                 'assets/images/jamekooper_.png',
//                 width: 80.0,
//                 height: 80.0,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 150,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Column(
//                 children: [
//                   Text(_model.name,
//                       style: GoogleFonts.roboto(
//                           fontSize: 18, fontWeight: FontWeight.w600)),
//                   Text(
//                       "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
//                       style:
//                           GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Expanded(child: Center(child: CircularProgressIndicator()));
//   }
//
//   Widget _buildProfileForm() {
//     return Expanded(
//       child: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         children: [
//           _buildHeightRow('Chiều cao (cm)', _model.height, (val) {
//             setState(() {
//               _model.height = int.tryParse(val) ?? 0;
//               isEdited = true;
//             });
//           }),
//           _buildWeightRow('Cân nặng (kg)', _model.weight, (val) {
//             setState(() {
//               _model.weight = int.tryParse(val) ?? 0;
//               isEdited = true;
//             });
//           }),
//           _buildPickerRow(
//             'Tần suất vận động ',
//             _model.activityLevel,
//             [
//               'Ít vận động',
//               'Vận động nhẹ',
//               'Vận động vừa phải',
//               'Vận động nhiều',
//               'Cường độ rất cao'
//             ],
//             (val) {
//               setState(() {
//                 _model.activityLevel = val;
//                 isEdited = true;
//               });
//             },
//           ),
//           _buildAllergySelector(_model.allergyLevelsData),
//           _buildDiseaseSelector(_model.diseaseLevelsData),
//         ],
//       ),
//     );
//   }
//
//   // 🟢 Ô nhập liệu cho chiều cao
//   Widget _buildHeightRow(String title, int value, Function(String) onChanged) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           SizedBox(
//             width: 150,
//             child: TextFormField(
//               initialValue: value.toString(),
//               textAlign: TextAlign.end,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Nhập chiều cao (cm)',
//               ),
//               onChanged: (val) {
//                 onChanged(val);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🟢 Ô nhập liệu cho cân nặng
//   Widget _buildWeightRow(String title, int value, Function(String) onChanged) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           SizedBox(
//             width: 150,
//             child: TextFormField(
//               initialValue: value.toString(),
//               textAlign: TextAlign.end,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Nhập cân nặng (kg)',
//               ),
//               onChanged: (val) {
//                 onChanged(val);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAllergySelector(List<Map<String, dynamic>> allergies) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Dị ứng',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//
//           // Nút chọn multiple allergies
//           GestureDetector(
//             onTap: () async {
//               final selected = await showDialog<List<int>>(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return MultiSelectDialog(
//                     items: allergies.map((allergy) {
//                       return MultiSelectItem<int>(
//                         int.tryParse(allergy['id'].toString()) ?? 0,
//                         allergy['title'],
//                       );
//                     }).toList(),
//                     // Đảm bảo giá trị initialValue là danh sách các ID dị ứng đã chọn
//                     initialValue: List<int>.from(_model
//                         .selectedAllergyIds), // Chuyển đổi selectedAllergyIds thành List<int>
//                   );
//                 },
//               );
//
//               if (selected != null) {
//                 setState(() {
//                   // Cập nhật lại selectedAllergyIds với giá trị người dùng đã chọn
//                   _model.selectedAllergyIds = selected;
//                   print('Selected Allergies: ${_model.selectedAllergyIds}');
//
//                   _model.allergies = selected.map((id) {
//                     return allergies
//                         .firstWhere((allergy) =>
//                             int.tryParse(allergy['id'].toString()) ==
//                             id)['title']
//                         .toString();
//                   }).toList();
//                   isEdited = true;
//                 });
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     _model.allergies.isNotEmpty
//                         ? _model.allergies
//                             .join(', ') // Hiển thị các dị ứng đã chọn
//                         : 'Chưa chọn dị ứng', // Hiển thị khi chưa chọn dị ứng
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Spacer(),
//                   Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDiseaseSelector(List<Map<String, dynamic>> diseases) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Bệnh nền ',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//
//           // Nút chọn multiple allergies
//           GestureDetector(
//             onTap: () async {
//               final selected = await showDialog<List<int>>(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return MultiSelectDialog(
//                     items: diseases.map((disease) {
//                       return MultiSelectItem<int>(
//                         int.tryParse(disease['id'].toString()) ?? 0,
//                         disease['title'],
//                       );
//                     }).toList(),
//                     // Đảm bảo giá trị initialValue là danh sách các ID dị ứng đã chọn
//                     initialValue: List<int>.from(_model
//                         .selectedDiseaseIds), // Chuyển đổi selectedAllergyIds thành List<int>
//                   );
//                 },
//               );
//
//               if (selected != null) {
//                 setState(() {
//                   // Cập nhật lại selectedAllergyIds với giá trị người dùng đã chọn
//                   _model.selectedDiseaseIds = selected;
//                   print('Selected Diseases: ${_model.selectedDiseaseIds}');
//
//                   _model.diseases = selected.map((id) {
//                     return diseases
//                         .firstWhere((disease) =>
//                             int.tryParse(disease['id'].toString()) ==
//                             id)['title']
//                         .toString();
//                   }).toList();
//                   isEdited = true;
//                 });
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     _model.diseases.isNotEmpty
//                         ? _model.diseases
//                             .join(', ') // Hiển thị các dị ứng đã chọn
//                         : 'Chưa chọn bệnh  ', // Hiển thị khi chưa chọn dị ứng
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Spacer(),
//                   Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPickerRow(String title, String value, List<String> options,
//       Function(String) onSelected) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           InkWell(
//             onTap: () =>
//                 _showCupertinoPicker(title, options, value, onSelected),
//             child: Row(
//               children: [
//                 Text(value, style: TextStyle(fontSize: 16)),
//                 SizedBox(width: 8),
//                 Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showCupertinoPicker(String title, List<String> options,
//       String currentValue, Function(String) onSelected) {
//     int selectedIndex = options.indexOf(currentValue);
//     _tempSelectedValue = currentValue;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.4,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 16),
//             Text(title,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: CupertinoPicker(
//                 scrollController:
//                     FixedExtentScrollController(initialItem: selectedIndex),
//                 itemExtent: 40,
//                 onSelectedItemChanged: (index) {
//                   _tempSelectedValue = options[index];
//                 },
//                 children: options
//                     .map((e) =>
//                         Center(child: Text(e, style: TextStyle(fontSize: 16))))
//                     .toList(),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: () {
//                   onSelected(_tempSelectedValue);
//                   setState(() {
//                     isEdited = true;
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: Text("DONE",
//                     style: TextStyle(color: Colors.white, fontSize: 18)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<String> _generateWeightList() {
//     return List.generate(91, (index) => '${10 + index}');
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../services/systemconfiguration_service.dart';
import 'edit_health_profile_screen_model.dart';

class EditHealthProfileScreenWidget extends StatefulWidget {
  const EditHealthProfileScreenWidget({super.key});

  @override
  State<EditHealthProfileScreenWidget> createState() =>
      _EditHealthProfileScreenWidgetState();
}

class _EditHealthProfileScreenWidgetState
    extends State<EditHealthProfileScreenWidget> {
  late EditHealthProfileScreenModel _model;
  bool isEdited = false;
  String _tempSelectedValue = '';
  final _formKey = GlobalKey<FormState>();
  late double minHeight = 100.0; // Mặc định minHeight
  late double maxHeight = 220.0; // Mặc định maxHeight
  late double minWeight = 30.0; // Mặc định minWeight
  late double maxWeight = 250.0; // Mặc định maxWeight
  late int minAllergy = 0; // Mặc định minHeight
  late int maxAllergy = 10; // Mặc định maxHeight
  late int minDisease = 0; // Mặc định minWeight
  late int maxDisease = 5; // Mặc định maxWeight
  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();
  Future<void> _getConfigValuesFromApi() async {
    try {
      // Lấy min/max height từ API
      final responseHeight = await _systemConfigService.getSystemConfigById(2);
      final heightConfig = responseHeight['data'];
      minHeight = heightConfig['minValue']?.toDouble() ?? 100.0;
      maxHeight = heightConfig['maxValue']?.toDouble() ?? 220.0;

      // Lấy min/max weight từ API
      final responseWeight = await _systemConfigService.getSystemConfigById(3);
      final weightConfig = responseWeight['data'];
      minWeight = weightConfig['minValue']?.toDouble() ?? 30.0;
      maxWeight = weightConfig['maxValue']?.toDouble() ?? 250.0;

      final responseAllergy = await _systemConfigService.getSystemConfigById(5);
      final allergyConfig = responseAllergy['data'];
      minAllergy = allergyConfig['minValue']?.toDouble() ?? 0;
      maxAllergy = allergyConfig['maxValue']?.toDouble() ?? 10;
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
    _model = EditHealthProfileScreenModel();

    Future.delayed(Duration.zero, () async {
      await _model.fetchUserProfile();
      await _model.fetchHealthProfile();

      await _model.fetchAllergyLevelsData();
      await _model.fetchDiseaseLevelsData();
      await _getConfigValuesFromApi();
      setState(() {});
    });
  }

  void _checkTodayUpdate() async {
    try {
      // Call checkTodayUpdate to see if the profile was updated today
      bool isUpdatedToday = await _model.checkTodayUpdate();

      if (isUpdatedToday) {
        // Show confirmation modal
        _showConfirmationModal();
      } else {
        // Not updated today, directly update health profile
        await _updateHealthProfile("ADD");
      }
    } catch (e) {
      print("❌ Lỗi khi kiểm tra: $e");
      // Handle errors if necessary
    }
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Thông báo'),
          content: Text(
              'Bạn đã cập nhật hồ sơ sức khỏe hôm nay. Bạn vẫn muốn cập nhật?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close modal when choosing "Cancel"
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    FlutterFlowTheme.of(context).primary, // Màu chữ
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _updateHealthProfile("REPLACE");
              },
              child: Text('Cập nhật'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    FlutterFlowTheme.of(context).primary, // Màu chữ
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _updateHealthProfile("ADD");
              },
              child: Text('Thêm mới'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateHealthProfile(String profileOption) async {
    await _model.updateHealthProfile(context, profileOption);
    setState(() {
      isEdited = false;
    });
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              'Chỉnh sửa hồ sơ sức khỏe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // InkWell(
          //   onTap: isEdited && (_formKey.currentState?.validate() ?? false)
          //       ? () async {
          //           await _model.updateHealthProfile(context);
          //           setState(() {
          //             isEdited = false;
          //           });
          //         }
          //       : null,
          //   child: Icon(
          //     Icons.check,
          //     color: isEdited && (_formKey.currentState?.validate() ?? false)
          //         ? Colors.green
          //         : Colors.grey,
          //     size: 28,
          //   ),
          // ),
          InkWell(
            onTap: isEdited && (_formKey.currentState?.validate() ?? false)
                ? () async {
                    _checkTodayUpdate(); // Check if profile is updated today (no await needed here)
                    setState(() {
                      isEdited = false;
                    });
                  }
                : null,
            child: Icon(
              Icons.check,
              color: isEdited && (_formKey.currentState?.validate() ?? false)
                  ? Colors.green
                  : Colors.grey,
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
            _buildHeightRow('Chiều cao (cm)', _model.height.toString(), (val) {
              setState(() {
                _model.height = double.tryParse(val) ?? 0.0;
                isEdited = true;
              });
            }),
            _buildWeightRow('Cân nặng (kg)', _model.weight.toString(), (val) {
              setState(() {
                _model.weight = double.tryParse(val) ?? 0.0;
                isEdited = true;
              });
            }),
            _buildPickerRow(
              'Tần suất vận động ',
              _model.activityLevel,
              [
                'Ít vận động',
                'Vận động nhẹ',
                'Vận động vừa phải',
                'Vận động nhiều',
                'Cường độ rất cao'
              ],
              (val) {
                setState(() {
                  _model.activityLevel = val;
                  isEdited = true;
                });
              },
            ),
            _buildDietStylePickerRow(
              'Chế độ ăn ',
              _model.dietStyle,
              [
                'Nhiều Carb, giảm Protein',
                'Nhiều Protein, giảm Carb',
                'Ăn chay',
                'Thuần chay',
                'Cân bằng'
              ],
              (val) {
                setState(() {
                  _model.dietStyle = val;
                  isEdited = true;
                });
              },
            ),
            _buildAllergySelector(_model.allergyLevelsData),
            _buildDiseaseSelector(_model.diseaseLevelsData),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightRow(
      String title, String value, Function(String) onChanged) {
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
          SizedBox(
            width: 150,
            child: TextFormField(
              initialValue: value,
              textAlign: TextAlign.end,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập chiều cao (cm)',
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  height: 1.2,
                ),
                errorMaxLines: 2,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Vui lòng nhập chiều cao';
                }
                final height = double.tryParse(val);
                if (height == null ||
                    height < minHeight ||
                    height > maxHeight) {
                  return 'Chiều cao phải từ $minHeight - $maxHeight cm';
                }
                return null;
              },
              onChanged: (val) {
                onChanged(val);
                _formKey.currentState?.validate(); // Hiển thị lỗi ngay lập tức
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHeightRow(
  //     String title, String value, Function(String) onChanged) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title,
  //             style:
  //                 const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //         SizedBox(
  //           width: 150,
  //           child: TextFormField(
  //             initialValue: value,
  //             textAlign: TextAlign.end,
  //             keyboardType:
  //                 const TextInputType.numberWithOptions(decimal: true),
  //             decoration: const InputDecoration(
  //               border: InputBorder.none,
  //               hintText: 'Nhập chiều cao (cm)',
  //               errorStyle: TextStyle(
  //                 color: Colors.red,
  //                 fontSize: 12,
  //                 height: 1.2,
  //               ),
  //               errorMaxLines: 2,
  //               contentPadding: EdgeInsets.symmetric(vertical: 10),
  //             ),
  //             validator: (val) {
  //               if (val == null || val.isEmpty) {
  //                 return 'Vui lòng nhập chiều cao';
  //               }
  //               final height = double.tryParse(val);
  //               if (height == null || height < 100 || height > 220) {
  //                 return 'Chiều cao phải từ 100-220 cm';
  //               }
  //               return null;
  //             },
  //             onChanged: (val) {
  //               onChanged(val);
  //               _formKey.currentState?.validate(); // Hiển thị lỗi ngay lập tức
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildWeightRow(
      String title, String value, Function(String) onChanged) {
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
          SizedBox(
            width: 150,
            child: TextFormField(
              initialValue: value,
              textAlign: TextAlign.end,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập cân nặng (kg)',
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  height: 1.2,
                ),
                errorMaxLines: 2,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Vui lòng nhập cân nặng';
                }
                final weight = double.tryParse(val);
                if (weight == null ||
                    weight < minWeight ||
                    weight > maxWeight) {
                  return 'Cân nặng phải từ $minWeight - $maxWeight kg';
                }
                return null;
              },
              onChanged: (val) {
                onChanged(val);
                _formKey.currentState?.validate(); // Hiển thị lỗi ngay lập tức
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildWeightRow(
  //     String title, String value, Function(String) onChanged) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title,
  //             style:
  //                 const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //         SizedBox(
  //           width: 150,
  //           child: TextFormField(
  //             initialValue: value,
  //             textAlign: TextAlign.end,
  //             keyboardType:
  //                 const TextInputType.numberWithOptions(decimal: true),
  //             decoration: const InputDecoration(
  //               border: InputBorder.none,
  //               hintText: 'Nhập cân nặng (kg)',
  //               errorStyle: TextStyle(
  //                 color: Colors.red,
  //                 fontSize: 12,
  //                 height: 1.2,
  //               ),
  //               errorMaxLines: 2,
  //               contentPadding: EdgeInsets.symmetric(vertical: 10),
  //             ),
  //             validator: (val) {
  //               if (val == null || val.isEmpty) {
  //                 return 'Vui lòng nhập cân nặng';
  //               }
  //               final weight = double.tryParse(val);
  //               if (weight == null || weight < 30 || weight > 250) {
  //                 return 'Cân nặng phải từ 30-250 kg';
  //               }
  //               return null;
  //             },
  //             onChanged: (val) {
  //               onChanged(val);
  //               _formKey.currentState?.validate(); // Hiển thị lỗi ngay lập tức
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAllergySelector(List<Map<String, dynamic>> allergies) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dị ứng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          GestureDetector(
            onTap: () async {
              final selected = await showDialog<List<int>>(
                context: context,
                builder: (BuildContext context) {
                  return MultiSelectDialog(
                    backgroundColor: Colors.white,
                    items: allergies.map((allergy) {
                      return MultiSelectItem<int>(
                          int.tryParse(allergy['id'].toString()) ?? 0,
                          allergy['title']);
                    }).toList(),
                    selectedColor: FlutterFlowTheme.of(context).primary,
                    initialValue: List<int>.from(_model.selectedAllergyIds),
                  );
                },
              );

              if (selected != null) {
                if (selected.length > maxAllergy ||
                    selected.length < minAllergy) {
                  // Show snackbar if more than 5 allergies are selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Bạn chỉ có thể chọn dị ứng trong khoảng $minAllergy - $maxAllergy dị ứng!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  setState(() {
                    _model.selectedAllergyIds = selected;
                    _model.allergies = selected.map((id) {
                      return allergies
                          .firstWhere((allergy) =>
                              int.tryParse(allergy['id'].toString()) ==
                              id)['title']
                          .toString();
                    }).toList();
                    isEdited = true;
                  });
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _model.allergies.isNotEmpty
                          ? _model.allergies.join(', ')
                          : 'Chưa chọn dị ứng',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDiseaseSelector(List<Map<String, dynamic>> diseases) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bệnh nền',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          GestureDetector(
            onTap: () async {
              final selected = await showDialog<List<int>>(
                context: context,
                builder: (BuildContext context) {
                  return MultiSelectDialog(
                    backgroundColor: Colors.white,
                    items: diseases.map((disease) {
                      return MultiSelectItem<int>(
                          int.tryParse(disease['id'].toString()) ?? 0,
                          disease['title']);
                    }).toList(),
                    selectedColor: FlutterFlowTheme.of(context).primary,
                    initialValue: List<int>.from(_model.selectedDiseaseIds),
                  );
                },
              );

              if (selected != null) {
                if (selected.length > maxDisease ||
                    selected.length < minDisease) {
                  // Show snackbar if more than 5 allergies are selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Bạn chỉ có thể chọn bệnh trong khoảng $minDisease - $maxDisease bệnh!"),
                        backgroundColor: Colors.red),
                  );
                } else {
                  setState(() {
                    _model.selectedDiseaseIds = selected;
                    _model.diseases = selected.map((id) {
                      return diseases
                          .firstWhere((disease) =>
                              int.tryParse(disease['id'].toString()) ==
                              id)['title']
                          .toString();
                    }).toList();
                    isEdited = true;
                  });
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _model.diseases.isNotEmpty
                          ? _model.diseases.join(', ')
                          : 'Chưa chọn bệnh',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          )
        ],
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

  Widget _buildDietStylePickerRow(String title, String value,
      List<String> options, Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
}
