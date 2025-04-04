import 'package:diet_plan_app/components/mealLog_list_food.dart';
import 'package:diet_plan_app/components/mealLog_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';
import '/components/mealLog_component_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../components/meallog_detail_widget.dart';
import '../components/quick_add_widget.dart';

class MealLogComponentWidget extends StatefulWidget {
  const MealLogComponentWidget({Key? key}) : super(key: key);

  @override
  State<MealLogComponentWidget> createState() => _MealLogComponentWidgetState();
}

class _MealLogComponentWidgetState extends State<MealLogComponentWidget> {
  late MealLogComponentModel _model;
  bool isPremium = false; // Biến trạng thái premium

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
    _model.fetchPersonalGoal();
    _checkPremiumStatus(); // Kiểm tra premium khi khởi tạo
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Hàm kiểm tra trạng thái premium
  Future<void> _checkPremiumStatus() async {
    final premiumStatus = await _model.checkPremiumStatus();
    if (mounted) {
      setState(() {
        isPremium = premiumStatus;
      });
    }
  }

  /// Hàm format ngày hiển thị
  String _getCustomDateString(DateTime date) {
    final now = DateTime.now();
    final difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    if (difference == -1) return 'Hôm qua';
    return DateFormat('d MMMM, yyyy', 'vi').format(date);
  }

  /// Hàm chọn ngày (locale: vi để hiển thị lịch tiếng Việt)
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

  Future<void> _navigateToAIMealLog() async {
    if (!mounted) return;

    // Kiểm tra trạng thái premium trước
    final isPremium = await _model.checkPremiumStatus();
    if (!isPremium) {
      final proceedToPremium = await showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  'Yêu cầu Premium',
                  style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Để nhận thực đơn AI, bạn cần nâng cấp lên tài khoản Premium.\nThưởng thức các tính năng độc quyền ngay hôm nay!',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (proceedToPremium != true || !mounted) return;

      // Chuyển đến màn hình mua premium
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyPremiumPackageScreenWidget(),
        ),
      );
      return; // Dừng lại nếu không phải premium
    }

    // Nếu là premium, tiếp tục lấy thực đơn AI
    await _model.fetchMealLogsAI();
    if (!mounted) return;

    // Hiển thị popup với danh sách các món ăn AI
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thực đơn AI"),
        content: SizedBox(
          width: double.maxFinite,
          child: _model.mealLogAis.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _model.mealLogAis.length,
                  itemBuilder: (context, index) {
                    final meal = _model.mealLogAis[index];
                    return ListTile(
                      title: Text(meal.foodName),
                      subtitle: Text(
                        "${meal.mealType} - ${meal.servingSize} - ${meal.calories} Calories",
                      ),
                    );
                  },
                )
              : const Text("Không có dữ liệu thực đơn AI"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Reject"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Hiển thị dialog nhập Feedback
              String feedback = "";
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Nhập Feedback"),
                    content: TextField(
                      onChanged: (value) {
                        feedback = value;
                      },
                      decoration: const InputDecoration(
                        hintText: "Nhập feedback của bạn...",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _model.sendAIChosenMealFeedback(feedback);
                          await _model.fetchMealLogs();
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Accept"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Diary',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            context.pushNamed('bottom_navbar_screen');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealLogNutritionWidget(
                    selectedDate: _model.selectedDate,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh chọn ngày
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
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
          // Nội dung còn lại: danh sách bữa, card calo...
          Expanded(
            child: ListView(
              children: [
                // Card Calo còn lại
                Card(
                  margin: const EdgeInsets.all(12.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Calo còn lại',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'delete_log':
                                    if (_model.mealLogs.isNotEmpty) {
                                      int mealLogId =
                                          _model.mealLogs[0].mealLogId;
                                      await _model.deleteMealLogEntry(
                                          mealLogId: mealLogId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Xóa nhật ký thành công')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Không có nhật ký để xóa')),
                                      );
                                    }
                                    break;
                                  case 'end_day':
                                    // Gọi API phân tích Meal Log
                                    final String? analysis =
                                        await _model.fetchAnalyzeMealLog();
                                    if (analysis != null) {
                                      // Tạo tiêu đề hiển thị ngày
                                      final String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(_model.selectedDate);

                                      // Hiển thị kết quả phân tích dưới dạng Markdown
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          // Bạn có thể tùy chỉnh title theo ý muốn
                                          title: Text(
                                              "Phân tích ngày: $formattedDate"),
                                          content: SingleChildScrollView(
                                            child: MarkdownBody(
                                              data: analysis,
                                              styleSheet: MarkdownStyleSheet(
                                                p: const TextStyle(
                                                    fontSize: 16),
                                                // Bạn có thể tuỳ chỉnh màu, kích cỡ chữ, v.v. cho từng phần
                                                strong: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                // Đặt style cho bullet points, headings, links, v.v. nếu cần
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Đóng"),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Không có kết quả phân tích.")),
                                      );
                                    }
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem<String>(
                                  value: 'delete_log',
                                  child: Text('Xóa nhật ký'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'end_day',
                                  child: Text('Kết thúc ngày'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                Container(height: 8.0, color: Colors.grey[200]),
                for (final category in _model.mealCategories) ...[
                  _buildMealCategoryCard(context, category),
                  Container(height: 10.0, color: Colors.grey[200]),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _navigateToAIMealLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPremium
                          ? FlutterFlowTheme.of(context)
                              .primary // Màu gốc khi premium
                          : Colors.grey[600], // Màu xám đen khi không premium
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Nhận thực đơn AI",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildMealCategoryCard(BuildContext context, String category) {
    final vietnameseCategory = _mapCategoryToVietnamese(category);
    final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildMealCategoryContent(
          context,
          mealLog,
          category,
          vietnameseCategory,
        ),
      ),
    );
  }

  Widget _buildMealCategoryContent(
    BuildContext context,
    dynamic mealLog,
    String category,
    String vietnameseCategory,
  ) {
    if (mealLog == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(vietnameseCategory, null),
          ListTile(
            title: const Text(
              'Thêm',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              onSelected: (String value) async {
                // Thêm async
                switch (value) {
                  case 'quick_add':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuickAddWidget(
                          mealName: category,
                          selectedDate: _model.selectedDate,
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        _model.fetchMealLogs();
                      }
                    });
                    break;
                  case 'reminders':
                    await _model
                        .toggleReminder(context); // Gọi hàm bật/tắt nhắc nhở
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
                  builder: (context) => MealLogListFoodWidget(
                    selectedDate: _model.selectedDate,
                    mealName: category,
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  _model.fetchMealLogs();
                }
              });
            },
          ),
          const Divider(),
        ],
      );
    }
    final details = mealLog.mealLogDetails
        .where((d) => d.mealType.toLowerCase() == category.toLowerCase())
        .toList();
    final bool hasAnyFood = details.isNotEmpty;
    final mealCals = details.fold(0, (sum, d) => sum + d.calories);
    final mealCarbs = details.fold(0, (sum, d) => sum + d.carbs);
    final mealFat = details.fold(0, (sum, d) => sum + d.fat);
    final mealProtein = details.fold(0, (sum, d) => sum + d.protein);
    final carbsPercent =
        mealCals > 0 ? (mealCarbs * 4 / mealCals * 100).round() : 0;
    final fatPercent =
        mealCals > 0 ? (mealFat * 9 / mealCals * 100).round() : 0;
    final proteinPercent =
        mealCals > 0 ? (mealProtein * 4 / mealCals * 100).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        for (int i = 0; i < details.length; i++) ...[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealLogDetailWidget(
                    detailId: details[i].detailId,
                  ),
                ),
              );
            },
            onLongPress: () {
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Chuyển đến...'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final mealType in [
                                        'Breakfast',
                                        'Lunch',
                                        'Dinner',
                                        'Snacks'
                                      ])
                                        ListTile(
                                          title: Text(mealType),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await _model
                                                .transferMealLogDetailEntry(
                                              detailId: details[i].detailId,
                                              targetMealType: mealType,
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
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
                '${details[i].calories} Calories, ${details[i].quantity} serving(s)${details[i].servingSize != null ? ', ${details[i].servingSize}' : ''}',
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
        ListTile(
          title: const Text(
            'Thêm',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (String value) async {
              // Thêm async
              switch (value) {
                case 'quick_add':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuickAddWidget(
                        mealName: category,
                        selectedDate: _model.selectedDate,
                      ),
                    ),
                  ).then((result) {
                    if (result == true) {
                      _model.fetchMealLogs();
                    }
                  });
                  break;
                case 'reminders':
                  await _model
                      .toggleReminder(context); // Gọi hàm bật/tắt nhắc nhở
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
                builder: (context) => MealLogListFoodWidget(
                  selectedDate: _model.selectedDate,
                  mealName: category,
                ),
              ),
            ).then((result) {
              if (result == true) {
                _model.fetchMealLogs();
              }
            });
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildMealHeader(String category, int? mealCals) {
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
          mealCals == null
              ? const SizedBox.shrink()
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
