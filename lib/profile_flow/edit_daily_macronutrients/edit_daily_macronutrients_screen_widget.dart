import 'package:diet_plan_app/profile_flow/edit_daily_macronutrients/edit_daily_macronutrients_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class EditDailyMacronutrientsScreenWidget extends StatefulWidget {
  const EditDailyMacronutrientsScreenWidget({super.key});

  @override
  State<EditDailyMacronutrientsScreenWidget> createState() =>
      _EditDailyMacronutrientsScreenWidgetState();
}

class _EditDailyMacronutrientsScreenWidgetState
    extends State<EditDailyMacronutrientsScreenWidget> {
  late EditDailyMacronutrientsScreenModel _model;
  bool isEdited = false;
  String _tempSelectedValue = '';

  @override
  @override
  void initState() {
    super.initState();
    _model = EditDailyMacronutrientsScreenModel();

    Future.delayed(Duration.zero, () async {
      await _model.fetchPersonalGoal();
      await _model.fetchHealthProfile();
      await _model.fetchUserProfile();
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
            _buildProfilePhoto(),
            _model.isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
          ],
        ),
      ),
    );
  }

  /// 🟢 Header với nút back mượt
  /// 🟢 Header với nút back từ MyProfileWidget
  Widget _buildHeader() {
    bool canUpdate =
        _model.dailyCarb > 0 && _model.dailyProtein > 0 && _model.dailyFat > 0;

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
                    await _model.updateDailyMacronutrients(
                        context); // Pass context here
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

  Widget _buildProfilePhoto() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
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
                      style:
                          GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
                ],
              ),
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
          // _buildEditableRow(
          //   'Protein',
          //   _model.dailyProtein,
          //   (val) {
          //     setState(() {
          //       _model.dailyProtein = val;
          //       isEdited = true;
          //     });
          //   },
          //   _model.dailyProtein == 0
          //       ? "Protein không được để trống"
          //       : null, // ✅ Show error if protein is 0
          // ),
          _buildDailyProteinRow('Protein (g)', _model.dailyProtein.toString(),
              (val) {
            setState(() {
              _model.dailyProtein = double.tryParse(val) ?? 0.0;
              isEdited = true;
            });
          }),
          _buildDailyCarbRow('Carb (g)', _model.dailyCarb.toString(), (val) {
            setState(() {
              _model.dailyCarb = double.tryParse(val) ?? 0.0;
              isEdited = true;
            });
          }),
          _buildDailyFatRow('Fat (g)', _model.dailyFat.toString(), (val) {
            setState(() {
              _model.dailyFat = double.tryParse(val) ?? 0.0;
              isEdited = true;
            });
          }),
          // _buildEditableRow(
          //   'Carb',
          //   _model.dailyCarb,
          //   (val) {
          //     setState(() {
          //       _model.dailyCarb = val;
          //       isEdited = true;
          //     });
          //   },
          //   _model.dailyCarb == 0
          //       ? "Carb không được để trống"
          //       : null, // ✅ Show error if carb is 0
          // ),
          // _buildEditableRow(
          //   'Fat',
          //   _model.dailyFat,
          //   (val) {
          //     setState(() {
          //       _model.dailyFat = val;
          //       isEdited = true;
          //     });
          //   },
          //   _model.dailyFat == 0
          //       ? "Fat không được để trống"
          //       : null, // ✅ Show error if fat is 0
          // ),
        ],
      ),
    );
  }

  Widget _buildDailyProteinRow(
      String title, String value, Function(String) onChanged) {
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
              initialValue: value,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập g',
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

  Widget _buildDailyCarbRow(
      String title, String value, Function(String) onChanged) {
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
              initialValue: value,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập g',
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

  Widget _buildDailyFatRow(
      String title, String value, Function(String) onChanged) {
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
              initialValue: value,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập g',
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

  Widget _buildEditableRow(
      String title, int value, Function(int) onChanged, String? errorText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                width: 150,
                child: TextFormField(
                  // Convert the int value to string for TextFormField's initialValue
                  initialValue: value.toString(),
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: errorText, // ✅ Show error message
                  ),
                  onChanged: (val) {
                    // Convert the value back to int and pass it to the onChanged function
                    if (val.isNotEmpty) {
                      onChanged(int.parse(val));
                    } else {
                      onChanged(
                          0); // Handle empty input by setting a default value
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
