import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../services/user_service.dart';

// class PersonalGoalChart extends StatefulWidget {
//   final VoidCallback? refreshChart; // Callback để làm mới biểu đồ
//
//   const PersonalGoalChart({this.refreshChart, super.key});
//
//   @override
//   PersonalGoalChartState createState() => PersonalGoalChartState();
// }
//
// class PersonalGoalChartState extends State<PersonalGoalChart> {
//   List<WeightData> goalData = []; // Dữ liệu mục tiêu
//   DateTime? minDate;
//   DateTime? maxDate;
//
//   UserService userService = UserService();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchGoalData();
//     if (widget.refreshChart != null) {
//       widget.refreshChart!(); // Gọi callback nếu được cung cấp
//     }
//   }
//
//   // Phương thức công khai để làm mới dữ liệu
//   Future<void> refresh() async {
//     await fetchGoalData();
//   }
//
//   // Fetch dữ liệu mục tiêu từ API
//   Future<void> fetchGoalData() async {
//     try {
//       final response =
//           await userService.getPersonalReport(); // Lấy từ API của bạn
//       if (response.statusCode == 200) {
//         final dataJson = jsonDecode(response.body)['data'];
//
//         // Duyệt qua từng mục và tạo điểm dữ liệu
//         List<WeightData> tempGoalData = [];
//         for (var item in dataJson) {
//           double targetWeight = item['targetWeight'].toDouble();
//           String startDateString = item['startDate']; // Ngày tạo mục tiêu
//           DateTime startDate = DateTime.parse(startDateString);
//
//           // Tạo đối tượng WeightData cho mỗi mục tiêu
//           tempGoalData.add(WeightData(startDate, targetWeight));
//         }
//
//         // Sắp xếp theo ngày
//         tempGoalData.sort((a, b) => a.date.compareTo(b.date));
//
//         if (mounted) {
//           setState(() {
//             goalData = tempGoalData;
//             if (goalData.isNotEmpty) {
//               minDate = goalData.first.date;
//               maxDate = goalData.last.date;
//             }
//           });
//         }
//       } else {
//         throw Exception('Failed to load goal data');
//       }
//     } catch (e) {
//       print('Error fetching goal data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (goalData.isEmpty || minDate == null || maxDate == null) {
//       return Center(
//         child: CircularProgressIndicator(
//           color: FlutterFlowTheme.of(context).primary,
//         ),
//       );
//     }
//
//     // Nếu chỉ có 1 data point, mở rộng khoảng thời gian hiển thị (thêm 1 ngày trước và sau)
//     if (minDate == maxDate) {
//       minDate = minDate!.subtract(const Duration(days: 1));
//       maxDate = maxDate!.add(const Duration(days: 1));
//     }
//
//     return Scaffold(
//       body: Center(
//         child: Container(
//           color: Colors.white,
//           padding: const EdgeInsets.all(18),
//           child: SfCartesianChart(
//             legend: Legend(
//               isVisible: true,
//               position: LegendPosition.bottom,
//               overflowMode: LegendItemOverflowMode.wrap,
//             ),
//             primaryXAxis: DateTimeAxis(
//               dateFormat: DateFormat('dd/MM'),
//               intervalType: DateTimeIntervalType
//                   .days, // Đảm bảo các điểm dữ liệu là hàng ngày
//               majorGridLines:
//                   MajorGridLines(width: 0), // Loại bỏ đường lưới chính
//             ),
//             primaryYAxis: NumericAxis(),
//             series: <CartesianSeries>[
//               // Đường biểu diễn mục tiêu cân nặng
//               LineSeries<WeightData, DateTime>(
//                 name: 'Mục tiêu cân nặng',
//                 dataSource: goalData,
//                 xValueMapper: (WeightData data, _) => data.date,
//                 yValueMapper: (WeightData data, _) => data.weight,
//                 markerSettings: const MarkerSettings(isVisible: true),
//                 color: Colors.green,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WeightData {
//   WeightData(this.date, this.weight);
//   final DateTime date;
//   final double weight;
// }
class PersonalGoalChart extends StatefulWidget {
  final VoidCallback? refreshChart; // Callback để làm mới biểu đồ

  const PersonalGoalChart({this.refreshChart, super.key});

  @override
  PersonalGoalChartState createState() => PersonalGoalChartState();
}

class PersonalGoalChartState extends State<PersonalGoalChart> {
  List<WeightData> goalData = []; // Dữ liệu mục tiêu
  DateTime? minDate;
  DateTime? maxDate;

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchGoalData();
    if (widget.refreshChart != null) {
      widget.refreshChart!(); // Gọi callback nếu được cung cấp
    }
  }

  // Phương thức công khai để làm mới dữ liệu
  Future<void> refresh() async {
    await fetchGoalData();
  }

  // Fetch dữ liệu mục tiêu từ API
  Future<void> fetchGoalData() async {
    try {
      final response =
          await userService.getPersonalReport(); // Lấy từ API của bạn
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'];

        // Duyệt qua từng mục và tạo điểm dữ liệu
        List<WeightData> tempGoalData = [];
        for (var item in dataJson) {
          double targetWeight = item['targetWeight'].toDouble();
          String startDateString = item['startDate']; // Ngày tạo mục tiêu
          DateTime startDate = DateTime.parse(startDateString);

          // Tạo đối tượng WeightData cho mỗi mục tiêu
          tempGoalData.add(WeightData(startDate, targetWeight));
        }

        // Sắp xếp theo ngày
        tempGoalData.sort((a, b) => a.date.compareTo(b.date));

        if (mounted) {
          setState(() {
            goalData = tempGoalData;
            if (goalData.isNotEmpty) {
              minDate = goalData.first.date;
              maxDate = goalData.last.date;
            }
          });
        }
      } else {
        throw Exception('Failed to load goal data');
      }
    } catch (e) {
      print('Error fetching goal data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (goalData.isEmpty || minDate == null || maxDate == null) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }

    // Nếu chỉ có 1 data point, mở rộng khoảng thời gian hiển thị (thêm 1 ngày trước và sau)
    if (minDate == maxDate) {
      minDate = minDate!.subtract(const Duration(days: 1));
      maxDate = maxDate!.add(const Duration(days: 1));
    }

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(18),
          child: SfCartesianChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('dd/MM'), // Định dạng hiển thị ngày
            ),
            primaryYAxis: NumericAxis(),
            series: <CartesianSeries>[
              // Đường biểu diễn mục tiêu cân nặng
              LineSeries<WeightData, DateTime>(
                name: 'Mục tiêu cân nặng',
                dataSource: goalData,
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                markerSettings: const MarkerSettings(isVisible: true),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightData {
  WeightData(this.date, this.weight);
  final DateTime date;
  final double weight;
}
