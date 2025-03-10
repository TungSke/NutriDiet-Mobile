// import 'package:diet_plan_app/log_in_flow/whats_your_goal/whats_your_goal_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../../components/appbar_model.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
// import '../../services/models/personal_goal_provider.dart';
// import '../../services/user_service.dart';
//
// class WhatsYourGoalModel extends FlutterFlowModel<WhatsYourGoalWidget> {
//   late AppbarModel appbarModel;
//
//   static const List<String?> goalLevels = [
//     'Maintain',
//     'LoseWeight',
//     'GainWeight',
//   ];
//
//   String? get selectedGoalLevel => null; // Không còn cần biến cục bộ
//
//   @override
//   void initState(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//   }
//
//   Future<void> updateGoalLevel(BuildContext context) async {
//     final personalGoalProvider = context.read<PersonalGoalProvider>();
//
//     if (personalGoalProvider.goalType == null) {
//       showSnackbar(context, 'Vui lòng chọn một mục tiêu.');
//       return;
//     }
//
//     try {
//       // 🔹 Lấy giá trị từ Provider, đảm bảo không có giá trị null
//       final response = await UserService().updatePersonalGoal(
//         goalType: personalGoalProvider.goalType ??
//             "Maintain", // ✅ Default to 'Maintain'
//         targetWeight:
//             personalGoalProvider.targetWeight ?? 60.0, // ✅ Default to 60.0kg
//         weightChangeRate:
//             personalGoalProvider.weightChangeRate ?? "Normal", // ✅ Default rate
//         goalDescription: personalGoalProvider.goalDescription ??
//             "Mục tiêu mặc định", // ✅ Default string
//         notes: personalGoalProvider.notes ??
//             "Không có ghi chú", // ✅ Default string
//       );
//
//       print("🔹 Status cập nhật: ${response.statusCode}");
//       print("🔹 Response cập nhật: ${response.body}");
//
//       if (response.statusCode == 200) {
//         showSnackbar(context, 'Cập nhật mục tiêu thành công!');
//       } else {
//         showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
//       }
//     } catch (e) {
//       print("❌ Lỗi xảy ra: $e");
//       showSnackbar(context, 'Lỗi: $e');
//     }
//   }
// }
