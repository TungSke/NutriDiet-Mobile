import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/components/ingredient_component_model.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key});

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  late IngredientComponentModel _model;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IngredientComponentModel());
    _model.setUpdateCallback(() => setState(() {}));
    _model.fetchIngredients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _model.maybeDispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _model.searchIngredients(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Chọn nguyên liệu',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'figtree',
            color: FlutterFlowTheme.of(context).secondaryBackground,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            useGoogleFonts: false,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 0.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Nhập tên nguyên liệu",
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'figtree',
                    color: FlutterFlowTheme.of(context).grey,
                    useGoogleFonts: false,
                  ),
                  // prefixIcon: Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: SvgPicture.asset(
                  //     'assets/images/search.svg',
                  //     width: 24.0,
                  //     height: 24.0,
                  //     color: FlutterFlowTheme.of(context).grey,
                  //   ),
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).lightGrey,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: _model.isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 24.0),
                itemCount: _model.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _model.ingredients[index];
                  return IngredientComponentWidget(
                    ingredient: ingredient,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientComponentWidget extends StatefulWidget {
  final Map<String, dynamic> ingredient;

  const IngredientComponentWidget({super.key, required this.ingredient});

  @override
  State<IngredientComponentWidget> createState() => _IngredientComponentWidgetState();
}

class _IngredientComponentWidgetState extends State<IngredientComponentWidget> {
  String _selectedPreference = 'Bình thường';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context).grey.withOpacity(0.1),
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ingredient['ingredientName'] ?? 'N/A',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'figtree',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: false,
                    ),
                  ),
                  Text(
                    '${widget.ingredient['calories']?.toString() ?? '0'} kcal',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'figtree',
                      color: FlutterFlowTheme.of(context).grey,
                      fontSize: 14.0,
                      useGoogleFonts: false,
                    ),
                  ),
                  Text(
                    "Protein: ${widget.ingredient['protein']?.toString() ?? '0'}g",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'figtree',
                      color: FlutterFlowTheme.of(context).grey,
                      fontSize: 14.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ].divide(const SizedBox(height: 4.0)),
              ),
              DropdownButton<String>(
                value: _selectedPreference,
                dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'figtree',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14.0,
                  useGoogleFonts: false,
                ),
                items: const [
                  DropdownMenuItem(value: 'Thích', child: Text('Thích')),
                  DropdownMenuItem(value: 'Bình thường', child: Text('Bình thường')),
                  DropdownMenuItem(value: 'Ghét', child: Text('Ghét')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPreference = value!;
                  });
                },
                underline: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}