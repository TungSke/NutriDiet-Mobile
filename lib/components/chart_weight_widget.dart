// import 'dart:convert';
//
// import 'package:diet_plan_app/services/user_service.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // for date formatting
//
// import '../flutter_flow/flutter_flow_theme.dart';
//
// class WeightLineChart extends StatefulWidget {
//   @override
//   _WeightLineChartState createState() => _WeightLineChartState();
// }
//
// class _WeightLineChartState extends State<WeightLineChart> {
//   List<FlSpot> data = [];
//   List<String> dateLabels = [];
//   double targetWeight = 80.0;
//   double minWeight = double.infinity;
//   double maxWeight = double.negativeInfinity;
//   UserService userService = UserService();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWeightData();
//     fetchTargetWeight();
//   }
//
//   Future<void> fetchWeightData() async {
//     try {
//       final response = await userService.getHealthProfileReport();
//       if (response.statusCode == 200) {
//         final dataJson = jsonDecode(response.body)['data'];
//
//         Map<String, double> latestDataMap =
//             {}; // Lưu trữ giá trị cuối cùng mỗi ngày
//         List<String> tempDateLabels = [];
//
//         // Duyệt qua các đối tượng trong mảng 'data'
//         for (var item in dataJson) {
//           double weight = item['value'].toDouble();
//           String rawDate = item['date'];
//
//           // Lấy phần ngày từ 'date' và định dạng lại
//           String dateKey = rawDate.split('T')[0];
//           String formattedDate =
//               DateFormat('dd/MM').format(DateTime.parse(dateKey));
//
//           // Lưu giá trị cuối cùng của ngày
//           latestDataMap[dateKey] = weight;
//
//           // Lưu ngày đã định dạng
//           if (!tempDateLabels.contains(formattedDate)) {
//             tempDateLabels.add(formattedDate);
//           }
//         }
//
//         // In ra các giá trị đã lọc
//         print("Latest Data Map: $latestDataMap");
//         print("Date Labels: $tempDateLabels");
//
//         // Tạo danh sách điểm dữ liệu từ các giá trị mới nhất của mỗi ngày
//         List<FlSpot> weightData = [];
//         latestDataMap.forEach((dateKey, weight) {
//           int index = tempDateLabels.indexOf(DateFormat('dd/MM')
//               .format(DateTime.parse(dateKey))); // Lấy chỉ số của ngày
//
//           weightData.add(FlSpot(index.toDouble(),
//               weight)); // Tạo FlSpot với giá trị cuối cùng của mỗi ngày
//         });
//
//         // In ra danh sách điểm dữ liệu đã được tạo
//         print("Weight Data (FlSpot): $weightData");
//
//         setState(() {
//           data = weightData;
//           dateLabels = tempDateLabels; // Giữ nguyên thứ tự ngày tháng
//         });
//
//         // Cập nhật minY và maxY
//         double maxWeightValue = latestDataMap.values
//             .reduce((a, b) => a > b ? a : b); // Lấy giá trị max từ dữ liệu
//         double minWeightValue = latestDataMap.values
//             .reduce((a, b) => a < b ? a : b); // Lấy giá trị min từ dữ liệu
//
//         // Cập nhật minY và maxY
//         if (minWeightValue < targetWeight) {
//           minWeight = minWeightValue -
//               5; // Nếu weight nhỏ hơn targetWeight, lấy minY = weight - 5
//         } else {
//           minWeight = targetWeight -
//               5; // Nếu weight lớn hơn hoặc bằng targetWeight, lấy minY = targetWeight - 5
//         }
//         maxWeight = maxWeightValue + 5; // maxY = max value trong ngày + 5
//       } else {
//         throw Exception('Failed to load weight data');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
//
//   Future<void> fetchTargetWeight() async {
//     try {
//       final response = await userService.getPersonalGoal();
//       if (response.statusCode == 200) {
//         final dataJson = jsonDecode(response.body)['data'];
//         setState(() {
//           targetWeight = dataJson['targetWeight']?.toDouble() ?? 80.0;
//         });
//       } else {
//         throw Exception('Failed to load target weight');
//       }
//     } catch (e) {
//       print('Error fetching target weight: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (data.isEmpty || targetWeight == 0.0) {
//       return Center(
//         child: CircularProgressIndicator(
//           color: FlutterFlowTheme.of(context).primary,
//         ),
//       );
//     }
//
//     // Tính toán minY và maxY cho trục Y
//     double adjustedMinY = minWeight; // minY được tính theo yêu cầu
//     double adjustedMaxY = maxWeight; // maxY được tính theo yêu cầu
//
//     return Padding(
//       padding: const EdgeInsets.all(18),
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(show: true),
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   // Get the corresponding date for the x-axis value
//                   String label = dateLabels[value.toInt()];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Text(
//                       label,
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   );
//                 },
//                 reservedSize: 40, // Ensure enough space between labels
//                 interval: 1, // Ensure labels don't overlap
//               ),
//             ),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Text(
//                       value.toStringAsFixed(0),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12, // Smaller font size to avoid overflow
//                       ),
//                     ),
//                   );
//                 },
//                 reservedSize: 32,
//               ),
//             ),
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: Border(
//               top: BorderSide.none,
//               right: BorderSide.none,
//               bottom: BorderSide(color: Colors.grey, width: 1),
//               left: BorderSide(color: Colors.grey, width: 1),
//             ),
//           ),
//           minX: 0, // Always start from 0 for x-axis
//           maxX: (dateLabels.length - 1)
//               .toDouble(), // Adjust maxX based on the number of date labels
//           minY: adjustedMinY,
//           maxY: adjustedMaxY,
//           lineBarsData: [
//             LineChartBarData(
//               spots: data,
//               isCurved: true,
//               color: Colors.blue,
//               dotData: FlDotData(show: true),
//             ),
//             LineChartBarData(
//               spots: [
//                 for (int i = 0; i < dateLabels.length; i++)
//                   FlSpot(i.toDouble(), targetWeight),
//               ],
//               isCurved: false,
//               color: Colors.green,
//               barWidth: 1,
//               isStrokeCapRound: true,
//               dashArray: [8, 4],
//               dotData: FlDotData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:diet_plan_app/services/user_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

import '../flutter_flow/flutter_flow_theme.dart';

class WeightLineChart extends StatefulWidget {
  final Function? refreshChart; // Định nghĩa tham số callback

  WeightLineChart({this.refreshChart});

  @override
  _WeightLineChartState createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  List<FlSpot> data = [];
  List<String> dateLabels = []; // Danh sách các ngày 2, 9, 16, 23, 30
  double targetWeight = 80.0;
  double minWeight = double.infinity;
  double maxWeight = double.negativeInfinity;
  UserService userService = UserService();

  void refreshChart() {
    setState(() {
      // Gọi lại fetchWeightData khi có thay đổi dữ liệu
      fetchWeightData();
      fetchTargetWeight();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateMonthDays(); // Tạo danh sách các ngày từ 1 đến 31
    fetchWeightData();
    fetchTargetWeight();
  }

  // Tạo danh sách các ngày từ 1 đến 31 của tháng hiện tại
  void _generateMonthDays() {
    final currentDate = DateTime.now();
    final month = currentDate.month;
    final year = currentDate.year;

    dateLabels = [];
    for (int i = 1; i <= 31; i++) {
      // Tạo ngày từ 1 đến 31 của tháng hiện tại
      String formattedDate =
          DateFormat('dd/MM').format(DateTime(year, month, i));
      dateLabels.add(formattedDate);
    }
  }

  Future<void> fetchWeightData() async {
    try {
      final response = await userService.getHealthProfileReport();
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'];

        Map<String, double> latestDataMap = {};
        List<String> tempDateLabels = [];

        for (var item in dataJson) {
          double weight = item['value'].toDouble();
          String rawDate = item['date'];

          String dateKey = rawDate.split('T')[0];
          String formattedDate =
              DateFormat('dd/MM').format(DateTime.parse(dateKey));

          latestDataMap[dateKey] = weight;

          if (!tempDateLabels.contains(formattedDate)) {
            tempDateLabels.add(formattedDate);
          }
        }

        List<FlSpot> weightData = [];
        latestDataMap.forEach((dateKey, weight) {
          int index = dateLabels
              .indexOf(DateFormat('dd/MM').format(DateTime.parse(dateKey)));
          weightData.add(FlSpot(index.toDouble(), weight));
        });

        setState(() {
          data = weightData;
        });

        double maxWeightValue =
            latestDataMap.values.reduce((a, b) => a > b ? a : b);
        double minWeightValue =
            latestDataMap.values.reduce((a, b) => a < b ? a : b);

        // Cập nhật minY và maxY theo logic mới
        if (targetWeight < maxWeightValue) {
          minWeight = targetWeight - 5;
          maxWeight = maxWeightValue + 5;
        } else {
          minWeight = minWeightValue - 5;
          maxWeight = targetWeight + 5;
        }

        // Gọi lại hàm refresh để làm mới biểu đồ khi cập nhật dữ liệu
        if (widget.refreshChart != null) {
          widget.refreshChart!();
        }
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
    if (data.isEmpty || targetWeight == 0.0) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }

    // Tính toán minY và maxY cho trục Y
    double adjustedMinY = minWeight; // minY được tính theo yêu cầu
    double adjustedMaxY = maxWeight; // maxY được tính theo yêu cầu

    return Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: 400, // Thêm chiều cao cho widget scroll dọc
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              verticalInterval: 1,
              getDrawingVerticalLine: (value) {
                // Lấy chỉ số và chuyển thành ngày tháng tương ứng
                String label = dateLabels[value.toInt()];
                List<String> dateParts = label.split('/');
                String day = dateParts[0];

                // Kiểm tra nếu là các ngày cần hiển thị grid lines
                if (['02', '09', '16', '23'].contains(day)) {
                  return FlLine(
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                }
                return FlLine(
                  color: Colors
                      .transparent, // Ẩn grid lines cho các ngày không phải 2, 9, 16, 23
                  strokeWidth: 0,
                );
              },
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    String label = dateLabels[value.toInt()];
                    List<String> dateParts = label.split('/');
                    String day = dateParts[0];
                    String month = dateParts[1];
                    if (['02', '09', '16', '23'].contains(day)) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              day,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              month,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                  reservedSize: 40,
                  interval: 1,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            minX: 0, // Trục X luôn bắt đầu từ 0
            maxX: (dateLabels.length - 1)
                .toDouble(), // Điều chỉnh maxX dựa trên số lượng ngày trong tháng
            minY: adjustedMinY,
            maxY: adjustedMaxY,
            lineBarsData: [
              // Đường cho dữ liệu cân nặng
              LineChartBarData(
                spots: data,
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: true),
              ),
              // Đường cho mục tiêu cân nặng
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
      ),
    );
  }
}
