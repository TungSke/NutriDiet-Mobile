import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ingredient_component_model.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key});

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  late IngredientComponentModel _model;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IngredientComponentModel());
    _model.setUpdateCallback(() => setState(() {}));
    _model.fetchIngredients(context: context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  void _onSearchSubmit(String value) {
    _model.searchIngredients(value, context);
  }

  void _clearSearch() {
    _searchController.clear();
    _model.searchIngredients('', context);
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 24.0,
          ),
          onPressed: () {
            context.safePop();
          },
        ),
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
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Nhập tên nguyên liệu',
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'figtree',
                    color: FlutterFlowTheme.of(context).grey,
                    useGoogleFonts: false,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
                      width: 24.0,
                      height: 24.0,
                      color: FlutterFlowTheme.of(context).grey,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: FlutterFlowTheme.of(context).grey,
                      size: 20.0,
                    ),
                    onPressed: _clearSearch,
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).lightGrey,
                ),
                onSubmitted: _onSearchSubmit,
                textInputAction: TextInputAction.search,
              ),
            ),
            Expanded(
              child: _model.isLoading
                  ? ListView.builder(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).lightGrey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                itemCount: _model.ingredients.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final ingredient = _model.ingredients[index];
                  return IngredientComponentWidget(
                    ingredient: ingredient,
                    onUpdatePreference: (newPreference) async {
                      await _model.updateIngredientPreference(
                        ingredient['ingredientId'],
                        newPreference,
                        context,
                      );
                    },
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
  final Future<void> Function(String) onUpdatePreference;

  const IngredientComponentWidget({
    super.key,
    required this.ingredient,
    required this.onUpdatePreference,
  });

  @override
  State<IngredientComponentWidget> createState() => _IngredientComponentWidgetState();
}

class _IngredientComponentWidgetState extends State<IngredientComponentWidget> {
  late String _selectedPreference;

  @override
  void initState() {
    super.initState();
    _selectedPreference = widget.ingredient['preference'] ?? 'Neutral';
  }

  void _handlePreferenceChange(String? newPreference) {
    if (newPreference != null) {
      setState(() {
        _selectedPreference = newPreference;
      });
      widget.onUpdatePreference(newPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () {
        // Có thể thêm hành động khi nhấn vào item (ví dụ, xem chi tiết nguyên liệu)
      },
      borderRadius: BorderRadius.circular(16.0),
      splashColor: theme.primary.withOpacity(0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: _selectedPreference == 'Like'
                ? theme.primary
                : _selectedPreference == 'Dislike'
                ? Colors.redAccent
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.grey.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ingredient['ingredientName'] ?? 'N/A',
                      style: theme.bodyMedium.override(
                        fontFamily: 'figtree',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16.0,
                          color: theme.primary,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${widget.ingredient['calories']?.toString() ?? '0'} kcal',
                          style: theme.bodyMedium.override(
                            fontFamily: 'figtree',
                            color: theme.grey,
                            fontSize: 14.0,
                            useGoogleFonts: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16.0,
                          color: theme.secondary,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Protein: ${widget.ingredient['protein']?.toString() ?? '0'}g',
                          style: theme.bodyMedium.override(
                            fontFamily: 'figtree',
                            color: theme.grey,
                            fontSize: 14.0,
                            useGoogleFonts: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: _selectedPreference == 'Like'
                      ? theme.primary.withOpacity(0.05)
                      : _selectedPreference == 'Dislike'
                      ? Colors.redAccent.withOpacity(0.05)
                      : theme.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _selectedPreference == 'Like'
                        ? theme.primary
                        : _selectedPreference == 'Dislike'
                        ? Colors.redAccent
                        : theme.grey,
                    width: 0.5,
                  ),
                ),
                child: DropdownButton<String>(
                  value: _selectedPreference,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _selectedPreference == 'Like'
                        ? theme.primary
                        : _selectedPreference == 'Dislike'
                        ? Colors.redAccent
                        : theme.grey,
                    size: 20.0,
                  ),
                  underline: Container(),
                  dropdownColor: theme.secondaryBackground,
                  items: [
                    DropdownMenuItem(
                      value: 'Like',
                      child: Row(
                        children: [
                          Icon(Icons.favorite, size: 14.0, color: theme.primary),
                          const SizedBox(width: 6.0),
                          Text(
                            'Thích',
                            style: theme.bodyMedium.override(
                              fontFamily: 'figtree',
                              color: theme.primary,
                              fontSize: 13.0,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Neutral',
                      child: Row(
                        children: [
                          Icon(Icons.remove_circle, size: 14.0, color: theme.grey),
                          const SizedBox(width: 6.0),
                          Text(
                            'Bình thường',
                            style: theme.bodyMedium.override(
                              fontFamily: 'figtree',
                              color: theme.grey,
                              fontSize: 13.0,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Dislike',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, size: 14.0, color: Colors.redAccent),
                          const SizedBox(width: 6.0),
                          Text(
                            'Không thích',
                            style: theme.bodyMedium.override(
                              fontFamily: 'figtree',
                              color: Colors.redAccent,
                              fontSize: 13.0,
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: _handlePreferenceChange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}