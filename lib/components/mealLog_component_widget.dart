import 'package:diet_plan_app/components/mealLog_list_food.dart';
import 'package:diet_plan_app/components/mealLog_nutrition.dart';
import 'package:diet_plan_app/services/models/meallog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/mealLog_component_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../components/meallog_detail_widget.dart';
import '../components/quick_add_widget.dart';
import '../log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';

class MealLogComponentWidget extends StatefulWidget {
  const MealLogComponentWidget({Key? key}) : super(key: key);

  @override
  State<MealLogComponentWidget> createState() => _MealLogComponentWidgetState();
}

class _MealLogComponentWidgetState extends State<MealLogComponentWidget> {
  late MealLogComponentModel _model;
  bool isPremium = false; // trạng thái premium
  bool _isLoadingAI = false;

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
    _checkPremiumStatus();
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

  Future<bool> _confirmProceedIfMealPlanApplied() async {
    bool applied = await _model.checkPlanApplied();
    if (applied) {
      bool? proceed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Cảnh báo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            content: Text(
              "Bạn đang áp dụng thực đơn. Bạn có chắc chắn muốn tiếp tục?",
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Hủy",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Tiếp tục",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return proceed ?? false;
    }
    return true;
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

  /// Hàm xử lý cho nút "Thực đơn AI"
  Future<void> _navigateToAIMealLog() async {
    // Kiểm tra xem ngày đã áp dụng mealplan chưa
    if (!await _confirmProceedIfMealPlanApplied()) return;

    // Kiểm tra trạng thái premium
    final premiumStatus = await _model.checkPremiumStatus();
    if (!premiumStatus) {
      final proceedToPremium = await showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
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
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
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
                          borderRadius: BorderRadius.circular(5),
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
      return;
    }

    // Nếu là premium, tiếp tục lấy thực đơn AI
    setState(() => _isLoadingAI = true);
    await _model.fetchMealLogsAI();
    if (mounted) setState(() => _isLoadingAI = false);
    if (!mounted) return;

    // Hiển thị popup với danh sách các món ăn AI
    showDialog(
      context: context,
      builder: (context) {
        // Gom nhóm theo mealType
        final Map<String, List<MealLogDetail>> grouped = {};
        for (var meal in _model.mealLogAis) {
          grouped.putIfAbsent(meal.mealType, () => []).add(meal);
        }
        final primaryColor = FlutterFlowTheme.of(context).primary;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(
            "Thực đơn AI",
            style: TextStyle(color: FlutterFlowTheme.of(context).accent5),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: _model.mealLogAis.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: grouped.entries.map((entry) {
                      String header;
                      switch (entry.key.toLowerCase()) {
                        case 'breakfast':
                          header = 'Bữa Sáng';
                          break;
                        case 'lunch':
                          header = 'Bữa Trưa';
                          break;
                        case 'dinner':
                          header = 'Bữa Tối';
                          break;
                        case 'snacks':
                          header = 'Bữa Phụ';
                          break;
                        default:
                          header = entry.key;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              header,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                          ...entry.value.map((meal) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  meal.foodName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${meal.servingSize} • ${meal.calories} Calories",
                                ),
                              )),
                        ],
                      );
                    }).toList(),
                  )
                : Text(
                    "Không có dữ liệu thực đơn AI",
                    style:
                        TextStyle(color: FlutterFlowTheme.of(context).primary),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).primary,
              ),
              child: Text(
                "Từ chối",
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
              ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Text(
                        "Nhập Feedback",
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).primary),
                      ),
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
                          onPressed: () async {
                            Navigator.pop(context);
                            await _model
                                .sendAIChosenMealFeedback("No feedback");
                            await _model.fetchMealLogs();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                FlutterFlowTheme.of(context).primary,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await _model.sendAIChosenMealFeedback(feedback);
                            await _model.fetchMealLogs();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                FlutterFlowTheme.of(context).primary,
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).primary,
              ),
              child: Text(
                "Đồng ý",
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Nhật ký',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'delete_log':
                                    // Kiểm tra trước khi xóa nhật ký
                                    if (await _confirmProceedIfMealPlanApplied()) {
                                      if (_model.mealLogs.isNotEmpty) {
                                        int mealLogId =
                                            _model.mealLogs[0].mealLogId;
                                        await _model.deleteMealLogEntry(
                                            mealLogId: mealLogId);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Xóa nhật ký thành công')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Không có nhật ký để xóa')),
                                        );
                                      }
                                    }
                                    break;
                                  case 'end_day':
                                    // Gọi API phân tích Meal Log
                                    final String? analysis =
                                        await _model.fetchAnalyzeMealLog();
                                    if (analysis != null) {
                                      final String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(_model.selectedDate);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          title: Text(
                                              "Phân tích ngày: $formattedDate"),
                                          content: SingleChildScrollView(
                                            child: MarkdownBody(
                                              data: analysis,
                                              styleSheet: MarkdownStyleSheet(
                                                p: const TextStyle(
                                                    fontSize: 16),
                                                strong: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  case 'clone_log':
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: _model.selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2040),
                                      locale: const Locale('vi'),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: Colors.green,
                                              onPrimary: Colors.white,
                                              onSurface: Colors.black,
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.green),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate != null) {
                                      await _model.cloneMealLogEntry(
                                          sourceDate: pickedDate);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Sao chép thành công')),
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
                                const PopupMenuItem<String>(
                                  value: 'clone_log',
                                  child: Text('Sao chép...'),
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
                              FontWeight.bold,
                            ),
                            _buildOperator('='),
                            _buildCalorieColumn(
                              _model.remainingCalories.toString(),
                              'Còn lại',
                              FontWeight.bold,
                              color: _model.remainingCalories < 0
                                  ? Colors.red
                                  : Colors.black,
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
                if (_model.selectedDate.year == DateTime.now().year &&
                    _model.selectedDate.month == DateTime.now().month &&
                    _model.selectedDate.day == DateTime.now().day)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Kiểm tra trước khi gọi "Thực đơn AI"
                        if (await _confirmProceedIfMealPlanApplied()) {
                          _navigateToAIMealLog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: FlutterFlowTheme.of(context).primary,
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: FlutterFlowTheme.of(context).primary),
                        ),
                      ),
                      child: _isLoadingAI
                          ? Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Text(
                              "Thực đơn AI",
                              style: TextStyle(
                                fontSize: 18,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieColumn(
    String value,
    String label,
    FontWeight weight, {
    Color color = Colors.black, // thêm tham số color với mặc định là đen
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 20,
            fontWeight: weight,
            color: color,
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
      default:
        return category;
    }
  }

  final Map<String, String> mealTimeTranslations = {
    'Breakfast': '6:00 - 8:00 sáng',
    'Lunch': '12:00 - 14:00 chiều',
    'Dinner': '18:00 - 20:00 tối',
    'Snacks': '15:00 - 16:00 chiều',
  };

  Widget _buildMealCategoryCard(BuildContext context, String category) {
    final vietnameseCategory = _mapCategoryToVietnamese(category);
    final mealLog = _model.mealLogs.isNotEmpty ? _model.mealLogs[0] : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
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
    // Nếu chưa có mealLog -> hiển thị option "Thêm"
    if (mealLog == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(category, vietnameseCategory, null),
          ListTile(
            title: Text(
              'Thêm',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              icon: const Icon(Icons.more_horiz),
              onSelected: (String value) async {
                switch (value) {
                  case 'quick_add':
                    if (await _confirmProceedIfMealPlanApplied()) {
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
                    }
                    break;
                  case 'reminders':
                    await _model.toggleReminder(context);
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
            onTap: () async {
              if (await _confirmProceedIfMealPlanApplied()) {
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
              }
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
        _buildMealHeader(
            category, vietnameseCategory, hasAnyFood ? mealCals : null),
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealLogDetailWidget(
                    detailId: details[i].detailId,
                  ),
                ),
              );
              if (result == true) {
                _model.fetchMealLogs();
              }
            },
            onLongPress: () async {
              // Kiểm tra trước khi xóa món
              if (!await _confirmProceedIfMealPlanApplied()) return;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                                          title: Text(_mapCategoryToVietnamese(
                                              mealType)),
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
                            // Kiểm tra trước khi xóa món
                            if (await _confirmProceedIfMealPlanApplied()) {
                              await _model.deleteMealLogDetailEntry(
                                mealLogId: mealLog.mealLogId,
                                detailId: details[i].detailId,
                              );
                            }
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
              trailing: (details[i].imageUrl != null &&
                      details[i].imageUrl!.isNotEmpty)
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.black,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: InteractiveViewer(
                                      child: Center(
                                        child: Image.network(
                                          details[i].imageUrl!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    right: 30,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(details[i].imageUrl!),
                        backgroundColor: Colors.transparent,
                      ),
                    )
                  : null,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            icon: const Icon(Icons.more_horiz),
            onSelected: (String value) async {
              switch (value) {
                case 'quick_add':
                  if (await _confirmProceedIfMealPlanApplied()) {
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
                  }
                  break;
                case 'reminders':
                  await _model.toggleReminder(context);
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
          onTap: () async {
            if (await _confirmProceedIfMealPlanApplied()) {
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
            }
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildMealHeader(
      String category, String vietnameseCategory, int? mealCals) {
    final mealTime = mealTimeTranslations[category] ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                vietnameseCategory,
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (mealTime.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($mealTime)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
