import 'dart:io';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/services/meallog_service.dart';
import 'package:diet_plan_app/services/models/meallog.dart';
import 'package:flutter/material.dart';

class MealLogDetailWidget extends StatefulWidget {
  final int detailId;

  const MealLogDetailWidget({Key? key, required this.detailId})
      : super(key: key);

  @override
  _MealLogDetailWidgetState createState() => _MealLogDetailWidgetState();
}

class _MealLogDetailWidgetState extends State<MealLogDetailWidget> {
  final MeallogService mealLogService = MeallogService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _calorieController;
  TextEditingController? _proteinController;
  TextEditingController? _carbsController;
  TextEditingController? _fatController;

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chi tiết',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: FutureBuilder<MealLogDetail?>(
        future: mealLogService.getMealLogDetail(detailId: widget.detailId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          final mealDetail = snapshot.data;
          if (mealDetail == null) {
            return const Center(child: Text("Không tìm thấy dữ liệu"));
          }

          // Khởi tạo controllers
          _calorieController ??=
              TextEditingController(text: mealDetail.calories.toString());
          _proteinController ??=
              TextEditingController(text: mealDetail.protein.toString());
          _carbsController ??=
              TextEditingController(text: mealDetail.carbs.toString());
          _fatController ??=
              TextEditingController(text: mealDetail.fat.toString());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên món và khẩu phần
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mealDetail.foodName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${mealDetail.servingSize}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Ảnh hoặc icon upload
                Center(
                  child: (mealDetail.imageUrl != null &&
                          mealDetail.imageUrl!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            mealDetail.imageUrl!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            // Mở dialog / flow để upload ảnh
                          },
                        ),
                ),

                const SizedBox(height: 16),

                // Thành phần món
                const Text(
                  "Thành phần món",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNutritionItem("Calories", _calorieController!.text),
                    _buildNutritionItem("Protein", _proteinController!.text),
                    _buildNutritionItem("Carbs", _carbsController!.text),
                    _buildNutritionItem("Fat", _fatController!.text),
                  ],
                ),

                const SizedBox(height: 20),

                // Form cập nhật
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _calorieController!,
                        label: "Calories (kcal)",
                        primaryColor: Colors.black,
                      ),
                      _buildTextField(
                        controller: _proteinController!,
                        label: "Protein (g)",
                        primaryColor: Colors.black,
                      ),
                      _buildTextField(
                        controller: _carbsController!,
                        label: "Carbs (g)",
                        primaryColor: Colors.black,
                      ),
                      _buildTextField(
                        controller: _fatController!,
                        label: "Fat (g)",
                        primaryColor: Colors.black,
                      ),

                      const SizedBox(height: 20),

                      // Nút cập nhật dinh dưỡng full width
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final calories =
                                  int.parse(_calorieController!.text);
                              final protein =
                                  int.parse(_proteinController!.text);
                              final carbs = int.parse(_carbsController!.text);
                              final fat = int.parse(_fatController!.text);

                              bool result = await mealLogService
                                  .updateMealLogDetailNutrition(
                                detailId: widget.detailId,
                                calorie: calories,
                                protein: protein,
                                carbs: carbs,
                                fat: fat,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      result ? Colors.green : Colors.red,
                                  content: Text(result
                                      ? 'Update thành công'
                                      : 'Update thất bại'),
                                ),
                              );
                              if (result) Navigator.pop(context, true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: primaryColor),
                            ),
                          ),
                          child: const Text(
                            "Cập nhật dinh dưỡng",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      // Nút upload ảnh full width
                      if (mealDetail.imageUrl == null ||
                          mealDetail.imageUrl!.isEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              File imageFile = File('path/to/your/image.jpg');
                              bool result =
                                  await mealLogService.addImageToMealLogDetail(
                                detailId: widget.detailId,
                                imageFile: imageFile,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result
                                      ? 'Upload ảnh thành công'
                                      : 'Upload ảnh thất bại'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryColor,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: primaryColor),
                              ),
                            ),
                            child: const Text(
                              "Thêm ảnh",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color primaryColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        if (int.tryParse(value) == null) {
          return "Nhập số hợp lệ";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _calorieController?.dispose();
    _proteinController?.dispose();
    _carbsController?.dispose();
    _fatController?.dispose();
    super.dispose();
  }
}
