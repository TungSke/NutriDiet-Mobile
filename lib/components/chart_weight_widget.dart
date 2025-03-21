import 'dart:convert';
import 'package:diet_plan_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:syncfusion_flutter_charts/charts.dart';
import '../flutter_flow/flutter_flow_theme.dart';

// Định nghĩa model cho dữ liệu cân nặng
class WeightData {
  WeightData(this.date, this.weight);
  final DateTime date;
  final double weight;
}

class WeightLineChart extends StatefulWidget {
  final Function? refreshChart;
  WeightLineChart({this.refreshChart});

  @override
  _WeightLineChartState createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  List<WeightData> weightChartData = [];
  double targetWeight = 80.0;
  DateTime? minDate;
  DateTime? maxDate;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchWeightData();
    fetchTargetWeight();
  }

  Future<void> fetchWeightData() async {
    try {
      final response = await userService.getHealthProfileReport();
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'];

        // Lấy giá trị cân nặng mới nhất mỗi ngày (key là ngày dạng "yyyy-MM-dd")
        Map<String, double> latestDataMap = {};
        for (var item in dataJson) {
          double weight = item['value'].toDouble();
          String rawDate = item['date'];
          String dateKey = rawDate.split('T')[0]; // "yyyy-MM-dd"
          latestDataMap[dateKey] = weight;
        }

        List<WeightData> tempData = [];
        latestDataMap.forEach((dateKey, weight) {
          DateTime date = DateTime.parse(dateKey);
          tempData.add(WeightData(date, weight));
        });

        // Sắp xếp theo thời gian tăng dần
        tempData.sort((a, b) => a.date.compareTo(b.date));

        setState(() {
          weightChartData = tempData;
          if (weightChartData.isNotEmpty) {
            minDate = weightChartData.first.date;
            maxDate = weightChartData.last.date;
          }
        });
      } else {
        throw Exception('Failed to load weight data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchTargetWeight() async {
    try {
      final response = await userService.getPersonalGoal();
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'];
        setState(() {
          targetWeight = dataJson['targetWeight']?.toDouble() ?? 80.0;
        });
      } else {
        throw Exception('Failed to load target weight');
      }
    } catch (e) {
      print('Error fetching target weight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weightChartData.isEmpty ||
        targetWeight == 0.0 ||
        minDate == null ||
        maxDate == null) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }

    // Tạo dữ liệu cho đường trọng lượng mục tiêu: chỉ cần 2 điểm từ ngày nhỏ nhất đến ngày lớn nhất
    final List<WeightData> targetSeriesData = [
      WeightData(minDate!, targetWeight),
      WeightData(maxDate!, targetWeight)
    ];

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('dd/MM'),
            ),
            primaryYAxis: NumericAxis(),
            series: <CartesianSeries>[
              // Đường biểu diễn cân nặng thực tế
              LineSeries<WeightData, DateTime>(
                dataSource: weightChartData,
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                markerSettings: MarkerSettings(isVisible: true),
                color: Colors.blue,
              ),
              // Đường biểu diễn trọng lượng mục tiêu
              LineSeries<WeightData, DateTime>(
                dataSource: targetSeriesData,
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                width: 2,
                color: Colors.tealAccent,
                markerSettings: MarkerSettings(isVisible: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
