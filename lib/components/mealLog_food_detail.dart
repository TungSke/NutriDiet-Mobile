import 'dart:convert';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/services/models/foodservingsize.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../services/meallog_service.dart';
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
  final MeallogService _meallogService = MeallogService();
  Food? _food;
  bool _isLoading = false;
  int? _selectedServingSizeId; // Lưu servingSizeId được chọn

  // Màu cho chart
  final Color accent1 = const Color(0xFFF04770);
  final Color accent3 = const Color(0xFFFFD167);
  final Color accent5 = const Color(0xFF073A4B);

  // Ví dụ cho Bữa ăn và số lượng khẩu phần
  String _selectedMeal = 'Breakfast';
  int _numberOfServings = 1;

  // Danh sách 7 ngày bắt đầu từ hôm nay
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
    setState(() => _isLoading = true);
    try {
      final response = await _foodService.getFoodById(foodId: widget.foodId);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _food = Food.fromJson(data);
          // Chọn servingSizeId mặc định: ưu tiên food.servingSizeId, nếu không thì lấy phần tử đầu tiên
          _selectedServingSizeId = _food!.servingSizeId ??
              (_food!.foodServingSizes?.isNotEmpty == true
                  ? _food!.foodServingSizes![0].servingSizeId
                  : null);
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải chi tiết món ăn: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addToMealLog() async {
    List<DateTime> selectedDates = _selectedDaysIndex.isEmpty
        ? [DateTime.now()]
        : _selectedDaysIndex.map((i) => _weekDays[i]).toList();

    final success = await _meallogService.addMealToMultipleDays(
      dates: selectedDates,
      foodId: widget.foodId,
      quantity: _numberOfServings.toDouble(),
      mealType: _selectedMeal,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Thêm vào nhật ký ăn uống thành công!'
              : 'Thêm vào nhật ký ăn uống thất bại.',
        ),
      ),
    );
    if (success) Navigator.pop(context, true);
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
        appBar: AppBar(title: const Text('Chi tiết món ăn')),
        body: const Center(child: Text('Không tìm thấy thông tin món ăn.')),
      );
    }

    // Lấy thông tin từ foodServingSizes dựa trên servingSizeId
    final servingSize = _food!.foodServingSizes?.firstWhere(
          (s) => s.servingSizeId == _selectedServingSizeId,
      orElse: () => _food!.foodServingSizes!.isNotEmpty
          ? _food!.foodServingSizes![0]
          : FoodServingSize(
        servingSizeId: 0,
        quantity: 1,
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        glucid: 0,
        fiber: 0,
      ),
    );

    // Lấy số liệu dinh dưỡng
    final double calories = (servingSize?.calories ?? 0) * _numberOfServings;
    final double carbs = (servingSize?.carbs ?? 0) * _numberOfServings;
    final double fat = (servingSize?.fat ?? 0) * _numberOfServings;
    final double protein = (servingSize?.protein ?? 0) * _numberOfServings;
    final double totalMacro = carbs + fat + protein;
    final double carbsRatio = totalMacro > 0 ? carbs / totalMacro * 100 : 0;
    final double fatRatio = totalMacro > 0 ? fat / totalMacro * 100 : 0;
    final double proteinRatio = totalMacro > 0 ? protein / totalMacro * 100 : 0;
    final Map<String, double> macroDataMap = {
      "Tinh bột": carbsRatio,
      "Chất béo": fatRatio,
      "Protein": proteinRatio,
    };

    final primaryColor = FlutterFlowTheme.of(context).primary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Chi tiết món ăn',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFoodImage(_food!),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    _food!.foodName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            _buildMealRow(),
            const SizedBox(height: 16),
            _buildServingsRow(),
            const SizedBox(height: 16),
            _buildServingSizeRow(_food!),
            const SizedBox(height: 24),
            _buildAddToMultipleDays(),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    dataMap: macroDataMap,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey[300]!,
                    chartValuesOptions:
                    const ChartValuesOptions(showChartValues: false),
                    colorList: [accent1, accent3, accent5],
                    ringStrokeWidth: 24,
                    legendOptions: const LegendOptions(showLegends: false),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        calories.toStringAsFixed(0),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text('Cal'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroColumn('Tinh bột', carbs, macroDataMap['Tinh bột']!),
                _buildMacroColumn('Chất béo', fat, macroDataMap['Chất béo']!),
                _buildMacroColumn('Protein', protein, macroDataMap['Protein']!),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addToMealLog,
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
                  'Thêm vào nhật ký',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodImage(Food food) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: (food.imageUrl != null && food.imageUrl!.isNotEmpty)
          ? Image.network(
        food.imageUrl!,
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
          'Bữa ăn',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton<String>(
          value: _selectedMeal,
          items: const [
            DropdownMenuItem(child: Text('Bữa Sáng'), value: 'Breakfast'),
            DropdownMenuItem(child: Text('Bữa Trưa'), value: 'Lunch'),
            DropdownMenuItem(child: Text('Bữa Tối'), value: 'Dinner'),
            DropdownMenuItem(child: Text('Bữa Phụ'), value: 'Snacks'),
          ],
          onChanged: (val) {
            setState(() => _selectedMeal = val ?? _selectedMeal);
          },
        ),
      ],
    );
  }

  Widget _buildServingsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Số khẩu phần',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_numberOfServings > 1) {
                  setState(() => _numberOfServings--);
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$_numberOfServings', style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () => setState(() => _numberOfServings++),
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
          'Khối lượng khẩu phần',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton<int>(
          value: _selectedServingSizeId,
          items: food.foodServingSizes?.map((serving) {
            return DropdownMenuItem<int>(
              value: serving.servingSizeId,
              child: Text('${serving.quantity} khẩu phần'),
            );
          }).toList() ??
              [],
          onChanged: (val) {
            setState(() {
              _selectedServingSizeId = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAddToMultipleDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thêm vào nhiều ngày',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDays.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = _weekDays[index];
              final label = _formatDay(day);
              final selected = _selectedDaysIndex.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedDaysIndex.remove(index);
                    } else {
                      _selectedDaysIndex.add(index);
                    }
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? FlutterFlowTheme.of(context).primary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? Colors.white : Colors.black,
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
    switch (date.weekday) {
      case DateTime.monday:
        return 'Th 2';
      case DateTime.tuesday:
        return 'Th 3';
      case DateTime.wednesday:
        return 'Th 4';
      case DateTime.thursday:
        return 'Th 5';
      case DateTime.friday:
        return 'Th 6';
      case DateTime.saturday:
        return 'Th 7';
      case DateTime.sunday:
      default:
        return 'CN';
    }
  }

  Widget _buildMacroColumn(String label, double gram, double percent) {
    return Column(
      children: [
        Text(
          '${percent.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${gram.toStringAsFixed(1)} g',
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}