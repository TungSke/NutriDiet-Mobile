import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightProgressChart extends StatelessWidget {
  final List<FlSpot> dataPoints = [
    FlSpot(0, 132.3),
    FlSpot(1, 135.0),
    FlSpot(2, 136.0),
    FlSpot(3, 144.3),
  ];

  WeightProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300, // Set a height for the chart
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.grey, width: 1)),
            minX: 0,
            maxX: 3,
            minY: 130,
            maxY: 150,
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: Colors.green,
                belowBarData: BarAreaData(
                    show: true,
                    color:
                        Colors.green.withOpacity(0.3)), // Area below the line
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
