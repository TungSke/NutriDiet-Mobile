// import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // ✅ Import Provider
//
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '../../components/appbar_widget.dart';
// import '../../services/models/personal_goal_provider.dart'; // ✅ Import PersonalGoalProvider
// import '../../services/user_service.dart';
//
// class TargetWeightScreenWidget extends StatefulWidget {
//   const TargetWeightScreenWidget({super.key});
//
//   @override
//   State<TargetWeightScreenWidget> createState() =>
//       _TargetWeightScreenWidgetState();
// }
//
// class _TargetWeightScreenWidgetState extends State<TargetWeightScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   double selectedKg = 60.0;
//   double currentWeight = 60.0;
//   List<double> kgOptions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentWeight();
//   }
//
//   Future<void> fetchCurrentWeight() async {
//     try {
//       final response = await UserService().getHealthProfile();
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final Map<String, dynamic> healthData = responseData['data'];
//
//         double apiWeight =
//             double.tryParse(healthData['weight'].toString()) ?? 0.0;
//         if (apiWeight > 0) {
//           setState(() {
//             currentWeight = apiWeight;
//             updateKgOptions(); // Cập nhật danh sách trọng lượng
//           });
//           print("🔹 Lấy cân nặng hiện tại thành công: $currentWeight kg");
//         }
//       }
//     } catch (e) {
//       print("❌ Lỗi lấy cân nặng từ API: $e");
//     }
//   }
//
//   void updateKgOptions() {
//     final personalGoalProvider = context.read<PersonalGoalProvider>();
//
//     if (personalGoalProvider.goalType == "GainWeight") {
//       kgOptions =
//           List.generate(50, (index) => currentWeight + index.toDouble());
//     } else if (personalGoalProvider.goalType == "LoseWeight") {
//       kgOptions = List.generate(50, (index) => currentWeight - index.toDouble())
//           .where((kg) => kg > 30.0)
//           .toList();
//     } else {
//       kgOptions = List.generate(100, (index) => index.toDouble() + 30.0);
//     }
//
//     selectedKg = currentWeight;
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final personalGoalProvider = context.watch<PersonalGoalProvider>();
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               const AppbarWidget(title: 'Mục tiêu của bạn'),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Mục tiêu cân nặng của bạn là bao nhiêu kg?',
//                       style: FlutterFlowTheme.of(context).headlineMedium,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Cân nặng hiện tại: ${currentWeight.toStringAsFixed(1)} kg',
//                       style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
//                             fontSize: 16.0,
//                             color: FlutterFlowTheme.of(context).grey,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       height: 200,
//                       color: FlutterFlowTheme.of(context).secondaryBackground,
//                       child: CupertinoPicker(
//                         itemExtent: 40,
//                         magnification: 1.2,
//                         squeeze: 1.2,
//                         useMagnifier: true,
//                         onSelectedItemChanged: (index) {
//                           setState(() {
//                             selectedKg = kgOptions[index];
//                           });
//
//                           print(
//                               "🔹 Người dùng đã chọn targetWeight: ${selectedKg.toStringAsFixed(1)} kg");
//                         },
//                         children: kgOptions.map((kg) {
//                           return Center(
//                             child: Text(
//                               '${kg.toStringAsFixed(1)} kg',
//                               style: FlutterFlowTheme.of(context).bodyLarge,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: FFButtonWidget(
//                         onPressed: () {
//                           personalGoalProvider.setTargetWeight(selectedKg);
//
//                           print(
//                               "🔹 Xác nhận targetWeight: ${personalGoalProvider.targetWeight?.toStringAsFixed(1)}");
//
//                           if (personalGoalProvider.goalType == "GainWeight") {
//                             context.pushNamed(
//                                 'increase_weight_change_rate_screen');
//                           } else if (personalGoalProvider.goalType ==
//                               "LoseWeight") {
//                             context.pushNamed(
//                                 'decrease_weight_change_rate_screen');
//                           } else {
//                             showSnackbar(
//                                 context, 'Lỗi: Mục tiêu không hợp lệ.');
//                           }
//                         },
//                         text: 'Xác nhận',
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 54.0,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           color: FlutterFlowTheme.of(context).primary,
//                           textStyle:
//                               FlutterFlowTheme.of(context).titleSmall.copyWith(
//                                     color: Colors.white,
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                           elevation: 2.0,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../components/appbar_widget.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../services/models/personal_goal_provider.dart'; // ✅ Import PersonalGoalProvider
import '../../services/systemconfiguration_service.dart';
import '../../services/user_service.dart'; // ✅ Import UserService

class TargetWeightScreenWidget extends StatefulWidget {
  const TargetWeightScreenWidget({super.key});

  @override
  State<TargetWeightScreenWidget> createState() =>
      _TargetWeightScreenWidgetState();
}

class _TargetWeightScreenWidgetState extends State<TargetWeightScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double selectedKgLeft = 70.0; // Chọn số nguyên bên trái
  double selectedKgRight = 0.0; // Chọn số nguyên bên phải (từ 0 đến 9)
  List<int> kgOptionsIntLeft = []; // Danh sách cho số nguyên bên trái
  List<int> kgOptionsIntRight =
      []; // Danh sách cho số nguyên bên phải (0 đến 9)
  List<String> dot = ['.']; // Dấu chấm (chỉ có một item)

  double currentWeight = 70.0; // Cân nặng hiện tại, giữ cố định

  double minTargetWeight = 30.0; // Mặc định minTargetWeight
  double maxTargetWeight = 250.0; // Mặc định maxTargetWeight

  @override
  void initState() {
    super.initState();
    fetchCurrentWeight();
    _getTargetWeightRangeFromApi(); // Lấy min và max target weight từ API
  }

  // Lấy cân nặng hiện tại từ API
  Future<void> fetchCurrentWeight() async {
    try {
      final response = await UserService().getHealthProfile();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> healthData = responseData['data'];

        double apiWeight =
            double.tryParse(healthData['weight'].toString()) ?? 0.0;
        if (apiWeight > 0) {
          setState(() {
            currentWeight = apiWeight; // Giữ giá trị cân nặng hiện tại
            selectedKgLeft = currentWeight
                .toInt()
                .toDouble(); // Cập nhật giá trị mặc định cho số nguyên bên trái
            updateKgOptions(); // Cập nhật danh sách trọng lượng
          });
          print("🔹 Lấy cân nặng hiện tại thành công: $currentWeight kg");
        }
      }
    } catch (e) {
      print("❌ Lỗi lấy cân nặng từ API: $e");
    }
  }

  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();

  // Lấy min và max target weight từ API
  Future<void> _getTargetWeightRangeFromApi() async {
    try {
      // Gọi API để lấy min và max target weight
      final response = await _systemConfigService
          .getSystemConfigById(4); // Thay đổi ID config nếu cần
      final weightConfig = response['data'];

      if (weightConfig != null) {
        setState(() {
          minTargetWeight = weightConfig['minValue']?.toDouble() ?? 30.0;
          maxTargetWeight = weightConfig['maxValue']?.toDouble() ?? 250.0;
        });
        updateKgOptions(); // Cập nhật danh sách trọng lượng
      }
      print(
          "🔹 Lấy min và max target weight thành công: $minTargetWeight - $maxTargetWeight");
    } catch (e) {
      print("❌ Lỗi lấy min/max target weight từ API: $e");
      setState(() {
        minTargetWeight = 30.0;
        maxTargetWeight = 250.0;
      });
      updateKgOptions(); // Cập nhật lại danh sách với giá trị mặc định
    }
  }

  // Cập nhật danh sách trọng lượng dựa trên min/max target weight
  void updateKgOptions() {
    final personalGoalProvider = context.read<PersonalGoalProvider>();

    if (personalGoalProvider.goalType == "LoseWeight") {
      // Nếu mục tiêu là giảm cân, giới hạn cân nặng từ minTargetWeight đến currentWeight.
      kgOptionsIntLeft = List.generate(
        (currentWeight.toInt() - minTargetWeight.toInt()) > 0
            ? (currentWeight.toInt() - minTargetWeight.toInt())
            : 0,
        (index) => currentWeight.toInt() - index,
      ); // Tạo danh sách từ currentWeight xuống minTargetWeight (bao gồm)
    } else if (personalGoalProvider.goalType == "GainWeight") {
      // Nếu mục tiêu là tăng cân, giới hạn cân nặng từ currentWeight đến maxTargetWeight.
      kgOptionsIntLeft = List.generate(
        (maxTargetWeight.toInt() - currentWeight.toInt()) > 0
            ? (maxTargetWeight.toInt() - currentWeight.toInt())
            : 0,
        (index) => currentWeight.toInt() + index,
      ); // Tạo danh sách từ currentWeight lên đến maxTargetWeight (bao gồm)
    } else {
      // Nếu mục tiêu là duy trì cân nặng, cho phép từ minTargetWeight đến currentWeight.
      kgOptionsIntLeft = List.generate(
        (currentWeight.toInt() - minTargetWeight.toInt()) > 0
            ? (currentWeight.toInt() - minTargetWeight.toInt())
            : 0,
        (index) => minTargetWeight.toInt() + index,
      ); // Tạo danh sách từ minTargetWeight đến currentWeight
    }

    // Giới hạn thập phân từ 0 đến 9
    kgOptionsIntRight = List.generate(
        10, (index) => index); // Giá trị từ 0 đến 9 cho phần thập phân.

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final personalGoalProvider = context.watch<PersonalGoalProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const AppbarWidget(title: 'Mục tiêu của bạn'),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mục tiêu cân nặng của bạn là bao nhiêu kg?',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cân nặng hiện tại: ${currentWeight.toStringAsFixed(1)} kg', // Hiển thị cân nặng hiện tại
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            fontSize: 16.0,
                            color: FlutterFlowTheme.of(context).grey,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Số nguyên bên trái
                        Expanded(
                          child: Container(
                            height: 200,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: CupertinoPicker(
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedKgLeft =
                                      kgOptionsIntLeft[index].toDouble();
                                });

                                print(
                                    "🔹 Người dùng đã chọn targetWeight (số nguyên bên trái): ${selectedKgLeft.toStringAsFixed(1)} kg");
                              },
                              children: kgOptionsIntLeft.map((kg) {
                                return Center(
                                  child: Text(
                                    '$kg',
                                    style:
                                        FlutterFlowTheme.of(context).bodyLarge,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5), // Dấu cách giữa hai picker
                        // Dấu chấm ở giữa (không thay đổi)
                        Expanded(
                          child: Container(
                            height: 200,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: CupertinoPicker(
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                // Dấu chấm không thay đổi
                                print("🔹 Dấu chấm");
                              },
                              children: dot.map((d) {
                                return Center(
                                  child: Text(
                                    d, // Chỉ có dấu chấm duy nhất
                                    style:
                                        FlutterFlowTheme.of(context).bodyLarge,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5), // Dấu cách giữa các phần
                        // Số nguyên bên phải (0-9)
                        Expanded(
                          child: Container(
                            height: 200,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: CupertinoPicker(
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedKgRight =
                                      kgOptionsIntRight[index].toDouble();
                                });

                                print(
                                    "🔹 Người dùng đã chọn targetWeight (số nguyên bên phải): ${selectedKgRight.toStringAsFixed(1)} kg");
                              },
                              children: kgOptionsIntRight.map((kg) {
                                return Center(
                                  child: Text(
                                    '$kg',
                                    style:
                                        FlutterFlowTheme.of(context).bodyLarge,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FFButtonWidget(
                          onPressed: () {
                            // Tính toán kết quả cuối cùng: Kết hợp số nguyên bên trái và số nguyên bên phải
                            double finalWeight = selectedKgLeft +
                                (selectedKgRight / 10); // 71 + 2/10 = 71.2
                            personalGoalProvider.setTargetWeight(finalWeight);

                            // Validate weight for GainWeight and LoseWeight
                            if (personalGoalProvider.goalType == "GainWeight" &&
                                finalWeight <= minTargetWeight) {
                              showSnackbar(
                                context,
                                "Bạn không thể chọn cân nặng nhỏ hơn hoặc bằng $minTargetWeight kg khi tăng cân.",
                                isError: true,
                              );
                            } else if (personalGoalProvider.goalType ==
                                    "LoseWeight" &&
                                finalWeight >= maxTargetWeight) {
                              showSnackbar(
                                context,
                                "Bạn không thể chọn cân nặng lớn hơn hoặc bằng $maxTargetWeight kg khi giảm cân.",
                                isError: true,
                              );
                            } else {
                              // Nếu không có lỗi, tiếp tục với mục tiêu đã chọn
                              if (personalGoalProvider.goalType ==
                                  "GainWeight") {
                                context.pushNamed(
                                    'increase_weight_change_rate_screen');
                              } else if (personalGoalProvider.goalType ==
                                  "LoseWeight") {
                                context.pushNamed(
                                    'decrease_weight_change_rate_screen');
                              } else {
                                showSnackbar(
                                    context, 'Lỗi: Mục tiêu không hợp lệ.');
                              }
                            }
                          },
                          text: 'Xác nhận',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 54.0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // ✅ Import Provider
//
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '../../components/appbar_widget.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
// import '../../services/models/personal_goal_provider.dart'; // ✅ Import PersonalGoalProvider
// import '../../services/user_service.dart';
//
// class TargetWeightScreenWidget extends StatefulWidget {
//   const TargetWeightScreenWidget({super.key});
//
//   @override
//   State<TargetWeightScreenWidget> createState() =>
//       _TargetWeightScreenWidgetState();
// }
//
// class _TargetWeightScreenWidgetState extends State<TargetWeightScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   double selectedKgLeft = 70.0; // Chọn số nguyên bên trái
//   double selectedKgRight = 0.0; // Chọn số nguyên bên phải (từ 0 đến 9)
//   List<int> kgOptionsIntLeft = []; // Danh sách cho số nguyên bên trái
//   List<int> kgOptionsIntRight =
//       []; // Danh sách cho số nguyên bên phải (0 đến 9)
//   List<String> dot = ['.']; // Dấu chấm (chỉ có một item)
//
//   double currentWeight = 70.0; // Cân nặng hiện tại, giữ cố định
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentWeight();
//   }
//
//   Future<void> fetchCurrentWeight() async {
//     try {
//       final response = await UserService().getHealthProfile();
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final Map<String, dynamic> healthData = responseData['data'];
//
//         double apiWeight =
//             double.tryParse(healthData['weight'].toString()) ?? 0.0;
//         if (apiWeight > 0) {
//           setState(() {
//             currentWeight = apiWeight; // Giữ giá trị cân nặng hiện tại
//             selectedKgLeft = currentWeight
//                 .toInt()
//                 .toDouble(); // Cập nhật giá trị mặc định cho số nguyên bên trái
//             updateKgOptions(); // Cập nhật danh sách trọng lượng
//           });
//           print("🔹 Lấy cân nặng hiện tại thành công: $currentWeight kg");
//         }
//       }
//     } catch (e) {
//       print("❌ Lỗi lấy cân nặng từ API: $e");
//     }
//   }
//
//   void updateKgOptions() {
//     final personalGoalProvider = context.read<PersonalGoalProvider>();
//
//     if (personalGoalProvider.goalType == "LoseWeight") {
//       // Nếu mục tiêu là giảm cân, giới hạn cân nặng từ 30kg đến currentWeight.
//       kgOptionsIntLeft = List.generate(
//         (currentWeight.toInt() - 30) > 0 ? (currentWeight.toInt() - 30) : 0,
//         (index) => currentWeight.toInt() - index,
//       ); // Tạo danh sách từ currentWeight xuống 30kg (bao gồm)
//     } else if (personalGoalProvider.goalType == "GainWeight") {
//       // Nếu mục tiêu là tăng cân, giới hạn cân nặng từ currentWeight đến 250kg.
//       kgOptionsIntLeft = List.generate(
//         (250 - currentWeight.toInt()) > 0 ? (250 - currentWeight.toInt()) : 0,
//         (index) => currentWeight.toInt() + index,
//       ); // Tạo danh sách từ currentWeight lên đến 250kg (bao gồm)
//     } else {
//       // Nếu mục tiêu là duy trì cân nặng, cho phép từ 30kg đến currentWeight.
//       kgOptionsIntLeft = List.generate(
//         (currentWeight.toInt() - 30) > 0 ? (currentWeight.toInt() - 30) : 0,
//         (index) => 30 + index,
//       ); // Tạo danh sách từ 30kg đến currentWeight
//     }
//
//     // Giới hạn thập phân từ 0 đến 9
//     kgOptionsIntRight = List.generate(
//         10, (index) => index); // Giá trị từ 0 đến 9 cho phần thập phân.
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final personalGoalProvider = context.watch<PersonalGoalProvider>();
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               const AppbarWidget(title: 'Mục tiêu của bạn'),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Mục tiêu cân nặng của bạn là bao nhiêu kg?',
//                       style: FlutterFlowTheme.of(context).headlineMedium,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Cân nặng hiện tại: ${currentWeight.toStringAsFixed(1)} kg', // Hiển thị cân nặng hiện tại
//                       style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
//                             fontSize: 16.0,
//                             color: FlutterFlowTheme.of(context).grey,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Số nguyên bên trái
//                         Expanded(
//                           child: Container(
//                             height: 200,
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                             child: CupertinoPicker(
//                               itemExtent: 40,
//                               onSelectedItemChanged: (index) {
//                                 setState(() {
//                                   selectedKgLeft =
//                                       kgOptionsIntLeft[index].toDouble();
//                                 });
//
//                                 print(
//                                     "🔹 Người dùng đã chọn targetWeight (số nguyên bên trái): ${selectedKgLeft.toStringAsFixed(1)} kg");
//                               },
//                               children: kgOptionsIntLeft.map((kg) {
//                                 return Center(
//                                   child: Text(
//                                     '$kg',
//                                     style:
//                                         FlutterFlowTheme.of(context).bodyLarge,
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 5), // Dấu cách giữa hai picker
//                         // Dấu chấm ở giữa (không thay đổi)
//                         Expanded(
//                           child: Container(
//                             height: 200,
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                             child: CupertinoPicker(
//                               itemExtent: 40,
//                               onSelectedItemChanged: (index) {
//                                 // Dấu chấm không thay đổi
//                                 print("🔹 Dấu chấm");
//                               },
//                               children: dot.map((d) {
//                                 return Center(
//                                   child: Text(
//                                     d, // Chỉ có dấu chấm duy nhất
//                                     style:
//                                         FlutterFlowTheme.of(context).bodyLarge,
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 5), // Dấu cách giữa các phần
//                         // Số nguyên bên phải (0-9)
//                         Expanded(
//                           child: Container(
//                             height: 200,
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                             child: CupertinoPicker(
//                               itemExtent: 40,
//                               onSelectedItemChanged: (index) {
//                                 setState(() {
//                                   selectedKgRight =
//                                       kgOptionsIntRight[index].toDouble();
//                                 });
//
//                                 print(
//                                     "🔹 Người dùng đã chọn targetWeight (số nguyên bên phải): ${selectedKgRight.toStringAsFixed(1)} kg");
//                               },
//                               children: kgOptionsIntRight.map((kg) {
//                                 return Center(
//                                   child: Text(
//                                     '$kg',
//                                     style:
//                                         FlutterFlowTheme.of(context).bodyLarge,
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: FFButtonWidget(
//                           onPressed: () {
//                             // Tính toán kết quả cuối cùng: Kết hợp số nguyên bên trái và số nguyên bên phải
//                             double finalWeight = selectedKgLeft +
//                                 (selectedKgRight / 10); // 71 + 2/10 = 71.2
//                             personalGoalProvider.setTargetWeight(finalWeight);
//
//                             // Validate weight for GainWeight and LoseWeight
//                             if (personalGoalProvider.goalType == "GainWeight" &&
//                                 finalWeight <= 30.0) {
//                               showSnackbar(
//                                 context,
//                                 "Bạn không thể chọn cân nặng nhỏ hơn hoặc bằng 30kg khi tăng cân.",
//                                 isError: true,
//                               );
//                             } else if (personalGoalProvider.goalType ==
//                                     "LoseWeight" &&
//                                 finalWeight >= 250.0) {
//                               showSnackbar(
//                                 context,
//                                 "Bạn không thể chọn cân nặng lớn hơn hoặc bằng 250kg khi giảm cân.",
//                                 isError: true,
//                               );
//                             } else {
//                               // Nếu không có lỗi, tiếp tục với mục tiêu đã chọn
//                               if (personalGoalProvider.goalType ==
//                                   "GainWeight") {
//                                 context.pushNamed(
//                                     'increase_weight_change_rate_screen');
//                               } else if (personalGoalProvider.goalType ==
//                                   "LoseWeight") {
//                                 context.pushNamed(
//                                     'decrease_weight_change_rate_screen');
//                               } else {
//                                 showSnackbar(
//                                     context, 'Lỗi: Mục tiêu không hợp lệ.');
//                               }
//                             }
//                           },
//                           text: 'Xác nhận',
//                           options: FFButtonOptions(
//                             width: double.infinity,
//                             height: 54.0,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             color: FlutterFlowTheme.of(context).primary,
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleSmall
//                                 .copyWith(
//                                   color: Colors.white,
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             elevation: 2.0,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showSnackbar(BuildContext context, String message,
//       {bool isError = false}) {
//     final snackBar = SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(color: Colors.white),
//       ),
//       backgroundColor: isError ? Colors.red : Colors.green,
//       duration: const Duration(seconds: 2),
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
