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

class _MyMealPlanScreenWidgetState extends State<MyMealPlanScreenWidget>
    with SingleTickerProviderStateMixin {
  late MyMealPlanComponentModel _model;
  String? activeMealPlan;
  bool isPremium = false; // Biến trạng thái premium

  // Animation Controller & Animations cho hiệu ứng trang trí
  late AnimationController _animationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _contentFadeAnimation;

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

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));
    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.5, curve: Curves.elasticOut)),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _model.dispose();
    _animationController.dispose();
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
                const Icon(Icons.star, color: Colors.yellow, size: 50),
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
                        style: TextStyle(color: Colors.white70, fontSize: 16),
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
                            fontWeight: FontWeight.bold),
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
      await _checkPremiumStatus(); // Cập nhật trạng thái premium
      return; // Dừng lại nếu không phải premium
    }

    // Nếu là premium, hiển thị dialog xác nhận
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
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
                    Icon(
                      Icons.restaurant_menu,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Thực đơn AI',
                        style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn có muốn AI tạo thực đơn 1 tuần phù hợp với mục tiêu sức khỏe của bạn?',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    if (isLoading) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        color: isLoading
                            ? Colors.grey
                            : FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                      setDialogState(() {
                        isLoading = true;
                      });

                      try {
                        // Gọi API tạo meal plan
                        final result = await _model.createSuitableMealPlanByAI();

                        if (!mounted) return;

                        if (result['success']) {
                          final mealPlan = result['mealPlan'] as MealPlan;
                          Navigator.pop(dialogContext); // Đóng dialog
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
                        } else {
                          setDialogState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  result['message'] ?? 'Lỗi khi tạo thực đơn AI'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                        });
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
                    },
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header không bị giới hạn bởi Padding
          FadeTransition(
            opacity: _headerFadeAnimation,
            child: SlideTransition(
              position: _headerSlideAnimation,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: MediaQuery.of(context).padding.top + 16.0,
                  bottom: 16.0,
                ),
                child: Center(
                  child: Text(
                    "Quản lý thực đơn",
                    style: theme.titleLarge.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Phần còn lại vẫn giữ Padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _buttonScaleAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4)
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm thực đơn...',
                                hintStyle: theme.bodyMedium,
                                prefixIcon: const Icon(Icons.search_sharp,
                                    color: Colors.grey),
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
                          icon: const Icon(Icons.filter_list,
                              color: Colors.grey, size: 28),
                          onPressed: () => _showFilterDialog(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _buttonScaleAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: _buildLargeButton(
                                "Thực đơn mẫu", _navigateToSampleMealPlan)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildLargeButton(
                                "Nhận thực đơn AI", _navigateToAIMealPlan)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: Builder(
                        builder: (context) {
                          if (_model.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (_model.mealPlans.isEmpty) {
                            return const Center(
                                child: Text("Không có thực đơn được tìm thấy"));
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primary,
        onPressed: _showAddMealPlanDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMealPlanItem(MealPlan mealPlan) {
    final theme = FlutterFlowTheme.of(context);
    bool isActive = mealPlan.status == 'Active';

    // Màu sắc dựa trên mục tiêu sức khỏe và trạng thái
    Color accentColor;
    IconData goalIcon;
    switch (mealPlan.healthGoal) {
      case 'Giảm cân':
        accentColor = Colors.green.shade400;
        goalIcon = Icons.fitness_center;
        break;
      case 'Tăng cân':
        accentColor = Colors.orange.shade400;
        goalIcon = Icons.restaurant;
        break;
      case 'Duy trì cân nặng':
        accentColor = Colors.blue.shade400;
        goalIcon = Icons.balance;
        break;
      default:
        accentColor = Colors.grey.shade400;
        goalIcon = Icons.help_outline;
    }

    // Màu viền cho trạng thái Active
    Color borderColor = isActive ? theme.primary : accentColor.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cột thông tin chính
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề
                          Text(
                            mealPlan.planName,
                            style: theme.titleMedium.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Phụ đề
                          Text(
                            mealPlan.healthGoal ?? 'Không có mục tiêu',
                            style: theme.bodyMedium.copyWith(
                              fontSize: 14,
                              color: theme.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Thông tin bổ sung
                          Text(
                            isActive
                                ? 'Đang áp dụng'
                                : 'Thời gian: ${mealPlan.duration ?? 0} ngày',
                            style: theme.bodySmall.copyWith(
                              fontSize: 12,
                              color: isActive
                                  ? theme.primary
                                  : theme.secondaryText.withOpacity(0.7),
                            ),
                          ),
                          if (isActive && mealPlan.startAt != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Từ: ${DateFormat('dd/MM').format(DateTime.parse(mealPlan.startAt!))}',
                              style: theme.bodySmall.copyWith(
                                fontSize: 12,
                                color: theme.secondaryText.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Cột biểu tượng
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        isActive ? Icons.check_circle : goalIcon,
                        color: isActive ? theme.primary : accentColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge số ngày
              Positioned(
                top: 8,
                right: 36,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? theme.primary : accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${mealPlan.duration ?? 0} ngày",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Điểm nhấn viền trái
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              // Nút ba chấm
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: theme.primary, size: 24),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(MealPlan mealPlan) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            title: const Text(
              'Xác nhận xóa',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Bạn có chắc muốn xóa "${mealPlan.planName}" không?',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success =
                      await _model.deleteMealPlan(mealPlan.mealPlanId!);
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Xóa Meal Plan thành công'
                              : 'Lỗi khi xóa Meal Plan',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Xóa',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
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

  void _showFilterDialog() {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            title: Text(
              "Lọc theo mục tiêu sức khỏe",
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: ["Giảm cân", "Tăng cân", "Duy trì cân nặng"]
                        .map((goal) {
                      return ChoiceChip(
                        label: Text(goal, style: const TextStyle(fontSize: 16)),
                        selected: _model.selectedFilter == goal,
                        onSelected: (selected) {
                          _model.setFilter(selected ? goal : null);
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _model.selectedFilter == goal
                              ? FlutterFlowTheme.of(context).primary
                              : Colors.black87,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.5)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Đóng",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 16,
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

  void _showAddMealPlanDialog() {
    String planName = '';
    String? healthGoal;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white, // nền trắng
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Thêm mới thực đơn',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primary, // chữ xanh
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tên thực đơn',
                  labelStyle:
                      TextStyle(color: FlutterFlowTheme.of(context).primary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: FlutterFlowTheme.of(context).primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => planName = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Mục tiêu sức khỏe',
                  labelStyle:
                      TextStyle(color: FlutterFlowTheme.of(context).primary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: FlutterFlowTheme.of(context).primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary, width: 2),
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                items: ['Giảm cân', 'Tăng cân', 'Duy trì cân nặng']
                    .map((goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(
                            goal,
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary),
                          ),
                        ))
                    .toList(),
                onChanged: (value) => healthGoal = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (planName.isNotEmpty && healthGoal != null) {
                  // Hiển thị loading
                  BuildContext? loadingContext;
                  showDialog(
                    context: dialogContext,
                    barrierDismissible: false,
                    builder: (ctx) {
                      loadingContext = ctx;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  try {
                    final mealPlanId =
                        await _model.createMealPlan(planName, healthGoal!);

                    // Đóng loading
                    if (loadingContext != null &&
                        Navigator.canPop(loadingContext!)) {
                      Navigator.pop(loadingContext!);
                    }

                    if (mealPlanId != null && mounted) {
                      Navigator.pop(dialogContext);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealPlanDetailWidget(
                            mealPlanId: mealPlanId,
                            source: MealPlanSource.myMealPlan,
                          ),
                        ),
                      );
                      await _model.fetchMealPlans();
                    } else {
                      Navigator.pop(dialogContext);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Lỗi khi tạo thực đơn: mealPlanId không hợp lệ'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Đóng loading nếu có
                    if (loadingContext != null &&
                        Navigator.canPop(loadingContext!)) {
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
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
