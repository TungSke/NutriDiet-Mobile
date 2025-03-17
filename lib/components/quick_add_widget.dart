import 'package:flutter/material.dart';

class QuickAddWidget extends StatefulWidget {
  final String mealName; // Tên bữa ăn, ví dụ "Breakfast", "Lunch", ...

  const QuickAddWidget({Key? key, required this.mealName}) : super(key: key);

  @override
  _QuickAddWidgetState createState() => _QuickAddWidgetState();
}

class _QuickAddWidgetState extends State<QuickAddWidget> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Add'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: Xử lý logic lưu data khi bấm nút check
              Navigator.pop(context); // đóng màn hình
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildRow('Meal', widget.mealName, isReadOnly: true),
          const Divider(),
          _buildRow('Calories', '', controller: _caloriesController),
          const Divider(),
          _buildRow('Fat (g)', '', controller: _fatController),
          const Divider(),
          _buildRow('Carbohydrates (g)', '', controller: _carbsController),
          const Divider(),
          _buildRow('Protein (g)', '', controller: _proteinController),
          const Divider(),
          // Bạn có thể thêm nút Lưu nếu thích
          ElevatedButton(
            onPressed: () {
              // TODO: xử lý lưu data
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String initialValue,
      {TextEditingController? controller, bool isReadOnly = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100, // Chiều rộng tùy ý
          child: TextFormField(
            controller: controller ?? TextEditingController(text: initialValue),
            readOnly: isReadOnly,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
