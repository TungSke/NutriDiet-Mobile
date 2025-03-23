import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../services/models/mealplan.dart';
import '../../services/models/mealplandetail.dart';
import '../select_food_screen/select_food_widget.dart';
import 'meal_plan_detail_model.dart';

enum MealPlanSource {
  myMealPlan,
  sampleMealPlan,
}

class MealPlanDetailWidget extends StatefulWidget {
  final int mealPlanId;
  final MealPlanSource source;

  const MealPlanDetailWidget({
    super.key,
    required this.mealPlanId,
    required this.source,
  });

  @override
  _MealPlanDetailWidgetState createState() => _MealPlanDetailWidgetState();
}

class _MealPlanDetailWidgetState extends State<MealPlanDetailWidget> {
  late MealPlanDetailModel _model;
  int selectedDay = 1;

  final Map<String, String> mealTypeTranslations = {
    'Breakfast': 'Bữa sáng',
    'Lunch': 'Bữa trưa',
    'Dinner': 'Bữa tối',
    'Snacks': 'Bữa phụ',
  };

  @override
  void initState() {
    super.initState();
    _model = MealPlanDetailModel();
    _model.fetchMealPlanById(widget.mealPlanId);
  }

  void _addNewDay() {
    setState(() {
      selectedDay = _model.getTotalActiveDays() + 1; // Thêm ngày mới
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã thêm ngày mới thành công"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditMealPlanDialog() {
    if (_model.mealPlan == null) return;

    String planName = _model.mealPlan!.planName;
    String? healthGoal = _model.mealPlan!.healthGoal;

    const validHealthGoals = ['Giảm cân', 'Tăng cân', 'Duy trì cân nặng'];

    if (healthGoal != null && !validHealthGoals.contains(healthGoal)) {
      healthGoal = null;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Chỉnh sửa thực đơn', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tên thực đơn',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.black),
              controller: TextEditingController(text: planName),
              onChanged: (value) => planName = value,
            ),
            DropdownButtonFormField<String>(
              value: healthGoal,
              decoration: const InputDecoration(
                labelText: 'Mục tiêu sức khỏe',
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: FlutterFlowTheme.of(context).primary,
              style: const TextStyle(color: Colors.black),
              items: validHealthGoals
                  .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                  .toList(),
              onChanged: (value) => healthGoal = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              if (planName.isNotEmpty && healthGoal != null) {
                BuildContext? loadingContext;
                showDialog(
                  context: dialogContext,
                  barrierDismissible: false,
                  builder: (loadingDialogContext) {
                    loadingContext = loadingDialogContext;
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                try {
                  final success = await _model.updateMealPlan(planName, healthGoal!);

                  if (loadingContext != null && Navigator.canPop(loadingContext!)) {
                    Navigator.pop(loadingContext!);
                  }

                  Navigator.pop(dialogContext);

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật thực đơn thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_model.errorMessage ?? 'Lỗi khi cập nhật thực đơn'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (loadingContext != null && Navigator.canPop(loadingContext!)) {
                    Navigator.pop(loadingContext!);
                  }
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi cập nhật thực đơn: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_model.mealPlan != null && _model.isDayEmpty(selectedDay)) {
          if (selectedDay > 1) {
            setState(() {
              selectedDay = _model.getActiveDays().lastWhere((day) => day < selectedDay, orElse: () => 1);
            });
          }
        }
        return true;
      },
      child: ListenableBuilder(
        listenable: _model,
        builder: (context, child) {
          if (_model.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (_model.mealPlan == null && _model.errorMessage != null) {
            return Scaffold(body: Center(child: Text(_model.errorMessage!)));
          }

          final mealPLAN = _model.mealPlan;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
                title: Text(
                  mealPLAN?.planName ?? "Thực đơn",
                  style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMealPlanCard(mealPLAN),
                        const SizedBox(height: 12),
                        _buildDaySelector(),
                        const SizedBox(height: 12),
                        _buildNutrientProgress(),
                        const SizedBox(height: 12),
                        Text(
                          "Total: ${_model.getNutrientTotalsForDay(selectedDay)['calories']!.toStringAsFixed(0)} kcal",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: MealPlanDetailModel.mealTypes.length,
                            itemBuilder: (context, index) {
                              final mealType = MealPlanDetailModel.mealTypes[index];
                              final meals = _model.getMealsForDay(selectedDay)[mealType] ?? [];
                              return _buildMealCard(mealType, meals);
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySelector() {
    final activeDays = _model.getActiveDays();
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...activeDays.map((day) => _buildDayButton(day, "Ngày $day")).toList(),
                if (widget.source == MealPlanSource.myMealPlan)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton(
                      icon: Icon(Icons.add_circle, color: FlutterFlowTheme.of(context).primary, size: 40),
                      onPressed: _addNewDay,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayButton(int day, String text) {
    bool isSelected = day == selectedDay;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => setState(() => selectedDay = day),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(MealPlan? mealPlan) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mealPlan?.planName ?? "Thực đơn",
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.source == MealPlanSource.myMealPlan && mealPlan != null)
                  IconButton(
                    icon: Icon(Icons.edit, color: FlutterFlowTheme.of(context).primary),
                    onPressed: _showEditMealPlanDialog,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoText("Mục tiêu sức khỏe", mealPlan?.healthGoal ?? "Không xác định"),
            _buildInfoText("Số ngày thực đơn", "${mealPlan?.duration ?? 0} ngày"), // Yêu cầu 1
            _buildInfoText("Tạo bởi", mealPlan?.createdBy ?? "Không rõ"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildNutrientProgress() {
    final nutrients = _model.getNutrientTotalsForDay(selectedDay);
    final totalCalories = nutrients['calories']!;
    final carbs = nutrients['carbs']!;
    final protein = nutrients['protein']!;
    final fat = nutrients['fat']!;

    const userGoals = {'calories': 2000.0, 'carbs': 250.0, 'protein': 100.0, 'fat': 70.0};

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutrientDisplay(
          "Carbs",
          widget.source == MealPlanSource.myMealPlan ? "$carbs/${userGoals['carbs']}" : carbs.toStringAsFixed(0),
          "g",
        ),
        _buildNutrientDisplay(
          "Protein",
          widget.source == MealPlanSource.myMealPlan ? "$protein/${userGoals['protein']}" : protein.toStringAsFixed(0),
          "g",
        ),
        _buildNutrientDisplay(
          "Fat",
          widget.source == MealPlanSource.myMealPlan ? "$fat/${userGoals['fat']}" : fat.toStringAsFixed(0),
          "g",
        ),
      ],
    );
  }

  Widget _buildNutrientDisplay(String label, String value, String unit) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text("$label ($unit)", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMealCard(String mealType, List<MealPlanDetail> meals) {
    final vietnameseMealType = mealTypeTranslations[mealType] ?? mealType;
    String foodNames;
    if (meals.isEmpty) {
      foodNames = "Chưa có món ăn";
    } else {
      // Yêu cầu 2: Xử lý món ăn trùng lặp với quantity
      final foodMap = <String, double>{};
      for (var meal in meals) {
        final name = meal.foodName ?? "Chưa có món ăn";
        foodMap[name] = (foodMap[name] ?? 0) + (meal.quantity ?? 1);
      }
      foodNames = foodMap.entries
          .map((entry) => entry.value > 1 ? "${entry.key} x ${entry.value.toInt()}" : entry.key)
          .join(", ");
    }
    final hasMeals = meals.isNotEmpty;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasMeals ? FlutterFlowTheme.of(context).primary : Colors.grey.shade300,
          width: hasMeals ? 2 : 1,
        ),
      ),
      elevation: hasMeals ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!hasMeals)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
              ),
            if (!hasMeals) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vietnameseMealType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: hasMeals ? Colors.black : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    foodNames,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasMeals ? Colors.black87 : Colors.grey.shade500,
                      fontStyle: hasMeals ? FontStyle.normal : FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.source == MealPlanSource.myMealPlan)
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectFoodWidget(
                        mealPlanId: widget.mealPlanId,
                        mealType: mealType,
                        dayNumber: selectedDay,
                        existingMeals: meals,
                      ),
                    ),
                  );
                  if (result == true && mounted) {
                    await _model.fetchMealPlanById(widget.mealPlanId);
                    if (_model.isDayEmpty(selectedDay) && selectedDay > 1) {
                      setState(() {
                        selectedDay = _model.getActiveDays().lastWhere((day) => day < selectedDay, orElse: () => 1);
                      });
                    }
                  }
                },
                splashRadius: 24,
                tooltip: 'Thêm món ăn',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (widget.source) {
      case MealPlanSource.myMealPlan:
        final isActive = _model.mealPlan?.status == 'Active';
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.red : FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              try {
                final success = await _model.applyMealPlan(widget.mealPlanId);
                if (!mounted) return;
                if (success) {
                  final isActive = _model.mealPlan?.status == 'Active';
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      title: Text(
                        isActive ? "Thực đơn đang được áp dụng" : "Hủy áp dụng thành công",
                        style: const TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        isActive ? "Thực đơn đã được áp dụng thành công." : "Thực đơn đã được hủy áp dụng thành công.",
                        style: const TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                } else {
                  final errorMessage = _model.errorMessage ?? 'Lỗi khi áp dụng/hủy áp dụng thực đơn';
                  if (errorMessage.contains("Bạn đã có một thực đơn đang được áp dụng")) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.red,
                        title: const Text(
                          "Thông báo",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          "Bạn đang có thực đơn khác được áp dụng",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Lỗi không xác định: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              isActive ? "HỦY ÁP DỤNG THỰC ĐƠN" : "ÁP DỤNG THỰC ĐƠN",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      case MealPlanSource.sampleMealPlan:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final success = await _model.cloneSampleMealPlan(widget.mealPlanId);
              if (!mounted) return;
              if (success) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    title: const Text("Sao chép thành công", style: TextStyle(color: Colors.white)),
                    content: const Text(
                      "Sao chép thực đơn thành công, vui lòng kiểm tra trong thực đơn của bạn.",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_model.errorMessage ?? 'Lỗi khi sao chép thực đơn'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("SAO CHÉP THỰC ĐƠN", style: TextStyle(color: Colors.white)),
          ),
        );
    }
  }
}