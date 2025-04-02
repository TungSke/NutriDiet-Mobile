import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'about_us_screen_model.dart';

export 'about_us_screen_model.dart';

class AboutUsScreenWidget extends StatefulWidget {
  const AboutUsScreenWidget({super.key});

  @override
  State<AboutUsScreenWidget> createState() => _AboutUsScreenWidgetState();
}

class _AboutUsScreenWidgetState extends State<AboutUsScreenWidget>
    with TickerProviderStateMixin {
  late AboutUsScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutUsScreenModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 800.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  title: 'Về Nutridiet',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      0,
                      16.0,
                      0,
                      16.0,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/about_us.png',
                          width: double.infinity,
                          height: 168.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text('Câu chuyện về Nutridiet',
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          'Ngày nay, việc duy trì lối sống lành mạnh đã trở thành một thách thức lớn đối với nhiều người do lịch trình bận rộn, thiếu kiến thức về dinh dưỡng và khó khăn trong việc lựa chọn chế độ ăn uống phù hợp. Không ít người gặp khó khăn trong việc đạt được mục tiêu sức khỏe, từ tăng cân, giảm cân đến duy trì sức khỏe tổng thể. Việc thiếu một nền tảng tích hợp giữa dữ liệu sức khỏe cá nhân và các gợi ý dinh dưỡng hiệu quả thường dẫn đến kế hoạch bữa ăn không cân đối, gây ra những vấn đề nghiêm trọng như béo phì, suy dinh dưỡng và bệnh mãn tính.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text(
                          'NutriDiet ra đời để giải quyết những thách thức này bằng cách cung cấp một nền tảng dinh dưỡng thông minh, cá nhân hóa dựa trên dữ liệu sức khỏe và mục tiêu của từng người dùng. Với công nghệ AI hiện đại, NutriDiet không chỉ giúp bạn dễ dàng lập kế hoạch bữa ăn mà còn điều chỉnh và tối ưu hóa liên tục dựa trên phản hồi và sở thích cá nhân. NutriDiet không chỉ mang đến sự tiện lợi mà còn giúp người dùng định hình một lối sống lành mạnh, bền vững và hiệu quả hơn.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text('Vì sao bạn nên chọn Nutridiet?',
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          'NutriDiet sử dụng AI để tạo ra kế hoạch bữa ăn phù hợp với mục tiêu sức khỏe, sở thích ăn uống và chế độ dinh dưỡng riêng của mỗi người dùng.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text(
                          'Phân tích các thông số như cân nặng, chiều cao, và mục tiêu sức khỏe để đưa ra các bữa ăn cân bằng và phù hợp nhất.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text(
                          'NutriDiet liên tục học hỏi và cải tiến dựa trên phản hồi và sở thích của người dùng, đảm bảo kế hoạch luôn cập nhật và hiệu quả.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text(
                          'Không còn đau đầu với việc lên kế hoạch bữa ăn, NutriDiet tự động hóa quá trình và giúp bạn tập trung vào việc tận hưởng thực phẩm lành mạnh.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      Text('Định hình lối sóống lành mạnh với Nutridiet',
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          'NutriDiet không chỉ là một công cụ, mà là người bạn đồng hành giúp bạn đạt được mục tiêu sức khỏe một cách dễ dàng và hiệu quả. Với công nghệ AI tiên tiến, NutriDiet cá nhân hóa kế hoạch bữa ăn dựa trên dữ liệu sức khỏe và sở thích của từng người dùng. Hệ thống không ngừng học hỏi và cải tiến, mang đến những gợi ý tối ưu nhất cho chế độ dinh dưỡng của bạn. NutriDiet giúp đơn giản hóa việc quản lý chế độ ăn uống, tạo sự cân bằng giữa tiện lợi và hiệu quả, đồng thời trao quyền cho bạn trên hành trình chăm sóc sức khỏe toàn diện.',
                          style: GoogleFonts.roboto(
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ].divide(const SizedBox(height: 16.0)),
                  ).animateOnPageLoad(
                      animationsMap['listViewOnPageLoadAnimation']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
