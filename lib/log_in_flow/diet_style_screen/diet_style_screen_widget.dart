import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'diet_style_screen_model.dart';

export 'diet_style_screen_model.dart';

class DietStyleScreenWidget extends StatefulWidget {
  const DietStyleScreenWidget({super.key});

  @override
  State<DietStyleScreenWidget> createState() => _DietStyleScreenWidgetState();
}

final List<Map<String, String>> dietStyles = [
  {
    'title': 'Nhiều Carb, giảm Protein',
    'description':
        'Mô tả: Chế độ ăn này tập trung vào việc cung cấp năng lượng chủ yếu từ các nguồn tinh bột như gạo, bánh mì, khoai tây, thay vì từ các nguồn protein. Đây là một lựa chọn phù hợp cho những ai muốn tăng cường năng lượng nhanh chóng mà không quá chú trọng đến việc bổ sung nhiều protein.',
    'image': 'assets/images/46.png'
  },
  {
    'title': 'Nhiều Protein, giảm Carb',
    'description':
        'Mô tả: Chế độ ăn này ưu tiên nguồn protein dồi dào từ các thực phẩm như thịt, cá, trứng, và các sản phẩm từ sữa. Đồng thời hạn chế việc tiêu thụ carbohydrate (tinh bột). Phù hợp cho những ai muốn xây dựng cơ bắp, giảm mỡ và duy trì cảm giác no lâu mà không cần quá nhiều carbs.',
    'image': 'assets/images/47.png'
  },
  {
    'title': 'Ăn chay',
    'description':
        'Mô tả: Chế độ ăn chay loại bỏ thịt và cá khỏi khẩu phần ăn nhưng vẫn cho phép tiêu thụ các sản phẩm từ sữa, trứng hoặc mật ong. Đây là một lựa chọn cho những ai muốn giảm thiểu việc sử dụng thực phẩm động vật mà vẫn bổ sung đủ protein từ các nguồn thực vật và sữa.',
    'image': 'assets/images/45.png'
  },
  {
    'title': 'Thuần chay',
    'description':
        'Mô tả: Chế độ ăn thuần chay loại bỏ hoàn toàn tất cả các sản phẩm có nguồn gốc từ động vật. Tập trung vào thực phẩm từ thực vật như rau củ, quả, ngũ cốc và các loại hạt. Đây là chế độ ăn dành cho những ai hoàn toàn không sử dụng thực phẩm có nguồn gốc động vật và muốn một chế độ ăn lành mạnh, tự nhiên.',
    'image': 'assets/images/44.png'
  },
  {
    'title': 'Cân bằng',
    'description':
        'Mô tả: Chế độ ăn cân bằng cung cấp đầy đủ các nhóm chất dinh dưỡng cần thiết cho cơ thể: carbohydrate, protein, chất béo, vitamin và khoáng chất. Đây là một chế độ ăn lý tưởng cho những ai muốn duy trì sức khỏe tổng thể, không thiếu hụt bất kỳ dưỡng chất nào.',
    'image': 'assets/images/include--3.png'
  }
];

class _DietStyleScreenWidgetState extends State<DietStyleScreenWidget> {
  late DietStyleScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DietStyleScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.appbarModel,
              updateCallback: () => safeSetState(() {}),
              child: const AppbarWidget(
                title: 'Chế độ ăn của bạn?',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  itemCount: dietStyles.length,
                  itemBuilder: (context, index) {
                    final level = dietStyles[index];
                    final isSelected = _model.select == index;

                    return InkWell(
                      onTap: () {
                        setState(() => _model.select = index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).lightGrey,
                          borderRadius: BorderRadius.circular(16.0),
                          border: isSelected
                              ? Border.all(
                                  color: FlutterFlowTheme.of(context).primary)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: const EdgeInsets.all(13.0),
                                child: Image.asset(
                                  level['image']!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 18.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      level['title']!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                            // useGoogleFonts: false,
                                          ),
                                    ),
                                    Text(
                                      level['description']!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            fontSize: 16.0,
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
                                            // useGoogleFonts: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
              child: FFButtonWidget(
                onPressed: () async {
                  await _model.updateDietStyle(context);
                  context.pushNamed('Select_allergy_screen');
                },
                text: 'Tiếp tục',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 54.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'figtree',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                  elevation: 0.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
