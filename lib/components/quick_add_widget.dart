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

    // Gọi API calorieEstimator để kiểm tra lượng calories thêm vào có vượt mục tiêu không
    final bool exceedsCalories = await _mealLogService.calorieEstimator(
      logDate: widget.selectedDate.toIso8601String(),
      additionalCalories: finalCalories,
    );

    // Nếu vượt calories, hiển thị dialog cảnh báo xác nhận
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

    // Gọi API quickAddMeal nếu không vượt hoặc người dùng đã xác nhận đồng ý
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
          'Thêm nhanh',
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

  final Map<String, String> mealTypeMapping = {
    'Breakfast': 'Bữa sáng',
    'Lunch': 'Bữa trưa',
    'Dinner': 'Bữa tối',
    'Snacks': 'Bữa phụ',
  };

  Widget _buildMealRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bữa (in đậm)
        const Text(
          'Bữa',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold, // In đậm
          ),
        ),
        DropdownButton<String>(
          value: _selectedMeal,
          underline: const SizedBox(), // ẩn gạch chân
          items: _mealTypes.map((type) {
            return DropdownMenuItem(
              value: type, // Giá trị này vẫn là tiếng Anh khi gọi API
              child: Text(mealTypeMapping[type] ?? type), // Hiển thị tiếng Việt
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

  /// Row Calories với placeholder và thông báo chênh lệch
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
        // Calories (in đậm)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calories',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold, // In đậm
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

  /// Row cho Fat/Carbohydrates/Protein
  Widget _buildMacroRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // label (in đậm)
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold, // In đậm
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
