import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/mealLog_component_model.dart';

class MealLogComponentWidget extends StatelessWidget {
  const MealLogComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealLogComponentModel>(
    builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  model.changeDate(
                    model.selectedDate.subtract(const Duration(days: 1)),
                  );
                },
              ),
              GestureDetector(
                onTap: () => _showDatePicker(context, model),
                child: Text(
                  DateFormat('MMMM d, yyyy').format(model.selectedDate),
                  style: const TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  model.changeDate(
                    model.selectedDate.add(const Duration(days: 1)),
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            Card(
              margin: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Calories Remaining',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.more_horiz),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCalorieColumn(model.calorieGoal.toString(), 'Goal', FontWeight.bold),
                        _buildOperator('-'),
                        _buildCalorieColumn(model.foodCalories.toString(), 'Food', FontWeight.normal),
                        _buildOperator('='),
                        _buildCalorieColumn(
                          model.remainingCalories.toString(), 
                          'Remaining', 
                          FontWeight.bold,
                          textColor: Colors.red
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ...model.mealCategories.map((category) => _buildMealCategory(category)),
          ],
        ),
      );
    });
  }

  Future<void> _showDatePicker(BuildContext context, MealLogComponentModel model) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: model.selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2040),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.green, // Màu tiêu đề và ngày được chọn
            onPrimary: Colors.white, // Màu chữ trên nút tiêu đề
            onSurface: Colors.black, // Màu chữ ngày chưa chọn
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green, // Màu của nút OK và Cancel
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != model.selectedDate) {
    model.changeDate(picked);
  }
}


  Widget _buildCalorieColumn(String value, String label, FontWeight weight, {Color? textColor}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 20,
            fontWeight: weight,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildOperator(String operator) {
    return Text(
      operator,
      style: const TextStyle(
        fontFamily: 'Figtree',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMealCategory(String category) {
    return Column(
      children: [
        ListTile(
          title: Text(
            category,
            style: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (category != 'Exercise')
          ListTile(
            title: Text(
              'ADD FOOD',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.more_horiz),
          )
        else
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: const Text('iPhone calorie adjustment'),
            trailing: const Text(
              '3',
              style: TextStyle(
                fontFamily: 'Figtree',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const Divider(),
      ],
    );
  }
}