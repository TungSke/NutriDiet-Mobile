import 'dart:convert';
import 'dart:io';

import 'package:diet_plan_app/components/activity_component_model.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_animations.dart';
import 'package:diet_plan_app/services/health_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Để format ngày tháng
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../flutter_flow/flutter_flow_model.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../services/user_service.dart';
import 'chart_weight_widget.dart';

class ActivityComponentWidget extends StatefulWidget {
  const ActivityComponentWidget({super.key});

  @override
  State<ActivityComponentWidget> createState() =>
      _ActivityComponentWidgetState();
}

class _ActivityComponentWidgetState extends State<ActivityComponentWidget> {
  late ActivityComponentModel _model;
  final UserService _userService = UserService();

  // Key để truy cập state bên trong WeightLineChart
  final _weightLineChartKey = GlobalKey<WeightLineChartState>();

  // Danh sách lưu lịch sử cân nặng
  List<Map<String, dynamic>> _weightHistory = [];

  // Hàm gọi trong onPressed để làm mới biểu đồ
  void _refreshChart() async {
    await _model.fetchHealthProfile();
    await _weightLineChartKey.currentState?.refresh();
    if (mounted) {
      setState(() {});
    }
  }

  final animationsMap = <String, AnimationInfo>{};

  Future<void> _uploadImage(int profileId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // Gọi API upload ảnh qua HealthService với profileId tương ứng
      final bool success = await HealthService().addImageToHealthProfile(
        profileId: profileId,
        imageFile: imageFile,
      );

      if (success) {
        // Nếu upload thành công, cập nhật lại danh sách lịch sử cân nặng
        await _fetchWeightHistory();
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi upload ảnh")),
        );
      }
    }
  }

  void _checkTodayUpdate() async {
    try {
      // Call checkTodayUpdate to see if the profile was updated today
      bool isUpdatedToday = await _model.checkTodayUpdate();

      if (isUpdatedToday) {
        // Show confirmation modal
        _showConfirmationModal();
      } else {
        // Not updated today, directly update health profile
        await _updateHealthProfile("ADD");
        await _model.fetchHealthProfile();
        if (mounted) {
          _refreshChart(); // Làm mới biểu đồ
          // Gọi lại fetchWeightHistory để cập nhật danh sách
          await _fetchWeightHistory();
        }
        Navigator.pop(context);
      }
    } catch (e) {
      print("❌ Lỗi khi kiểm tra: $e");
      // Handle errors if necessary
    }
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(
              'Bạn đã cập nhật hồ sơ sức khỏe hôm nay. Bạn vẫn muốn cập nhật không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close modal when choosing "Cancel"
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: FlutterFlowTheme.of(context).primary),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    FlutterFlowTheme.of(context).primary, // Màu chữ
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _updateHealthProfile("REPLACE");
                // Not updated today, directly update health profile

                await _model.fetchHealthProfile();
                if (mounted) {
                  _refreshChart(); // Làm mới biểu đồ
                  // Gọi lại fetchWeightHistory để cập nhật danh sách
                  await _fetchWeightHistory();
                }
              },
              child: Text('Thay thế'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    FlutterFlowTheme.of(context).primary, // Màu chữ
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _updateHealthProfile("ADD");
                await _model.fetchHealthProfile();
                if (mounted) {
                  _refreshChart(); // Làm mới biểu đồ
                  // Gọi lại fetchWeightHistory để cập nhật danh sách
                  await _fetchWeightHistory();
                }
              },
              child: Text('Thêm mới'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateHealthProfile(String profileOption) async {
    await _model.updateHealthProfile(context, profileOption);
  }

  Future<void> _deletePhoto(int profileId) async {
    bool success =
        await HealthService().deleteHealthProfileImage(profileId: profileId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa ảnh profile thành công")),
      );
      // Làm mới danh sách sau khi xóa ảnh
      await _fetchWeightHistory();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Xóa ảnh profile thất bại")),
      );
    }
  }

  Future<void> _deleteEntry(int profileId) async {
    bool success =
        await HealthService().deleteHealthProfile(profileId: profileId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa profile thành công")),
      );
      // Cập nhật lại thông tin health profile (cân nặng hiện tại)
      await _model.fetchHealthProfile();
      // Cập nhật lại danh sách lịch sử cân nặng
      await _fetchWeightHistory();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể xóa profile duy nhất")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityComponentModel());
    _model.fetchUserProfile();
    _model.fetchHealthProfile();

    // Gọi API lấy lịch sử cân nặng
    _fetchWeightHistory();

    // Thêm animation cho tiêu đề
    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.linear,
            delay: 50.ms,
            duration: 400.ms,
            begin: const Offset(0.0, -20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  // Hàm lấy dữ liệu cân nặng theo thời gian (lịch sử) từ API
  Future<void> _fetchWeightHistory() async {
    try {
      final response = await _userService.getHealthProfileReport();
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final dataList = responseData['data'] as List;
        // Lưu lại vào biến state
        setState(() {
          // Ép kiểu về List<Map<String,dynamic>>
          _weightHistory =
              dataList.map((item) => item as Map<String, dynamic>).toList();
          // Có thể sắp xếp theo thời gian giảm dần hoặc tăng dần
          _weightHistory.sort((a, b) {
            final dateA = DateTime.parse(a['date']);
            final dateB = DateTime.parse(b['date']);
            return dateB.compareTo(dateA); // Mới nhất lên đầu
          });
        });
      } else {
        throw Exception('Failed to load weight history');
      }
    } catch (e) {
      print('Error fetching weight history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 25.0, 20.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 16.0),
                    child: Text(
                      'Hoạt động',
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'figtree',
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: false,
                            lineHeight: 1.5,
                          ),
                    ).animateOnPageLoad(
                        animationsMap['textOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung chính
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Thông tin người dùng
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: _model.avatar.isNotEmpty
                            ? Image.network(
                                _model.avatar,
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/dummy_profile.png',
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text(
                              _model.name,
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "• ${_model.age} tuổi • ${_model.height} cm • ${_model.weight} kg",
                              style: GoogleFonts.roboto(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Mục tiêu
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 24.0, 20.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mục tiêu gần đây:',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _model.goalType,
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cân nặng ban đầu, mục tiêu, button cập nhật
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Cân nặng ban đầu: ",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    "${_model.weight} kg",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Cân nặng mục tiêu:",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    "${_model.targetWeight} kg",
                                    style: TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            backgroundColor: Colors.green,
                            elevation: 4.0,
                            shape: const CircleBorder(),
                            mini: true,
                            heroTag: null,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row hiển thị thông tin phần trăm hoàn thành
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Đã hoàn thành",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              Text(
                                "${_model.progressPercentage}/100 %",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  8), // Khoảng cách giữa text và progress bar
                          // Progress bar trực quan
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _model.progressPercentage /
                                  100.0, // Giá trị từ 0.0 đến 1.0
                              minHeight: 10,
                              backgroundColor: Colors.grey.shade300,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Biểu đồ
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 400,
                      child: WeightLineChart(
                        key: _weightLineChartKey,
                        refreshChart: _refreshChart,
                      ),
                    ),
                  ),
                ),

                // BMI / TDEE
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tình trạng hiện tại:",
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _model.bmiType,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getBmiTypeColor(_model.bmiType),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "BMI",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 12.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor:
                                const Color.fromRGBO(204, 129, 17, 1),
                            center: Text(
                              _model.bmi,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Figtree',
                                    color: FlutterFlowTheme.of(context).grey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                        Text("Chỉ số BMI ")
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "TDEE",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 12.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor:
                                const Color.fromARGB(255, 4, 142, 135),
                            center: Text(
                              _model.tdee,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Figtree',
                                    color: FlutterFlowTheme.of(context).grey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                        Text("Chỉ số TDEE ")
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 15),
                  child: Text(
                    (_model.evaluate),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lịch sử cân nặng:",
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (_weightHistory.isEmpty)
                        const Text('Chưa có dữ liệu.'),
                      if (_weightHistory.isNotEmpty)
                        // Dùng Column + map để hiển thị nhanh
                        Column(
                          children: _weightHistory.map((item) {
                            // Parse ngày
                            final date = DateTime.parse(item['date']);
                            // Format ngày tháng bằng tiếng Việt
                            final formattedDate =
                                DateFormat("EEEE, dd 'thg' M, yyyy", "vi_VN")
                                    .format(date);
                            final weight = item['value'];
                            final imageUrl = item['imageUrl'];

                            return GestureDetector(
                              onLongPress: () => _showEntryMenu(
                                  item), // Gọi popup khi long press
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  formattedDate,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '$weight kg',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: imageUrl != null
                                    ? GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: InteractiveViewer(
                                                  child: Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          imageUrl,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.cloud_upload),
                                        onPressed: () async {
                                          // Nếu muốn cho phép upload ngay khi bấm icon
                                          await _uploadImage(item['profileId']);
                                        },
                                      ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Thêm hàm hiển thị bottom sheet khi long press
  void _showEntryMenu(Map<String, dynamic> item) {
    // Lấy thông tin cần thiết
    final date = DateTime.parse(item['date']);
    final formattedDate =
        DateFormat("EEEE, dd 'thg' M, yyyy", "vi_VN").format(date);
    final imageUrl = item['imageUrl'];
    final profileId = item['profileId'];

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              // Hiển thị ngày của entry
              ListTile(
                title: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Nếu đã có ảnh, hiển thị nút Delete Photo, ngược lại hiển thị nút Import Photo
              if (imageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _deletePhoto(profileId);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Import Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _uploadImage(profileId);
                  },
                ),
              // Nút xóa luôn entry (profile)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Entry'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEntry(profileId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // BottomSheet cập nhật cân nặng
  void _showBottomSheet(BuildContext context) async {
    double currentWeight = _model.weight;
    double currentHeight = _model.height;

    String currentActivityLevel = _model.activityLevel;
    List<int> currentAllergies = _model.allergies;
    List<int> currentDiseases = _model.diseases;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: StatefulBuilder(
            builder: (context, setStateForBottomSheet) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Cập nhật cân nặng',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // Text(
                  //   '${currentWeight.toStringAsFixed(1)} kg',
                  //   style: const TextStyle(
                  //     fontSize: 32.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Container(
                        width:
                            30, // Set width to control the size of the button
                        height: 30,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary, // Set background color to green
                          shape: BoxShape.circle, // Circular button shape
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove,
                              color: Colors.white), // White icon
                          onPressed: () {
                            setStateForBottomSheet(() {
                              currentWeight -= 0.1;
                              currentWeight = double.parse(
                                  currentWeight.toStringAsFixed(1));
                            });
                          },
                          iconSize: 20, // Smaller icon size
                          padding:
                              EdgeInsets.zero, // Remove any default padding
                        ),
                      ),
                      Text(
                        '${currentWeight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width:
                            30, // Set width to control the size of the button
                        height: 30,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary, // Set background color to green
                          shape: BoxShape.circle, // Circular button shape
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add,
                              color: Colors.white), // White icon
                          onPressed: () {
                            setStateForBottomSheet(() {
                              currentWeight += 0.1;
                              currentWeight = double.parse(
                                  currentWeight.toStringAsFixed(1));
                            });
                          },
                          iconSize: 20, // Smaller icon size
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.add),
                      //   onPressed: () {
                      //     setStateForBottomSheet(() {
                      //       currentWeight += 0.1;
                      //       currentWeight =
                      //           double.parse(currentWeight.toStringAsFixed(1));
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        _model.weight = currentWeight;

                        _checkTodayUpdate();
                        // await _model.fetchHealthProfile();
                        // if (mounted) {
                        //   _refreshChart(); // Làm mới biểu đồ
                        //   // Gọi lại fetchWeightHistory để cập nhật danh sách
                        //   await _fetchWeightHistory();
                        // }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: FlutterFlowTheme.of(context)
                            .primary, // Text color (white)
                      ),
                      child: const Text(
                        'Lưu',
                      ))
                ],
              );
            },
          ),
        );
      },
    );
  }
}

Color _getBmiTypeColor(String bmiType) {
  switch (bmiType) {
    case 'Gầy':
      return Colors.blue; // Màu xanh dương cho Gầy
    case 'Bình thường':
      return Colors.green; // Màu xanh lá cho Bình thường
    case 'Thừa cân':
      return Colors.orange.shade300; // Màu vàng cho Thừa cân
    case 'Béo phì độ 1':
      return Colors.orange.shade500; // Màu cam nhạt cho Béo phì độ 1
    case 'Béo phì độ 2':
      return Colors.orange.shade900; // Màu cam đậm cho Béo phì độ 2
    case 'Béo phì độ 3':
      return Colors.red; // Màu đỏ cho Béo phì độ 3
    default:
      return Colors.black; // Nếu không xác định được, mặc định màu đen
  }
}

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    ),
    backgroundColor: Colors.green, // Set background color to green
    duration: Duration(seconds: 2), // Duration for the snackbar to be visible
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
