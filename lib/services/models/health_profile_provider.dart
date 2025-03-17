// import 'package:flutter/material.dart';
//
// class HealthProfileProvider extends ChangeNotifier {
//   int? height;
//   int? weight;
//   String? activityLevel;
//   String aisuggestion = "string"; // ✅ Giá trị mặc định
//
//   List<int> allergies = []; // List để chứa các dị ứng
//   List<int> diseases = []; // List để chứa các bệnh lý
//
//   // Cập nhật chiều cao (height)
//   void setHeight(int value) {
//     height = value;
//     notifyListeners();
//   }
//
//   // Cập nhật cân nặng (weight)
//   void setWeight(int value) {
//     weight = value;
//     notifyListeners();
//   }
//
//   // Cập nhật mức độ hoạt động (activityLevel)
//   void setActivityLevel(String value) {
//     activityLevel = value;
//     notifyListeners();
//   }
//
//   // Cập nhật đề xuất AI (aisuggestion)
//   void setAisuggestion(String value) {
//     aisuggestion = value;
//     notifyListeners();
//   }
//
//   // Cập nhật danh sách dị ứng (allergies)
//   void setAllergies(List<int> value) {
//     allergies = value;
//     notifyListeners();
//   }
//
//   // Cập nhật danh sách bệnh lý (diseases) - Ensure it's List<int>
//   void setDiseases(List<int> value) {
//     diseases = value;
//     notifyListeners();
//   }
//
//   // Kiểm tra xem thông tin đã đầy đủ chưa
//   bool isComplete() {
//     return height != null && weight != null && activityLevel != null;
//   }
//
//   // Chuyển đổi thông tin profile thành một Map
//   Map<String, dynamic> toJson() {
//     return {
//       'Height': height,
//       'Weight': weight,
//       'ActivityLevel': activityLevel,
//       'Aisuggestion': aisuggestion,
//       'Allergies': allergies,
//       'Diseases': diseases,
//     };
//   }
// }
import 'package:flutter/material.dart';

class HealthProfileProvider extends ChangeNotifier {
  double? height; // Đổi từ int? thành double?
  double? weight; // Đổi từ int? thành double?
  String? activityLevel;
  String aisuggestion = "string"; // ✅ Giá trị mặc định

  List<int> allergies = []; // List để chứa các dị ứng
  List<int> diseases = []; // List để chứa các bệnh lý

  // Cập nhật chiều cao (height)
  void setHeight(double value) {
    // Cập nhật kiểu dữ liệu là double
    height = value;
    notifyListeners();
  }

  // Cập nhật cân nặng (weight)
  void setWeight(double value) {
    // Cập nhật kiểu dữ liệu là double
    weight = value;
    notifyListeners();
  }

  // Cập nhật mức độ hoạt động (activityLevel)
  void setActivityLevel(String value) {
    activityLevel = value;
    notifyListeners();
  }

  // Cập nhật đề xuất AI (aisuggestion)
  void setAisuggestion(String value) {
    aisuggestion = value;
    notifyListeners();
  }

  // Cập nhật danh sách dị ứng (allergies)
  void setAllergies(List<int> value) {
    allergies = value;
    notifyListeners();
  }

  // Cập nhật danh sách bệnh lý (diseases) - Ensure it's List<int>
  void setDiseases(List<int> value) {
    diseases = value;
    notifyListeners();
  }

  // Kiểm tra xem thông tin đã đầy đủ chưa
  bool isComplete() {
    return height != null && weight != null && activityLevel != null;
  }

  // Chuyển đổi thông tin profile thành một Map
  Map<String, dynamic> toJson() {
    return {
      'Height': height,
      'Weight': weight,
      'ActivityLevel': activityLevel,
      'Aisuggestion': aisuggestion,
      'Allergies': allergies,
      'Diseases': diseases,
    };
  }
}
