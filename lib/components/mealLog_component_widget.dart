import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/mealLog_component_model.dart';
import '../components/serch_data_widget.dart';
import '../components/quick_add_widget.dart';
import '../services/models/meallog.dart';

class MealLogComponentWidget extends StatelessWidget {
  const MealLogComponentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealLogComponentModel>(
      create: (context) => MealLogComponentModel(),
      child: Consumer<MealLogComponentModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      model.changeDate(
                        model.selectedDate.subtract(const Duration(days: 1)),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => _showDatePicker(context, model),
                    child: Text(
                      DateFormat('MMMM d, yyyy').format(model.selectedDate),
                      style: const TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      model.changeDate(
                        model.selectedDate.add(const Duration(days: 1)),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: ListView(
              children: [
                // Card hiển thị Calories Remaining
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Calories Remaining',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Goal - Food = Remaining
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCalorieColumn(
                              model.calorieGoal.toString(),
                              'Goal',
                              FontWeight.bold,
                            ),
                            _buildOperator('-'),
                            _buildCalorieColumn(
                              model.foodCalories.toString(),
                              'Food',
                              FontWeight.normal,
                            ),
                            _buildOperator('='),
                            _buildCalorieColumn(
                              model.remainingCalories.toString(),
                              'Remaining',
                              FontWeight.bold,
                              textColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      
                // Hiển thị các bữa
                for (final category in model.mealCategories)
                  _buildMealCategory(context, model, category),
              ],
            ),
          );
        },
      ),
    );
  }

  // Chọn ngày
  Future<void> _showDatePicker(
      BuildContext context, MealLogComponentModel model) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: model.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // Màu tiêu đề và ngày được chọn
              onPrimary: Colors.white, // Màu chữ trên nút tiêu đề
              onSurface: Colors.black, // Màu chữ ngày chưa chọn
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Màu của nút OK và Cancel
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != model.selectedDate) {
      model.changeDate(picked); // Cập nhật model, từ đó UI mới được rebuild
    }
  }

  Widget _buildCalorieColumn(String value, String label, FontWeight weight,
      {Color? textColor}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 20,
            fontWeight: weight,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildOperator(String operator) {
    return Text(
      operator,
      style: const TextStyle(
        fontFamily: 'Figtree',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Hiển thị từng bữa (Breakfast, Lunch, ...)
  /// Lọc các món ăn thuộc bữa đó, tính tổng cals, macro...
  Widget _buildMealCategory(
    BuildContext context,
    MealLogComponentModel model,
    String category,
  ) {
    // Giả sử API trả về 1 mealLog / ngày, ta lấy log đầu tiên (nếu có)
    // Nếu API có thể trả về nhiều mealLog 1 ngày, bạn tự điều chỉnh
    final mealLog = model.mealLogs.isNotEmpty ? model.mealLogs[0] : null;
    if (mealLog == null) {
      // Chưa có data => vẫn hiển thị khung bữa + ADD FOOD
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(category, 0),
          // ADD FOOD
          ListTile(
            title: const Text(
              'ADD FOOD',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              onSelected: (String value) {
                switch (value) {
                  case 'quick_add':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuickAddWidget(mealName: category),
                      ),
                    );
                    break;
                  case 'reminders':
                    // ...
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'quick_add',
                    child: Text('Quick Add'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'reminders',
                    child: Text('Reminders'),
                  ),
                ];
              },
            ),
            onTap: () {
              // Mở màn hình search
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SerchDataWidget(),
                ),
              );
            },
          ),
          const Divider(),
        ],
      );
    }

    // Lọc các chi tiết trùng bữa
    final details = mealLog.mealLogDetails
        .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
        .toList();

    // Tính tổng cals
    final mealCals = details.fold(0, (sum, d) => sum + d.calories);
    // Tính macro
    final mealCarbs = details.fold(0, (sum, d) => sum + d.carbs);
    final mealFat = details.fold(0, (sum, d) => sum + d.fat);
    final mealProtein = details.fold(0, (sum, d) => sum + d.protein);
    final totalMacros = mealCarbs + mealFat + mealProtein;
    final carbsPercent =
        totalMacros > 0 ? (mealCarbs / totalMacros * 100).round() : 0;
    final fatPercent =
        totalMacros > 0 ? (mealFat / totalMacros * 100).round() : 0;
    final proteinPercent =
        totalMacros > 0 ? (mealProtein / totalMacros * 100).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề bữa (ví dụ: Breakfast) + tổng cals
        _buildMealHeader(category, mealCals),

        // Nếu có món ăn, hiển thị tỉ lệ macro
        if (details.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Carbs $carbsPercent% • Fat $fatPercent% • Protein $proteinPercent%',
              style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

        // Danh sách món ăn
        for (final item in details)
          ListTile(
            title: Text(
              item.foodName,
              style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${item.calories} cals, ${item.quantity} serving(s)'
              '${item.servingSize != null ? ', ${item.servingSize}' : ''}',
              style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

        // Nút ADD FOOD
        ListTile(
          title: const Text(
            'ADD FOOD',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (String value) {
              switch (value) {
                case 'quick_add':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuickAddWidget(mealName: category),
                    ),
                  );
                  break;
                case 'reminders':
                  // ...
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'quick_add',
                  child: Text('Quick Add'),
                ),
                const PopupMenuItem<String>(
                  value: 'reminders',
                  child: Text('Reminders'),
                ),
              ];
            },
          ),
          onTap: () {
            // Khi bấm "ADD FOOD", mở Search
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SerchDataWidget(),
              ),
            );
          },
        ),

        const Divider(),
      ],
    );
  }

  // Widget helper: tiêu đề bữa ăn + tổng cals
  Widget _buildMealHeader(String category, int mealCals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            mealCals.toString(),
            style: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
