// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/services/disease_service.dart'; // Thay allergy_service thành disease_service
// import '/services/user_service.dart';
// import '../../components/appbar_model.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
// import '../../services/models/health_profile_provider.dart';
//
// class SelectDiseaseScreenModel extends ChangeNotifier {
//   List<int> selectedDiseaseIds = []; // Danh sách bệnh đã chọn (List<int>)
//
//   /// Dữ liệu bệnh từ API
//   List<Map<String, dynamic>> diseaseLevelsData = [];
//   bool isLoading = true;
//
//   /// Model cho AppBar
//   late AppbarModel appbarModel;
//
//   void init(BuildContext context) {
//     appbarModel = createModel(context, () => AppbarModel());
//     fetchDiseaseLevels(); // Lấy danh sách bệnh
//   }
//
//   @override
//   void dispose() {
//     appbarModel.dispose();
//     super.dispose();
//   }
//
//   /// 🔹 Lấy danh sách bệnh từ API
//   Future<void> fetchDiseaseLevels() async {
//     try {
//       final diseaseService =
//           DiseaseService(); // Sử dụng DiseaseService thay AllergyService
//       final data = await diseaseService.fetchDiseaseLevelsData();
//
//       diseaseLevelsData = data.where((disease) => disease['id'] != -1).toList();
//     } catch (e) {
//       print("❌ Lỗi khi lấy danh sách bệnh: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }
//
//   void toggleSelection(int diseaseId) {
//     if (selectedDiseaseIds.contains(diseaseId)) {
//       selectedDiseaseIds.removeWhere((id) => id == diseaseId);
//     } else {
//       selectedDiseaseIds.add(diseaseId);
//     }
//     print("📌 Danh sách bệnh đã chọn: $selectedDiseaseIds");
//     notifyListeners();
//   }
//
//   /// 🔹 Cập nhật bệnh lên HealthProfileProvider và API
//   Future<void> updateDisease(BuildContext context) async {
//     try {
//       // Lấy thông tin sức khỏe từ HealthProfileProvider
//       final healthProfileProvider = context.read<HealthProfileProvider>();
//
//       // Lấy height, weight, và activityLevel từ HealthProfileProvider
//       int height = healthProfileProvider.height ?? 0;
//       int weight = healthProfileProvider.weight ?? 0;
//       String aisuggestion = healthProfileProvider.aisuggestion ?? "string";
//       String activityLevel = healthProfileProvider.activityLevel ?? "";
//
//       // Kiểm tra xem có đầy đủ thông tin không
//       if (height == 0 || weight == 0 || activityLevel.isEmpty) {
//         showSnackbar(context, '⚠️ Thông tin sức khỏe chưa đầy đủ.');
//         return;
//       }
//
//       // Cập nhật danh sách bệnh vào HealthProfileProvider
//       healthProfileProvider.setDiseases(
//           selectedDiseaseIds); // Chắc chắn rằng `selectedDiseaseIds` là List<int>
//
//       // Lấy allergy và disease từ HealthProfileProvider
//       List<int> allergies = healthProfileProvider.allergies;
//       List<int> diseases = healthProfileProvider
//           .diseases; // Lấy diseases từ HealthProfileProvider
//
//       // Kiểm tra và hiển thị thông tin bệnh và dị ứng
//       print("📌 Allergies: $allergies");
//       print("📌 Diseases: $diseases");
//
//       // Gửi thông tin lên API
//       final response = await UserService().updateHealthProfile(
//         height: height,
//         weight: weight,
//         activityLevel: activityLevel,
//         aisuggestion: "string",
//         allergies: allergies, // Gửi allergy
//         diseases: diseases, // Gửi disease
//       );
//
//       print("🔹 Response status code: ${response.statusCode}");
//       print("🔹 Response body: ${response.body}");
//       if (response.statusCode == 200) {
//         FFAppState().diseaseIds =
//             diseases.toString(); // Lưu disease thay allergy
//         FFAppState().update(() {});
//         showSnackbar(context, 'Cập nhật bệnh thành công!');
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
import 'package:provider/provider.dart';

import '/services/disease_service.dart'; // Thay allergy_service thành disease_service
import '/services/user_service.dart';
import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../services/models/health_profile_provider.dart';

class SelectDiseaseScreenModel extends ChangeNotifier {
  List<int> selectedDiseaseIds = []; // Danh sách bệnh đã chọn (List<int>)

  /// Dữ liệu bệnh từ API
  List<Map<String, dynamic>> diseaseLevelsData = [];
  bool isLoading = true;
  bool isDiseaseUpdated = false;

  /// Model cho AppBar
  late AppbarModel appbarModel;

  void init(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    fetchDiseaseLevels(); // Lấy danh sách bệnh
  }

  @override
  void dispose() {
    appbarModel.dispose();
    super.dispose();
  }

  /// 🔹 Lấy danh sách bệnh từ API
  Future<void> fetchDiseaseLevels() async {
    try {
      final diseaseService =
          DiseaseService(); // Sử dụng DiseaseService thay AllergyService
      final data = await diseaseService.fetchDiseaseLevelsData();

      diseaseLevelsData = data.where((disease) => disease['id'] != -1).toList();
    } catch (e) {
      print("❌ Lỗi khi lấy danh sách bệnh: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleSelection(int diseaseId) {
    if (selectedDiseaseIds.contains(diseaseId)) {
      selectedDiseaseIds.removeWhere((id) => id == diseaseId);
    } else {
      selectedDiseaseIds.add(diseaseId);
    }
    print("📌 Danh sách bệnh đã chọn: $selectedDiseaseIds");
    notifyListeners();
  }

  /// 🔹 Cập nhật bệnh lên HealthProfileProvider và API
//   Future<void> updateDisease(BuildContext context) async {
//     try {
//       // Lấy thông tin sức khỏe từ HealthProfileProvider
//       final healthProfileProvider = context.read<HealthProfileProvider>();
//
//       // Lấy height, weight, và activityLevel từ HealthProfileProvider
//       double height =
//           healthProfileProvider.height ?? 0.0; // Cập nhật thành double
//       double weight =
//           healthProfileProvider.weight ?? 0.0; // Cập nhật thành double
//       String aisuggestion = healthProfileProvider.aisuggestion ?? "string";
//       String activityLevel = healthProfileProvider.activityLevel ?? "";
//       String dietStyle = healthProfileProvider.dietStyle ?? "";
//       // Kiểm tra xem có đầy đủ thông tin không
//       if (height == 0.0 || weight == 0.0 || activityLevel.isEmpty) {
//         showSnackbar(context, '⚠️ Thông tin sức khỏe chưa đầy đủ.');
//         return;
//       }
//
//       // Cập nhật danh sách bệnh vào HealthProfileProvider
//       healthProfileProvider.setDiseases(
//           selectedDiseaseIds); // Chắc chắn rằng `selectedDiseaseIds` là List<int>
//
//       // Lấy allergy và disease từ HealthProfileProvider
//       List<int> allergies = healthProfileProvider.allergies;
//       List<int> diseases = healthProfileProvider
//           .diseases; // Lấy diseases từ HealthProfileProvider
//
//       // Kiểm tra và hiển thị thông tin bệnh và dị ứng
//       print("📌 Allergies: $allergies");
//       print("📌 Diseases: $diseases");
//
//       // Gửi thông tin lên API
//       final response = await UserService().updateHealthProfile(
//         height: height,
//         weight: weight,
//         activityLevel: activityLevel,
//         dietStyle: dietStyle,
//         aisuggestion: "",
//         allergies: allergies, // Gửi allergy
//         diseases: diseases, // Gửi disease
//       );
//
//       print("🔹 Response status code: ${response.statusCode}");
//       print("🔹 Response body: ${response.body}");
//       if (response.statusCode == 200) {
//         FFAppState().diseaseIds =
//             diseases.toString(); // Lưu disease thay allergy
//         FFAppState().update(() {});
//         showSnackbar(context, 'Cập nhật bệnh thành công!');
//       } else {
//         showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
//       }
//     } catch (e) {
//       print("❌ Lỗi xảy ra: $e");
//       showSnackbar(context, 'Lỗi: $e');
//     }
//   }
// }
  /// 🔹 Cập nhật bệnh lên HealthProfileProvider và API
  Future<void> updateDisease(BuildContext context) async {
    try {
      isLoading = true; // Bắt đầu quá trình gửi dữ liệu bệnh lên API
      notifyListeners();

      final healthProfileProvider = context.read<HealthProfileProvider>();

      double height = healthProfileProvider.height ?? 0.0;
      double weight = healthProfileProvider.weight ?? 0.0;
      String aisuggestion = healthProfileProvider.aisuggestion ?? "string";
      String activityLevel = healthProfileProvider.activityLevel ?? "";
      String dietStyle = healthProfileProvider.dietStyle ?? "";
      String profileOption = healthProfileProvider.profileOption;

      print("🔹 Dữ liệu sẽ được gửi:");
      print("Height: $height, Weight: $weight");
      print("Activity Level: $activityLevel, Diet Style: $dietStyle");
      print("Profile Option: $profileOption, Aisuggestion: $aisuggestion");
      print("Allergies: ${healthProfileProvider.allergies}");
      print("Diseases: ${selectedDiseaseIds}");

      if (height == 0.0 || weight == 0.0 || activityLevel.isEmpty) {
        showSnackbar(context, '⚠️ Thông tin sức khỏe chưa đầy đủ.');
        return;
      }

      healthProfileProvider.setDiseases(selectedDiseaseIds);

      List<int> allergies = healthProfileProvider.allergies;
      List<int> diseases = healthProfileProvider.diseases;

      final response = await UserService().updateHealthProfile(
        height: height,
        weight: weight,
        activityLevel: activityLevel,
        dietStyle: dietStyle,
        profileOption: profileOption,
        // aisuggestion: "",
        allergies: allergies,
        diseases: diseases,
      );
      // Kiểm tra phản hồi
      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        FFAppState().diseaseIds = diseases.toString();
        FFAppState().update(() {});
        // showSnackbar(context, 'Cập nhật bệnh thành công!');
        isDiseaseUpdated = true; // Đánh dấu bệnh đã được cập nhật thành công
      } else {
        showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
        isDiseaseUpdated = false; // Nếu có lỗi, đánh dấu là chưa thành công
      }
    } catch (e) {
      print("❌ Lỗi xảy ra: $e");
      showSnackbar(context, 'Lỗi: $e');
      isDiseaseUpdated = false; // Nếu xảy ra lỗi, đánh dấu là chưa thành công
    } finally {
      isLoading =
          false; // Đảm bảo luôn thay đổi trạng thái loading sau khi gửi xong
      notifyListeners();
    }
  }
}
