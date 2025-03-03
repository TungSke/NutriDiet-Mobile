import '../../services/user_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_profile_widget.dart' show MyProfileWidget;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfileModel extends FlutterFlowModel<MyProfileWidget> with ChangeNotifier {
  final UserService _userService = UserService();

  String name = '';
  String gender = '';
  String age = '';
  String phoneNumber = '';
  String location = '';
  String email = '';

  @override
  void initState(BuildContext context) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userService.whoAmI();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = '${data['name']}';
        gender = data['gender'];
        age = data['age'];
        phoneNumber = data['phoneNumber'];
        location = data['location'];
        email = data["email"];
        notifyListeners();
      } else {
        debugPrint('Failed to fetch user profile');
      }
    }catch (e){
      debugPrint("Lỗi khi lấy thông tin người dùng: $e");
    }
  }

  @override
  void dispose() {}
}
