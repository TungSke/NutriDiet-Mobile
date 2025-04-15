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
import 'dart:convert';
import 'package:intl/intl.dart';

// Định nghĩa model cho dữ liệu cân nặng
class WeightData {
  WeightData(this.date, this.weight, {this.isLatest = false});
  final DateTime date;
  final double weight;
  final bool isLatest; // Đánh dấu mục tiêu mới nhất
}

class PersonalGoalChart extends StatefulWidget {
  final VoidCallback? refreshChart;

  const PersonalGoalChart({this.refreshChart, super.key});

  @override
  PersonalGoalChartState createState() => PersonalGoalChartState();
}

class PersonalGoalChartState extends State<PersonalGoalChart> {
  late Future<List<WeightData>> _goalDataFuture; // Future để lưu trữ dữ liệu
  DateTime? minDate;
  DateTime? maxDate;
  String? errorMessage;

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _goalDataFuture = fetchGoalData(); // Khởi tạo Future trong initState
  }

  // Phương thức công khai để làm mới dữ liệu
  Future<void> refresh() async {
    setState(() {
      _goalDataFuture = fetchGoalData(); // Cập nhật Future khi làm mới
    });
  }

  // Fetch dữ liệu mục tiêu từ API
  Future<List<WeightData>> fetchGoalData() async {
    try {
      final response = await userService.getPersonalReport();
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'] as List;

        // Tìm mục tiêu mới nhất dựa trên createdAt
        Map<String, dynamic>? latestGoal;
        DateTime? latestCreatedAt;
        for (var item in dataJson) {
          if (item['createdAt'] == null) continue;
          DateTime createdAt = DateTime.parse(item['createdAt']);
          if (latestCreatedAt == null || createdAt.isAfter(latestCreatedAt)) {
            latestCreatedAt = createdAt;
            latestGoal = item;
          }
        }

        // Xử lý tất cả dữ liệu mục tiêu
        List<WeightData> tempGoalData = [];
        for (var item in dataJson) {
          if (item['targetWeight'] == null || item['startDate'] == null) {
            continue;
          }

          double targetWeight;
          try {
            targetWeight = item['targetWeight'].toDouble();
          } catch (e) {
            continue;
          }

          String startDateString = item['startDate'];
          DateTime? startDate;
          try {
            startDate = DateTime.parse(startDateString).toLocal();
            startDate = DateTime(startDate.year, startDate.month, startDate.day);
          } catch (e) {
            continue;
          }

          bool isLatest = latestGoal != null &&
              item['createdAt'] == latestGoal['createdAt'];
          tempGoalData.add(WeightData(startDate, targetWeight, isLatest: isLatest));
        }

        // Sắp xếp theo ngày tăng dần
        tempGoalData.sort((a, b) => a.date.compareTo(b.date));

        // Cập nhật minDate và maxDate
        if (tempGoalData.isNotEmpty) {
          minDate = tempGoalData.first.date;
          maxDate = tempGoalData.last.date;
        } else {
          errorMessage = 'Chưa có mục tiêu nào';
        }

        return tempGoalData;
      } else {
        throw Exception('Không thể tải dữ liệu mục tiêu');
      }
    } catch (e) {
      errorMessage = 'Lỗi khi tải dữ liệu: $e';
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeightData>>(
      future: _goalDataFuture,
      builder: (context, snapshot) {
        // Hiển thị loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          );
        }

        // Hiển thị thông báo khi có lỗi hoặc không có dữ liệu
        if (snapshot.hasError || (snapshot.hasData && snapshot.data!.isEmpty)) {
          return Center(
            child: Text(
              errorMessage ?? 'Lỗi không xác định',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        // Dữ liệu đã tải thành công
        final goalData = snapshot.data!;
        List<WeightData> allDataForLine = List.from(goalData);

        // Tính toán khoảng thời gian hiển thị: 6 ngày liên tiếp
        DateTime displayMinDate;
        DateTime displayMaxDate = maxDate!; // Ngày mới nhất
        const int visibleDays = 6; // Hiển thị 6 ngày

        // Tính ngày bắt đầu: 5 ngày trước ngày mới nhất
        displayMinDate = maxDate!.subtract(const Duration(days: visibleDays - 1));

        // Nếu ngày bắt đầu sớm hơn ngày đầu tiên có dữ liệu, điều chỉnh lại
        if (minDate!.isAfter(displayMinDate)) {
          displayMinDate = minDate!.subtract(const Duration(days: 1));
          displayMaxDate = displayMinDate.add(const Duration(days: visibleDays - 1));
        }

        return Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: SfCartesianChart(
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: false,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'Ngày: point.x\nCân nặng: point.y kg\n', // Custom tooltip format
                ), // Enable tooltips
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.scroll,
                  textStyle: const TextStyle(fontSize: 12),
                  iconWidth: 10,
                  iconHeight: 10,
                ),
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat('dd/MM'),
                  intervalType: DateTimeIntervalType.days,
                  minimum: displayMinDate,
                  maximum: displayMaxDate,
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: Colors.grey[300]!.withOpacity(0.5),
                  ),
                  maximumLabels: 6,
                  interval: 1,
                  title: AxisTitle(
                    text: 'Ngày',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  decimalPlaces: 1,
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: Colors.grey[300]!.withOpacity(0.5),
                  ),
                  title: AxisTitle(
                    text: 'Cân nặng (kg)',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                series: <CartesianSeries>[
                  // Series để vẽ đường nối toàn bộ
                  LineSeries<WeightData, DateTime>(
                    name: 'Đường thay đổi mục tiêu',
                    dataSource: allDataForLine,
                    xValueMapper: (WeightData data, _) => data.date,
                    yValueMapper: (WeightData data, _) => data.weight,
                    markerSettings: const MarkerSettings(
                      isVisible: false,
                    ),
                    color: Colors.tealAccent,
                    width: 2,
                  ),
                  // Series để hiển thị các điểm mục tiêu cũ
                  LineSeries<WeightData, DateTime>(
                    name: 'Mục tiêu cũ',
                    dataSource: goalData.where((data) => !data.isLatest).toList(),
                    xValueMapper: (WeightData data, _) => data.date,
                    yValueMapper: (WeightData data, _) => data.weight,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      width: 6,
                      height: 6,
                      color: Colors.tealAccent,
                    ),
                    color: Colors.tealAccent,
                    width: 0,
                    legendIconType: LegendIconType.circle,
                  ),
                  // Series để làm nổi bật điểm mới nhất
                  LineSeries<WeightData, DateTime>(
                    name: 'Mục tiêu hiện tại',
                    dataSource: goalData.where((data) => data.isLatest).toList(),
                    xValueMapper: (WeightData data, _) => data.date,
                    yValueMapper: (WeightData data, _) => data.weight,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      width: 10,
                      height: 10,
                      color: Colors.orangeAccent,
                    ),
                    color: Colors.orangeAccent,
                    width: 0,
                    legendIconType: LegendIconType.circle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}