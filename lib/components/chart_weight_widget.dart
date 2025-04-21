import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../services/user_service.dart';

// Định nghĩa model cho dữ liệu cân nặng
class WeightData {
  WeightData(this.date, this.weight, {this.imageUrl});
  final DateTime date;
  final double weight;
  final String? imageUrl;
}

class WeightLineChart extends StatefulWidget {
  final VoidCallback? refreshChart;
  const WeightLineChart({this.refreshChart, super.key});

  @override
  WeightLineChartState createState() => WeightLineChartState();
}

class WeightLineChartState extends State<WeightLineChart> {
  WeightData? initialWeight; // Cân nặng ban đầu
  WeightData? latestWeight; // Cân nặng hiện tại
  double targetWeight = 80.0; // Mục tiêu cân nặng
  DateTime? minDate; // Ngày sớm nhất
  DateTime? maxDate; // Ngày mới nhất
  String? errorMessage;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchData();
    if (widget.refreshChart != null) {
      widget.refreshChart!();
    }
  }

  // Phương thức công khai để làm mới dữ liệu
  Future<void> refresh() async {
    setState(() {
      fetchData();
    });
  }

  // Lấy dữ liệu từ API
  Future<void> fetchData() async {
    try {
      // Lấy dữ liệu cân nặng
      final response = await userService.getHealthProfileReport();
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body)['data'];
        if (dataJson.isEmpty) {
          setState(() {
            errorMessage = 'Chưa có dữ liệu cân nặng. Hãy cập nhật ngay!';
          });
          return;
        }

        // Xử lý dữ liệu cân nặng
        List<WeightData> tempData = [];
        for (var item in dataJson) {
          double weight = item['value'].toDouble();
          String rawDate = item['date'];
          DateTime date = DateTime.parse(rawDate).toLocal();
          String? imageUrl = item['imageUrl'];
          tempData.add(WeightData(date, weight, imageUrl: imageUrl));
        }

        // Sắp xếp theo thời gian
        tempData.sort((a, b) => a.date.compareTo(b.date));

        // Xác định cân nặng ban đầu và mới nhất
        setState(() {
          initialWeight = tempData.first;
          latestWeight = tempData.last;
          minDate = DateTime(initialWeight!.date.year, initialWeight!.date.month, initialWeight!.date.day);
          maxDate = DateTime(latestWeight!.date.year, latestWeight!.date.month, latestWeight!.date.day);
        });

        // Lấy cân nặng mục tiêu
        final goalResponse = await userService.getPersonalGoal();
        if (goalResponse.statusCode == 200) {
          final goalData = jsonDecode(goalResponse.body)['data'];
          setState(() {
            targetWeight = goalData['targetWeight']?.toDouble() ?? 80.0;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Không thể tải dữ liệu cân nặng';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi tải dữ liệu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trường hợp lỗi
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Trường hợp đang tải
    if (initialWeight == null || latestWeight == null || minDate == null || maxDate == null) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    }

    // Điều chỉnh trục x
    DateTime displayMinDate = minDate!;
    DateTime displayMaxDate = maxDate!;

    // Nếu cả hai điểm nằm trong cùng ngày, tạo 2 thời điểm khác nhau để vẽ đường
    if (minDate == maxDate) {
      displayMinDate = DateTime(minDate!.year, minDate!.month, minDate!.day, 0, 0); // 00:00
      displayMaxDate = DateTime(maxDate!.year, maxDate!.month, maxDate!.day, 23, 59); // 23:59
    }

    // Dữ liệu cho đường cân nặng thực tế
    final actualWeightData = [
      WeightData(displayMinDate, initialWeight!.weight, imageUrl: initialWeight!.imageUrl),
      WeightData(displayMaxDate, latestWeight!.weight, imageUrl: latestWeight!.imageUrl),
    ];

    // Dữ liệu cho đường mục tiêu
    final targetWeightData = [
      WeightData(displayMinDate, targetWeight),
      WeightData(displayMaxDate, targetWeight),
    ];

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(18),
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
              enable: true,
              color: Colors.black87, // Đặt màu nền tooltip là trắng
              borderWidth: 1,
              borderColor: Colors.grey[300]!, // Viền nhẹ để dễ nhìn
              builder: (data, point, series, pointIdx, seriesIdx) {
                WeightData weightData = data as WeightData;
                String date = DateFormat('dd/MM/yyyy - HH:mm').format(weightData.date);
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ngày: $date',
                        style: TextStyle(color: Colors.white), // Chữ màu đen
                      ),
                      Text(
                        'Cân nặng: ${weightData.weight} kg',
                        style: TextStyle(color: Colors.white), // Chữ màu đen
                      ),
                      if (weightData.imageUrl != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(weightData.imageUrl!),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              textStyle: TextStyle(fontSize: 12),
              overflowMode: LegendItemOverflowMode.wrap, // Chia thành nhiều hàng nếu dài
              height: '20%', // Đảm bảo đủ không gian cho 2 hàng
            ),
            primaryXAxis: DateTimeAxis(
              isVisible: false, // Ẩn trục x
              minimum: displayMinDate,
              maximum: displayMaxDate,
              intervalType: DateTimeIntervalType.days,
              interval: 1,
            ),
            primaryYAxis: NumericAxis(
              decimalPlaces: 1,
              majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey[200]),
              title: AxisTitle(text: 'Cân nặng (kg)'),
              minimum: [initialWeight!.weight, latestWeight!.weight, targetWeight].reduce((a, b) => a < b ? a : b) - 5,
              maximum: [initialWeight!.weight, latestWeight!.weight, targetWeight].reduce((a, b) => a > b ? a : b) + 5,
              interval: 1, // Hiển thị các mức cách nhau 1 kg
            ),
            series: <CartesianSeries>[
              // Đường mục tiêu cân nặng (nét liền)
              LineSeries<WeightData, DateTime>(
                name: 'Mục tiêu cân nặng',
                dataSource: targetWeightData,
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                color: Colors.teal[200],
                width: 2,
                markerSettings: MarkerSettings(isVisible: false),
              ),
              // Đường cân nặng thực tế
              LineSeries<WeightData, DateTime>(
                name: 'Cân nặng thực tế',
                dataSource: actualWeightData,
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                color: Colors.blue[700],
                width: 3,
                markerSettings: MarkerSettings(isVisible: false),
              ),
              // Điểm cân nặng ban đầu
              LineSeries<WeightData, DateTime>(
                name: 'Cân nặng ban đầu',
                dataSource: [WeightData(displayMinDate, initialWeight!.weight, imageUrl: initialWeight!.imageUrl)],
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                width: 0,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 6,
                  height: 6,
                  color: Colors.tealAccent,
                ),
                color: Colors.tealAccent,
                legendIconType: LegendIconType.circle,
              ),
              // Điểm cân nặng hiện tại
              LineSeries<WeightData, DateTime>(
                name: 'Cân nặng hiện tại',
                dataSource: [WeightData(displayMaxDate, latestWeight!.weight, imageUrl: latestWeight!.imageUrl)],
                xValueMapper: (WeightData data, _) => data.date,
                yValueMapper: (WeightData data, _) => data.weight,
                width: 0,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 12,
                  height: 12,
                  color: Colors.orangeAccent,
                  borderWidth: 2,
                  borderColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}