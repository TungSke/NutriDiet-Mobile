import 'package:flutter/material.dart';
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
                        _buildTextField('Tên đầy đủ', _model.fullNameController),
                        const SizedBox(height: 20.0),
                        _buildDatePicker(context),
                        const SizedBox(height: 20.0),
                        _buildGenderSelector(),
                        const SizedBox(height: 20.0),
                        _buildTextField('Địa chỉ', _model.locationController),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label không được để trống';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.all(16.0),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
        ),
        Text(label),
      ],
    );
  }
}
