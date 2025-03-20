import 'package:flutter/material.dart';

class Ingredient {
  final String name;
  final String calories;
  final String portion;

  Ingredient({required this.name, required this.calories, required this.portion});
}

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({Key? key}) : super(key: key);

  @override
  _IngredientListScreenState createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  final List<Ingredient> ingredients = [
    Ingredient(name: "Cà chua", calories: "20 Calories", portion: "1 quả"),
    Ingredient(name: "Rau cải", calories: "15 Calories", portion: "100g"),
    Ingredient(name: "Thịt bò", calories: "250 Calories", portion: "100g"),
    Ingredient(name: "Cá hồi", calories: "300 Calories", portion: "1 miếng"),
    Ingredient(name: "Trứng gà", calories: "70 Calories", portion: "1 quả"),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Ingredient> filteredIngredients = ingredients.where((ingredient) {
      return ingredient.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chọn nguyên liệu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            TextField(
              decoration: InputDecoration(
                hintText: "Nhập tên nguyên liệu",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Danh sách nguyên liệu
            Expanded(
              child: ListView.builder(
                itemCount: filteredIngredients.length,
                itemBuilder: (context, index) {
                  return IngredientItem(ingredient: filteredIngredients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientItem extends StatefulWidget {
  final Ingredient ingredient;

  const IngredientItem({Key? key, required this.ingredient}) : super(key: key);

  @override
  _IngredientItemState createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientItem> {
  String _selectedPreference = 'Bình thường';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tên nguyên liệu + Calories
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.ingredient.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.ingredient.calories,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                "Khẩu phần: ${widget.ingredient.portion}",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),

          // Dropdown chọn thích, bình thường, ghét
          Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: DropdownButton<String>(
              value: _selectedPreference,
              dropdownColor: Colors.white, // Đổi màu nền dropdown thành trắng
              focusColor: Colors.transparent, // Loại bỏ hiệu ứng focus
              style: const TextStyle(color: Colors.black), // Đổi màu chữ trong dropdown
              items: const [
                DropdownMenuItem(value: 'Thích', child: Text('Thích')),
                DropdownMenuItem(value: 'Bình thường', child: Text('Bình thường')),
                DropdownMenuItem(value: 'Ghét', child: Text('Ghét')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPreference = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
