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

  // Hàm hiển thị ngày: Hôm nay / Hôm qua / Ngày mai / format tiếng Việt
  String _getCustomDateString(DateTime date) {
    final now = DateTime.now();
    final difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    if (difference == -1) return 'Hôm qua';

    // Các ngày khác hiển thị dạng "d MMMM, yyyy" (tiếng Việt)
    return DateFormat('d MMMM, yyyy', 'vi').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                _getCustomDateString(_model.selectedDate),
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
          // Card hiển thị Calories Remaining (Calo còn lại)
          Card(
            margin: const EdgeInsets.all(12.0),
            color: Colors.white,
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
                        'Calo còn lại',
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
                  // Goal - Food - Remaining
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCalorieColumn(
                        _model.calorieGoal.toString(),
                        'Mục tiêu',
                        FontWeight.bold,
                      ),
                      _buildOperator('-'),
                      _buildCalorieColumn(
                        _model.foodCalories.toString(),
                        'Thức ăn',
                        FontWeight.normal,
                      ),
                      _buildOperator('='),
                      _buildCalorieColumn(
                        _model.remainingCalories.toString(),
                        'Còn lại',
                        FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Khoảng trống xám ngăn giữa Card Calo & các bữa
          Container(
            height: 8.0,
            color: Colors.grey[200],
          ),

          // Hiển thị các bữa, mỗi bữa là 1 Card, xen kẽ khoảng trống xám
          for (final category in _model.mealCategories) ...[
            _buildMealCategoryCard(context, category),
            Container(
              height: 10.0,
              color: Colors.grey[200],
            ),
          ],
        ],
      ),
    );
  }

  // Hàm chọn ngày (locale: vi để hiển thị lịch tiếng Việt)
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _model.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      locale: const Locale('vi'),
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

  Widget _buildCalorieColumn(String value, String label, FontWeight weight) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 20,
            fontWeight: weight,
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

  String _mapCategoryToVietnamese(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return 'Bữa sáng';
      case 'lunch':
        return 'Bữa trưa';
      case 'dinner':
        return 'Bữa tối';
      case 'snacks':
        return 'Bữa phụ';
      case 'exercise':
        return 'Tập luyện';
      default:
        return category;
    }
  }

  /// Thay vì trả về Column trực tiếp, ta trả về một Card cho mỗi bữa
  Widget _buildMealCategoryCard(BuildContext context, String category) {
    final vietnameseCategory = _mapCategoryToVietnamese(category);

    final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;
    // Tạo Card
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildMealCategoryContent(
            context, mealLog, category, vietnameseCategory),
      ),
    );
  }

  /// Nội dung bên trong Card của bữa ăn
  Widget _buildMealCategoryContent(
    BuildContext context,
    mealLog,
    String category,
    String vietnameseCategory,
  ) {
    // Nếu chưa có mealLog, hiển thị 0 + Thêm món
    if (mealLog == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bữa này hoàn toàn chưa có log => không hiển thị tổng calo
          _buildMealHeader(vietnameseCategory, null),

          ListTile(
            title: const Text(
              'Thêm món',
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
                            QuickAddWidget(mealName: vietnameseCategory),
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
                    child: Text('Thêm nhanh'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'reminders',
                    child: Text('Nhắc nhở'),
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

    // Lọc các món ăn
    final details = mealLog.mealLogDetails
        .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
        .toList();

    // Nếu bữa này không có món => ẩn tổng calo
    final bool hasAnyFood = details.isNotEmpty;

    // Tính tổng Calories & macro
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
        // Nếu bữa có món thì hiển thị mealCals, nếu không thì null
        _buildMealHeader(vietnameseCategory, hasAnyFood ? mealCals : null),

        if (hasAnyFood)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        for (int i = 0; i < details.length; i++) ...[
          GestureDetector(
            onLongPress: () {
              // Dialog xóa món
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Nhật ký'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Chuyển đến...'),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Xử lý Move to...
                          },
                        ),
                        ListTile(
                          title: const Text('Xóa món'),
                          onTap: () async {
                            Navigator.pop(context);
                            await _model.deleteMealLogDetailEntry(
                              mealLogId: mealLog.mealLogId,
                              detailId: details[i].detailId,
                            );
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
                details[i].foodName,
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${details[i].calories} Calories, '
                '${details[i].quantity} serving(s)'
                '${details[i].servingSize != null ? ', ${details[i].servingSize}' : ''}',
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          if (i < details.length - 1)
            const Divider(color: Colors.black, thickness: 1),
        ],
        if (hasAnyFood) const Divider(color: Colors.black, thickness: 1),

        // Nút "Thêm món"
        ListTile(
          title: const Text(
            'Thêm món',
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
                          QuickAddWidget(mealName: vietnameseCategory),
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
                  child: Text('Thêm nhanh'),
                ),
                const PopupMenuItem<String>(
                  value: 'reminders',
                  child: Text('Nhắc nhở'),
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

  /// Sửa _buildMealHeader để nếu mealCals == null thì không hiển thị cals
  Widget _buildMealHeader(String category, int? mealCals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tên bữa
          Text(
            category,
            style: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Nếu mealCals == null => không hiển thị
          mealCals == null
              ? const SizedBox.shrink() // Trả về widget rỗng
              : Text(
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
