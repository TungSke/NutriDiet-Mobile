// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/components/appbar_widget.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'weight_enter_screen_model.dart';
//
// export 'weight_enter_screen_model.dart';
//
// class WeightEnterScreenWidget extends StatefulWidget {
//   const WeightEnterScreenWidget({super.key});
//
//   @override
//   State<WeightEnterScreenWidget> createState() =>
//       _WeightEnterScreenWidgetState();
// }
//
// class _WeightEnterScreenWidgetState extends State<WeightEnterScreenWidget> {
//   late WeightEnterScreenModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => WeightEnterScreenModel());
//     _model.kgTextController ??=
//         TextEditingController(text: FFAppState().kgvalue);
//     _model.kgFocusNode ??= FocusNode();
//   }
//
//   @override
//   void dispose() {
//     _model.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     context.watch<FFAppState>();
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
//               const AppbarWidget(title: 'Nhập cân nặng'),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _model.formKey, // Thêm formKey
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         TextFormField(
//                           controller: _model.kgTextController,
//                           focusNode: _model.kgFocusNode,
//                           onChanged: (_) => EasyDebounce.debounce(
//                             '_model.kgTextController',
//                             const Duration(milliseconds: 2000),
//                             () async {
//                               FFAppState().kgvalue =
//                                   _model.kgTextController.text;
//                               FFAppState().update(() {});
//                             },
//                           ),
//                           autofocus: false,
//                           textInputAction: TextInputAction.next,
//                           obscureText: false,
//                           decoration: InputDecoration(
//                             labelText: 'Nhập cân nặng (kg)',
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).grey,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).primary,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             contentPadding: const EdgeInsets.all(16.0),
//                           ),
//                           style: FlutterFlowTheme.of(context).bodyMedium,
//                           keyboardType: TextInputType.number,
//                           cursorColor: FlutterFlowTheme.of(context).primary,
//                           validator: _model.kgTextControllerValidator
//                               ?.asValidator(context),
//                         ),
//                         const SizedBox(height: 20.0),
//                         FFButtonWidget(
//                           onPressed: () async {
//                             if (_model.formKey.currentState?.validate() ??
//                                 false) {
//                               await _model.updateWeight(context);
//                               // context.pushNamed('Whats_your_goal');
//                               context.pushNamed('frequency_exercise_screen');
//                             }
//                           },
//                           text: 'Tiếp tục',
//                           options: FFButtonOptions(
//                             width: double.infinity,
//                             height: 54.0,
//                             color: FlutterFlowTheme.of(context).primary,
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleSmall
//                                 .override(
//                                   fontFamily: 'figtree',
//                                   color: Colors.white,
//                                   fontSize: 18.0,
//                                   useGoogleFonts: false,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             borderRadius: BorderRadius.circular(16.0),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/services/models/health_profile_provider.dart';
// import '../../components/appbar_widget.dart';
//
// class WeightEnterScreenWidget extends StatefulWidget {
//   const WeightEnterScreenWidget({super.key});
//
//   @override
//   State<WeightEnterScreenWidget> createState() =>
//       _WeightEnterScreenWidgetState();
// }
//
// class _WeightEnterScreenWidgetState extends State<WeightEnterScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   double selectedWeightLeft = 30.0; // Default weight (whole number part)
//   double selectedWeightRight = 0.0; // Decimal part (0-9)
//
//   List<int> weightOptionsIntLeft = []; // List of whole number weights
//   List<int> weightOptionsIntRight =
//       List.generate(10, (index) => index); // Decimal values 0-9
//
//   @override
//   void initState() {
//     super.initState();
//     updateWeightOptions(); // Generate weight options
//   }
//
//   void updateWeightOptions() {
//     // Generate weight options from 30 to 250 kg (theo DTO)
//     weightOptionsIntLeft =
//         List.generate(221, (index) => 30 + index); // Weights from 30 to 250
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//               const AppbarWidget(title: 'Nhập cân nặng'),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Text(
//                         'Nhập cân nặng của bạn(kg):',
//                         style: FlutterFlowTheme.of(context).headlineMedium,
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Weight options before decimal (e.g., 50)
//                           Expanded(
//                             child: Container(
//                               height: 200,
//                               child: CupertinoPicker(
//                                 itemExtent: 40,
//                                 onSelectedItemChanged: (index) {
//                                   setState(() {
//                                     selectedWeightLeft =
//                                         weightOptionsIntLeft[index].toDouble();
//                                   });
//                                   print(
//                                       "🔹 Người dùng đã chọn cân nặng (số nguyên bên trái): $selectedWeightLeft kg");
//                                 },
//                                 children: weightOptionsIntLeft.map((weight) {
//                                   return Center(
//                                     child: Text('$weight',
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyLarge),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           // Decimal part (0-9)
//                           Expanded(
//                             child: Container(
//                               height: 200,
//                               child: CupertinoPicker(
//                                 itemExtent: 40,
//                                 onSelectedItemChanged: (index) {
//                                   setState(() {
//                                     selectedWeightRight =
//                                         weightOptionsIntRight[index].toDouble();
//                                   });
//                                   print(
//                                       "🔹 Người dùng đã chọn cân nặng (phần thập phân): $selectedWeightRight kg");
//                                 },
//                                 children: weightOptionsIntRight.map((weight) {
//                                   return Center(
//                                     child: Text('$weight',
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyLarge),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       FFButtonWidget(
//                         onPressed: () {
//                           double finalWeight =
//                               selectedWeightLeft + (selectedWeightRight / 10);
//                           // Kiểm tra validation
//                           if (finalWeight < 30 || finalWeight > 250) {
//                             showSnackbar(
//                                 context, 'Cân nặng phải từ 30 đến 250 kg!',
//                                 isError: true);
//                             return;
//                           }
//
//                           Provider.of<HealthProfileProvider>(context,
//                                   listen: false)
//                               .setWeight(finalWeight);
//
//                           print("🔹 Xác nhận cân nặng: $finalWeight kg");
//
//                           showSnackbar(
//                               context, 'Cập nhật cân nặng thành công!');
//                           context.pushNamed('frequency_exercise_screen');
//                         },
//                         text: 'Xác nhận',
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 54.0,
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
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void showSnackbar(BuildContext context, String message,
//     {bool isError = false}) {
//   final snackBar = SnackBar(
//     content: Text(
//       message,
//       style: const TextStyle(color: Colors.white),
//     ),
//     backgroundColor: isError ? Colors.red : Colors.green,
//     duration: const Duration(seconds: 2),
//   );
//
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/models/health_profile_provider.dart';
import '../../components/appbar_widget.dart';
import '../../services/systemconfiguration_service.dart';

class WeightEnterScreenWidget extends StatefulWidget {
  const WeightEnterScreenWidget({super.key});

  @override
  State<WeightEnterScreenWidget> createState() =>
      _WeightEnterScreenWidgetState();
}

class _WeightEnterScreenWidgetState extends State<WeightEnterScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double selectedWeightLeft = 30.0; // Default weight (whole number part)
  double selectedWeightRight = 0.0; // Decimal part (0-9)

  List<int> weightOptionsIntLeft = []; // List of whole number weights
  List<int> weightOptionsIntRight =
      List.generate(10, (index) => index); // Decimal values 0-9

  double minWeight = 30.0;
  double maxWeight = 250.0;
  @override
  void initState() {
    super.initState();
    _getWeightRangeFromApi(); // Fetch weight range from API
  }

  final SystemConfigurationService _systemConfigService =
      SystemConfigurationService();
  // Fetch min and max weight from API
  Future<void> _getWeightRangeFromApi() async {
    try {
      // Call your API here to fetch the weight range
      // Example: Fetching from an API
      final response = await _systemConfigService.getSystemConfigById(3);
      final weightConfig = response['data'];

      if (weightConfig != null) {
        minWeight = weightConfig['minValue']?.toDouble() ?? 30.0;
        maxWeight = weightConfig['maxValue']?.toDouble() ?? 250.0;
      }

      updateWeightOptions(); // Update weight options based on fetched min/max
    } catch (e) {
      print("Error fetching weight range: $e");
      updateWeightOptions(); // Use default if API fails
    }
  }

  void updateWeightOptions() {
    weightOptionsIntLeft = List.generate((maxWeight - minWeight).toInt() + 1,
        (index) => minWeight.toInt() + index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              const AppbarWidget(title: 'Nhập cân nặng'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Nhập cân nặng của bạn(kg):',
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Weight options before decimal (e.g., 50)
                          Expanded(
                            child: Container(
                              height: 200,
                              child: CupertinoPicker(
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedWeightLeft =
                                        weightOptionsIntLeft[index].toDouble();
                                  });
                                  print(
                                      "🔹 Người dùng đã chọn cân nặng (số nguyên bên trái): $selectedWeightLeft kg");
                                },
                                children: weightOptionsIntLeft.map((weight) {
                                  return Center(
                                    child: Text('$weight',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Decimal part (0-9)
                          Expanded(
                            child: Container(
                              height: 200,
                              child: CupertinoPicker(
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedWeightRight =
                                        weightOptionsIntRight[index].toDouble();
                                  });
                                  print(
                                      "🔹 Người dùng đã chọn cân nặng (phần thập phân): $selectedWeightRight kg");
                                },
                                children: weightOptionsIntRight.map((weight) {
                                  return Center(
                                    child: Text('$weight',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FFButtonWidget(
                        onPressed: () {
                          double finalWeight =
                              selectedWeightLeft + (selectedWeightRight / 10);
                          // Kiểm tra validation
                          if (finalWeight < minWeight ||
                              finalWeight > maxWeight) {
                            showSnackbar(context,
                                'Cân nặng phải từ $minWeight đến $maxWeight kg!',
                                isError: true);
                            return;
                          }

                          Provider.of<HealthProfileProvider>(context,
                                  listen: false)
                              .setWeight(finalWeight);

                          print("🔹 Xác nhận cân nặng: $finalWeight kg");

                          showSnackbar(
                              context, 'Cập nhật cân nặng thành công!');
                          context.pushNamed('frequency_exercise_screen');
                        },
                        text: 'Xác nhận',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 54.0,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
