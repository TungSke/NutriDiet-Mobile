import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/log_in_flow/ai_suggestion_screen/ai_suggestion_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class AiSuggestionScreenWidget extends StatefulWidget {
  const AiSuggestionScreenWidget({super.key});

  @override
  State<AiSuggestionScreenWidget> createState() =>
      _AiSuggestionScreenWidgetState();
}

class _AiSuggestionScreenWidgetState extends State<AiSuggestionScreenWidget> {
  late AiSuggestionScreenModel _model;
  bool isLoading = true; // Biến để theo dõi trạng thái loading của trang
  bool isCreating =
      false; // Biến để theo dõi trạng thái loading của nút "Tạo lại"

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AiSuggestionScreenModel());
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
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white),
                                    child: Image.asset(
                                      'assets/images/app_launcher_icon.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("Lời khuyên AI !",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
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
                                                'assets/images/ai.png',
                                                width: 200,
                                                height: 200,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Lời khuyên AI",
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      "Tạo lời khuyên dựa vào bệnh dị ứng để giúp bạn cải thiện bệnh"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 500,
                                          height: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Lời khuyên:",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                      // child:
                                                      //   Text(
                                                      //       _model.aisuggestion),
                                                      // ),
                                                      child: MarkdownBody(
                                                    data: _model.aisuggestion,
                                                    styleSheet:
                                                        MarkdownStyleSheet(
                                                      p: const TextStyle(
                                                          fontSize: 16),
                                                      // Bạn có thể tuỳ chỉnh màu, kích cỡ chữ, v.v. cho từng phần
                                                      strong: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      // Đặt style cho bullet points, headings, links, v.v. nếu cần
                                                    ),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                            "Nếu bạn cảm thấy chưa phù hợp, hãy tạo lại! "),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            setState(() {
                                              isCreating =
                                                  true; // Hiển thị loading cho nút "Tạo lại"
                                            });

                                            // Gọi hàm tạo lời khuyên AI mới
                                            await _model.createAiSuggestion();

                                            // Sau khi tạo xong, fetch lại dữ liệu
                                            await _model.fetchHealthProfile();

                                            setState(() {
                                              isCreating =
                                                  false; // Tắt trạng thái loading cho nút "Tạo lại"
                                            });
                                          },
                                          text: isCreating
                                              ? 'Đang tạo lại...'
                                              : 'Tạo lại', // Thay đổi text của nút
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 54.0,
                                            color: Colors.red,
                                            textStyle: GoogleFonts.roboto(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () => context.pushNamed(
                                              'bottom_navbar_screen'),
                                          text: 'Tiếp tục',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 54.0,
                                            color: FlutterFlowTheme.of(context)
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
                        onTap: () =>
                            Navigator.of(context).pop(), // <-- trả về màn trước
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.close, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
