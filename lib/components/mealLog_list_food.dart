import 'dart:convert';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/services/meallog_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/food_service.dart';
import '../services/models/food.dart';
import 'mealLog_food_detail.dart';

class MealLogListFoodWidget extends StatefulWidget {
  final DateTime selectedDate;
  final String mealName; // ví dụ: "Breakfast", "Lunch", v.v.

  const MealLogListFoodWidget({
    Key? key,
    required this.selectedDate,
    required this.mealName,
  }) : super(key: key);

  @override
  _MealLogListFoodWidgetState createState() => _MealLogListFoodWidgetState();
}

class _MealLogListFoodWidgetState extends State<MealLogListFoodWidget> {
  final FoodService _foodService = FoodService();
  final MeallogService _meallogService = MeallogService();
  late Future<List<Food>> _foodFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods({String? search}) async {
    final query = (search == null || search.isEmpty) ? "" : search;
    setState(() {
      _foodFuture = _foodService.getAllFoods(
        pageIndex: 1,
        pageSize: 50,
        search: query,
      );
    });
  }

  void _addToMealLog(Food food) {
    _showQuantityDialog(food);
  }

  void _showQuantityDialog(Food food) {
    final TextEditingController _quantityController =
        TextEditingController(text: "1");
    final primaryColor = FlutterFlowTheme.of(context).primary;

    showDialog(
      context: context,
      builder: (context) {
        // Dùng StatefulBuilder để có thể cập nhật UI bên trong dialog
        return StatefulBuilder(
          builder: (context, setState) {
            int quantity = int.tryParse(_quantityController.text) ?? 1;

            void updateQuantity(int newQty) {
              if (newQty < 1) return;
              _quantityController.text = newQty.toString();
              setState(() {}); // rebuild phần UI số lượng
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text("Thêm ${food.foodName}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (food.servingSize != null && food.servingSize!.isNotEmpty)
                    Text("Serving Size: ${food.servingSize}"),
                  const SizedBox(height: 12),

                  // === Thay đổi UI ở đây ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút trừ
                      InkWell(
                        onTap: () => updateQuantity(quantity - 1),
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.remove, color: primaryColor),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Hiển thị số lượng
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Nút cộng
                      InkWell(
                        onTap: () => updateQuantity(quantity + 1),
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.add, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  // ===========================
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, // màu chữ
                  ),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: primaryColor),
                    ),
                  ),
                  onPressed: () async {
                    // Lấy lại quantity từ controller
                    final int qty = int.tryParse(_quantityController.text) ?? 1;
                    // --- giữ nguyên toàn bộ logic cũ từ đây ---
                    final int additionalCalories =
                        ((food.calories ?? 0) * qty).toInt();

                    final bool exceeds = await _meallogService.calorieEstimator(
                      logDate: widget.selectedDate.toIso8601String(),
                      additionalCalories: additionalCalories,
                    );

                    if (exceeds) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: const Text('Cảnh báo'),
                          content: const Text(
                            'Đã vượt lượng Calories mục tiêu. Bạn có chắc muốn thêm?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black, // màu chữ
                              ),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: primaryColor),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Đồng ý'),
                            ),
                          ],
                        ),
                      );
                      if (confirm != true) return;
                    }

                    final resp = await _foodService.checkFoodAvoidance(
                      foodId: food.foodId,
                      context: context,
                    );
                    if (resp.statusCode == 200) {
                      final msg = jsonDecode(resp.body)['message'] ?? '';
                      if (msg.isNotEmpty) {
                        final confirmAvoid = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            title: const Text('Cảnh báo'),
                            content: Text(msg),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: primaryColor),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Đồng ý'),
                              ),
                            ],
                          ),
                        );
                        if (confirmAvoid != true) return;
                      }
                    }

                    final success = await _meallogService.createMealLog(
                      logDate: widget.selectedDate.toIso8601String(),
                      mealType: widget.mealName,
                      servingSize: food.servingSize ?? "",
                      foodId: food.foodId,
                      quantity: qty,
                    );

                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Thêm "${food.foodName}" vào ${_translateMealName(widget.mealName)} thành công!',
                          ),
                        ),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Lỗi khi thêm món ăn. Vui lòng thử lại!"),
                        ),
                      );
                    }
                  },
                  child: const Text("Xác nhận"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _translateMealName(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return 'Bữa Sáng';
      case 'lunch':
        return 'Bữa Trưa';
      case 'dinner':
        return 'Bữa Tối';
      case 'snack':
        return 'Bữa Phụ';
      default:
        return meal;
    }
  }

  Future<void> _openFoodDetail(Food food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealLogFoodDetailWidget(foodId: food.foodId),
      ),
    );
    if (result == true) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlutterFlowTheme.of(context).primary;
    final title = 'Thêm món vào ${_translateMealName(widget.mealName)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (v) => _fetchFoods(search: v),
              decoration: InputDecoration(
                hintText: 'Tìm món ăn',
                hintStyle: TextStyle(color: primaryColor.withOpacity(0.6)),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: primaryColor),
                  onPressed: () {
                    _searchController.clear();
                    _fetchFoods(search: "");
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),

          // Danh sách món ăn
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: _foodFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Lỗi: ${snap.error}'));
                }
                final foods = snap.data ?? [];
                if (foods.isEmpty) {
                  return const Center(child: Text('Không tìm thấy món ăn.'));
                }
                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, i) {
                    final food = foods[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            (food.imageUrl != null && food.imageUrl!.isNotEmpty)
                                ? NetworkImage(food.imageUrl!)
                                : null,
                        child: (food.imageUrl == null || food.imageUrl!.isEmpty)
                            ? const Icon(Icons.fastfood)
                            : null,
                      ),
                      title: Text(food.foodName),
                      subtitle: Text(
                        '${food.calories?.toStringAsFixed(0) ?? "0"} cal • '
                        '${food.servingSize ?? "1 serving"}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add, color: primaryColor),
                        onPressed: () => _addToMealLog(food),
                      ),
                      onTap: () => _openFoodDetail(food),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
