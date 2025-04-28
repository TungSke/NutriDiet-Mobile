import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';
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
  bool isPremium = false;

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
    _model = MealPlanDetailModel();
    _model.fetchMealPlanById(widget.mealPlanId);
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final premiumStatus = await _model.checkPremiumStatus();
    if (mounted) {
      setState(() {
        isPremium = premiumStatus;
      });
    }
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

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            contentPadding: const EdgeInsets.all(24),
            title: Text(
              'Chỉnh sửa thực đơn',
              style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên thực đơn',
                      labelStyle: TextStyle(color: FlutterFlowTheme.of(context).primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.black),
                    controller: TextEditingController(text: planName),
                    onChanged: (value) => planName = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: healthGoal,
                    decoration: InputDecoration(
                      labelText: 'Mục tiêu sức khỏe',
                      labelStyle: TextStyle(color: FlutterFlowTheme.of(context).primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                    items: validHealthGoals
                        .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                        .toList(),
                    onChanged: (value) => healthGoal = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Hủy',
                  style: TextStyle(color: FlutterFlowTheme.of(context).primary, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (planName.isNotEmpty && healthGoal != null) {
                    BuildContext? loadingContext;
                    showDialog(
                      context: context,
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

                      Navigator.pop(context);

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
                      Navigator.pop(context);
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCopyMealPlanDialog() {
    final activeDays = _model.getActiveDays();
    int? dayNumberFrom = activeDays.contains(selectedDay) ? selectedDay : activeDays.isNotEmpty ? activeDays.first : null;
    int? dayNumberTo = _model.getTotalActiveDays() + 1; // Mặc định là ngày mới

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            contentPadding: const EdgeInsets.all(24),
            title: Text(
              'Sao chép thực đơn theo ngày',
              style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: dayNumberFrom,
                      decoration: InputDecoration(
                        labelText: 'Sao chép từ ngày',
                        labelStyle: TextStyle(color: FlutterFlowTheme.of(context).primary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      dropdownColor: Colors.white,
                      style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                      items: activeDays.isNotEmpty
                          ? activeDays
                          .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text('Ngày $day'),
                      ))
                          .toList()
                          : [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Không có ngày nào'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          dayNumberFrom = value;
                          // Nếu ngày đích trùng với ngày nguồn, đặt lại ngày đích
                          if (dayNumberTo == value) {
                            dayNumberTo = _model.getTotalActiveDays() + 1;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: dayNumberTo,
                      decoration: InputDecoration(
                        labelText: 'Sao chép đến ngày',
                        labelStyle: TextStyle(color: FlutterFlowTheme.of(context).primary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      dropdownColor: Colors.white,
                      style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                      items: List.generate(_model.getTotalActiveDays() + 1, (index) => index + 1)
                          .map((day) => DropdownMenuItem(
                        value: day,
                        enabled: day != dayNumberFrom, // Vô hiệu hóa ngày trùng với ngày nguồn
                        child: Text(
                          'Ngày $day',
                          style: TextStyle(
                            color: day == dayNumberFrom ? Colors.grey : FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          dayNumberTo = value;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (dayNumberFrom == null || dayNumberTo == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng chọn cả ngày nguồn và ngày đích'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Hiển thị loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  try {
                    print('Bắt đầu sao chép: mealPlanId=$widget.mealPlanId, from=$dayNumberFrom, to=$dayNumberTo');
                    final success = await _model
                        .copyMealPlanDetail(
                      widget.mealPlanId,
                      dayNumberFrom!,
                      dayNumberTo!,
                      context,
                    )
                        .timeout(const Duration(seconds: 30), onTimeout: () {
                      throw TimeoutException('Sao chép thực đơn quá thời gian chờ');
                    });

                    print('Kết quả sao chép: $success');

                    // Đóng loading dialog
                    Navigator.pop(context);
                    Navigator.pop(context);

                    if (success && mounted) {
                      setState(() {
                        selectedDay = dayNumberTo!;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sao chép ngày thực đơn thành công'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (mounted) {
                      // Kiểm tra lỗi 404 khi success == false
                      final errorMessage = _model.errorMessage ?? 'Lỗi khi sao chép ngày thực đơn';
                      if (errorMessage.contains('No MealPlanDetails')) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                              contentPadding: const EdgeInsets.all(24),
                              title: Text(
                                'Không thể sao chép',
                                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              content: Text(
                                'Không thể sao chép đến ngày $dayNumberTo vì thực đơn ở ngày $dayNumberFrom không có món ăn nào.',
                                style: const TextStyle(color: Colors.black87, fontSize: 16),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            );
                          },
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
                    // Đóng loading dialog và dialog chính
                    Navigator.pop(context);
                    Navigator.pop(context);

                    if (mounted) {
                      // Kiểm tra lỗi 404 trong ngoại lệ
                      if (e.toString().contains('No MealPlanDetails')) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                              contentPadding: const EdgeInsets.all(24),
                              title: Text(
                                'Không thể sao chép',
                                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              content: Text(
                                'Không thể sao chép đến ngày $dayNumberTo vì thực đơn ở ngày $dayNumberFrom không có món ăn nào.',
                                style: const TextStyle(color: Colors.black87, fontSize: 16),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi khi sao chép ngày thực đơn: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Sao chép',
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
            body: Container(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: MealPlanDetailModel.mealTypes.length + 1,
                      itemBuilder: (context, index) {
                        if (index < MealPlanDetailModel.mealTypes.length) {
                          // Hiển thị MealCard
                          final mealType = MealPlanDetailModel.mealTypes[index];
                          final meals = _model.getMealsForDay(selectedDay)[mealType] ?? [];
                          return _buildMealCard(mealType, meals);
                        } else {
                          // Hiển thị ActionButtons ở cuối danh sách
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _buildActionButtons(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySelector() {
    final activeDays = _model.getActiveDays();
    final maxDay = selectedDay > activeDays.last ? selectedDay : activeDays.last; // Lấy ngày lớn nhất
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(maxDay, (index) => index + 1)
                    .map((day) => _buildDayButton(day, "Ngày $day"))
                    .toList(),
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
        child: Stack(
          children: [
            Column(
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
                _buildInfoText("Số ngày thực đơn", "${mealPlan?.duration ?? 0} ngày"),
                _buildInfoText("Tạo bởi", mealPlan?.createdBy ?? "Không rõ"),
              ],
            ),
            // Nút cảnh báo vàng chỉ hiển thị cho myMealPlan
            if (widget.source == MealPlanSource.myMealPlan)
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.warning_amber_rounded,
                        color: isPremium ? Colors.yellow : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () async {
                        if (!isPremium) {
                          await _showPremiumRequiredDialog();
                          return;
                        }
                        _showAIWarningDialog();
                      },
                      tooltip: "Xem cảnh báo AI",
                    ),
                    Text(
                      "Cảnh báo thực đơn",
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: isPremium ? Colors.yellow.shade700 : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPremiumRequiredDialog() async {
    final proceedToPremium = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                'Để sử dụng tính năng "Xem cảnh báo thực đơn từ chuyên gia AI", bạn cần nâng cấp lên tài khoản Premium.\nThưởng thức các tính năng độc quyền ngay hôm nay!',
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

    if (proceedToPremium == true && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyPremiumPackageScreenWidget(),
        ),
      );
      // Kiểm tra lại trạng thái premium sau khi quay lại
      await _checkPremiumStatus();
    }
  }

// Hàm hiển thị popup AI Warning
  void _showAIWarningDialog() {
    bool isRefreshing = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Cảnh báo về thực đơn",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5, // Giới hạn chiều cao tối đa
              minWidth: 280, // Đảm bảo chiều rộng tối thiểu
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_model.mealPlan?.aiWarning == null && _model.errorMessage == null) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey.shade600,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Chưa có cảnh báo",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Nhấn 'Làm mới' để tạo cảnh báo từ AI.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Text(
                      _model.mealPlan?.aiWarning ?? _model.errorMessage ?? "Chưa có cảnh báo, vui lòng nhấn Làm mới để tạo.",
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    "Làm mới nếu bạn vừa thay đổi chi tiết thực đơn",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (isRefreshing) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Đóng",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isRefreshing
                  ? null
                  : () async {
                setDialogState(() {
                  isRefreshing = true;
                });

                await _model.createAIWarning(widget.mealPlanId);

                if (mounted) {
                  setDialogState(() {
                    isRefreshing = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                "Làm mới",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
    final userGoals = _model.userGoals ?? {'calories': 2000.0, 'carbs': 250.0, 'fat': 70.0, 'protein': 100.0};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Chú thích hiển thị theo source
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              widget.source == MealPlanSource.myMealPlan
                  ? "Tổng Dinh Dưỡng Ngày $selectedDay/Mục Tiêu Cần Nạp Mỗi Ngày"
                  : "Tổng Dinh Dưỡng Ngày $selectedDay",
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
                widget.source == MealPlanSource.myMealPlan
                    ? "${totalCalories.toStringAsFixed(0)}/${userGoals['calories']!.toStringAsFixed(0)}"
                    : totalCalories.toStringAsFixed(0),
                "kcal",
              ),
              _buildNutrientDisplay(
                "Carbs",
                widget.source == MealPlanSource.myMealPlan
                    ? "${carbs.toStringAsFixed(0)}/${userGoals['carbs']!.toStringAsFixed(0)}"
                    : carbs.toStringAsFixed(0),
                "g",
              ),
              _buildNutrientDisplay(
                "Protein",
                widget.source == MealPlanSource.myMealPlan
                    ? "${protein.toStringAsFixed(0)}/${userGoals['protein']!.toStringAsFixed(0)}"
                    : protein.toStringAsFixed(0),
                "g",
              ),
              _buildNutrientDisplay(
                "Fat",
                widget.source == MealPlanSource.myMealPlan
                    ? "${fat.toStringAsFixed(0)}/${userGoals['fat']!.toStringAsFixed(0)}"
                    : fat.toStringAsFixed(0),
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
                fontSize: 14, // Giảm font size để hiển thị đầy đủ
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Cho phép xuống dòng nếu cần
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

  Widget _buildActionButtons() {
    switch (widget.source) {
      case MealPlanSource.myMealPlan:
        final isActive = _model.mealPlan?.status == 'Active';
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? Colors.red : FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  // Existing apply/hide apply logic remains unchanged
                  try {
                    final success = await _model.applyMealPlan(widget.mealPlanId);
                    if (!mounted) return;
                    if (success) {
                      final isActive = _model.mealPlan?.status == 'Active';
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                            ),
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                              contentPadding: const EdgeInsets.all(24),
                              title: Text(
                                isActive ? "Thực đơn đang được áp dụng" : "Hủy áp dụng thành công",
                                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              content: Text(
                                isActive
                                    ? "Thực đơn đã được áp dụng thành công."
                                    : "Thực đơn đã được hủy áp dụng thành công.",
                                style: TextStyle(color: Colors.black87, fontSize: 16),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      final errorMessage = _model.errorMessage ?? 'Lỗi khi áp dụng/hủy áp dụng thực đơn';
                      if (errorMessage.contains("Bạn đã có một thực đơn đang được áp dụng")) {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                              ),
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 8,
                                contentPadding: const EdgeInsets.all(24),
                                title: Text(
                                  "Thông báo",
                                  style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                content: const Text(
                                  "Bạn đang có thực đơn khác được áp dụng",
                                  style: TextStyle(color: Colors.black87, fontSize: 16),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: FlutterFlowTheme.of(context).primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showCopyMealPlanDialog,
                child: Text(
                  "SAO CHÉP NGÀY",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                      ),
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        contentPadding: const EdgeInsets.all(24),
                        title: Text(
                          "Sao chép thành công",
                          style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        content: const Text(
                          "Sao chép thực đơn thành công, vui lòng kiểm tra trong thực đơn của bạn.",
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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

    // Lấy giá trị calories cho bữa ăn
    final calories = _model.getCaloriesForMealType(selectedDay, mealType);

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasMeals) // Hiển thị calories nếu có món ăn
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "${calories.toStringAsFixed(0)} kcal",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
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
          ],
        ),
      ),
    );
  }
}