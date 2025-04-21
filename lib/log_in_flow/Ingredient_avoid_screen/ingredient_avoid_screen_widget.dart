import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/Ingredient_avoid_screen/ingredient_avoid_screen_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../buy_premium_package_screen/buy_premium_package_screen_widget.dart';

class IngredientAvoidScreenWidget extends StatefulWidget {
  const IngredientAvoidScreenWidget({super.key});

  @override
  State<IngredientAvoidScreenWidget> createState() =>
      _IngredientAvoidScreenWidgetState();
}

class _IngredientAvoidScreenWidgetState
    extends State<IngredientAvoidScreenWidget> {
  late IngredientAvoidScreenModel _model;
  bool isLoading = true; // Biến để theo dõi trạng thái loading
  bool isCreating = false;
  bool isPremium = false;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IngredientAvoidScreenModel());
    _fetchData(); // Gọi hàm fetch dữ liệu khi màn hình được mở
    _checkPremiumStatus();
  }

  // Hàm fetch dữ liệu
  Future<void> _fetchData() async {
    await _model.fetchHealthProfile();
    setState(() {
      isLoading = false; // Cập nhật trạng thái khi dữ liệu đã được tải
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Hiển thị loading nếu đang fetch
              )
            : Stack(
                children: [
                  // Hình ảnh package.png phóng to khi cuộn (Lớp dưới cùng)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/images/package.png", // Set your image here
                      height: 200, // Initial height of the image
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 800, // Nội dung dưới hình ảnh
                              color: Colors.white.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 50, left: 8, right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 20,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        'assets/images/app_launcher_icon.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Các nguyên liệu cần tránh !",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Vì bạn đang: ",
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _model.allergies
                                                      .map((allergy) {
                                                    String allergyName =
                                                        allergy.split(':')[0];
                                                    return "$allergyName";
                                                  }).join(', '),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Và mắc: ",
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _model.diseases
                                                      .map((disease) {
                                                    String diseaseName =
                                                        disease.split(':')[0];
                                                    return "$diseaseName";
                                                  }).join(', '),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24,
                                          right: 24,
                                          top: 36,
                                          bottom: 20),
                                      child: Column(
                                        spacing: 20,
                                        children: [
                                          Row(
                                            spacing: 10,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/healsuggestion.png',
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Nguyên liệu cần tránh ",
                                                      style: GoogleFonts.roboto(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Tạo nguyên liệu cần tránh dựa vào bệnh dị ứng để giúp bạn cải thiện bệnh",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Container(
                                            width: double
                                                .infinity, // Đảm bảo container không bị giới hạn chiều rộng
                                            height: 200,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Tránh ăn:"),
                                                  // Hiển thị từng nguyên liệu cần tránh với dấu gạch đầu dòng
                                                  ..._model.allergies
                                                      .map((allergy) {
                                                    if (allergy.contains(':')) {
                                                      String ingredients =
                                                          allergy.split(':')[1];
                                                      if (ingredients
                                                          .isNotEmpty) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .close_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 20),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                // Sử dụng Expanded để tránh tràn ngang
                                                                child: Text(
                                                                  "$ingredients",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    }
                                                    return SizedBox();
                                                  }).toList(),
                                                  ..._model.diseases
                                                      .map((disease) {
                                                    if (disease.contains(':')) {
                                                      String ingredients =
                                                          disease.split(':')[1];
                                                      if (ingredients
                                                          .isNotEmpty) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .close_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 20),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                // Sử dụng Expanded để tránh tràn ngang
                                                                child: Text(
                                                                  "$ingredients",
                                                                  // Đảm bảo không tràn
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    }
                                                    return SizedBox();
                                                  }).toList(),
                                                ],
                                              )),
                                            ),
                                          ),

                                          // FFButonWidget(
                                          //   onPressed: () async {
                                          //     if (!isPremium) {
                                          //       await _showPremiumRequiredDialog();
                                          //       return;
                                          //     }
                                          //
                                          //     setState(() {
                                          //       isCreating = true; // Hiển thị trạng thái loading cho nút
                                          //     });
                                          //
                                          //     await _model.createAiSuggestion(); // Gọi hàm tạo lời khuyên AI
                                          //     await _model.fetchHealthProfile(); // Cập nhật lại dữ liệu sau khi tạo
                                          //
                                          //     setState(() {
                                          //       isCreating = false; // Tắt trạng thái loading
                                          //     });
                                          //
                                          //     context.pushNamed('ai_suggestion_screen'); // Điều hướng sau khi tạo xong
                                          //   },
                                          //   text: isCreating ?
                                          //   'Đang tạo lại...' : 'Tạo lời khuyên AI',
                                          //   options: FFButtonOptions(
                                          //     width: double.infinity,
                                          //     height: 54.0,
                                          //     color: isPremium ? Colors.red : Colors.grey,
                                          //     textStyle: GoogleFonts.roboto(
                                          //       fontSize: 18.0,
                                          //       color: Colors.white,
                                          //       fontWeight: FontWeight.bold,
                                          //     ),
                                          //     borderRadius: BorderRadius.circular(16.0),
                                          //   ),
                                          // ),
                                          FFButtonWidget(
                                            onPressed: () => context.pushNamed(
                                                'bottom_navbar_screen'),
                                            text: 'Tiếp tục',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 54.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle: GoogleFonts.roboto(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: ClipOval(
                      child: Material(
                        color: Colors.white.withOpacity(0.7), // nền tròn mờ
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Future<void> _checkPremiumStatus() async {
    final premiumStatus = await _model.checkPremiumStatus();
    if (mounted) {
      setState(() {
        isPremium = premiumStatus;
      });
    }
  }

  // Hàm hiển thị dialog "Yêu cầu Premium"
  Future<void> _showPremiumRequiredDialog() async {
    final proceedToPremium = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Yêu cầu Premium',
                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Để sử dụng tính năng "Tạo lời khuyên AI", bạn cần nâng cấp lên tài khoản Premium.\nThưởng thức các tính năng độc quyền ngay hôm nay!',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (proceedToPremium == true && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyPremiumPackageScreenWidget(),
        ),
      );
      // Kiểm tra lại trạng thái premium sau khi quay lại
      await _model.checkPremiumStatus();
      setState(() {}); // Cập nhật giao diện nếu cần
    }
  }
}
