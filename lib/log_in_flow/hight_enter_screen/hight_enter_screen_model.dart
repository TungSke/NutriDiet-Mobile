// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../components/appbar_model.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
// import '../../services/models/health_profile_provider.dart';
// import 'hight_enter_screen_widget.dart';
//
// class HightEnterScreenModel extends FlutterFlowModel<HightEnterScreenWidget> {
//   /// State fields for stateful widgets in this page.
//
//   final formKey = GlobalKey<FormState>();
//   late AppbarModel appbarModel;
//
//   FocusNode? cmFocusNode;
//   TextEditingController? cmTextController;
//   String? Function(BuildContext, String?)? cmTextControllerValidator;
//
//   @override
//   void initState(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//     cmTextControllerValidator = _cmTextControllerValidator;
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//     cmFocusNode?.dispose();
//     cmTextController?.dispose();
//   }
//
//   String? _cmTextControllerValidator(BuildContext context, String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Vui lòng nhập chiều cao';
//     }
//     return null;
//   }
//
//   Future<void> updateHeight(BuildContext context) async {
//     final newHeightStr = cmTextController?.text.trim();
//     if (newHeightStr == null || newHeightStr.isEmpty) {
//       return;
//     }
//
//     // Sử dụng double thay vì int để có thể nhập giá trị thập phân
//     final double? newHeight = double.tryParse(newHeightStr);
//     if (newHeight == null || newHeight <= 0) {
//       showSnackbar(context, 'Chiều cao không hợp lệ, vui lòng nhập số dương.');
//       return;
//     }
//
//     // Lưu chiều cao vào HealthProfileProvider dưới dạng double
//     Provider.of<HealthProfileProvider>(context, listen: false)
//         .setHeight(newHeight);
//
//     // Log chiều cao vào console
//     print('Chiều cao đã lưu vào provider: $newHeight');
//
//     // Cập nhật lại trạng thái ứng dụng (FFAppState)
//     FFAppState().cmvalue = newHeightStr;
//     FFAppState().update(() {});
//
//     // Hiển thị thông báo cho người dùng
//     showSnackbar(context, 'Cập nhật chiều cao thành công!');
//   }
// }
