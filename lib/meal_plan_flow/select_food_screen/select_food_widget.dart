import 'dart:convert';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_flow/brek_fast_i_ingredients/brek_fast_i_ingredients_widget.dart';
import '../../services/models/food.dart';
import '../../services/models/mealplandetail.dart';
import 'select_food_model.dart';

class SelectFoodWidget extends StatefulWidget {
  final int mealPlanId;
  final String mealType;
  final int dayNumber;
  final List<MealPlanDetail> existingMeals;

  const SelectFoodWidget({
    Key? key,
    required this.mealPlanId,
    required this.mealType,
    required this.dayNumber,
    required this.existingMeals,
  }) : super(key: key);

  @override
  _SelectFoodWidgetState createState() => _SelectFoodWidgetState();
}

class _SelectFoodWidgetState extends State<SelectFoodWidget> {
  late SelectFoodModel _model;
  final TextEditingController _searchController = TextEditingController();
  Map<int, Food> _foodCache = {};

  final Map<String, String> _mealTypeTranslations = {
    'Breakfast': 'Bữa sáng',
    'Lunch': 'Bữa trưa',
    'Dinner': 'Bữa tối',
    'Snacks': 'Bữa phụ',
  };

  String _getMealTypeInVietnamese(String mealType) {
    return _mealTypeTranslations[mealType] ?? mealType;
  }

  @override
  void initState() {
    super.initState();
    _model = SelectFoodModel();
    _model.setExistingMeals(widget.existingMeals);
    _initData();
  }

  Future<void> _initData() async {
    await _model.fetchFoods();
    await _model.fetchMealTotals(widget.mealPlanId, widget.dayNumber, widget.mealType); // Tải totalByMealType
    if (widget.existingMeals.isNotEmpty) {
      await _fetchFoodDetailsForExistingMeals();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchFoodDetailsForExistingMeals() async {
    final futures = <Future>[];
    for (var meal in widget.existingMeals) {
      if (meal.foodId != null && !_foodCache.containsKey(meal.foodId)) {
        futures.add(
          _model.foodService.getFoodById(foodId: meal.foodId!).then((response) {
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              final foodJson = data['data'] ?? data;
              final food = Food.fromJson(foodJson);
              _foodCache[meal.foodId!] = food;
            } else {
              _foodCache[meal.foodId!] = Food(
                foodId: meal.foodId!,
                foodName: meal.foodName ?? "Unknown",
                imageUrl: "",
              );
            }
          }).catchError((e) {
            _foodCache[meal.foodId!] = Food(
              foodId: meal.foodId!,
              foodName: "Error: $e",
              imageUrl: "",
            );
          }),
        );
      }
    }
    await Future.wait(futures);
  }

  Future<void> _fetchFoodDetail(int foodId) async {
    if (!_foodCache.containsKey(foodId)) {
      final response = await _model.foodService.getFoodById(foodId: foodId);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final food = Food.fromJson(data['data']);
        _foodCache[foodId] = food;
      } else {
        _foodCache[foodId] = Food(foodId: foodId, foodName: "Unknown", imageUrl: "");
      }
      if (mounted) setState(() {});
    }
  }

  void _fetchFoods({String? search}) {
    _model.fetchFoods(search: search);
  }

  void _addToMealPlan(Food food) {
    _showQuantityDialog(food);
  }

  void _showQuantityDialog(Food food) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Thêm ${food.foodName}",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (food.servingSize != null && food.servingSize!.isNotEmpty)
                Text(
                  "Khẩu phần: ${food.servingSize}",
                  style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: FlutterFlowTheme.of(context).primary),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    "$quantity",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: FlutterFlowTheme.of(context).primary),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Hủy",
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                final response = await _model.foodService.checkFoodAvoidance(
                  foodId: food.foodId!,
                  context: context,
                );
                final statusCode = response.statusCode;
                final responseData = jsonDecode(response.body);
                final message = responseData['message'] as String?;

                if (!mounted) return;

                if (statusCode == 200) {
                  await _showWarningDialog(food, message, quantity);
                } else if (statusCode == 400) {
                  await _addFoodDirectly(food, quantity);
                } else {
                  _showErrorSnackBar();
                }
              },
              child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showWarningDialog(Food food, String? message, int quantity) async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Cảnh báo",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "$message\nBạn vẫn muốn thêm món ăn này?",
          style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Hủy",
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Vẫn thêm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await _addFoodDirectly(food, quantity);
    }
  }

  Future<void> _addFoodDirectly(Food food, int quantity) async {
    final success = await _model.addFoodToMealPlan(
      mealPlanId: widget.mealPlanId,
      dayNumber: widget.dayNumber,
      mealType: widget.mealType,
      foodId: food.foodId!,
      quantity: quantity.toDouble(),
      context: context,
    );

    if (!mounted) return;

    if (success) {
      await _fetchFoodDetail(food.foodId!);
      _showSuccessDialog(food);
    } else {
      _showErrorSnackBar();
    }
  }

  void _showSuccessDialog(Food food) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Thành công",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
        content: Text(
          'Đã thêm "${food.foodName}" vào ${_getMealTypeInVietnamese(widget.mealType)}',
          style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_model.errorMessage ?? "Lỗi khi thêm món ăn hoặc kiểm tra tránh thức ăn"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _removeFromMealPlan(MealPlanDetail meal) {
    if (meal.mealPlanDetailId == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Xóa ${meal.foodName}",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
        content: Text(
          "Bạn có chắc muốn xóa ${meal.foodName} khỏi ${_getMealTypeInVietnamese(widget.mealType)}?",
          style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Hủy",
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final success = await _model.removeFoodFromMealPlan(
                meal.mealPlanDetailId!, widget.mealPlanId, widget.dayNumber, widget.mealType,
              );

              Navigator.pop(context);

              if (!mounted) return;

              if (success) {
                if (_model.existingMeals.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      title: Text(
                        "Thông báo",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      content: Text(
                        "Không còn món ăn nào trong ${_getMealTypeInVietnamese(widget.mealType)}",
                        style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      title: Text(
                        "Thành công",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      content: Text(
                        'Đã xóa "${meal.foodName}" khỏi ${_getMealTypeInVietnamese(widget.mealType)}',
                        style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "OK",
                            style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_model.errorMessage ?? "Lỗi khi xóa món ăn"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông số dinh dưỡng
  Widget _buildNutrientDisplay(String label, String value, String unit) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$label ($unit)",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          centerTitle: true,
          title: Text(
            'Chọn món cho ${_getMealTypeInVietnamese(widget.mealType)} - Ngày ${widget.dayNumber}',
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _model,
        builder: (context, child) {
          final nutrients = _model.getNutrientTotals(); // Lấy thông số dinh dưỡng
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => _fetchFoods(search: value),
                  decoration: InputDecoration(
                    hintText: 'Tìm món ăn',
                    hintStyle: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                    prefixIcon: Icon(Icons.search, color: FlutterFlowTheme.of(context).primary),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: FlutterFlowTheme.of(context).primary),
                      onPressed: () {
                        _searchController.clear();
                        _fetchFoods(search: "");
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ),
              Expanded(
                child: _model.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _model.errorMessage != null
                    ? Center(child: Text(_model.errorMessage!))
                    : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_model.existingMeals.isNotEmpty) ...[
                              Text(
                                "Món ăn hiện có trong ${_getMealTypeInVietnamese(widget.mealType)}",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Hiển thị thông số dinh dưỡng
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNutrientDisplay(
                                    "Calories",
                                    "${nutrients['calories']!.toStringAsFixed(0)}",
                                    "kcal",
                                  ),
                                  _buildNutrientDisplay(
                                    "Carbs",
                                    "${nutrients['carbs']!.toStringAsFixed(0)}",
                                    "g",
                                  ),
                                  _buildNutrientDisplay(
                                    "Protein",
                                    "${nutrients['protein']!.toStringAsFixed(0)}",
                                    "g",
                                  ),
                                  _buildNutrientDisplay(
                                    "Fat",
                                    "${nutrients['fat']!.toStringAsFixed(0)}",
                                    "g",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _model.existingMeals.length,
                                itemBuilder: (context, index) {
                                  final meal = _model.existingMeals[index];
                                  final food = meal.foodId != null ? _foodCache[meal.foodId!] : null;
                                  return Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      onTap: () {
                                        if (meal.foodId != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BrekFastIIngredientsWidget(
                                                foodId: meal.foodId!,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: food != null &&
                                            food.imageUrl != null &&
                                            food.imageUrl!.isNotEmpty
                                            ? NetworkImage(food.imageUrl!)
                                            : null,
                                        child: food == null ||
                                            food.imageUrl == null ||
                                            food.imageUrl!.isEmpty
                                            ? Icon(Icons.fastfood,
                                            color: FlutterFlowTheme.of(context).primary)
                                            : null,
                                      ),
                                      title: Text(
                                        meal.foodName ?? "Chưa có món ăn",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        "Số lượng: ${(meal.quantity?.toInt() ?? 0)}",
                                        style: TextStyle(
                                            color: FlutterFlowTheme.of(context).secondaryText),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeFromMealPlan(meal),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Divider(height: 20),
                            ],
                            Text(
                              "Danh sách món ăn",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final food = _model.foods[index];
                          return Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              onTap: () {
                                if (food.foodId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BrekFastIIngredientsWidget(
                                        foodId: food.foodId!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: (food.imageUrl != null && food.imageUrl!.isNotEmpty)
                                    ? NetworkImage(food.imageUrl!)
                                    : null,
                                child: (food.imageUrl == null || food.imageUrl!.isEmpty)
                                    ? Icon(Icons.fastfood, color: FlutterFlowTheme.of(context).primary)
                                    : null,
                              ),
                              title: Text(
                                food.foodName,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${food.calories?.toStringAsFixed(0) ?? "0"} cal • ${food.servingSize ?? "1 serving"}',
                                style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add, color: FlutterFlowTheme.of(context).primary),
                                onPressed: () => _addToMealPlan(food),
                              ),
                            ),
                          );
                        },
                        childCount: _model.foods.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: _model.isLoadingMore
                            ? const Center(child: CircularProgressIndicator())
                            : _model.hasMore
                            ? Center(
                          child: ElevatedButton(
                            onPressed: () => _model.loadMoreFoods(search: _searchController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Tải thêm",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                            : const Center(child: Text("Đã tải hết danh sách món ăn")),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}