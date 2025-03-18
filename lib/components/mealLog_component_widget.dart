import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/mealLog_component_model.dart';
import '../components/serch_data_widget.dart';
import '../components/quick_add_widget.dart';

class MealLogComponentWidget extends StatefulWidget {
  const MealLogComponentWidget({Key? key}) : super(key: key);

  @override
  State<MealLogComponentWidget> createState() => _MealLogComponentWidgetState();
}

class _MealLogComponentWidgetState extends State<MealLogComponentWidget> {
  late MealLogComponentModel _model;

  @override
  void initState() {
    super.initState();
    _model = MealLogComponentModel();
    _model.setUpdateCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
    _model.fetchMealLogs();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _model.changeDate(
                  _model.selectedDate.subtract(const Duration(days: 1)),
                );
              },
            ),
            GestureDetector(
              onTap: () => _showDatePicker(context),
              child: Text(
                DateFormat('MMMM d, yyyy').format(_model.selectedDate),
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
                _model.changeDate(
                  _model.selectedDate.add(const Duration(days: 1)),
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
                        _model.calorieGoal.toString(),
                        'Goal',
                        FontWeight.bold,
                      ),
                      _buildOperator('-'),
                      _buildCalorieColumn(
                        _model.foodCalories.toString(),
                        'Food',
                        FontWeight.normal,
                      ),
                      _buildOperator('='),
                      _buildCalorieColumn(
                        _model.remainingCalories.toString(),
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
          for (final category in _model.mealCategories)
            _buildMealCategory(context, category),
        ],
      ),
    );
  }

  // Hàm chọn ngày
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _model.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _model.selectedDate) {
      _model.changeDate(picked);
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
  /// Hiển thị từng bữa (Breakfast, Lunch, ...)
  Widget _buildMealCategory(BuildContext context, String category) {
    // Giả sử API trả về 1 mealLog cho ngày, lấy log đầu tiên nếu có
    final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;
    if (mealLog == null) {
      // Chưa có data, vẫn hiển thị khung bữa + ADD FOOD
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(category, 0),
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
                    // Xử lý khác nếu cần
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

    // Lọc các món ăn thuộc bữa
    final details = mealLog.mealLogDetails
        .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
        .toList();

    // Tính tổng calories và macro
    final mealCals = details.fold(0, (sum, d) => sum + d.calories);
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
        _buildMealHeader(category, mealCals),
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
        // Hiển thị từng món ăn (mealLogDetail)
        for (final item in details)
          GestureDetector(
            onLongPress: () {
              // Khi người dùng nhấn giữ, hiển thị popup (AlertDialog)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Diary'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Move to...'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Delete Entry'),
                          onTap: () async {
                            Navigator.pop(context); // Đóng dialog
                            // Gọi hàm xóa trong model
                            await _model.deleteMealLogDetailEntry(
                              mealLogId: mealLog.mealLogId, // ID của MealLog
                              detailId: item.detailId, // ID của MealLogDetail
                            );
                            // Hàm deleteMealLogDetailEntry sẽ fetchMealLogs() lại
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ListTile(
              title: Text(
                item.foodName,
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${item.calories} cals, '
                '${item.quantity} serving(s)'
                '${item.servingSize != null ? ', ${item.servingSize}' : ''}',
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 14,
                  color: Colors.grey,
                ),
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
                  // Xử lý khác nếu cần
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

  // Widget helper: tiêu đề bữa ăn + tổng calories
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
