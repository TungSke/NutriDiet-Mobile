import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/components/appbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'help_screen_model.dart';

export 'help_screen_model.dart';

class HelpScreenWidget extends StatefulWidget {
  const HelpScreenWidget({super.key});

  @override
  State<HelpScreenWidget> createState() => _HelpScreenWidgetState();
}

class _HelpScreenWidgetState extends State<HelpScreenWidget> {
  late HelpScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpScreenModel());

    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController2 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController3 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController4 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController5 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController6 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController7 =
        ExpandableController(initialExpanded: false);
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
                  title: 'Giúp đỡ',
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    16.0,
                    0,
                    16.0,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController2,
                                child: ExpandablePanel(
                                  header: Text(
                                      'Tại sao ăn kiêng lại quan trọng?',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Text(
                                      'Ăn kiêng không chỉ giúp kiểm soát cân nặng mà còn đóng vai trò quan trọng trong việc duy trì sức khỏe, tăng cường năng lượng và cải thiện chất lượng cuộc sống. Một chế độ ăn uống hợp lý giúp giảm nguy cơ mắc các bệnh tim mạch, tiểu đường, béo phì và nhiều vấn đề sức khỏe khác. Đồng thời, ăn uống lành mạnh còn tác động tích cực đến tâm trạng, giúp giảm căng thẳng và tăng sự tập trung. Vì vậy, lựa chọn thực phẩm phù hợp không chỉ giúp bạn đạt được vóc dáng mong muốn mà còn mang lại một cơ thể khỏe mạnh và tinh thần sảng khoái hơn.',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontWeight: FontWeight.normal)),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController3,
                                child: ExpandablePanel(
                                  header: Text('Bắt đầu ăn kiêng như thế nào?',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Text(
                                      'Để bắt đầu ăn kiêng hiệu quả, trước tiên bạn cần xác định mục tiêu của mình, dù là giảm cân, tăng cân hay duy trì sức khỏe. Hãy lựa chọn một chế độ ăn phù hợp, ưu tiên thực phẩm tự nhiên và hạn chế đồ chế biến sẵn. Chia nhỏ bữa ăn, ăn đúng giờ và uống đủ nước sẽ giúp cơ thể hấp thu dinh dưỡng tốt hơn. Bên cạnh đó, kết hợp vận động thường xuyên không chỉ hỗ trợ quá trình ăn kiêng mà còn giúp duy trì một lối sống lành mạnh. Quan trọng nhất là kiên trì và lắng nghe cơ thể để điều chỉnh chế độ ăn sao cho phù hợp, giúp bạn đạt được kết quả bền vững.',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontWeight: FontWeight.normal)),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController4,
                                child: ExpandablePanel(
                                  header: Text('Thế nào là ăn kiêng lành mạnh?',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Text(
                                      'Để ăn kiêng một cách lành mạnh, bạn cần đảm bảo cơ thể vẫn nhận đủ dinh dưỡng trong khi kiểm soát lượng calo tiêu thụ. Hãy tập trung vào thực phẩm tự nhiên như rau xanh, trái cây, protein nạc (gà, cá, trứng), ngũ cốc nguyên cám và chất béo tốt (dầu ô liu, hạt, quả bơ). Tránh thực phẩm chế biến sẵn, đồ uống có đường và đồ ăn nhanh. Ngoài ra, hãy chia nhỏ bữa ăn, uống đủ nước và kết hợp vận động thường xuyên để duy trì sức khỏe lâu dài. Quan trọng nhất là kiên trì và lắng nghe cơ thể để điều chỉnh chế độ ăn phù hợp với nhu cầu cá nhân.',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontWeight: FontWeight.normal)),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController5,
                                child: ExpandablePanel(
                                  header: Text('Chế độ ăn bình thường là gì?',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Chế độ ăn bình thường là chế độ ăn uống cân bằng và đa dạng, bao gồm tất cả các nhóm thực phẩm chính:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Carbohydrates (Tinh bột): Bao gồm các thực phẩm như cơm, bánh mì, mì, ngũ cốc.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Protein (Chất đạm): Thịt, cá, trứng, đậu.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Fat (Chất béo): Bao gồm dầu ăn, bơ, hạt, quả bơ.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Vitamins và khoáng chất: Có trong rau củ, trái cây, các loại hạt.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController6,
                                child: ExpandablePanel(
                                  header: Text('Như thế nào là ăn đúng cách',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '1. Ăn đúng giờ: Ăn ba bữa chính và các bữa phụ vào giờ cố định.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '2. Ăn từ từ và nhai kỹ: Nhai kỹ giúp dễ tiêu hóa và no lâu.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '3. Ăn đủ no, không ăn quá no: Ăn vừa đủ để cơ thể thoải mái.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '4. Ăn đa dạng thực phẩm: Bổ sung đủ rau, trái cây, ngũ cốc, protein và chất béo lành mạnh.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '5. Ăn bữa nhỏ và thường xuyên: Chia các bữa ăn thành nhiều bữa nhỏ trong ngày.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '6. Uống đủ nước: Uống ít nhất 8 cốc nước mỗi ngày.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '7. Lắng nghe cơ thể: Ăn khi đói và dừng khi no',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '8. Tránh ăn vặt không lành mạnh: Hạn chế đồ ăn có đường, dầu mỡ.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 0.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: FlutterFlowTheme.of(context).lightGrey,
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController7,
                                child: ExpandablePanel(
                                  header: Text('Chế độ ăn bình thường là gì?',
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .lightGrey,
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Text(
                                          'Chế độ ăn bình thường là chế độ ăn cân bằng, cung cấp đầy đủ các chất dinh dưỡng cần thiết cho cơ thể để duy trì sức khỏe và hoạt động hàng ngày. Một chế độ ăn bình thường sẽ bao gồm:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Carbohydrates (Tinh bột): Bao gồm ngũ cốc nguyên hạt, cơm, bánh mì, khoai lang, và các loại rau củ chứa tinh bột. Đây là nguồn năng lượng chính cho cơ thể.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Protein (Chất đạm): Thực phẩm giàu protein như thịt nạc, cá, trứng, đậu, và các sản phẩm từ sữa giúp cơ thể xây dựng và duy trì cơ bắp, cũng như các chức năng sinh lý khác.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Fat (Chất béo): Chất béo lành mạnh từ dầu ô liu, quả bơ, các loại hạt và cá béo rất quan trọng trong việc duy trì chức năng của các tế bào và hệ thần kinh.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Vitamins và khoáng chất: Rau xanh, trái cây, và các loại thực phẩm tươi sống cung cấp vitamin và khoáng chất giúp cơ thể duy trì sức khỏe và phòng ngừa bệnh tật.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          '   - Nước: Uống đủ nước là yếu tố không thể thiếu để duy trì sự sống và giúp cơ thể hoạt động hiệu quả',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Chế độ ăn bình thường không quá nghiêm ngặt về khẩu phần, nhưng cần đảm bảo sự cân bằng và sự đa dạng của các nhóm thực phẩm để cơ thể nhận đủ dinh dưỡng cần thiết cho sự phát triển và duy trì sức khỏe.',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: true,
                                    expandIcon: Icons.keyboard_arrow_down,
                                    collapseIcon: Icons.keyboard_arrow_up,
                                    iconSize: 24.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    iconPadding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
