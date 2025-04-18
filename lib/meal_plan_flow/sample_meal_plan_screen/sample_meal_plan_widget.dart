import 'package:diet_plan_app/meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/models/mealplan.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../meal_plan_detail/meal_plan_detail_widget.dart';

class SampleMealPlanWidget extends StatefulWidget {
  const SampleMealPlanWidget({super.key});

  @override
  State<SampleMealPlanWidget> createState() => _SampleMealPlanWidgetState();
}

class _SampleMealPlanWidgetState extends State<SampleMealPlanWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<SampleMealPlanModel>(context, listen: false).fetchSampleMealPlans());

    // Lắng nghe cuộn để tải thêm
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !Provider.of<SampleMealPlanModel>(context, listen: false).isLoadingMore) {
        Provider.of<SampleMealPlanModel>(context, listen: false).fetchSampleMealPlans();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SampleMealPlanModel>();
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Thực đơn mẫu",
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
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm thực đơn...',
                            hintStyle: theme.bodyMedium,
                            prefixIcon: const Icon(Icons.search_sharp, color: Colors.grey),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: model.updateSearchQuery,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey, size: 28),
                        onPressed: () => _showFilterDialog(context, model),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: model.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : model.filteredMealPlans.isEmpty
                        ? const Center(
                        child: Text("Không có thực đơn được tìm thấy", style: TextStyle(fontSize: 16)))
                        : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: model.filteredMealPlans.length + (model.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == model.filteredMealPlans.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return _buildMealPlanItem(context, model.filteredMealPlans[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, SampleMealPlanModel model) {
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
                    children: ["Giảm cân", "Tăng cân", "Duy trì cân nặng"].map((goal) {
                      final isSelected = model.selectedFilter == goal;
                      return ChoiceChip(
                        label: Text(goal, style: const TextStyle(fontSize: 16)),
                        selected: isSelected,
                        onSelected: (selected) {
                          model.updateFilter(selected ? goal : null);
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.black87,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: FlutterFlowTheme.of(context).primary.withOpacity(0.5)),
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

  Widget _buildMealPlanItem(BuildContext context, MealPlan mealPlan) {
    final theme = FlutterFlowTheme.of(context);

    // Màu sắc dựa trên mục tiêu sức khỏe
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealPlanDetailWidget(
                mealPlanId: mealPlan.mealPlanId!,
                source: MealPlanSource.sampleMealPlan,
              ),
            ),
          );
          if (result == true && mounted) {
            Navigator.pop(context, true);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accentColor.withOpacity(0.3),
              width: 1,
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
                            mealPlan.planName ?? "Không có tên",
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
                            mealPlan.healthGoal ?? "Không có mục tiêu",
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
                            "Thời gian: ${mealPlan.duration ?? 0} ngày",
                            style: theme.bodySmall.copyWith(
                              fontSize: 12,
                              color: theme.secondaryText.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Cột biểu tượng/icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        goalIcon,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge số ngày
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
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
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}