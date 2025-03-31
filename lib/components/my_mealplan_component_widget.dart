import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';
import '../meal_plan_flow/meal_plan_detail/ai_meal_plan_detail/ai_meal_plan_detail_widget.dart';
import '../meal_plan_flow/meal_plan_detail/meal_plan_detail_widget.dart';
import '../meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_widget.dart';
import '../services/models/mealplan.dart';
import 'my_mealplan_component_model.dart';

class MyMealPlanScreenWidget extends StatefulWidget {
  const MyMealPlanScreenWidget({super.key});

  @override
  State<MyMealPlanScreenWidget> createState() => _MyMealPlanScreenWidgetState();
}

class _MyMealPlanScreenWidgetState extends State<MyMealPlanScreenWidget> {
  late MyMealPlanComponentModel _model;
  String? activeMealPlan;
  bool isPremium = false; // Biến trạng thái premium

  @override
  void initState() {
    super.initState();
    _model = MyMealPlanComponentModel();
    _model.setUpdateCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
    _model.fetchMealPlans();
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

  Future<void> _navigateToSampleMealPlan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SampleMealPlanWidget()),
    );
    if (mounted) {
      await _model.fetchMealPlans();
    }
  }

  Future<void> _navigateToAIMealPlan() async {
    if (!mounted) return;

    // Kiểm tra trạng thái premium trước
    final isPremium = await _model.checkPremiumStatus();
    if (!isPremium) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

    // Nếu là premium, hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Nhận thực đơn AI', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Nhận thực đơn 1 tuần từ AI',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Đóng', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Hiển thị loading dialog
    BuildContext? loadingContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        loadingContext = dialogContext;
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Gọi API tạo meal plan
      final result = await _model.createSuitableMealPlanByAI();

      // Đóng loading dialog
      if (loadingContext != null && Navigator.canPop(loadingContext!)) {
        Navigator.pop(loadingContext!);
      }

      if (result['success'] && mounted) {
        final mealPlan = result['mealPlan'] as MealPlan;
        debugPrint("Navigating to AI Meal Plan Detail with temporary MealPlan");
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIMealPlanDetailWidget(
              initialMealPlan: mealPlan,
            ),
          ),
        );
        if (mounted) {
          await _model.fetchMealPlans();
        }
      } else if (mounted) {
        // Nếu backend trả về lỗi (ví dụ: 403), hiển thị SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Lỗi khi tạo thực đơn AI'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Đóng loading dialog nếu có lỗi
      if (loadingContext != null && Navigator.canPop(loadingContext!)) {
        Navigator.pop(loadingContext!);
      }
      if (mounted) {
        debugPrint("Error in _navigateToAIMealPlan: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi không xác định: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 119.0,
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Text(
                "Quản lý thực đơn",
                style: theme.titleLarge.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm thực đơn...',
                        hintStyle: theme.bodyMedium,
                        prefixIcon: const Icon(Icons.search_sharp, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onChanged: (value) {
                        _model.fetchMealPlans(searchQuery: value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey, size: 28),
                  onPressed: () => _showFilterDialog(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildLargeButton("Thực đơn mẫu", _navigateToSampleMealPlan)),
                const SizedBox(width: 10),
                Expanded(child: _buildLargeButton("Nhận thực đơn AI", _navigateToAIMealPlan)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_model.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_model.mealPlans.isEmpty) {
                    return const Center(child: Text("Không có thực đơn được tìm thấy"));
                  }
                  final filteredPlans = _model.getFilteredMealPlans();
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: filteredPlans.length,
                    itemBuilder: (context, index) {
                      return _buildMealPlanItem(filteredPlans[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primary,
        onPressed: _showAddMealPlanDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMealPlanItem(MealPlan mealPlan) {
    bool isActive = mealPlan.status == 'Active';
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isActive ? Colors.green[100] : const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              mealPlan.planName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${mealPlan.healthGoal ?? 'Không có mục tiêu'} - Số ngày: ${mealPlan.duration ?? 'Không xác định'}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealPlanDetailWidget(
                    mealPlanId: mealPlan.mealPlanId!,
                    source: MealPlanSource.myMealPlan,
                  ),
                ),
              );
              if (mounted) {
                await _model.fetchMealPlans();
              }
            },
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(mealPlan);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Xóa'),
                ),
              ],
            ),
          ),
          if (isActive)
            Positioned(
              bottom: 8,
              right: 16,
              child: Text(
                "Thực đơn đang được áp dụng từ ngày ${mealPlan.startAt != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(mealPlan.startAt!)) : 'Không xác định'}",
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(MealPlan mealPlan) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc muốn xóa "${mealPlan.planName}" không?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              debugPrint('Xóa meal plan: ${mealPlan.planName}');
              Navigator.pop(context);
              final success = await _model.deleteMealPlan(mealPlan.mealPlanId!);
              if (mounted) {
                if (success) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Xóa Meal Plan thành công')),
                  );
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Lỗi khi xóa Meal Plan')),
                  );
                }
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lọc theo mục tiêu sức khỏe", style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10,
                children: ["Giảm cân", "Tăng cân", "Duy trì cân nặng"].map((goal) {
                  return ChoiceChip(
                    label: Text(goal),
                    selected: _model.selectedFilter == goal,
                    onSelected: (selected) {
                      _model.setFilter(selected ? goal : null);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddMealPlanDialog() {
    String planName = '';
    String? healthGoal;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Thêm mới thực đơn', style: TextStyle(color: Colors.white)),
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
              onChanged: (value) => planName = value,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Mục tiêu sức khỏe',
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: FlutterFlowTheme.of(context).primary,
              style: const TextStyle(color: Colors.black),
              items: ['Giảm cân', 'Tăng cân', 'Duy trì cân nặng']
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
                debugPrint('Thêm mới: $planName - $healthGoal');

                // Hiển thị loading trong dialog
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
                  final mealPlanId = await _model.createMealPlan(planName, healthGoal);

                  if (loadingContext != null && Navigator.canPop(loadingContext!)) {
                    Navigator.pop(loadingContext!);
                  }

                  if (mealPlanId != null) {
                    // Đóng dialog trước khi chuyển hướng
                    Navigator.pop(dialogContext);

                    // Chuyển hướng đến MealPlanDetailWidget
                    if (mounted) {
                      await Navigator.push(
                        context, // Context của MyMealPlanScreenWidget
                        MaterialPageRoute(
                          builder: (context) => MealPlanDetailWidget(
                            mealPlanId: mealPlanId,
                            source: MealPlanSource.myMealPlan,
                          ),
                        ),
                      );

                    }
                  } else {
                    Navigator.pop(dialogContext);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lỗi khi tạo thực đơn: mealPlanId không hợp lệ'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  // Đóng loading nếu có lỗi
                  if (loadingContext != null && Navigator.canPop(loadingContext!)) {
                    Navigator.pop(loadingContext!);
                  }
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi tạo thực đơn: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Thêm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeButton(String title, VoidCallback onPressed) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: title == "Nhận thực đơn AI" && !isPremium
              ? Colors.grey[600] // Màu xám đen khi không premium
              : FlutterFlowTheme.of(context).primary, // Màu gốc khi premium
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}