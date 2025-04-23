// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// import '../../services/allergy_service.dart';
// import '../../services/disease_service.dart';
// import '../../services/user_service.dart';
//
// class EditHealthProfileScreenModel extends ChangeNotifier {
//   final _userService = UserService();
//   String name = '';
//   String age = '';
//   String phoneNumber = '';
//   String location = '';
//   String email = '';
//
//   int height = 0; // Chiều cao
//   int weight = 0; // Cân nặng
//   String activityLevel = ''; // Mức độ vận động
//   List<String> allergies = []; // ✅ Dị ứng
//   List<String> diseases = [];
//   bool isLoading = true;
//   List<int> selectedAllergyIds = []; // Danh sách các dị ứng đã chọn
//   List<int> selectedDiseaseIds = [];
//   String userId = '';
//   String errorMessage = "";
//
//   final Map<String, String> _activityLevelMap = {
//     'Ít vận động': 'Sedentary',
//     'Vận động nhẹ': 'LightlyActive',
//     'Vận động vừa phải': 'ModeratelyActive',
//     'Vận động nhiều': 'VeryActive',
//     'Cường độ rất cao': 'ExtraActive',
//   };
//
//   final Map<String, String> _reverseActivityLevelMap = {
//     'Sedentary': 'Ít vận động',
//     'LightlyActive': 'Vận động nhẹ',
//     'ModeratelyActive': 'Vận động vừa phải',
//     'VeryActive': 'Vận động nhiều',
//     'ExtraActive': 'Cường độ rất cao',
//   };
//
//   Future<void> fetchUserProfile() async {
//     try {
//       final response = await _userService.whoAmI();
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         name = data['name'] ?? "Chưa cập nhật";
//         age = data['age']?.toString() ?? "0";
//         phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
//         location = data['address'] ?? "Chưa cập nhật";
//         email = data["email"] ?? "Chưa cập nhật";
//         userId = data['id']?.toString() ?? "";
//
//         isLoading = false; // Đặt trạng thái không còn loading
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> fetchHealthProfile() async {
//     try {
//       final response = await _userService.getHealthProfile();
//
//       if (response.statusCode == 200) {
//         final healthData = jsonDecode(response.body);
//
//         // Parse height and weight as integers with null check
//         height = healthData['data']['height'] != null
//             ? int.parse(healthData['data']['height'].toString())
//             : 0;
//         weight = healthData['data']['weight'] != null
//             ? int.parse(healthData['data']['weight'].toString())
//             : 0;
//
//         activityLevel =
//             _reverseActivityLevelMap[healthData['data']['activityLevel']] ??
//                 "Chưa cập nhật";
//
//         // Cập nhật tên dị ứng
//         allergies = healthData['data']["allergies"] != null
//             ? (healthData['data']["allergies"] as List)
//                 .map((allergy) => allergy["allergyName"].toString())
//                 .toList()
//             : [];
//
//         selectedAllergyIds = healthData['data']["allergies"] != null
//             ? (healthData['data']["allergies"] as List)
//                 .map((allergy) => int.parse(allergy["allergyId"].toString()))
//                 .toList()
//             : [];
//
//         diseases = healthData['data']["diseases"] != null
//             ? (healthData['data']["diseases"] as List)
//                 .map((disease) => disease["diseaseName"].toString())
//                 .toList()
//             : [];
//
//         selectedDiseaseIds = healthData['data']["diseases"] != null
//             ? (healthData['data']["diseases"] as List)
//                 .map((disease) => int.parse(disease["diseaseId"].toString()))
//                 .toList()
//             : [];
//
//         isLoading = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   List<Map<String, dynamic>> allergyLevelsData =
//       []; // Danh sách các dị ứng từ API
//   List<Map<String, dynamic>> diseaseLevelsData =
//       []; // Danh sách các dị ứng từ API
//
// // Hàm lấy danh sách dị ứng từ API
//   Future<void> fetchAllergyLevelsData() async {
//     try {
//       final allergyService = AllergyService();
//       final response = await allergyService.fetchAllergyLevelsData();
//       allergyLevelsData = response; // Cập nhật dữ liệu dị ứng
//       notifyListeners(); // Cập nhật UI sau khi có dữ liệu
//     } catch (e) {
//       print("❌ Lỗi khi lấy dữ liệu dị ứng: $e");
//     }
//   }
//
//   Future<void> fetchDiseaseLevelsData() async {
//     try {
//       final diseaseService = DiseaseService();
//       final response = await diseaseService.fetchDiseaseLevelsData();
//       diseaseLevelsData = response; // Cập nhật dữ liệu dị ứng
//       notifyListeners(); // Cập nhật UI sau khi có dữ liệu
//     } catch (e) {
//       print("❌ Lỗi khi lấy dữ liệu dị ứng: $e");
//     }
//   }
//
//   Future<void> updateHealthProfile(BuildContext context) async {
//     try {
//       // Nếu không có dị ứng được chọn, vẫn tiếp tục cập nhật mà không gửi danh sách dị ứng
//       final activityLevelInEnglish =
//           _activityLevelMap[activityLevel] ?? 'Sedentary';
//
//       final response = await _userService.updateHealthProfile(
//         activityLevel: activityLevelInEnglish,
//         weight: weight,
//         height: height,
//         allergies: selectedAllergyIds.isEmpty
//             ? []
//             : selectedAllergyIds, // Nếu không có dị ứng thì gửi danh sách trống
//         diseases: selectedDiseaseIds.isEmpty ? [] : selectedDiseaseIds,
//       );
//
//       if (response.statusCode == 200) {
//         print('✅ Cập nhật thành công!');
//         await fetchHealthProfile(); // Fetch updated data
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Cập nhật thành công!')),
//         );
//         Navigator.pop(context, true);
//       } else {
//         final responseData = jsonDecode(response.body);
//         final errorMessage = responseData['message'] ?? 'Cập nhật thất bại';
//         print('❌ Lỗi: $errorMessage');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     } catch (e) {
//       print("❌ Lỗi khi cập nhật hồ sơ sức khỏe: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại.')),
//       );
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/allergy_service.dart';
import '../../services/disease_service.dart';
import '../../services/user_service.dart';

class EditHealthProfileScreenModel extends ChangeNotifier {
  final _userService = UserService();
  String name = '';
  String age = '';
  String phoneNumber = '';
  String location = '';
  String email = '';
  String avatar = '';
  double height = 0.0; // Chiều cao, đổi sang double
  double weight = 0.0; // Cân nặng, đổi sang double
  String activityLevel = ''; // Mức độ vận động
  String dietStyle = '';
  String aisuggestion = '';
  String profileOption = '';
  List<String> allergies = []; // ✅ Dị ứng
  List<String> diseases = [];
  bool isLoading = true;
  List<int> selectedAllergyIds = []; // Danh sách các dị ứng đã chọn
  List<int> selectedDiseaseIds = [];
  String userId = '';
  String errorMessage = "";
  bool isAllergySelectionValid() {
    return selectedAllergyIds.length <= 5;
  }

  bool isDiseaseSelectionValid() {
    return selectedAllergyIds.length <= 10;
  }

  final Map<String, String> _activityLevelMap = {
    'Ít vận động': 'Sedentary',
    'Vận động nhẹ': 'LightlyActive',
    'Vận động vừa phải': 'ModeratelyActive',
    'Vận động nhiều': 'VeryActive',
    'Cường độ rất cao': 'ExtraActive',
  };
  final Map<String, String> _dietStyleMap = {
    'Nhiều Carb, giảm Protein': 'HighCarbLowProtein',
    'Nhiều Protein, giảm Carb': 'HighProteinLowCarb',
    'Ăn chay': 'Vegetarian',
    'Thuần chay': 'Vegan',
    'Cân bằng': 'Balanced',
  };
  final Map<String, String> _reverseDietStyleMap = {
    'HighCarbLowProtein': 'Nhiều Carb, giảm Protein',
    'HighProteinLowCarb': 'Nhiều Protein, giảm Carb',
    'Vegetarian': 'Ăn chay',
    'Vegan': 'Thuần chay',
    'Balanced': 'Cân bằng',
  };

  final Map<String, String> _reverseActivityLevelMap = {
    'Sedentary': 'Ít vận động',
    'LightlyActive': 'Vận động nhẹ',
    'ModeratelyActive': 'Vận động vừa phải',
    'VeryActive': 'Vận động nhiều',
    'ExtraActive': 'Cường độ rất cao',
  };

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        name = data['name'] ?? "Chưa cập nhật";
        age = data['age']?.toString() ?? "0";
        phoneNumber = data['phoneNumber'] ?? "Chưa cập nhật";
        location = data['address'] ?? "Chưa cập nhật";
        email = data["email"] ?? "Chưa cập nhật";
        userId = data['id']?.toString() ?? "";
        avatar = data['avatar'];
        isLoading = false; // Đặt trạng thái không còn loading
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin mục tiêu cá nhân: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHealthProfile() async {
    try {
      final response = await _userService.getHealthProfile();

      if (response.statusCode == 200) {
        final healthData = jsonDecode(response.body);

        // Kiểm tra nếu dữ liệu trả về là null hoặc không có trường 'data'
        if (healthData == null || healthData['data'] == null) {
          print("❌ Dữ liệu trả về là null hoặc không hợp lệ.");
          isLoading = false;
          notifyListeners();
          return;
        }

        // Giải mã và xử lý dữ liệu nếu hợp lệ
        height = healthData['data']['height'] != null
            ? double.tryParse(healthData['data']['height'].toString()) ?? 0.0
            : 0.0;
        weight = healthData['data']['weight'] != null
            ? double.tryParse(healthData['data']['weight'].toString()) ?? 0.0
            : 0.0;
        aisuggestion = healthData['data']['aisuggestion'] ?? "Chưa cập nhật";
        activityLevel =
            _reverseActivityLevelMap[healthData['data']['activityLevel']] ??
                "Chưa cập nhật";
        dietStyle = _reverseDietStyleMap[healthData['data']['dietStyle']] ??
            "Chưa cập nhật";

        allergies = healthData['data']["allergies"] != null
            ? (healthData['data']["allergies"] as List)
                .map((allergy) => allergy["allergyName"].toString())
                .toList()
            : [];
        selectedAllergyIds = healthData['data']["allergies"] != null
            ? (healthData['data']["allergies"] as List)
                .map((allergy) => int.parse(allergy["allergyId"].toString()))
                .toList()
            : [];

        diseases = healthData['data']["diseases"] != null
            ? (healthData['data']["diseases"] as List)
                .map((disease) => disease["diseaseName"].toString())
                .toList()
            : [];
        selectedDiseaseIds = healthData['data']["diseases"] != null
            ? (healthData['data']["diseases"] as List)
                .map((disease) => int.parse(disease["diseaseId"].toString()))
                .toList()
            : [];

        isLoading = false;
        notifyListeners();
      } else {
        print("❌ Lỗi khi lấy hồ sơ sức khỏe, mã lỗi: ${response.statusCode}");
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin sức khỏe: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> allergyLevelsData =
      []; // Danh sách các dị ứng từ API
  List<Map<String, dynamic>> diseaseLevelsData =
      []; // Danh sách các dị ứng từ API

// Hàm lấy danh sách dị ứng từ API
  Future<void> fetchAllergyLevelsData() async {
    try {
      final allergyService = AllergyService();
      final response = await allergyService.fetchAllergyLevelsData();
      allergyLevelsData = response; // Cập nhật dữ liệu dị ứng
      notifyListeners(); // Cập nhật UI sau khi có dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu dị ứng: $e");
    }
  }

  Future<void> fetchDiseaseLevelsData() async {
    try {
      final diseaseService = DiseaseService();
      final response = await diseaseService.fetchDiseaseLevelsData();
      diseaseLevelsData = response; // Cập nhật dữ liệu dị ứng
      notifyListeners(); // Cập nhật UI sau khi có dữ liệu
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu dị ứng: $e");
    }
  }

  Future<bool> checkTodayUpdate() async {
    try {
      final response = await _userService.getTodayCheck(); // Call API

      if (response.statusCode == 200) {
        // Directly parse the response body as a boolean
        final bool isUpdatedToday = jsonDecode(response.body);

        return isUpdatedToday ??
            false; // If the response is true, return true, else return false
      } else {
        throw Exception("Lỗi khi lấy kiểm tra hôm nay");
      }
    } catch (e) {
      print("❌ Lỗi khi kiểm tra: $e");
      return false; // Return false if there's an error
    }
  }

  Future<void> updateHealthProfile(
      BuildContext context, String profileOption) async {
    try {
      // Nếu không có dị ứng được chọn, vẫn tiếp tục cập nhật mà không gửi danh sách dị ứng
      final activityLevelInEnglish =
          _activityLevelMap[activityLevel] ?? 'Sedentary';
      final dietStyleInEnglish = _dietStyleMap[dietStyle] ?? 'Balanced';

      final response = await _userService.updateHealthProfile(
          activityLevel: activityLevelInEnglish,
          dietStyle: dietStyleInEnglish,
          profileOption: profileOption,
          weight: weight, // Cập nhật cân nặng kiểu double
          height: height, // Cập nhật chiều cao kiểu double
          allergies: selectedAllergyIds.isEmpty
              ? []
              : selectedAllergyIds, // Nếu không có dị ứng thì gửi danh sách trống
          diseases: selectedDiseaseIds.isEmpty ? [] : selectedDiseaseIds,
          aisuggestion: aisuggestion);

      if (response.statusCode == 200) {
        print('✅ Cập nhật thành công!');
        await fetchHealthProfile(); // Fetch updated data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thành công!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green, // Nền xanh
          ),
        );
        Navigator.pop(context, true);
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'] ?? 'Cập nhật thất bại';
        print('❌ Lỗi: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red, // Nền đỏ
          ),
        );
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật hồ sơ sức khỏe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại.')),
      );
    }
  }
}
