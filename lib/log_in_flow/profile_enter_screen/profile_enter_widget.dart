import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'profile_enter_model.dart';

class ProfileEnterWidget extends StatefulWidget {
  const ProfileEnterWidget({super.key});

  @override
  State<ProfileEnterWidget> createState() => _ProfileEnterWidgetState();
}

class _ProfileEnterWidgetState extends State<ProfileEnterWidget> {
  late ProfileEnterModel _model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = ProfileEnterModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              const AppbarWidget(title: 'Nhập thông tin cá nhân'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfilePhoto(),
                        _buildTextField('Tên đầy đủ', _model.fullNameController,
                            _model.fullNameFocusNode),
                        const SizedBox(height: 20.0),
                        _buildDatePicker(context),
                        const SizedBox(height: 20.0),
                        _buildGenderSelector(),
                        const SizedBox(height: 20.0),
                        _buildTextField('Địa chỉ', _model.locationController,
                            _model.locationFocusNode),
                        const SizedBox(height: 30.0),
                        FFButtonWidget(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _model.updateUserProfile(context);
                            }
                          },
                          text: 'Tiếp tục',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 54.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(String label, TextEditingController controller) {
  //   return TextFormField(
  //     controller: controller,
  //     validator: (value) {
  //       if (value == null || value.trim().isEmpty) {
  //         return '$label không được để trống';
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
  //       contentPadding: const EdgeInsets.all(16.0),
  //     ),
  //   );
  // }
  Widget _buildTextField(
      String label, TextEditingController controller, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label không được để trống';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: focusNode.hasFocus
              ? FlutterFlowTheme.of(context).primary
              : Colors.black, // Màu chữ khi focus
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: FlutterFlowTheme.of(context)
                  .primary), // Đổi màu khi focus vào
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  // Widget _buildDatePicker(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async {
  //       DateTime? pickedDate = await showDatePicker(
  //         locale: const Locale('vi', 'VN'),
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(1900),
  //         lastDate: DateTime.now(),
  //       );
  //       if (pickedDate != null) {
  //         setState(() {
  //           _model.birthDate = pickedDate;
  //         });
  //       }
  //     },
  //     child: InputDecorator(
  //       decoration: InputDecoration(
  //         labelText: 'Ngày sinh',
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
  //         contentPadding: const EdgeInsets.all(16.0),
  //       ),
  //       child: Text(
  //         _model.birthDate != null
  //             ? DateFormat('dd/MM/yyyy').format(_model.birthDate!)
  //             : 'Chọn ngày sinh',
  //         style: const TextStyle(fontSize: 16.0),
  //       ),
  //     ),
  //   );
  // }
  // Để sử dụng File

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
                });
              }
            },
            child: Text('Chọn ảnh', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          locale: const Locale('vi', 'VN'),
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: FlutterFlowTheme.of(context)
                    .primary, // Màu sắc của nút chọn
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: FlutterFlowTheme.of(context)
                        .primary, // Màu chữ của nút OK
                  ),
                ),
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(primary: FlutterFlowTheme.of(context).primary),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _model.birthDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Ngày sinh',
          labelStyle: TextStyle(
            color: Colors.black, // Màu chữ khi chưa focus
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.green), // Màu viền khi focus
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.all(16.0),
        ),
        child: Text(
          _model.birthDate != null
              ? DateFormat('dd/MM/yyyy').format(_model.birthDate!)
              : 'Chọn ngày sinh',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Giới tính', style: TextStyle(fontSize: 16.0)),
        Row(
          children: [
            _buildRadioOption('Nam', 'Male'),
            _buildRadioOption('Nữ', 'Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _model.gender,
          onChanged: (newValue) {
            setState(() {
              _model.gender = newValue!;
            });
          },
          activeColor: FlutterFlowTheme.of(context).primary, // Đổi màu khi chọn
        ),
        Text(label),
      ],
    );
  }
}
