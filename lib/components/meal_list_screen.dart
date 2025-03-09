import 'package:diet_plan_app/components/serch_data_widget.dart';
import 'package:flutter/material.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          MealCard(
            title: "Bữa sáng",
            description: "Recommended portion: 25% of daily consumption",
          ),
          SizedBox(height: 8),
          MealCard(
            title: "Bữa trưa",
            description: "Recommended portion: 30% of daily consumption",
          ),
          SizedBox(height: 8),
          MealCard(
            title: "Bữa chiều",
            description: "Recommended portion: 10% of daily consumption",
          ),
          SizedBox(height: 8),
          MealCard(
            title: "Bữa tối",
            description: "Recommended portion: 20% of daily consumption",
          ),
          SizedBox(height: 8),
          MealCard(
            title: "Bữa phụ",
            description: "Recommended portion: 15% of daily consumption",
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String title;
  final String description;

  const MealCard({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SerchDataWidget(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Thêm thức ăn",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
