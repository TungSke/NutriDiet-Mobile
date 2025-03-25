// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'edit_personal_goal_screen_model.dart';
//
// class EditPersonalGoalScreenWidget extends StatefulWidget {
//   const EditPersonalGoalScreenWidget({super.key});
//
//   @override
//   State<EditPersonalGoalScreenWidget> createState() =>
//       _EditPersonalGoalScreenWidgetState();
// }
//
// class _EditPersonalGoalScreenWidgetState
//     extends State<EditPersonalGoalScreenWidget> {
//   late EditPersonalGoalScreenModel _model;
//   bool isEdited = false;
//   String _tempSelectedValue = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _model = EditPersonalGoalScreenModel();
//
//     Future.delayed(Duration.zero, () async {
//       await _model.fetchPersonalGoal();
//       await _model.fetchHealthProfile();
//       await _model.fetchUserProfile();
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
//     bool canUpdate = _model.goalType.isNotEmpty &&
//         _model.targetWeight != 0 &&
//         _model.weightChangeRate.isNotEmpty;
//
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
//             'Chỉnh sửa mục tiêu cá nhân',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           InkWell(
//             onTap: isEdited && canUpdate
//                 ? () async {
//                     await _model
//                         .updatePersonalGoal(context); // Pass context here
//                     setState(() {
//                       isEdited = false;
//                     });
//
//                     // Success message is already handled in the update method
//                   }
//                 : null,
//             child: Icon(
//               Icons.check,
//               color: (isEdited && canUpdate) ? Colors.green : Colors.grey,
//               size: 28,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfilePhoto() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
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
//           _buildPickerRow(
//             'Mục tiêu',
//             _model.goalType,
//             ['Giữ cân', 'Tăng cân', 'Giảm cân'],
//             (val) {
//               setState(() {
//                 _model.goalType = val;
//                 isEdited = true;
//               });
//             },
//           ),
//           // Nếu goalType là "Giữ cân", ẩn các trường targetWeight và weightChangeRate
//           if (_model.goalType != 'Giữ cân') ...[
//             _buildTargetWeightRow('Mục tiêu cân nặng (kg)', _model.targetWeight,
//                 (val) {
//               setState(() {
//                 _model.targetWeight = int.tryParse(val) ?? 0;
//                 isEdited = true;
//               });
//             }),
//             _buildPickerRow(
//               'Mức độ thay đổi cân nặng',
//               _model.weightChangeRate,
//               [
//                 'Giữ cân',
//                 'Tăng 0.25kg/1 tuần',
//                 'Tăng 0.5kg/1 tuần',
//                 'Giảm 0.25Kg/1 tuần',
//                 'Giảm 0.5Kg/1 tuần',
//                 'Giảm 0.75Kg/1 tuần',
//                 'Giảm 1Kg/1 tuần'
//               ],
//               (val) {
//                 setState(() {
//                   _model.weightChangeRate = val;
//                   isEdited = true;
//                 });
//               },
//             ),
//           ],
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
//   Widget _buildTargetWeightRow(
//       String title, int value, Function(String) onChanged) {
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
//                 hintText: 'Nhập cân nặng (kg) ',
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

import '../../flutter_flow/flutter_flow_theme.dart';
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

  @override
  void initState() {
    super.initState();
    _model = EditPersonalGoalScreenModel();

    Future.delayed(Duration.zero, () async {
      await _model.fetchUserProfile();
      await _model.fetchPersonalGoal();
      await _model.fetchHealthProfile();

      setState(() {}); // 🚀 Cập nhật UI ngay sau khi fetch dữ liệu
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
                        // Nếu có avatar từ API, sử dụng Image.network
                        _model.avatar,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        // Nếu không có avatar, sử dụng hình mặc định
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
    bool canUpdate = _model.goalType.isNotEmpty &&
        _model.targetWeight != 0 &&
        _model.weightChangeRate.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.arrow_back, size: 28),
          ),
          Text(
            'Chỉnh sửa mục tiêu cá nhân',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: isEdited && canUpdate
                ? () async {
                    await _model
                        .updatePersonalGoal(context); // Pass context here
                    setState(() {
                      isEdited = false;
                    });

                    // Success message is already handled in the update method
                  }
                : null,
            child: Icon(
              Icons.check,
              color: (isEdited && canUpdate) ? Colors.green : Colors.grey,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Expanded(child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildProfileForm() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
          // Nếu goalType là "Giữ cân", ẩn các trường targetWeight và weightChangeRate
          if (_model.goalType != 'Giữ cân') ...[
            _buildTargetWeightRow('Mục tiêu cân nặng (kg)', _model.targetWeight,
                (val) {
              setState(() {
                _model.targetWeight =
                    double.tryParse(val) ?? 0.0; // Chuyển từ int sang double
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
    );
  }

  Widget _buildPickerRow(String title, String value, List<String> options,
      Function(String) onSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(
            onTap: () =>
                _showCupertinoPicker(title, options, value, onSelected),
            child: Row(
              children: [
                Text(value, style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(
            onTap: () =>
                _showCupertinoPicker(title, options, value, onSelected),
            child: Row(
              children: [
                Text(value, style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWeightRow(
      String title, double value, Function(String) onChanged) {
    // Chỉnh sửa thành double
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(
            width: 150,
            child: TextFormField(
              initialValue: value.toString(),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.numberWithOptions(
                  decimal: true), // Cho phép nhập số thập phân
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập cân nặng (kg) ',
              ),
              onChanged: (val) {
                onChanged(val);
              },
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedIndex),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  _tempSelectedValue = options[index];
                },
                children: options
                    .map((e) =>
                        Center(child: Text(e, style: TextStyle(fontSize: 16))))
                    .toList(), // Convert Iterable<Center> to List<Widget>
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
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
                child: Text("DONE",
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
