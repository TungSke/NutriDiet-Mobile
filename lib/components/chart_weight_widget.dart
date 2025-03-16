import 'dart:convert';

import 'package:diet_plan_app/services/user_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

import '../flutter_flow/flutter_flow_theme.dart';

class WeightLineChart extends StatefulWidget {
  @override
  _WeightLineChartState createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  List<FlSpot> data = [];
  List<String> dateLabels = [];
  double targetWeight = 80.0;
  double minWeight = double.infinity;
  double maxWeight = double.negativeInfinity;
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

        Map<String, List<double>> latestDataMap = {};
        List<String> tempDateLabels = [];

        for (var item in dataJson) {
          double weight = item['value'].toDouble();
          String rawDate = item['date'];

          String dateKey = rawDate.split('T')[0]; // Extract date part
          String formattedDate = DateFormat('dd/MM')
              .format(DateTime.parse(dateKey)); // Format date to dd/MM

          if (!latestDataMap.containsKey(dateKey)) {
            latestDataMap[dateKey] = [];
            tempDateLabels.add(formattedDate); // Store formatted date
          }

          latestDataMap[dateKey]!.add(weight);
        }

        List<FlSpot> weightData = [];
        latestDataMap.forEach((dateKey, weights) {
          // Use index from dateLabels for the x value
          int index = tempDateLabels.indexOf(DateFormat('dd/MM')
              .format(DateTime.parse(dateKey))); // Get the correct index

          for (double weight in weights) {
            if (weight < minWeight) minWeight = weight;
            if (weight > maxWeight) maxWeight = weight;

            weightData
                .add(FlSpot(index.toDouble(), weight)); // Use index for x value
          }
        });

        setState(() {
          data = weightData;
          dateLabels =
              tempDateLabels.toSet().toList(); // Use formatted date labels
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
          if (targetWeight < minWeight) minWeight = targetWeight;
          if (targetWeight > maxWeight) maxWeight = targetWeight;
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
    if (data.isEmpty || targetWeight == 0.0) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }

    // Adjust minY and maxY for weight range
    double adjustedMinY = minWeight - 5;
    double adjustedMaxY = maxWeight + 5;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Get the corresponding date for the x-axis value
                  String label = dateLabels[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(label, style: TextStyle(color: Colors.black)),
                  );
                },
                reservedSize: 32,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12, // Smaller font size to avoid overflow
                      ),
                    ),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          minX: 0, // Always start from 0 for x-axis
          maxX: (dateLabels.length - 1)
              .toDouble(), // Adjust maxX based on the number of date labels
          minY: adjustedMinY,
          maxY: adjustedMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: Colors.blue,
              belowBarData:
                  BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
              dotData: FlDotData(show: true),
            ),
            LineChartBarData(
              spots: [
                for (int i = 0; i < dateLabels.length; i++)
                  FlSpot(i.toDouble(), targetWeight),
              ],
              isCurved: false,
              color: Colors.green,
              barWidth: 1,
              isStrokeCapRound: true,
              dashArray: [8, 4],
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
