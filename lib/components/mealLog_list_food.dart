import 'dart:convert';

import 'package:diet_plan_app/services/meallog_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/food_service.dart';
import '../services/models/food.dart';
import 'mealLog_food_detail.dart';

class MealLogListFoodWidget extends StatefulWidget {
  final DateTime selectedDate;
  final String mealName;

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
      _foodFuture =
          _foodService.getAllFoods(pageIndex: 1, pageSize: 50, search: query);
    });
    print("Fetching foods with search query: $query");
  }

  /// Thêm món ăn vào MealLog trực tiếp (khi bấm icon `+`)
  void _addToMealLog(Food food) {
    _showQuantityDialog(food);
  }

  /// Hiển thị dialog cho phép nhập số lượng
  void _showQuantityDialog(Food food) {
    final TextEditingController _quantityController =
        TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thêm ${food.foodName}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (food.servingSize != null && food.servingSize!.isNotEmpty)
              Text("Serving Size: ${food.servingSize}"),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số lượng",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              // 1) Lấy số lượng nhập vào
              final int quantity = int.tryParse(_quantityController.text) ?? 1;
              // 2) Tính thêm Calories
              final int additionalCalories =
                  ((food.calories ?? 0) * quantity).toInt();

              // 3) Check vượt Calories
              final bool exceedsCalories =
                  await _meallogService.calorieEstimator(
                logDate: widget.selectedDate.toIso8601String(),
                additionalCalories: additionalCalories,
              );

              // Nếu vượt Calories, hỏi người dùng
              if (exceedsCalories) {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cảnh báo'),
                    content: const Text(
                      'Đã vượt lượng Calories mục tiêu. Bạn có chắc muốn thêm?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Đồng ý'),
                      ),
                    ],
                  ),
                );
                if (confirm != true) {
                  // Người dùng không đồng ý
                  Navigator.pop(context);
                  return;
                }
              }
              final Response avoidMessage =
                  await _foodService.checkFoodAvoidance(
                foodId: food.foodId,
                context: context,
              );
              if (avoidMessage.statusCode == 200) {
                final jsonData = jsonDecode(avoidMessage.body);
                final String message = jsonData['message'] ?? '';
                if (message.isNotEmpty) {
                  final bool? confirmAvoid = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cảnh báo'),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Đồng ý'),
                        ),
                      ],
                    ),
                  );
                  if (confirmAvoid != true) {
                    // Người dùng không đồng ý thêm món ăn cần tránh
                    Navigator.pop(context);
                    return;
                  }
                }
              }

              // 5) Nếu không vượt calories hoặc người dùng đồng ý vượt
              // và không phải món cần tránh (hoặc vẫn đồng ý thêm),
              // thì cuối cùng gọi hàm thêm vào MealLog
              final bool success = await _meallogService.createMealLog(
                logDate: widget.selectedDate.toIso8601String(),
                mealType: widget.mealName,
                servingSize: food.servingSize ?? "",
                foodId: food.foodId,
                quantity: quantity,
              );

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Thêm "${food.foodName}" vào ${widget.mealName} thành công!',
                    ),
                  ),
                );
                // Pop màn hình SearchFood, trả về true để MealLogScreen refresh
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lỗi khi thêm món ăn. Vui lòng thử lại!"),
                  ),
                );
              }
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  /// Mở màn hình chi tiết Food (MealLogFoodDetailWidget)
  /// Nếu ở màn hình chi tiết user thêm món thành công => trả về true
  /// => Ta cũng pop màn hình search này về MealLogScreen.
  Future<void> _openFoodDetail(Food food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealLogFoodDetailWidget(
          foodId: food.foodId,
        ),
      ),
    );
    if (result == true) {
      // Màn hình FoodDetail báo thành công => pop SearchFood
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm món vào ${widget.mealName}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _fetchFoods(search: value),
              decoration: InputDecoration(
                hintText: 'Tìm món ăn',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchFoods(search: "");
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Hiển thị danh sách món ăn
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: _foodFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không tìm thấy món ăn.'));
                } else {
                  final foods = snapshot.data!;
                  return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: (food.imageUrl != null &&
                                  food.imageUrl!.isNotEmpty)
                              ? NetworkImage(food.imageUrl!)
                              : null,
                          child:
                              (food.imageUrl == null || food.imageUrl!.isEmpty)
                                  ? const Icon(Icons.fastfood)
                                  : null,
                        ),
                        title: Text(food.foodName),
                        subtitle: Text(
                          '${food.calories?.toStringAsFixed(0) ?? "0"} cal • '
                          '${food.servingSize ?? "1 serving"}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addToMealLog(food),
                        ),
                        onTap: () {
                          // Mở màn hình chi tiết
                          _openFoodDetail(food);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
