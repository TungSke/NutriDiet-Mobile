import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _model = EditHealthProfileScreenModel();

    Future.delayed(Duration.zero, () async {
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
            _buildProfilePhoto(),
            _model.isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    bool canUpdate = _model.height != 0 &&
        _model.weight != 0 &&
        _model.activityLevel.isNotEmpty;

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
            'Chỉnh sửa hồ sơ sức khỏe',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: isEdited && canUpdate
                ? () async {
                    await _model
                        .updateHealthProfile(context); // Pass context here
                    setState(() {
                      isEdited = false;
                    });
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
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          TextButton(
            onPressed: () {},
            child:
                Text('Đặt ảnh đại diện', style: TextStyle(color: Colors.green)),
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
          _buildHeightRow('Height', _model.height, (val) {
            setState(() {
              _model.height = int.tryParse(val) ?? 0;
              isEdited = true;
            });
          }),
          _buildWeightRow('Weight', _model.weight, (val) {
            setState(() {
              _model.weight = int.tryParse(val) ?? 0;
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
        ],
      ),
    );
  }

  // 🟢 Ô nhập liệu cho chiều cao
  Widget _buildHeightRow(String title, int value, Function(String) onChanged) {
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập chiều cao (cm)',
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

  // 🟢 Ô nhập liệu cho cân nặng
  Widget _buildWeightRow(String title, int value, Function(String) onChanged) {
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập cân nặng (kg)',
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
                    .toList(),
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
