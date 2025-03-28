import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/Ingredient_avoid_screen/ingredient_avoid_screen_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IngredientAvoidScreenModel());
    _fetchData(); // Gọi hàm fetch dữ liệu khi màn hình được mở
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
                    CircularProgressIndicator()) // Hiển thị loading nếu đang fetch
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
                                padding: const EdgeInsets.all(8.0),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Image.asset(
                                        'assets/images/app_launcher_icon.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text("Các nguyên liệu cần tránh !",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold)),
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
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
                                          ]),
                                        ),
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
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
                                          ]),
                                        ),
                                      ],
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
                                                        "Lời khuyên dinh dưỡng",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    Text(
                                                        "Tạo lời khuyên dựa vào bệnh dị ứng để giúp bạn cải thiện bệnh"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 500,
                                            height: 200,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Tránh ăn:"),
                                                  ..._model.allergies
                                                      .map((allergy) {
                                                    if (allergy.contains(':')) {
                                                      String ingredients =
                                                          allergy.split(':')[1];
                                                      if (ingredients
                                                          .isNotEmpty) {
                                                        return Text(
                                                            "• $ingredients");
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
                                                        return Text(
                                                            "• $ingredients");
                                                      }
                                                    }
                                                    return SizedBox();
                                                  }).toList(),
                                                ],
                                              ),
                                            ),
                                          ),
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
                ],
              ));
  }
}
