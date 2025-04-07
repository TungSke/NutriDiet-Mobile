import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../services/meallog_service.dart';

class QuickAddWidget extends StatefulWidget {
  final String mealName; // "Breakfast", "Lunch", "Dinner", "Snacks"
  final DateTime selectedDate;

  const QuickAddWidget({
    Key? key,
    required this.mealName,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _QuickAddWidgetState createState() => _QuickAddWidgetState();
}

class _QuickAddWidgetState extends State<QuickAddWidget> {
  final MeallogService _mealLogService = MeallogService();

  // Danh sách bữa ăn
  final List<String> _mealTypes = const ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  late String _selectedMeal;

  // Controllers
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.mealName;
    _fatController.addListener(_onMacroChanged);
    _carbsController.addListener(_onMacroChanged);
    _proteinController.addListener(_onMacroChanged);
    _caloriesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fatController.removeListener(_onMacroChanged);
    _carbsController.removeListener(_onMacroChanged);
    _proteinController.removeListener(_onMacroChanged);
    _caloriesController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  double get _macroCalories {
    final double fat = double.tryParse(_fatController.text) ?? 0;
    final double carbs = double.tryParse(_carbsController.text) ?? 0;
    final double protein = double.tryParse(_proteinController.text) ?? 0;
    return fat * 9 + carbs * 4 + protein * 4;
  }

  void _onMacroChanged() {
    setState(() {});
  }

  int get _typedCalories => int.tryParse(_caloriesController.text) ?? 0;

  int get _calDiff => _typedCalories - _macroCalories.round();

  Future<void> _onSave() async {
    final int fats = int.tryParse(_fatController.text) ?? 0;
    final int carbs = int.tryParse(_carbsController.text) ?? 0;
    final int protein = int.tryParse(_proteinController.text) ?? 0;

    int finalCalories = _typedCalories;
    if (finalCalories == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calories không được để trống!')),
      );
      return;
    }

    final bool exceedsCalories = await _mealLogService.calorieEstimator(
      logDate: widget.selectedDate.toIso8601String(),
      additionalCalories: finalCalories,
    );

    if (exceedsCalories) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cảnh báo'),
          content: const Text(
            'Đã vượt lượng Calories mục tiêu. Bạn có chắc chắn muốn thêm?',
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
        return;
      }
    }

    final success = await _mealLogService.quickAddMeal(
      logDate: widget.selectedDate,
      mealType: _selectedMeal,
      calories: finalCalories,
      carbohydrates: carbs,
      fats: fats,
      protein: protein,
    );

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm món nhanh thất bại!')),
      );
    }
  }

  void _onScanBarcode() async {
    try {
      final result = await context.pushNamed('barcode_scanner_screen');
      if (result != null && mounted) {
        final barcode = result as String;
        print('Mã vạch: $barcode');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mã vạch: $barcode')),
        );

        final foodData = await _fetchFoodDataFromBarcode(barcode);
        if (foodData != null) {
          setState(() {
            _caloriesController.text = foodData['calories'].toString();
            _fatController.text = foodData['fat'].toString();
            _carbsController.text = foodData['carbs'].toString();
            _proteinController.text = foodData['protein'].toString();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy thông tin món ăn!')),
          );
        }
      }
    } catch (e) {
      print('Error navigating to barcode_scanner_screen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi điều hướng: $e')),
      );
    }
  }

  Future<Map<String, dynamic>?> _fetchFoodDataFromBarcode(String barcode) async {
    await Future.delayed(const Duration(seconds: 1));
    if (barcode == '123456789') {
      return {
        'calories': 350,
        'fat': 10,
        'carbs': 50,
        'protein': 15,
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double macroCals = _macroCalories;
    final int typedCals = _typedCalories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Thêm nhanh',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Quét mã vạch',
            onPressed: _onScanBarcode,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onSave,
          ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildMealRow(),
          const Divider(),
          _buildCaloriesRow(macroCals, typedCals),
          const Divider(),
          _buildMacroRow(
            label: 'Fat (g)',
            controller: _fatController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Carbohydrates (g)',
            controller: _carbsController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Protein (g)',
            controller: _proteinController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
        ],
      ),
    );
  }

  final Map<String, String> mealTypeMapping = const {
    'Breakfast': 'Bữa sáng',
    'Lunch': 'Bữa trưa',
    'Dinner': 'Bữa tối',
    'Snacks': 'Bữa phụ',
  };

  Widget _buildMealRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bữa',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: _selectedMeal,
          underline: const SizedBox(),
          items: _mealTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(mealTypeMapping[type] ?? type),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedMeal = val;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildCaloriesRow(double macroCals, int typedCals) {
    bool hasMacros = macroCals > 0;
    bool userTyped = typedCals > 0;
    String subLabel = '';
    if (!userTyped && hasMacros) {
      subLabel = 'Tính toán dựa trên giá trị dinh dưỡng.';
    } else if (userTyped && hasMacros && (typedCals != macroCals.round())) {
      final diff = typedCals - macroCals.round();
      subLabel =
      "Tổng calo của macros là ${macroCals.round()} cals.\nChênh lệch: $diff cals";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calories',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 130,
              child: TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập số lượng calorie',
                ),
              ),
            ),
          ],
        ),
        if (subLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              subLabel,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildMacroRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 130,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}