import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../services/models/mealplan.dart';
import '../../../services/models/mealplandetail.dart';
import 'ai_meal_plan_detail_model.dart';

class AIMealPlanDetailWidget extends StatefulWidget {
  final MealPlan? initialMealPlan;
  final int? mealPlanId;

  const AIMealPlanDetailWidget({
    super.key,
    this.initialMealPlan,
    this.mealPlanId,
  }) : assert(initialMealPlan != null || mealPlanId != null, 'Phải cung cấp initialMealPlan hoặc mealPlanId');

  @override
  _AIMealPlanDetailWidgetState createState() => _AIMealPlanDetailWidgetState();
}

class _AIMealPlanDetailWidgetState extends State<AIMealPlanDetailWidget> {
  late AIMealPlanDetailModel _model;
  int selectedDay = 1;

  @override
  void initState() {
    super.initState();
    _model = AIMealPlanDetailModel();
    if (widget.initialMealPlan != null) {
      _model.setInitialMealPlan(widget.initialMealPlan!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    } else if (widget.mealPlanId != null) {
      _model.fetchMealPlanById(widget.mealPlanId!);
    }
  }

  void _rejectMealPlan() {
    showDialog(
      context: context,
      builder: (context) {
        String reason = '';
        return AlertDialog(
          title: const Text("Từ chối thực đơn"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nêu lý do bạn không thích ở thực đơn, thực đơn sẽ được làm mới",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => reason = value,
                decoration: const InputDecoration(
                  hintText: "Nhập lý do...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Đóng dialog nhập lý do

                BuildContext? loadingDialogContext;
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      loadingDialogContext = dialogContext;
                      return AlertDialog(
                        content: Row(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Đang tạo thực đơn mới từ yêu cầu của bạn"),
                          ],
                        ),
                      );
                    },
                  );
                }

                try {
                  final result = await _model.rejectMealPlan(reason);

                  if (!mounted) {
                    if (loadingDialogContext != null && Navigator.canPop(loadingDialogContext!)) {
                      Navigator.pop(loadingDialogContext!);
                    }
                    return;
                  }

                  if (result['success']) {
                    if (result['mealPlan'] != null) {
                      _model.setInitialMealPlan(result['mealPlan'] as MealPlan);
                    } else {
                      final newPlanResult = await _model.createSuitableMealPlanByAI();
                      if (newPlanResult['success'] && newPlanResult['mealPlan'] != null) {
                        _model.setInitialMealPlan(newPlanResult['mealPlan'] as MealPlan);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(newPlanResult['message'] ?? 'Lỗi khi tạo thực đơn mới'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Lỗi khi từ chối thực đơn'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã xảy ra lỗi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (loadingDialogContext != null && Navigator.canPop(loadingDialogContext!)) {
                    Navigator.pop(loadingDialogContext!);
                  }
                }
              },
              child: const Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }

  void _saveMealPlan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận lưu thực đơn"),
          content: const Text("Bạn có chắc chắn muốn lưu thực đơn này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Đóng dialog xác nhận

                BuildContext? loadingDialogContext;
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      loadingDialogContext = dialogContext;
                      return AlertDialog(
                        content: Row(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Đang lưu thực đơn..."),
                          ],
                        ),
                      );
                    },
                  );
                }

                try {
                  final result = await _model.saveMealPlanAI();
                  if (!mounted) {
                    if (loadingDialogContext != null && Navigator.canPop(loadingDialogContext!)) {
                      Navigator.pop(loadingDialogContext!);
                    }
                    return;
                  }

                  if (result['success']) {
                    Navigator.pop(context); // Quay lại màn hình trước đó
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Đã lưu thực đơn thành công"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Lỗi khi lưu thực đơn'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã xảy ra lỗi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (loadingDialogContext != null && Navigator.canPop(loadingDialogContext!)) {
                    Navigator.pop(loadingDialogContext!);
                  }
                }
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _model,
      builder: (context, child) {
        if (_model.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (_model.mealPlan == null) {
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
      },
    );
  }

  Widget _buildDaySelector() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _model.getTotalDays(),
                    (index) => _buildDayButton(index + 1, "Ngày ${index + 1}"),
              ),
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
                    mealPlan.planName,
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoText("Mục tiêu sức khỏe", mealPlan.healthGoal ?? "Không xác định"),
            _buildInfoText("Số ngày thực đơn", "${_model.getTotalDays()} ngày"),
            _buildInfoText("Tạo bởi", "AI"),
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
    final carbs = nutrients['carbs']!;
    final protein = nutrients['protein']!;
    final fat = nutrients['fat']!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutrientDisplay("Carbs", carbs.toStringAsFixed(0), "g"),
        _buildNutrientDisplay("Protein", protein.toStringAsFixed(0), "g"),
        _buildNutrientDisplay("Fat", fat.toStringAsFixed(0), "g"),
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
      color: Colors.white,
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
        onTap: () {},
      ),
    );
  }

  Widget _buildActionButtons() {
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