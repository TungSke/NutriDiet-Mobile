import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class MealPlanDetailWidget extends StatefulWidget {
  final String mealPlanName;
  final String goal;
  final int days;
  final String createdBy;

  const MealPlanDetailWidget({
    super.key,
    required this.mealPlanName,
    required this.goal,
    required this.days,
    required this.createdBy,
  });

  @override
  _MealPlanDetailWidgetState createState() => _MealPlanDetailWidgetState();
}

class _MealPlanDetailWidgetState extends State<MealPlanDetailWidget> {
  int selectedDay = 1;
  late int totalDays;

  final List<String> meals = ["Bữa sáng", "Bữa trưa", "Bữa tối", "Bữa phụ"];

  @override
  void initState() {
    super.initState();
    totalDays = widget.days;
  }

  void _addNewDay() {
    setState(() {
      totalDays++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Điều chỉnh độ cao của AppBar
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            widget.mealPlanName,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
                  _buildMealPlanCard(),
                  const SizedBox(height: 12),
                  _buildDaySelector(),
                  const SizedBox(height: 12),
                  _buildNutrientProgress(),
                  const SizedBox(height: 12),
                  const Text("Total: 1,597 kcal", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return _buildMealCard(meals[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text("ÁP DỤNG THỰC ĐƠN", style: TextStyle(color: Colors.white)),
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

  Widget _buildDaySelector() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(totalDays, (index) => _buildDayButton(index + 1, "Ngày ${index + 1}"))
                ..add(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton(
                      icon: Icon(Icons.add_circle, color: FlutterFlowTheme.of(context).primary, size: 40),
                      onPressed: _addNewDay,
                    ),
                  ),
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

  Widget _buildMealPlanCard() {
    return Card(
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
                Text(widget.mealPlanName, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.edit, color: FlutterFlowTheme.of(context).primary),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoText("Mục tiêu sức khỏe", widget.goal),
            _buildInfoText("Số ngày thực đơn", "$totalDays ngày"),
            _buildInfoText("Tạo bởi", widget.createdBy),
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
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildNutrientProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildProgressIndicator("Carbs", 0.59),
        _buildProgressIndicator("Protein", 0.19),
        _buildProgressIndicator("Fat", 0.22),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, double value) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: value,
                color: FlutterFlowTheme.of(context).primary,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            Text("${(value * 100).round()}%"),
          ],
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMealCard(String meal) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(meal, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: CircleAvatar(
          backgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
          child: Icon(Icons.add, color: FlutterFlowTheme.of(context).primary),
        ),
        onTap: () {},
      ),
    );
  }
}
