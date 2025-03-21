import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:diet_plan_app/services/meallog_service.dart';

class MealLogNutritionWidget extends StatefulWidget {
  final DateTime selectedDate;

  const MealLogNutritionWidget({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<MealLogNutritionWidget> createState() => _MealLogNutritionWidgetState();
}

class _MealLogNutritionWidgetState extends State<MealLogNutritionWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDate;
  bool _isLoading = true;
  Map<String, dynamic>? _nutritionData;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _tabController = TabController(length: 2, vsync: this);
    _fetchNutritionData();
  }

  Future<void> _fetchNutritionData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String formattedDate = DateFormat('yyyy-M-d').format(_selectedDate);
      final service = MeallogService();
      final data = await service.getNutritionSummary(date: formattedDate);
      setState(() {
        _nutritionData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error fetching nutrition data: $e");
    }
  }

  void _changeDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    _fetchNutritionData();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      locale: const Locale('vi'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      _changeDate(picked);
    }
  }

  String _getCustomDateString(DateTime date) {
    final now = DateTime.now();
    final difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    if (difference == -1) return 'Hôm qua';
    return DateFormat('d MMMM, yyyy', 'vi').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: () {
                        _changeDate(
                            _selectedDate.subtract(const Duration(days: 1)));
                      },
                    ),
                    GestureDetector(
                      onTap: () => _showDatePicker(context),
                      child: Text(
                        _getCustomDateString(_selectedDate),
                        style: const TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.chevron_right, color: Colors.black),
                      onPressed: () {
                        _changeDate(_selectedDate.add(const Duration(days: 1)));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nutrition',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'CALORIES'),
                Tab(text: 'MACROS'),
              ],
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Phân tích dữ liệu nutrition từ _nutritionData
    final totalCalories = _nutritionData?['totalCalories'] ?? 0;
    final netCalories = _nutritionData?['netCalories'] ?? 0;
    final goalCalories = _nutritionData?['goal'] ?? 0;

    // Meal breakdown: chuyển đổi danh sách thành Map<String, double>
    final List<dynamic> mealBreakdownList =
        _nutritionData?['mealBreakdown'] ?? [];
    Map<String, double> mealCaloriesMap = {};
    for (var meal in mealBreakdownList) {
      // Nếu cần chuyển về chữ thường để nhất quán
      final mealType = meal['mealType'].toString();
      mealCaloriesMap[mealType] = (meal['calories'] as num).toDouble();
    }
    // Nếu thiếu snack, thêm mặc định 0.0
    if (!mealCaloriesMap.containsKey('Snack') &&
        !mealCaloriesMap.containsKey('snack') &&
        !mealCaloriesMap.containsKey('Snacks')) {
      mealCaloriesMap['Snack'] = 0.0;
    }

    // Macros
    final macros = _nutritionData?['macros'] ?? {};
    final double carbs =
        (macros['carbs'] ?? 0) is num ? (macros['carbs'] as num).toDouble() : 0;
    final double fat =
        (macros['fat'] ?? 0) is num ? (macros['fat'] as num).toDouble() : 0;
    final double protein = (macros['protein'] ?? 0) is num
        ? (macros['protein'] as num).toDouble()
        : 0;

    // Highest in Calories
    final List<dynamic> highestInCaloriesList =
        _nutritionData?['highestInCalories'] ?? [];
    // Trích xuất Highest in Carbs, Fat, Protein
    final List<dynamic> highestInCarbsList =
        _nutritionData?['highestInCarbs'] ?? [];
    final List<dynamic> highestInFatList =
        _nutritionData?['highestInFat'] ?? [];
    final List<dynamic> highestInProteinList =
        _nutritionData?['highestInProtein'] ?? [];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black),
                    onPressed: () {
                      _changeDate(
                          _selectedDate.subtract(const Duration(days: 1)));
                    },
                  ),
                  GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: Text(
                      _getCustomDateString(_selectedDate),
                      style: const TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black),
                    onPressed: () {
                      _changeDate(_selectedDate.add(const Duration(days: 1)));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Nutrition',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'CALORIES'),
              Tab(text: 'MACROS'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab CALORIES: hiển thị PieChart và các thông tin calo
          _buildCaloriesTab(
            totalCalories,
            goalCalories,
            netCalories,
            mealCaloriesMap,
            highestInCaloriesList,
          ),
          // Tab MACROS: hiển thị PieChart, thông tin macro và dữ liệu Highest in Carbs/Fat/Protein
          _buildMacrosTab(
            carbs,
            fat,
            protein,
            highestInCarbsList,
            highestInFatList,
            highestInProteinList,
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị thông tin tab CALORIES
  Widget _buildCaloriesTab(
    int totalCalories,
    int goalCalories,
    int netCalories,
    Map<String, double> mealMap,
    List<dynamic> highestInCaloriesList,
  ) {
    final dataMap = <String, double>{};
    mealMap.forEach((key, value) {
      if (value > 0) dataMap[key] = value;
    });
    if (dataMap.isEmpty) dataMap['No Data'] = 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PieChart(
            dataMap: dataMap,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
          ),
          const SizedBox(height: 16),
          _buildCalorieInfoRow('Total Calories', totalCalories),
          _buildCalorieInfoRow('Net Calories', netCalories),
          _buildCalorieInfoRow('Goal', goalCalories),
          const SizedBox(height: 16),
          const Text(
            'Highest in Calories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...highestInCaloriesList.map((item) {
            return ListTile(
              title: Text(item['foodName'] ?? ''),
              trailing: Text((item['value'] ?? 0).toString()),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Widget hiển thị thông tin tab MACROS
  Widget _buildMacrosTab(
    double carbs,
    double fat,
    double protein,
    List<dynamic> highestInCarbsList,
    List<dynamic> highestInFatList,
    List<dynamic> highestInProteinList,
  ) {
    final totalMacro = carbs + fat + protein;
    final dataMap = <String, double>{
      if (carbs > 0) 'Carbohydrates': carbs,
      if (fat > 0) 'Fat': fat,
      if (protein > 0) 'Protein': protein,
    };
    if (dataMap.isEmpty) dataMap['No Data'] = 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PieChart(
            dataMap: dataMap,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
          ),
          const SizedBox(height: 16),
          _buildMacroInfoRow('Carbohydrates', carbs, totalMacro),
          _buildMacroInfoRow('Fat', fat, totalMacro),
          _buildMacroInfoRow('Protein', protein, totalMacro),
          const SizedBox(height: 16),
          // Hiển thị Highest in Carbohydrates
          const Text(
            'Highest in Carbohydrates (g)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          highestInCarbsList.isNotEmpty
              ? Column(
                  children: highestInCarbsList.map((item) {
                    return ListTile(
                      title: Text(item['foodName'] ?? ''),
                      trailing: Text((item['value'] ?? 0).toString()),
                    );
                  }).toList(),
                )
              : const ListTile(
                  title: Text('No Data'),
                  trailing: Text('0'),
                ),
          const SizedBox(height: 8),
          // Hiển thị Highest in Fat
          const Text(
            'Highest in Fat (g)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          highestInFatList.isNotEmpty
              ? Column(
                  children: highestInFatList.map((item) {
                    return ListTile(
                      title: Text(item['foodName'] ?? ''),
                      trailing: Text((item['value'] ?? 0).toString()),
                    );
                  }).toList(),
                )
              : const ListTile(
                  title: Text('No Data'),
                  trailing: Text('0'),
                ),
          const SizedBox(height: 8),
          // Hiển thị Highest in Protein
          const Text(
            'Highest in Protein (g)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          highestInProteinList.isNotEmpty
              ? Column(
                  children: highestInProteinList.map((item) {
                    return ListTile(
                      title: Text(item['foodName'] ?? ''),
                      trailing: Text((item['value'] ?? 0).toString()),
                    );
                  }).toList(),
                )
              : const ListTile(
                  title: Text('No Data'),
                  trailing: Text('0'),
                ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfoRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget _buildMacroInfoRow(String label, double gram, double total) {
    final percent = total > 0 ? (gram / total * 100).toStringAsFixed(0) : '0';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label ($gram g)'),
          Text('$percent%'),
        ],
      ),
    );
  }
}
