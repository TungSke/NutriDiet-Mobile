import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../meal_plan_flow/ai_meal_plan_screen/ai_meal_plan_widget.dart';
import '../meal_plan_flow/meal_plan_detail/meal_plan_detail_widget.dart';
import '../meal_plan_flow/sample_meal_plan_screen/sample_meal_plan_widget.dart';

class MyMealPlanScreenWidget extends StatefulWidget {
  const MyMealPlanScreenWidget({super.key});

  @override
  State<MyMealPlanScreenWidget> createState() => _MyMealPlanScreenWidgetState();
}

class _MyMealPlanScreenWidgetState extends State<MyMealPlanScreenWidget> {
  String searchQuery = "";
  String? selectedFilter;

  final List<Map<String, dynamic>> mealPlans = [
    {"name": "Thực đơn A", "goal": "Giảm cân", "days": 3, "createby": "User", "isActive": false},
    {"name": "Thực đơn B", "goal": "Tăng cơ", "days": 7,"createby": "User", "isActive": true},
    {"name": "Thực đơn C", "goal": "Giữ dáng", "days": 10,"createby": "User", "isActive": false},
  ];

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
              alignment: AlignmentDirectional(0.0, 1.0),
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
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm thực đơn...',
                        hintStyle: theme.bodyMedium,
                        prefixIcon: const Icon(Icons.search_sharp, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onChanged: (value) => setState(() => searchQuery = value),
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
                _buildLargeButton("Thực đơn mẫu", SampleMealPlanWidget()),
                FloatingActionButton(
                  backgroundColor: theme.primary,
                  onPressed: () {},
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                _buildLargeButton("Thực đơn AI", AIMealPlanWidget()),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: _filteredMealPlans().length,
                itemBuilder: (context, index) => _buildMealPlanItem(_filteredMealPlans()[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lọc theo mục tiêu sức khỏe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10,
                children: ["Giảm cân", "Tăng cơ", "Giữ dáng"].map((goal) {
                  return ChoiceChip(
                    label: Text(goal),
                    selected: selectedFilter == goal,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = selected ? goal : null;
                      });
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
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _filteredMealPlans() {
    return mealPlans.where((plan) {
      final matchesSearch = searchQuery.isEmpty || plan["name"].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == null || plan["goal"] == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildMealPlanItem(Map<String, dynamic> mealPlan) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color(0xFFF5F5F5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(mealPlan["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("${mealPlan["goal"]} - Số ngày: ${mealPlan["days"]}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: Switch(
          value: mealPlan["isActive"],
          activeColor: FlutterFlowTheme.of(context).primary,
          onChanged: (bool value) => setState(() => mealPlan["isActive"] = value),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealPlanDetailWidget(
                mealPlanName: mealPlan["name"],
                goal: mealPlan["goal"],
                days: mealPlan["days"],
                createdBy: mealPlan["createby"],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildLargeButton(String title, Widget targetScreen) {
    return SizedBox(
      width: 160,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
