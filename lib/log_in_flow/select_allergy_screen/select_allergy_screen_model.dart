// import 'package:flutter/material.dart';
//
// import '/services/allergy_service.dart';
// import '/services/user_service.dart';
// import '../../components/appbar_model.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
//
// class SelectAllergyScreenModel extends ChangeNotifier {
//   List<int> selectedAllergyIds = [];
//
//   /// Dữ liệu dị ứng từ API
//   List<Map<String, dynamic>> allergyLevelsData = [];
//   bool isLoading = true;
//
//   /// Model cho AppBar
//   late AppbarModel appbarModel;
//
//   void init(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//     fetchAllergyLevels();
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//     super.dispose();
//   }
//
//   /// 🔹 Lấy danh sách dị ứng từ API
//   Future<void> fetchAllergyLevels() async {
//     try {
//       final allergyService = AllergyService();
//       final data = await allergyService.fetchAllergyLevelsData();
//
//       allergyLevelsData = data.where((allergy) => allergy['id'] != -1).toList();
//     } catch (e) {
//       print("❌ Lỗi khi lấy danh sách dị ứng: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }
//
//   void toggleSelection(int allergyId) {
//     if (selectedAllergyIds.contains(allergyId)) {
//       selectedAllergyIds.removeWhere((id) => id == allergyId);
//     } else {
//       selectedAllergyIds.add(allergyId);
//     }
//     print("📌 Danh sách dị ứng đã chọn: $selectedAllergyIds");
//     notifyListeners();
//   }
//
//   /// 🔹 Cập nhật dị ứng lên API
//   Future<void> updateAllergy(BuildContext context) async {
//     try {
//       final healthProfileResponse = await UserService().getHealthProfile();
//       if (healthProfileResponse.statusCode != 200) {
//         showSnackbar(context, 'Lỗi API: Không thể lấy thông tin sức khỏe.');
//         return;
//       }
//
//       final Map<String, dynamic> healthProfile =
//           jsonDecode(healthProfileResponse.body);
//       final profileData = healthProfile['data'];
//
//       if (profileData == null) {
//         showSnackbar(context, '⚠️ Không có dữ liệu sức khỏe hợp lệ.');
//         return;
//       }
//
//       int height = int.tryParse(profileData['height']?.toString() ?? '') ?? 0;
//       int weight = int.tryParse(profileData['weight']?.toString() ?? '') ?? 0;
//       String activityLevel = profileData['activityLevel']?.toString() ?? "";
//
//       if (height == 0 || weight == 0) {
//         showSnackbar(context, '⚠️ Không thể lấy thông tin sức khỏe.');
//         return;
//       }
//
//       List<int> allergiesToSend =
//           selectedAllergyIds.isEmpty ? [0] : selectedAllergyIds;
//       print("📌 selectedAllergyIds trước khi gửi API: $selectedAllergyIds");
//
//       final response = await UserService().updateHealthProfile(
//         height: height,
//         weight: weight,
//         activityLevel: activityLevel,
//         aisuggestion: null,
//         allergies: selectedAllergyIds,
//         diseases: [],
//       );
//
//       print("🔹 Response status code: ${response.statusCode}");
//       print("🔹 Response body: ${response.body}");
//       if (response.statusCode == 200) {
//         FFAppState().allergyIds = allergiesToSend.toString();
//         FFAppState().update(() {});
//         showSnackbar(context, 'Cập nhật dị ứng thành công!');
//       } else {
//         showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
//       }
//     } catch (e) {
//       print("❌ Lỗi xảy ra: $e");
//       showSnackbar(context, 'Lỗi: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';

import '/services/allergy_service.dart';
import '/services/user_service.dart';
import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';

class SelectAllergyScreenModel extends ChangeNotifier {
  List<int> selectedAllergyIds = [];

  /// Dữ liệu dị ứng từ API
  List<Map<String, dynamic>> allergyLevelsData = [];
  bool isLoading = true;

  /// Model cho AppBar
  late AppbarModel appbarModel;

  void init(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    fetchAllergyLevels();
  }

  @override
  void dispose() {
    appbarModel.dispose();
    super.dispose();
  }

  /// 🔹 Lấy danh sách dị ứng từ API
  Future<void> fetchAllergyLevels() async {
    try {
      final allergyService = AllergyService();
      final data = await allergyService.fetchAllergyLevelsData();

      allergyLevelsData = data.where((allergy) => allergy['id'] != -1).toList();
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách dị ứng: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleSelection(int allergyId) {
    if (selectedAllergyIds.contains(allergyId)) {
      selectedAllergyIds.removeWhere((id) => id == allergyId);
    } else {
      selectedAllergyIds.add(allergyId);
    }
    print("📌 Danh sách dị ứng đã chọn: $selectedAllergyIds");
    notifyListeners();
  }
  // void toggleSelection(int allergyId) {
  //   if (selectedAllergyIds.contains(allergyId)) {
  //     selectedAllergyIds.removeWhere((id) => id == allergyId);
  //   } else {
  //     if (selectedAllergyIds.length < 5) {
  //       selectedAllergyIds.add(allergyId);
  //     } else {
  //       // Show Snackbar when trying to select more than 5 allergies
  //       print("📌 Bạn chỉ có thể chọn ít hơn 5 dị ứng");
  //       notifyListeners(); // Update UI after the change
  //     }
  //   }
  //   print("📌 Danh sách dị ứng đã chọn: $selectedAllergyIds");
  //   notifyListeners();
  // }

  /// 🔹 Cập nhật dị ứng lên API
  Future<void> updateAllergy(BuildContext context) async {
    try {
      final healthProfileResponse = await UserService().getHealthProfile();
      if (healthProfileResponse.statusCode != 200) {
        showSnackbar(context, 'Lỗi API: Không thể lấy thông tin sức khỏe.');
        return;
      }

      final Map<String, dynamic> healthProfile =
          jsonDecode(healthProfileResponse.body);
      final profileData = healthProfile['data'];

      if (profileData == null) {
        showSnackbar(context, '⚠️ Không có dữ liệu sức khỏe hợp lệ.');
        return;
      }

      double height =
          double.tryParse(profileData['height']?.toString() ?? '') ?? 0.0;
      double weight =
          double.tryParse(profileData['weight']?.toString() ?? '') ?? 0.0;
      String activityLevel = profileData['activityLevel']?.toString() ?? "";

      if (height == 0.0 || weight == 0.0) {
        showSnackbar(context, '⚠️ Không thể lấy thông tin sức khỏe.');
        return;
      }

      List<int> allergiesToSend =
          selectedAllergyIds.isEmpty ? [0] : selectedAllergyIds;
      print("📌 selectedAllergyIds trước khi gửi API: $selectedAllergyIds");

      final response = await UserService().updateHealthProfile(
        height: height,
        weight: weight,
        activityLevel: activityLevel,
        // aisuggestion: null,
        allergies: selectedAllergyIds,
        diseases: [],
      );

      print("🔹 Response status code: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");
      if (response.statusCode == 200) {
        FFAppState().allergyIds = allergiesToSend.toString();
        FFAppState().update(() {});
        showSnackbar(context, 'Cập nhật dị ứng thành công!');
      } else {
        showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
      }
    } catch (e) {
      print("❌ Lỗi xảy ra: $e");
      showSnackbar(context, 'Lỗi: $e');
    }
  }
}
