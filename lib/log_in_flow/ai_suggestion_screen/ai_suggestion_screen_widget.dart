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
  String selectedCategory = "DinhDuong";
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AiSuggestionScreenModel());
    _fetchData(); // Gọi hàm fetch dữ liệu khi màn hình được mở
  }

  final Map<String, String> categoryNames = {

    'DinhDuong': 'Dinh dưỡng',
    'LuyenTap': 'Luyện tập',
    'LoiSong': 'Lối sống',
  };
  List<AiSuggestion> filteredSuggestions = [];
  Future<void> _fetchData() async {
    await _model.fetchHealthProfile(); // Lấy dữ liệu từ API
    setState(() {
      isLoading = false;
      // Lọc aisuggestions dựa trên selectedCategory
      if (selectedCategory == 'DinhDuong') {
        // Hiển thị chỉ những suggestion có type = 'All'
        filteredSuggestions = _model.aisuggestions
            .where((suggestion) => suggestion.type == 'DinhDuong')
            .toList();
      } else {
        // Hiển thị những suggestion có type tương ứng với selectedCategory
        filteredSuggestions = _model.aisuggestions
            .where((suggestion) => suggestion.type == selectedCategory)
            .toList();
      }
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
              child: CircularProgressIndicator(),
            ) // Hiển thị loading nếu đang fetch
          : Stack(
              children: [
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
                          Padding(
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
                                    top: 70,
                                  ),
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
                                                Column(
                                                  children: [
                                                    Text("Lời khuyên AI",
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
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8, top: 15),
                                            child: Column(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primary, // Màu nền xanh
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Bo góc cho dropdown
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      value: selectedCategory,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          selectedCategory =
                                                              newValue!; // Lưu giá trị category đã chọn
                                                        });
                                                        _fetchData(); // Fetch lại dữ liệu khi category thay đổi
                                                      },
                                                      items: <String>[

                                                        'DinhDuong',
                                                        'LuyenTap',
                                                        'LoiSong'
                                                      ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                        (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                categoryNames[
                                                                        value] ??
                                                                    value,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                      dropdownColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      iconEnabledColor:
                                                          Colors.white,
                                                      iconSize: 24,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
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
                                            child: ListView.builder(
                                              itemCount: filteredSuggestions
                                                  .length, // Sử dụng filteredSuggestions để hiển thị
                                              itemBuilder: (context, index) {
                                                final suggestion =
                                                    filteredSuggestions[index];

                                                // Định dạng 'createdAt' trực tiếp ở đây
                                                // Định dạng 'createdAt' trực tiếp ở đây
                                                String formattedDate =
                                                    DateFormat(
                                                            'HH:mm dd/MM/yyyy')
                                                        .format(
                                                  DateTime.parse(
                                                      suggestion.createdAt),
                                                );
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Lời khuyên:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "Tạo lúc:$formattedDate",
                                                        style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary),
                                                      ),
                                                      MarkdownBody(
                                                        data:
                                                            suggestion.content,
                                                        styleSheet:
                                                            MarkdownStyleSheet(
                                                          p: const TextStyle(
                                                              fontSize: 16),
                                                          strong:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      // Text(suggestion.content),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                      Text(
                                          "Nếu bạn cảm thấy chưa phù hợp, hãy tạo lại! "),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          setState(() {
                                            isCreating =
                                                true; // Đánh dấu là đang tạo lại
                                          });

                                          // Gọi API để tạo lại lời khuyên AI dựa trên category đã chọn
                                          await _model.createAiSuggestion(
                                              selectedCategory);
                                          // Gọi lại _fetchData để tải lại dữ liệu và lọc lại danh sách
                                          await _fetchData();

                                          setState(() {
                                            isCreating =
                                                false; // Đánh dấu là đã hoàn thành việc tạo lại
                                          });
                                        },
                                        text: isCreating
                                            ? 'Đang tạo lại...'
                                            : 'Tạo lại',
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
                                        onPressed: () => context
                                            .pushNamed('bottom_navbar_screen'),
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
                        // <-- trả về màn trước
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
