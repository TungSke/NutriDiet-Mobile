import 'package:diet_plan_app/components/foodList_component_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../services/models/food.dart';

class FoodListComponentWidget extends StatefulWidget {
  final String? searchQuery;
  final bool showFavoritesOnly;

  const FoodListComponentWidget({
    super.key,
    this.searchQuery,
    this.showFavoritesOnly = false,
  });

  @override
  State<FoodListComponentWidget> createState() => _FoodListComponentWidgetState();
}

class _FoodListComponentWidgetState extends State<FoodListComponentWidget> {
  late FoodListComponentModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodListComponentModel());
    _fetchData();
  }

  @override
  void didUpdateWidget(FoodListComponentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      print("Search query updated: ${widget.searchQuery}");
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    await _model.fetchFoods(search: widget.searchQuery, context: context);
    if (mounted) setState(() {});
  }

  void _showFavoriteDialog(Food food) {
    final isFavorite = _model.isFavorite(food.foodId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: isFavorite ? Colors.red : Colors.white,
        title: Text(
          isFavorite ? "Xóa khỏi yêu thích" : "Thêm vào yêu thích",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isFavorite ? Colors.white : FlutterFlowTheme.of(context).primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          isFavorite
              ? "Bạn có muốn xóa ${food.foodName} khỏi danh sách yêu thích?"
              : "Bạn muốn thêm ${food.foodName} vào danh sách yêu thích?",
          style: TextStyle(fontSize: 14, color: isFavorite ? Colors.white : Colors.grey),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFavorite ? Colors.white : Colors.grey.shade300,
              foregroundColor: isFavorite ? Colors.red : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Hủy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFavorite ? Colors.red : Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFavorite ? Colors.white : FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              bool success;
              if (isFavorite) {
                success = await _model.removeFavoriteFood(food.foodId, context);
              } else {
                success = await _model.addFavoriteFood(food.foodId, context);
              }
              Navigator.pop(context);
              if (success && mounted) {
                setState(() {});
                _showSuccessDialog(food.foodName, isFavorite);
              } else if (mounted) {
                _showErrorDialog();
              }
            },
            child: Text(
              isFavorite ? "Xóa" : "Thêm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String foodName, bool wasFavorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).primary),
            const SizedBox(width: 8),
            Text(
              "Thành công",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ),
        content: Text(
          wasFavorite
              ? "Đã xóa $foodName khỏi danh sách yêu thích."
              : "Đã thêm $foodName vào danh sách yêu thích.",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              "Lỗi",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ),
        content: const Text(
          "Thao tác không thành công. Vui lòng thử lại.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: _model.foodList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu'));
        }

        final filteredFoods = widget.showFavoritesOnly
            ? snapshot.data!.where((food) => _model.isFavorite(food.foodId)).toList()
            : snapshot.data!;

        if (filteredFoods.isEmpty && widget.showFavoritesOnly) {
          return const Center(child: Text('Bạn chưa có món ăn yêu thích nào'));
        }

        return ListView.builder(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
          itemCount: filteredFoods.length,
          itemBuilder: (context, index) {
            final food = filteredFoods[index];
            final isFavorite = _model.isFavorite(food.foodId);

            return GestureDetector(
              onTap: () {
                int foodId = food.foodId;
                context.pushNamed(
                  'brek_fast_iIngredients',
                  pathParameters: {'foodId': foodId.toString()},
                );
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: food.imageUrl != null
                            ? Image.network(
                          food.imageUrl!,
                          width: 70.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/placeholder.png',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Image.asset(
                          'assets/images/placeholder.png',
                          width: 70.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              food.foodName,
                              maxLines: 1,
                              minFontSize: 12,
                              maxFontSize: 16,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/fire-icon--1.svg',
                                  width: 10.0,
                                  height: 16.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 4.0),
                                AutoSizeText(
                                  '${food.calories ?? '0'} kcal',
                                  maxLines: 1,
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                  style: GoogleFonts.montserrat(
                                    color: FlutterFlowTheme.of(context).grey,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                AutoSizeText(
                                  "Khẩu phần:",
                                  maxLines: 1,
                                  minFontSize: 7,
                                  maxFontSize: 10,
                                  style: GoogleFonts.montserrat(
                                    color: FlutterFlowTheme.of(context).grey,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: AutoSizeText(
                                    food.servingSize ?? 'Không rõ',
                                    maxLines: 1,
                                    minFontSize: 7,
                                    maxFontSize: 10,
                                    style: GoogleFonts.montserrat(
                                      color: FlutterFlowTheme.of(context).grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite
                              ? FlutterFlowTheme.of(context).primary
                              : Colors.grey,
                          size: 20.0,
                        ),
                        onPressed: () => _showFavoriteDialog(food),
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}