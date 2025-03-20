import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class EditProfileScreenModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool canUpdateProfile() {
    return name.trim().isNotEmpty ||
        location.trim().isNotEmpty ||
        gender.trim().isNotEmpty ||
        age.trim().isNotEmpty;
  }

  final Map<String, String> _genderMap = {
    'Nam': 'Male',
    'Nữ': 'Female',
  };

  // Mảng ánh xạ giá trị số về giá trị mô tả
  final Map<String, String> _reverseGenderMap = {
    'Male': 'Nam',
    'Female': 'Nữ',
  };

  // User profile fields
  String name = '';
  String avatar = '';
  String gender = '';
  String age = '';
  String location = ''; // ✅ Correct field for updating
  String address = ''; // ✅ Correct field for fetching

  bool isLoading = true;

  EditProfileScreenModel() {
    fetchUserProfile();
  }

  /// 🟢 Fetch user profile (uses `address`)
  Future<void> fetchUserProfile() async {
    try {
      print("🔄 Fetching user profile...");
      final response = await UserService().whoAmI();

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        name = userData['name'] ?? "Chưa cập nhật";
        gender = _reverseGenderMap[userData['gender']] ?? "Not specified";
        age = userData['age']?.toString() ?? "0";
        address = userData['address'] ?? "Chưa cập nhật"; // ✅ Uses 'address'
        location = address; // ✅ Sync 'location' with 'address'
        avatar = avatar;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Error fetching user profile: $e");
    }
  }

  /// 🟢 Update user profile (uses `location`)
  Future<void> updateUserProfile() async {
    try {
      print("🔄 Updating profile...");
      final genderInEnglish = _genderMap[gender] ?? 'Male';

      // ✅ Ensure `location` isn't empty
      String updatedLocation =
          location.trim().isEmpty ? "Chưa cập nhật" : location;

      final response = await UserService().updateUser(
        fullName: name,
        age: int.tryParse(age) ?? 0,
        gender: genderInEnglish,
        avatar: avatar,
        location: updatedLocation, // ✅ Uses 'location' for update
      );

      if (response.statusCode == 200) {
        print('✅ Update successful!');

        // ✅ Fetch updated profile to keep data consistent
        await fetchUserProfile();
      } else {
        print('❌ Update failed: ${response.body}');
      }
    } catch (e) {
      print("❌ Error updating profile: $e");
    }
  }
}
