import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class SampleMealPlanWidget extends StatefulWidget {
  const SampleMealPlanWidget({super.key});

  @override
  State<SampleMealPlanWidget> createState() => _SampleMealPlanWidgetState();
}

class _SampleMealPlanWidgetState extends State<SampleMealPlanWidget> {
  String searchQuery = "";
  String? selectedFilter;

  final List<Map<String, dynamic>> sampleMealPlans = [
    {"name": "Thực đơn Keto", "goal": "Giảm cân", "days": 7},
    {"name": "Thực đơn Protein", "goal": "Tăng cơ", "days": 14},
    {"name": "Thực đơn Low-Carb", "goal": "Giữ dáng", "days": 10},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Thực đơn mẫu",
            style: TextStyle(color: Colors.white),
          ),
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
    return sampleMealPlans.where((plan) {
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
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(mealPlan["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("${mealPlan["goal"]} - Số ngày: ${mealPlan["days"]}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
        onTap: () {},
      ),
    );
  }
}
