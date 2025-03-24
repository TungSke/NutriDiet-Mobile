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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealDetail.foodName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (mealDetail.imageUrl != null &&
                      mealDetail.imageUrl!.isNotEmpty)
                    Image.network(mealDetail.imageUrl ?? ""),
                  const SizedBox(height: 10),
                  Text("Serving: ${mealDetail.servingSize}"),
                  Text("Quantity: ${mealDetail.quantity}"),
                  const SizedBox(height: 10),
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final int calories =
                            int.parse(_calorieController!.text);
                        final int protein = int.parse(_proteinController!.text);
                        final int carbs = int.parse(_carbsController!.text);
                        final int fat = int.parse(_fatController!.text);

                        bool result =
                            await mealLogService.updateMealLogDetailNutrition(
                          detailId: widget.detailId,
                          calorie: calories,
                          protein: protein,
                          carbs: carbs,
                          fat: fat,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result
                                ? 'Update thành công'
                                : 'Update thất bại'),
                          ),
                        );
                      }
                    },
                    child: const Text("Cập nhật dinh dưỡng"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Giả sử bạn có File imageFile từ thư viện hay máy ảnh
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
                ],
              ),
            ),
          );
        },
      ),
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
