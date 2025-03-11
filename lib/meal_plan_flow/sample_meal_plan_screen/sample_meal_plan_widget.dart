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
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<SampleMealPlanModel>(context, listen: false).fetchSampleMealPlans());
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SampleMealPlanModel>();
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text("Thực đơn mẫu", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: theme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  ? const Center(child: Text("Không có thực đơn được tìm thấy", style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: model.filteredMealPlans.length,
                itemBuilder: (context, index) => _buildMealPlanItem(context, model.filteredMealPlans[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, SampleMealPlanModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: FlutterFlowTheme.of(context).primary, // Màu xanh giống button
              title: const Text("Lọc theo mục tiêu sức khỏe", style: TextStyle(color: Colors.white)),
              content: Wrap(
                spacing: 10,
                children: ["Giảm cân", "Tăng cân", "Healthy", "Tiểu đường"].map((goal) {
                  final isSelected = model.selectedFilter == goal;
                  return ChoiceChip(
                    label: Text(goal),
                    selected: isSelected,
                    onSelected: (selected) {
                      model.updateFilter(isSelected ? null : goal); // Chọn lại filter => clear filter
                      setState(() {}); // Cập nhật UI của dialog
                    },
                  );
                }).toList(), 
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
      },
    );
  }

  Widget _buildMealPlanItem(BuildContext context, MealPlan mealPlan) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(mealPlan.planName ?? "Không có tên", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("${mealPlan.healthGoal ?? "Không có mục tiêu"} - Số ngày: ${mealPlan.duration ?? 0}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealPlanDetailWidget(
                mealPlanId: mealPlan.mealPlanId,
              ),
            ),
          );
        },
      ),
    );
  }
}