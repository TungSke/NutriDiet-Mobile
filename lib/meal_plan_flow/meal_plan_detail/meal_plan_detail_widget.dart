import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../services/models/mealplan.dart';
import '../../services/models/mealplandetail.dart';
import 'meal_plan_detail_model.dart';

enum MealPlanSource {
  myMealPlan,
  sampleMealPlan,
  aiMealPlan,
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

  @override
  void initState() {
    super.initState();
    _model = MealPlanDetailModel();
    _fetchMealPlan();
  }

  Future<void> _fetchMealPlan() async {
    await _model.fetchMealPlanById(widget.mealPlanId);
    setState(() {});
  }

  void _addNewDay() {
    setState(() {
      // Logic thêm ngày mới (chỉ cho MyMealPlan)
    });
  }

  void _copyMealPlan() {
    debugPrint("Sao chép thực đơn ${widget.mealPlanId} về MyMealPlan");
    Navigator.pop(context);
  }

  void _applyMealPlan() {
    debugPrint("Áp dụng thực đơn ${widget.mealPlanId}");
  }

  void _rejectMealPlan() {
    showDialog(
      context: context,
      builder: (context) {
        String reason = '';
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          title: const Text("Từ chối thực đơn", style: TextStyle(color: Colors.white)),
          content: TextField(
            decoration: const InputDecoration(
              hintText: "Nhập lý do từ chối...",
              hintStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => reason = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                debugPrint("Từ chối thực đơn ${widget.mealPlanId} với lý do: $reason");
                Navigator.pop(context);
                _fetchMealPlan(); // Giả lập tạo mới
              },
              child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _saveMealPlan() {
    debugPrint("Lưu thực đơn ${widget.mealPlanId} về MyMealPlan");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_model.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_model.errorMessage != null || _model.mealPlan == null) {
      return Scaffold(body: Center(child: Text(_model.errorMessage ?? "Không tìm thấy kế hoạch")));
    }

    final mealPlan = _model.mealPlan!;
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
            mealPlan.planName,
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
                  _buildMealPlanCard(mealPlan),
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
                      itemCount: _model.getMealsForDay(selectedDay).length,
                      itemBuilder: (context, index) {
                        final meal = _model.getMealsForDay(selectedDay)[index];
                        return _buildMealCard(meal);
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
  }

  Widget _buildDaySelector() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  _model.getTotalDays(),
                      (index) => _buildDayButton(index + 1, "Ngày ${index + 1}"),
                ),
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

  Widget _buildMealPlanCard(MealPlan mealPlan) {
    return Card(
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
                    mealPlan.planName,
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.source == MealPlanSource.myMealPlan)
                  IconButton(
                    icon: Icon(Icons.edit, color: FlutterFlowTheme.of(context).primary),
                    onPressed: () {
                      debugPrint("Chỉnh sửa thực đơn ${widget.mealPlanId}");
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoText("Mục tiêu sức khỏe", mealPlan.healthGoal ?? "Không xác định"),
            _buildInfoText("Số ngày thực đơn", "${_model.getTotalDays()} ngày"),
            _buildInfoText("Tạo bởi", mealPlan.createdBy ?? "Không rõ"),
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

  Widget _buildMealCard(MealPlanDetail meal) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          meal.mealType ?? "Không xác định",
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          meal.foodName ?? "Chưa có món ăn",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: widget.source == MealPlanSource.myMealPlan
            ? CircleAvatar(
          backgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
          child: Icon(Icons.add, color: FlutterFlowTheme.of(context).primary),
        )
            : null,
        onTap: () {},
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (widget.source) {
      case MealPlanSource.myMealPlan:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _applyMealPlan,
            child: const Text("ÁP DỤNG THỰC ĐƠN", style: TextStyle(color: Colors.white)),
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
            onPressed: _copyMealPlan,
            child: const Text("SAO CHÉP THỰC ĐƠN", style: TextStyle(color: Colors.white)),
          ),
        );
      case MealPlanSource.aiMealPlan:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _rejectMealPlan,
                child: const Text("TỪ CHỐI THỰC ĐƠN", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveMealPlan,
                child: const Text("LƯU THỰC ĐƠN", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
    }
  }
}