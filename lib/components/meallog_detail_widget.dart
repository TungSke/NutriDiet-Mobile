import 'dart:io';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết'),
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

          // Khởi tạo các controller nếu chưa có, dùng giá trị lấy từ API
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
                // Tên món và khẩu phần ở phía trên
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tên món ăn
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
                    // Khẩu phần (Serving/Quantity)
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

                // Tiêu đề phần "Thành phần món"
                const Text(
                  "Thành phần món",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Hiển thị tóm tắt dinh dưỡng (Calories, Protein, Carbs, Fat)
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

                // Form cập nhật chi tiết dinh dưỡng
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _calorieController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Calories (kcal)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập calories';
                          }
                          if (int.tryParse(value) == null) {
                            return "Nhập số hợp lệ";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _proteinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Protein (g)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập protein';
                          }
                          if (int.tryParse(value) == null) {
                            return "Nhập số hợp lệ";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _carbsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Carbs (g)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập carbs';
                          }
                          if (int.tryParse(value) == null) {
                            return "Nhập số hợp lệ";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _fatController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Fat (g)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập fat';
                          }
                          if (int.tryParse(value) == null) {
                            return "Nhập số hợp lệ";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Nút cập nhật
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final int calories =
                                int.parse(_calorieController!.text);
                            final int protein =
                                int.parse(_proteinController!.text);
                            final int carbs = int.parse(_carbsController!.text);
                            final int fat = int.parse(_fatController!.text);

                            bool result = await mealLogService
                                .updateMealLogDetailNutrition(
                              detailId: widget.detailId,
                              calorie: calories,
                              protein: protein,
                              carbs: carbs,
                              fat: fat,
                            );
                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Update thành công'),
                                ),
                              );
                              // Khi update thành công, pop màn hình và trả về kết quả true
                              Navigator.pop(context, true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Update thất bại'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Cập nhật dinh dưỡng"),
                      ),

                      // Nút upload ảnh chỉ hiển thị khi không có ảnh
                      if (mealDetail.imageUrl == null ||
                          mealDetail.imageUrl!.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Ví dụ mô phỏng upload ảnh từ File
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
                            child: const Text("Thêm ảnh"),
                          ),
                        ),
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

  /// Widget con hiển thị từng chỉ số dinh dưỡng
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

  @override
  void dispose() {
    _calorieController?.dispose();
    _proteinController?.dispose();
    _carbsController?.dispose();
    _fatController?.dispose();
    super.dispose();
  }
}
