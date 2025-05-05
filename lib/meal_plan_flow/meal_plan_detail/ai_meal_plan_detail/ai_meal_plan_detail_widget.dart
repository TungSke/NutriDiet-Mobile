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

  // Ánh xạ tên bữa ăn sang tiếng Việt
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

  final Map<String, Map<String, String>> mealTypeTranslations = {
    'Breakfast': {
      'name': 'Bữa sáng',
      'time': '6:00 - 8:00 sáng',
    },
    'Lunch': {
      'name': 'Bữa trưa',
      'time': '12:00 - 14:00 chiều',
    },
    'Dinner': {
      'name': 'Bữa tối',
      'time': '18:00 - 20:00 tối',
    },
    'Snacks': {
      'name': 'Bữa phụ',
      'time': '15:00 - 16:00 chiều',
    },
  };

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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        String reason = '';
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            contentPadding: const EdgeInsets.all(24),
            title: Row(
              children: [
                Icon(Icons.feedback, color: FlutterFlowTheme.of(context).primary, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Từ chối thực đơn",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vui lòng cho biết lý do bạn không hài lòng với thực đơn. Thực đơn sẽ được làm mới dựa trên phản hồi của bạn.",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => reason = value,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Nhập lý do...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Hủy",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Đóng dialog nhập lý do

                  BuildContext? loadingDialogContext;
                  if (mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) {
                        loadingDialogContext = dialogContext;
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80), // Giới hạn kích thước Dialog
                            padding: const EdgeInsets.all(16), // Giảm padding
                            child: Center(
                              child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary,
                                strokeWidth: 3, // Giảm độ dày của vòng tròn
                              ),
                            ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Thực đơn đã được làm mới thành công"),
                          backgroundColor: Colors.green,
                        ),
                      );
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveMealPlan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: Text(
            "Bạn có gì không hài lòng về thực đơn không?",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primary,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Hãy cho chúng tôi biết ý kiến của bạn!",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                Navigator.pop(context);
                _executeSaveMealPlan(null);
              },
              child: const Text("Không", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
              child: const Text(
                "Có",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog() {
    String? selectedFeedback;
    String? additionalDetail;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(Icons.feedback, color: FlutterFlowTheme.of(context).primary),
                  const SizedBox(width: 8),
                  Text(
                    "Phản hồi về thực đơn",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5, // Giới hạn chiều cao dialog
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            RadioListTile<String>(
                              value: "Hài lòng với phản hồi về thực đơn",
                              groupValue: selectedFeedback,
                              title: Text(
                                "Hài lòng",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              onChanged: (value) {
                                setState(() {
                                  selectedFeedback = value;
                                  additionalDetail = null;
                                });
                              },
                            ),
                            Divider(height: 1, color: Colors.grey.shade300),
                            RadioListTile<String>(
                              value: "Không hài lòng với phản hồi về thực đơn",
                              groupValue: selectedFeedback,
                              title: Text(
                                "Không hài lòng",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              onChanged: (value) {
                                setState(() {
                                  selectedFeedback = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (selectedFeedback == "Không hài lòng với phản hồi về thực đơn") ...[
                        const SizedBox(height: 8),
                        Text(
                          "Chi tiết",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) => additionalDetail = value,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Nhập chi tiết phản hồi của bạn...",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _saveMealPlan();
                  },
                  child: const Text("Đóng", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: selectedFeedback == null
                      ? null
                      : () async {
                    Navigator.pop(dialogContext);
                    String finalFeedback = selectedFeedback!;
                    if (additionalDetail != null && additionalDetail!.isNotEmpty) {
                      finalFeedback += ", chi tiết: $additionalDetail";
                    }
                    _executeSaveMealPlan(finalFeedback);
                  },
                  child: const Text(
                    "Gửi",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _executeSaveMealPlan(String? feedback) async {
    BuildContext? loadingDialogContext;
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          loadingDialogContext = dialogContext;
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80), // Giới hạn kích thước Dialog
              padding: const EdgeInsets.all(16), // Giảm padding
              child: Center(
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  strokeWidth: 3, // Giảm độ dày của vòng tròn
                ),
              ),
            ),
          );
        },
      );
    }

    try {
      final result = await _model.saveMealPlanAI(feedback: feedback);
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
          resizeToAvoidBottomInset: true,
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
                  child: SingleChildScrollView( // Thêm SingleChildScrollView
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMealPlanCard(mealPlan),
                        const SizedBox(height: 12),
                        _buildDaySelector(),
                        const SizedBox(height: 12),
                        _buildNutrientProgress(),
                        const SizedBox(height: 12),
                        const SizedBox(height: 12),
                        SizedBox( // Thay Expanded bằng SizedBox với chiều cao cụ thể
                          height: 200, // Điều chỉnh chiều cao phù hợp
                          child: ListView.builder(
                            itemCount: _model.getMealsForDay(selectedDay).length,
                            itemBuilder: (context, index) {
                              final mealType = _model.getMealsForDay(selectedDay).keys.elementAt(index);
                              final meals = _model.getMealsForDay(selectedDay)[mealType]!;
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
            _buildInfoText("Tạo bởi", mealPlan.createdBy ?? "Không xác định"),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              "Tổng Dinh Dưỡng Ngày $selectedDay",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).tertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNutrientDisplay(
                "Calories",
                totalCalories.toStringAsFixed(0),
                "kcal",
              ),
              _buildNutrientDisplay(
                "Carbs",
                carbs.toStringAsFixed(0),
                "g",
              ),
              _buildNutrientDisplay(
                "Protein",
                protein.toStringAsFixed(0),
                "g",
              ),
              _buildNutrientDisplay(
                "Fat",
                fat.toStringAsFixed(0),
                "g",
              ),
            ],
          ),
        ],
      ),
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
                fontSize: 14, // Giảm font size để đảm bảo hiển thị đầy đủ
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Cho phép xuống dòng nếu giá trị dài
              overflow: TextOverflow.visible, // Đảm bảo không bị cắt
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$label ($unit)",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMealCard(String mealType, List<MealPlanDetail> meals) {
    final vietnameseMealInfo = mealTypeTranslations[mealType] ?? {
      'name': mealType,
      'time': '',
    };
    final vietnameseMealType = vietnameseMealInfo['name']!;
    final mealTime = vietnameseMealInfo['time']!;
    String foodNames;
    if (meals.isEmpty) {
      foodNames = "Chưa có món ăn";
    } else {
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
    final totalCalories = meals.fold<double>(
      0,
          (sum, meal) => sum + (meal.totalCalories ?? 0),
    );

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
                  Row(
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
            if (hasMeals)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "${totalCalories.toStringAsFixed(0)} kcal",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(0, 48), // Đảm bảo chiều cao tối thiểu
            ),
            onPressed: _rejectMealPlan,
            child: Text(
              "TỪ CHỐI THỰC ĐƠN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14, // Giảm font size để tránh xuống dòng
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Cắt bớt nếu văn bản quá dài
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(0, 48), // Đảm bảo chiều cao tối thiểu
            ),
            onPressed: _saveMealPlan,
            child: Text(
              "LƯU THỰC ĐƠN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14, // Giảm font size để nhất quán
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Cắt bớt nếu văn bản quá dài
            ),
          ),
        ),
      ],
    );
  }
}