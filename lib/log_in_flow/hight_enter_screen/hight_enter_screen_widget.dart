// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/components/appbar_widget.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'hight_enter_screen_model.dart';
//
// export 'hight_enter_screen_model.dart';
//
// class HightEnterScreenWidget extends StatefulWidget {
//   const HightEnterScreenWidget({super.key});
//
//   @override
//   State<HightEnterScreenWidget> createState() => _HightEnterScreenWidgetState();
// }
//
// class _HightEnterScreenWidgetState extends State<HightEnterScreenWidget> {
//   late HightEnterScreenModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => HightEnterScreenModel());
//     _model.cmTextController ??=
//         TextEditingController(text: FFAppState().cmvalue);
//     _model.cmFocusNode ??= FocusNode();
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
//               const AppbarWidget(title: 'Nhập chiều cao'),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _model.formKey, // Sử dụng formKey đúng cách
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         TextFormField(
//                           controller: _model.cmTextController,
//                           focusNode: _model.cmFocusNode,
//                           onChanged: (_) => EasyDebounce.debounce(
//                             '_model.cmTextController',
//                             const Duration(milliseconds: 2000),
//                             () async {
//                               FFAppState().cmvalue =
//                                   _model.cmTextController.text;
//                               FFAppState().update(() {});
//                             },
//                           ),
//                           autofocus: false,
//                           textInputAction: TextInputAction.next,
//                           obscureText: false,
//                           decoration: InputDecoration(
//                             labelText: 'Nhập chiều cao (cm)',
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
//                           validator: _model.cmTextControllerValidator
//                               ?.asValidator(context),
//                         ),
//                         const SizedBox(height: 20.0),
//                         FFButtonWidget(
//                           onPressed: () async {
//                             if (_model.formKey.currentState?.validate() ??
//                                 false) {
//                               await _model.updateHeight(context);
//                               context.pushNamed('weight_Enter_screen');
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/models/health_profile_provider.dart';
import '../../components/appbar_widget.dart';

class HightEnterScreenWidget extends StatefulWidget {
  const HightEnterScreenWidget({super.key});

  @override
  State<HightEnterScreenWidget> createState() =>
      _HeightEnterScreenWidgetState();
}

class _HeightEnterScreenWidgetState extends State<HightEnterScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double selectedHeightLeft =
      160.0; // Default height in centimeters (whole number part)
  double selectedHeightRight = 0.0; // Decimal part (0-9)

  List<int> heightOptionsIntLeft = []; // List of whole number heights
  List<int> heightOptionsIntRight =
      List.generate(10, (index) => index); // Decimal values 0-9

  @override
  void initState() {
    super.initState();
    updateHeightOptions(); // Generate height options
  }

  void updateHeightOptions() {
    // Generate height options from 100 to 220 cm (can be adjusted as needed)
    heightOptionsIntLeft =
        List.generate(121, (index) => 100 + index); // Heights from 100 to 220
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
              const AppbarWidget(title: 'Nhập chiều cao'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Nhập chiều cao của bạn:',
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Height options before decimal (e.g., 160)
                          Expanded(
                            child: Container(
                              height:
                                  200, // Set height of picker container for scrolling
                              child: CupertinoPicker(
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedHeightLeft =
                                        heightOptionsIntLeft[index].toDouble();
                                  });
                                  print(
                                      "🔹 Người dùng đã chọn chiều cao (số nguyên bên trái): $selectedHeightLeft cm");
                                },
                                children: heightOptionsIntLeft.map((height) {
                                  return Center(
                                    child: Text('$height',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5), // Space between two pickers
                          // Decimal part (0-9)
                          Expanded(
                            child: Container(
                              height:
                                  200, // Set height of picker container for scrolling
                              child: CupertinoPicker(
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedHeightRight =
                                        heightOptionsIntRight[index].toDouble();
                                  });
                                  print(
                                      "🔹 Người dùng đã chọn chiều cao (phần thập phân): $selectedHeightRight cm");
                                },
                                children: heightOptionsIntRight.map((height) {
                                  return Center(
                                    child: Text('$height',
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
                          double finalHeight = selectedHeightLeft +
                              (selectedHeightRight /
                                  10); // Combine integer part and decimal part
                          Provider.of<HealthProfileProvider>(context,
                                  listen: false)
                              .setHeight(finalHeight);

                          print("🔹 Xác nhận chiều cao: $finalHeight cm");

                          showSnackbar(
                              context, 'Cập nhật chiều cao thành công!');
                          context.pushNamed('weight_Enter_screen');
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

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    ),
    backgroundColor: Colors.green, // Set background color to green
    duration: Duration(seconds: 2), // Duration for the snackbar to be visible
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
