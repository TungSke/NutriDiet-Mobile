import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class MyMealPlanScreenWidget extends StatefulWidget {
  const MyMealPlanScreenWidget({super.key});

  @override
  State<MyMealPlanScreenWidget> createState() => _MyMealPlanScreenWidgetState();
}

class _MyMealPlanScreenWidgetState extends State<MyMealPlanScreenWidget> {
  int selectedTab = 1; // Mặc định chọn "Đã tạo"

  final List<String> tabs = ["Thực đơn mẫu", "Đã tạo", "Thực đơn AI"];

  final List<Map<String, dynamic>> mealPlans = [
    {"name": "Thực đơn A", "goal": "Giảm cân", "days": 7, "isActive": false},
    {"name": "Thực đơn B", "goal": "Tăng cơ", "days": 14, "isActive": true},
    {"name": "Thực đơn C", "goal": "Giữ dáng", "days": 10, "isActive": false},
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // TODO: Điều hướng đến trang tạo thực đơn mới
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Tabs trong cùng một thành phần màu xanh lá
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                tabs.length,
                    (index) => _buildTabItem(tabs[index], index),
              ),
            ),
          ),

          // Danh sách Meal Plan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mealPlans.length,
              itemBuilder: (context, index) {
                return _buildMealPlanItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tabs (Thực đơn mẫu, Đã tạo, Thực đơn AI)
  Widget _buildTabItem(String title, int index) {
    final bool isSelected = index == selectedTab;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 60,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  // Danh sách Meal Plan
  Widget _buildMealPlanItem(int index) {
    final mealPlan = mealPlans[index];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          mealPlan["name"],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${mealPlan["goal"]} - Số ngày: ${mealPlan["days"]}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Switch(
          value: mealPlan["isActive"],
          activeColor: FlutterFlowTheme.of(context).primary,
          onChanged: (bool value) {
            setState(() {
              mealPlans[index]["isActive"] = value;
            });
          },
        ),
        onTap: () {
          // TODO: Điều hướng đến trang chi tiết thực đơn
        },
      ),
    );
  }
}
