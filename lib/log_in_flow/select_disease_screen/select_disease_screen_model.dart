import 'package:flutter/material.dart';

import '/services/disease_service.dart';
import '/services/user_service.dart';
import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_util.dart';

class SelectDiseaseScreenModel extends ChangeNotifier {
  List<int> selectedDiseaseIds = [];

  /// Dữ liệu bệnh từ API
  List<Map<String, dynamic>> diseaseLevelsData = [];
  bool isLoading = true;

  /// Model cho AppBar
  late AppbarModel appbarModel;

  void init(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
    fetchDiseaseLevels();
  }

  @override
  void dispose() {
    appbarModel.dispose();
    super.dispose();
  }

  /// 🔹 Lấy danh sách bệnh từ API
  Future<void> fetchDiseaseLevels() async {
    try {
      final diseaseService = DiseaseService();
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

  /// 🔹 Cập nhật bệnh lên API
  /// 🔹 Cập nhật bệnh lên API
  /// 🔹 Cập nhật bệnh lên API
  // 🔹 Cập nhật bệnh lên API
  Future<void> updateDisease(BuildContext context) async {
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

      int height = int.tryParse(profileData['height']?.toString() ?? '') ?? 0;
      int weight = int.tryParse(profileData['weight']?.toString() ?? '') ?? 0;
      String activityLevel = profileData['activityLevel']?.toString() ?? "";

      // 🟢 Debug log - Kiểm tra dữ liệu từ API
      print("📌 Dữ liệu allergies từ API: ${profileData['allergies']}");

      List<int> allergies = [];
      if (FFAppState().allergyIds != null) {
        if (FFAppState().allergyIds is String) {
          allergies = (FFAppState().allergyIds as String)
              .split(',')
              .map((e) => int.tryParse(e.trim()) ?? 0)
              .where((id) => id > 0)
              .toList();
        } else if (FFAppState().allergyIds is List) {
          allergies = (FFAppState().allergyIds as List)
              .whereType<int>() // Đảm bảo chỉ lấy phần tử kiểu int
              .toList();
        }
      }

// 🟢 Debug: Kiểm tra allergies lấy từ FFAppState
      print("📌 FFAppState().allergyIds sau khi xử lý: $allergies");

      // ⚡️ Kiểm tra nếu lấy từ API
      if (allergies.isEmpty && profileData['allergies'] is List) {
        allergies = (profileData['allergies'] as List<dynamic>)
            .map((e) {
              if (e is Map<String, dynamic> && e.containsKey('allergyId')) {
                print("🔹 Mapping allergy từ API: $e");
                return e['allergyId'] as int? ?? 0;
              }
              return 0;
            })
            .where((id) => id > 0)
            .toList();
      }

      // 🟢 Debug: Kiểm tra allergies sau khi xử lý
      print("📌 Allergies sau khi xử lý: $allergies");

      if (height == 0 || weight == 0) {
        showSnackbar(context, '⚠️ Không thể lấy thông tin sức khỏe.');
        return;
      }

      List<int> diseasesToSend =
          selectedDiseaseIds.isEmpty ? [] : selectedDiseaseIds;
      List<int> allergiesToSend = allergies.isEmpty ? [] : allergies;

      // 🟢 Debug log trước khi gửi API
      print("📌 selectedDiseaseIds trước khi gửi API: $selectedDiseaseIds");
      print("📌 allergies trước khi gửi API: $allergiesToSend");

      final response = await UserService().updateHealthProfile(
        height: height,
        weight: weight,
        activityLevel: activityLevel,
        aisuggestion: null,
        allergies: allergiesToSend,
        diseases: diseasesToSend,
      );

      print("🔹 Response status code: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        FFAppState().diseaseIds = diseasesToSend.toString();
        FFAppState().update(() {});
        showSnackbar(context, 'Cập nhật bệnh thành công!');
      } else {
        showSnackbar(context, 'Cập nhật thất bại: ${response.body}');
      }
    } catch (e) {
      print("❌ Lỗi xảy ra: $e");
      showSnackbar(context, 'Lỗi: $e');
    }
  }
}
