// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/components/appbar_widget.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '../../services/models/health_profile_provider.dart';
// import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;
//
// class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
//   ///  State fields for stateful widgets in this page.
//
//   final formKey = GlobalKey<FormState>();
//   late AppbarModel appbarModel;
//
//   FocusNode? kgFocusNode;
//   TextEditingController? kgTextController;
//   String? Function(BuildContext, String?)? kgTextControllerValidator;
//
//   @override
//   void initState(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//     kgTextControllerValidator = _kgTextControllerValidator;
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//     kgFocusNode?.dispose();
//     kgTextController?.dispose();
//   }
//
//   String? _kgTextControllerValidator(BuildContext context, String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Vui lòng nhập cân nặng';
//     }
//     return null;
//   }
//
//   Future<void> updateWeight(BuildContext context) async {
//     final newWeightStr = kgTextController?.text.trim();
//     if (newWeightStr == null || newWeightStr.isEmpty) {
//       return;
//     }
//
//     final int? newWeight = int.tryParse(newWeightStr);
//     if (newWeight == null || newWeight <= 0) {
//       showSnackbar(context, 'Cân nặng không hợp lệ, vui lòng nhập số dương.');
//       return;
//     }
//
//     // Lưu cân nặng vào HealthProfileProvider dưới dạng int
//     Provider.of<HealthProfileProvider>(context, listen: false)
//         .setWeight(newWeight);
//
//     // Log cân nặng vào console để kiểm tra
//     print(
//         'Cân nặng đã lưu vào provider: ${Provider.of<HealthProfileProvider>(context, listen: false).weight}');
//
//     // Cập nhật lại trạng thái ứng dụng (FFAppState)
//     FFAppState().kgvalue = newWeightStr;
//     FFAppState().update(() {});
//
//     // Hiển thị thông báo cho người dùng
//     showSnackbar(context, 'Cập nhật cân nặng thành công!');
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/components/appbar_widget.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '../../services/models/health_profile_provider.dart';
// import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;
//
// class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
//   /// State fields for stateful widgets in this page.
//
//   final formKey = GlobalKey<FormState>();
//   late AppbarModel appbarModel;
//
//   FocusNode? kgFocusNode;
//   TextEditingController? kgTextController;
//   String? Function(BuildContext, String?)? kgTextControllerValidator;
//
//   @override
//   void initState(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//     kgTextControllerValidator = _kgTextControllerValidator;
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//     kgFocusNode?.dispose();
//     kgTextController?.dispose();
//   }
//
//   String? _kgTextControllerValidator(BuildContext context, String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Vui lòng nhập cân nặng';
//     }
//     return null;
//   }
//
//   Future<void> updateWeight(BuildContext context) async {
//     final newWeightStr = kgTextController?.text.trim();
//     if (newWeightStr == null || newWeightStr.isEmpty) {
//       return;
//     }
//
//     // Sử dụng double thay vì int để có thể nhập cân nặng với phần thập phân
//     final double? newWeight = double.tryParse(newWeightStr);
//     if (newWeight == null || newWeight <= 0) {
//       showSnackbar(context, 'Cân nặng không hợp lệ, vui lòng nhập số dương.');
//       return;
//     }
//
//     // Lưu cân nặng vào HealthProfileProvider dưới dạng double
//     Provider.of<HealthProfileProvider>(context, listen: false)
//         .setWeight(newWeight);
//
//     // Log cân nặng vào console để kiểm tra
//     print(
//         'Cân nặng đã lưu vào provider: ${Provider.of<HealthProfileProvider>(context, listen: false).weight}');
//
//     // Cập nhật lại trạng thái ứng dụng (FFAppState)
//     FFAppState().kgvalue = newWeightStr;
//     FFAppState().update(() {});
//
//     // Hiển thị thông báo cho người dùng
//     showSnackbar(context, 'Cập nhật cân nặng thành công!');
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../services/models/health_profile_provider.dart';
import 'weight_enter_screen_widget.dart' show WeightEnterScreenWidget;

class WeightEnterScreenModel extends FlutterFlowModel<WeightEnterScreenWidget> {
  /// State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  late AppbarModel appbarModel;

  FocusNode? kgFocusNode;
  TextEditingController? kgTextController;
  String? Function(BuildContext, String?)? kgTextControllerValidator;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    kgTextControllerValidator = _kgTextControllerValidator;
  }

  @override
  void dispose() {
    appbarModel.dispose();
    kgFocusNode?.dispose();
    kgTextController?.dispose();
  }

  String? _kgTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Vui lòng nhập cân nặng';
    }
    return null;
  }

  Future<void> updateWeight(BuildContext context) async {
    final newWeightStr = kgTextController?.text.trim();
    if (newWeightStr == null || newWeightStr.isEmpty) {
      return;
    }

    // Sử dụng double thay vì int để có thể nhập cân nặng với phần thập phân
    final double? newWeight = double.tryParse(newWeightStr);
    if (newWeight == null || newWeight <= 0) {
      showSnackbar(context, 'Cân nặng không hợp lệ, vui lòng nhập số dương.');
      return;
    }

    // Lưu cân nặng vào HealthProfileProvider dưới dạng double
    Provider.of<HealthProfileProvider>(context, listen: false)
        .setWeight(newWeight);

    // Log cân nặng vào console để kiểm tra
    print(
        'Cân nặng đã lưu vào provider: ${Provider.of<HealthProfileProvider>(context, listen: false).weight}');

    // Cập nhật lại trạng thái ứng dụng (FFAppState)
    FFAppState().kgvalue = newWeightStr;
    FFAppState().update(() {});

    // Hiển thị thông báo cho người dùng
    showSnackbar(context, 'Cập nhật cân nặng thành công!');
  }
}
