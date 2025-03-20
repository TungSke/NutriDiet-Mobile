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
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  late String _selectedMeal;

  // Controllers
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mặc định bữa ăn từ ngoài truyền vào (tiếng Anh)
    _selectedMeal = widget.mealName;
    // Lắng nghe thay đổi ở Fat/Carbs/Protein để cập nhật giao diện
    _fatController.addListener(_onMacroChanged);
    _carbsController.addListener(_onMacroChanged);
    _proteinController.addListener(_onMacroChanged);
    // Lắng nghe thay đổi Calories để cập nhật giao diện
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

  /// Tính tổng Calories từ Fat/Carbs/Protein (1g Fat = 9 cal, 1g Carbs = 4 cal, 1g Protein = 4 cal)
  double get _macroCalories {
    final double fat = double.tryParse(_fatController.text) ?? 0;
    final double carbs = double.tryParse(_carbsController.text) ?? 0;
    final double protein = double.tryParse(_proteinController.text) ?? 0;
    return fat * 9 + carbs * 4 + protein * 4;
  }

  /// Mỗi khi Fat/Carbs/Protein thay đổi => cập nhật UI
  void _onMacroChanged() {
    setState(() {});
  }

  /// Lấy giá trị Calories người dùng nhập (0 nếu rỗng)
  int get _typedCalories => int.tryParse(_caloriesController.text) ?? 0;

  /// Trả về chênh lệch giữa Calories người dùng nhập và Calories tính từ macros
  int get _calDiff => _typedCalories - _macroCalories.round();

  /// Khi người dùng bấm Lưu, nếu ô Calories trống thì dùng macro, ngược lại dùng giá trị người dùng nhập
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

  @override
  Widget build(BuildContext context) {
    final double macroCals = _macroCalories;
    final int typedCals = _typedCalories;

    return Scaffold(
      backgroundColor: Colors.white, // Màu nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar trắng
        title: const Text(
          'Quick Add',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
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
            hintText: 'Optional',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Carbohydrates (g)',
            controller: _carbsController,
            hintText: 'Optional',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Protein (g)',
            controller: _proteinController,
            hintText: 'Optional',
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildMealRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Meal', style: TextStyle(fontSize: 16, color: Colors.black)),
        DropdownButton<String>(
          value: _selectedMeal,
          underline: const SizedBox(), // ẩn gạch chân
          items: _mealTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
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

  /// Row Calories với placeholder và thông báo chênh lệch (ảnh 2 & 3)
  Widget _buildCaloriesRow(double macroCals, int typedCals) {
    bool hasMacros = macroCals > 0;
    bool userTyped = typedCals > 0;
    String subLabel = '';
    if (!userTyped && hasMacros) {
      subLabel = 'Calculated based on nutrient values.';
    } else if (userTyped && hasMacros && (typedCals != macroCals.round())) {
      final diff = typedCals - macroCals.round();
      subLabel =
          "Your macros total ${macroCals.round()} cals.\nDifference: $diff cals";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calories',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(
              width: 130,
              child: TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter calorie amount',
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

  /// Row cho Fat/Carbohydrates/Protein với placeholder "Optional"
  Widget _buildMacroRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
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
