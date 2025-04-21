import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/systemconfiguration_service.dart';
import 'edit_profile_screen_model.dart';

class EditProfileScreenWidget extends StatefulWidget {
  const EditProfileScreenWidget({super.key});

  @override
  State<EditProfileScreenWidget> createState() =>
      _EditProfileScreenWidgetState();
}

class _EditProfileScreenWidgetState extends State<EditProfileScreenWidget> {
  late EditProfileScreenModel _model;
  bool isEdited = false;
  String _tempSelectedValue = '';
  late int minAge = 13; // Mặc định minWeight
  late int maxAge = 100; // Mặc định maxWeight
  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();

  Future<void> _getConfigValuesFromApi() async {
    try {
      // Lấy min/max height từ API
      final responseHeight = await _systemConfigService.getSystemConfigById(1);
      final ageConfig = responseHeight['data'];
      minAge = ageConfig['minValue'] ?? 13;
      maxAge = ageConfig['maxValue'] ?? 100;

      // Lấy min/max weight từ API

      setState(() {}); // Cập nhật UI sau khi lấy dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy cấu hình: $e");
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    _model = EditProfileScreenModel();

    Future.delayed(Duration.zero, () async {
      await _model.fetchUserProfile();
      await _getConfigValuesFromApi();
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
    bool canUpdate = _model.name.isNotEmpty &&
        _model.location.isNotEmpty &&
        _model.gender.isNotEmpty &&
        _model.age.isNotEmpty;

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
          Flexible(
            child: Text(
              'Chỉnh sửa hồ sơ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: isEdited &&
                    canUpdate // ✅ Only allow update if all fields are filled
                ? () async {
                    await _model.updateUserProfile();

                    setState(() {
                      isEdited = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cập nhật thành công!"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context, true);
                  }
                : null, // ✅ Disable button if fields are empty
            child: Icon(
              Icons.check,
              color: (isEdited && canUpdate)
                  ? Colors.green
                  : Colors.grey, // ✅ Disable if not valid
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
            backgroundImage: _model.avatar.isNotEmpty
                ? FileImage(File(
                    _model.avatar)) // Sử dụng FileImage thay vì NetworkImage
                : null,
            child: _model.avatar.isEmpty
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          TextButton(
            onPressed: () async {
              // Sử dụng ImagePicker để chọn ảnh
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

              if (pickedFile != null) {
                // Cập nhật avatar và trạng thái đã thay đổi
                setState(() {
                  _model.avatar = pickedFile.path;
                  isEdited = true;
                });
              }
            },
            child: Text('Chọn ảnh', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  /// 🟢 Hiển thị Loading khi chưa tải dữ liệu
  Widget _buildLoadingIndicator() {
    return Expanded(child: Center(child: CircularProgressIndicator()));
  }

  /// 🟢 Form thông tin cá nhân
  /// 🟢 Form to display editable user details
  /// 🟢 Form thông tin cá nhân
  Widget _buildProfileForm() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildEditableRow(
            'Tên của bạn',
            _model.name,
            (val) {
              setState(() {
                _model.name = val;
                isEdited = true;
              });
            },
            _model.name.isEmpty
                ? "Tên không được để trống"
                : null, // ✅ Show error
          ),
          _buildPickerRow(
            'Giới tính',
            _model.gender,
            ['Nam', 'Nữ'],
            (val) {
              setState(() {
                _model.gender = val;
                isEdited = true;
              });
            },
          ),
          _buildPickerRow(
            'Tuổi ',
            _model.age,
            _generateAgeList(),
            (val) {
              setState(() {
                _model.age = val;
                isEdited = true;
              });
            },
          ),
          _buildEditableRow(
            'Địa chỉ',
            _model.location,
            (val) {
              setState(() {
                _model.location = val;
                isEdited = true;
              });
            },
            _model.location.isEmpty
                ? "Địa chỉ không được để trống"
                : null, // ✅ Show error
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String title, String value,
      Function(String) onChanged, String? errorText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              SizedBox(
                width: 150,
                child: TextFormField(
                  initialValue: value,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: errorText, // ✅ Show error message
                  ),
                  onChanged: (val) {
                    if (val.trim().isEmpty) {
                      val = ""; // ✅ Keep empty instead of defaulting
                    }
                    onChanged(val);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🟢 Ô chọn dữ liệu bằng Bottom Picker
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

  /// 🟢 Hiển thị Bottom Picker (Chỉ thay đổi khi nhấn "DONE")
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

  /// 🟢 Tạo danh sách tuổi từ 10 đến 100
  List<String> _generateAgeList() {
    return List.generate((maxAge - minAge + 1), (index) => '${minAge + index}');
  }
}
