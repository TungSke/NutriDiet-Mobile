import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'brek_fast_i_ingredients_model.dart';
export 'brek_fast_i_ingredients_model.dart';

class BrekFastIIngredientsWidget extends StatefulWidget {
  final int foodId;
  const BrekFastIIngredientsWidget({super.key, required this.foodId});

  @override
  State<BrekFastIIngredientsWidget> createState() =>
      _BrekFastIIngredientsWidgetState();
}

class _BrekFastIIngredientsWidgetState extends State<BrekFastIIngredientsWidget> {
  late BrekFastIIngredientsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrekFastIIngredientsModel());
    _model.onStateChange = () => setState(() {});
    _model.loadFood(widget.foodId).then((_) {
      setState(() {});
    });

    _model.getAllCusineType();
    _model.getFoodRecipe(widget.foodId, context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (_model.food == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            Container(
              width: double.infinity,
              height: 273.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(_model.food?["imageUrl"]).image,
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0.0, -1.0),
                child: SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 16.0, 20.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: SvgPicture.asset(
                                    'assets/images/appbar-arroew.svg',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (FFAppState().isLogin == true) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/fill-hert.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/like---.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 16.0, 20.0, 0.0),
                  child: Text(
                    _model.food?["foodName"],
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'figtree',
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                          lineHeight: 1.5,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 16.0, 20.0, 0.0),
                  child: Text(
                    _model.food?["servingSize"],
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'figtree',
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                          lineHeight: 1.5,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 24.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    // child: custom_widgets.Readmore(
                    //   width: double.infinity,
                    //   height: 72.0,
                    // ),
                    child:
                        Text(_model.food!["description"] ?? "Không có mô tả"),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _model.tabar = 0;
                        safeSetState(() {});
                      },
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Thành phần món',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.tabar == 0
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: _model.tabar == 0 ? 18.0 : 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                            Divider(
                              thickness: 2.0,
                              color: _model.tabar == 0
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _model.tabar = 1;
                        safeSetState(() {});
                      },
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Recipe',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'figtree',
                                    color: _model.tabar == 1
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).grey,
                                    fontSize: _model.tabar == 1 ? 18.0 : 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                            Divider(
                              thickness: 2.0,
                              color: _model.tabar == 1
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (_model.tabar == 0) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 16.0, 20.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Calories',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["calories"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 16.0, 20.0, 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Protein',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["protein"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'carbs',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["carbs"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 16.0, 20.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'fat',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["fat"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 16.0, 20.0, 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'glucid',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["glucid"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).lightGrey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 16.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'fiber',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _model.food!["fiber"].toString(),
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'figtree',
                                        color:
                                            FlutterFlowTheme.of(context).grey,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      // Text("Nguyên liệu:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
                      // SizedBox(height: 10),
                      // ..._model.food!["ingredients"].map<Widget>((ingredient) =>
                      //     Card(
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Colors.white, // Đặt màu nền trắng
                      //           border: Border.all(color: Colors.black, width: 1.0,),
                      //         ),
                      //         child: ListTile(
                      //           title: Text(
                      //             ingredient["ingredientName"],
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //           trailing: Text(
                      //             "${ingredient["calories"]} kcal",
                      //             style: TextStyle(color: Colors.grey[600]),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      // ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_model.foodRecipe != null)
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: _model.parseFormattedText(),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Bạn có muốn thử công thức khác?",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/serch-diet-empty.png',
                                width: 116.0,
                                height: 116.0,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Bạn chưa có công thức nấu ăn này',
                                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tạo công thức của riêng bạn',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                              ),
                            ],
                          ),

                        SizedBox(height: 16),

                        // Dropdown chọn loại ẩm thực
                        DropdownButton<int>(
                          value: _model.cusinetypelist.any((c) => c["cuisineId"] == _model.selectedCuisineId)
                              ? _model.selectedCuisineId
                              : null,
                          hint: const Text("Chọn loại ẩm thực"),
                          isExpanded: true,
                          items: _model.cusinetypelist.map((cuisine) {
                            return DropdownMenuItem<int>(
                              value: cuisine["cuisineId"],
                              child: Text(cuisine["cuisineName"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _model.selectedCuisineId = value!;
                            });
                          },style: TextStyle(backgroundColor: Colors.white),
                        ),

                        SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () => _model.showRejectDialog(widget.foodId, context),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.all(20)),
                          child: Text("Từ chối công thức",style: TextStyle(color: Colors.white))
                        ),

                        SizedBox(height: 16),

                        GestureDetector(
                          onTap: () async {
                            await _model.createFoodRecipeAI(widget.foodId, context);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5.0, offset: Offset(2, 2)),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_model.isLoading)
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                if (!_model.isLoading) Icon(Icons.auto_awesome, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  _model.isLoading ? "Đang tạo..." : "Tạo công thức bằng AI",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
