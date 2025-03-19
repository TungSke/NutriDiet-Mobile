import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/food_service.dart';
import '../services/models/food.dart';

class MealLogFoodDetailWidget extends StatefulWidget {
  final int foodId;

  const MealLogFoodDetailWidget({Key? key, required this.foodId})
      : super(key: key);

  @override
  _MealLogFoodDetailWidgetState createState() =>
      _MealLogFoodDetailWidgetState();
}

class _MealLogFoodDetailWidgetState extends State<MealLogFoodDetailWidget> {
  final FoodService _foodService = FoodService();
  Food? _food;
  bool _isLoading = false;

  // Ví dụ cho Meal (bữa ăn) và số lượng (servings):
  String _selectedMeal = 'Lunch';
  int _numberOfServings = 1;

  // Chọn nhiều ngày - ví dụ 7 ngày tiếp theo
  late List<DateTime> _weekDays;
  final Set<int> _selectedDaysIndex = {};

  @override
  void initState() {
    super.initState();
    _fetchFoodDetail();
    _initWeekDays();
  }

  void _initWeekDays() {
    final now = DateTime.now();
    _weekDays = List.generate(7, (i) => now.add(Duration(days: i)));
  }

  Future<void> _fetchFoodDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _foodService.getFoodById(foodId: widget.foodId);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        setState(() {
          _food = Food.fromJson(data);
        });
      } else {
        debugPrint("Failed to load food detail: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching food detail: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addToMealLog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Meal Log!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_food == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Food')),
        body: const Center(child: Text('Không tìm thấy thông tin món ăn.')),
      );
    }

    // Lấy giá trị int
    final int calories = _food?.calories ?? 0;
    final int carbs = _food?.carbs ?? 0;
    final int fat = _food?.fat ?? 0;
    final int protein = _food?.protein ?? 0;

    final int totalMacro = carbs + fat + protein;
    // Tránh chia cho 0
    final double carbsRatio = totalMacro > 0 ? (carbs / totalMacro * 100) : 0;
    final double fatRatio = totalMacro > 0 ? (fat / totalMacro * 100) : 0;
    final double proteinRatio =
        totalMacro > 0 ? (protein / totalMacro * 100) : 0;

    // Dữ liệu cho pie chart (phải là double)
    final Map<String, double> macroDataMap = {
      "Carbs": carbsRatio,
      "Fat": fatRatio,
      "Protein": proteinRatio,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: () {
              // Icon check bên phải appbar
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Ảnh món ăn
            _buildFoodImage(_food!),

            const SizedBox(height: 16),

            // Row hiển thị tên món + icon check
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _food!.foodName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),

            const SizedBox(height: 10),
            _buildMealRow(),

            const SizedBox(height: 10),
            _buildNumberOfServingsRow(),

            const SizedBox(height: 10),
            _buildServingSizeRow(_food!),

            const SizedBox(height: 16),
            _buildAddToMultipleDays(),

            const SizedBox(height: 16),
            // Biểu đồ tròn macros
            _buildMacroPieChart(calories, carbs, fat, protein, macroDataMap),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addToMealLog,
                child: const Text('Add to Meal Log'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodImage(Food food) {
    final imageUrl = food.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/placeholder_food.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildMealRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Meal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton<String>(
          value: _selectedMeal,
          items: const [
            DropdownMenuItem(child: Text('Breakfast'), value: 'Breakfast'),
            DropdownMenuItem(child: Text('Lunch'), value: 'Lunch'),
            DropdownMenuItem(child: Text('Dinner'), value: 'Dinner'),
            DropdownMenuItem(child: Text('Snacks'), value: 'Snacks'),
          ],
          onChanged: (val) {
            setState(() {
              _selectedMeal = val ?? 'Lunch';
            });
          },
        ),
      ],
    );
  }

  Widget _buildNumberOfServingsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Number of Servings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_numberOfServings > 1) {
                  setState(() {
                    _numberOfServings--;
                  });
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$_numberOfServings',
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _numberOfServings++;
                });
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServingSizeRow(Food food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Serving Size',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          food.servingSize ?? '1 serving',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAddToMultipleDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add to Multiple Days',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDays.length,
            separatorBuilder: (context, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = _weekDays[index];
              final dayString = _formatDay(day);
              final isSelected = _selectedDaysIndex.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedDaysIndex.remove(index);
                    } else {
                      _selectedDaysIndex.add(index);
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        dayString,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDay(DateTime date) {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
  }

  Widget _buildMacroPieChart(
    int calories,
    int carbs,
    int fat,
    int protein,
    Map<String, double> macroDataMap,
  ) {
    return Column(
      children: [
        // Biểu đồ tròn
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                dataMap: macroDataMap,
                chartType: ChartType.ring,
                baseChartColor: Colors.grey[300]!,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
                colorList: const [Colors.blue, Colors.orange, Colors.purple],
                ringStrokeWidth: 24,
                legendOptions: const LegendOptions(
                  showLegends: false,
                ),
              ),
              // Hiển thị tổng calo ở giữa
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    calories.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Cal"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Thông tin Carbs / Fat / Protein
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMacroColumn("Carbs", carbs, macroDataMap["Carbs"] ?? 0),
            _buildMacroColumn("Fat", fat, macroDataMap["Fat"] ?? 0),
            _buildMacroColumn("Protein", protein, macroDataMap["Protein"] ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroColumn(String label, int gram, double percent) {
    final p = percent.toStringAsFixed(0); // phần trăm
    final g = gram.toString(); // gram
    return Column(
      children: [
        Text(
          '$p%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text('$g g'),
        Text(label),
      ],
    );
  }
}
