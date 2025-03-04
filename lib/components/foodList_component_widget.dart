import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Import màn hình FoodDetail
import '../services/food_service.dart';
import '../services/models/food.dart';

class FoodListComponentWidget extends StatefulWidget {
  const FoodListComponentWidget({super.key});

  @override
  State<FoodListComponentWidget> createState() =>
      _FoodListComponentWidgetState();
}

class _FoodListComponentWidgetState extends State<FoodListComponentWidget> {
  final FoodService _foodService = FoodService();
  late Future<List<Food>> _foodList;

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    try {
      _foodList = _foodService.getAllFoods(pageIndex: 1, pageSize: 10);
    } catch (e) {
      print("Error fetching food data: $e");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: _foodList,
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

        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final food = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  int foodId = food.foodId;
                  context.pushNamed(
                    'brek_fast_iIngredients',
                    pathParameters: {'foodId': foodId.toString()},
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 104.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).lightGrey,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: food.imageUrl != null
                              ? Image.network(
                                  food.imageUrl!,
                                  width: 96.0,
                                  height: 96.0,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/placeholder.png',
                                  width: 96.0,
                                  height: 96.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.foodName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'figtree',
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: SvgPicture.asset(
                                      'assets/images/fire-icon--1.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${food.calories ?? '0'} Calories',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: Text("Khẩu phần:"),
                                  ),
                                  Expanded(
                                    child: Text(
                                      food.servingSize ?? 'Không rõ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'figtree',
                                            color: FlutterFlowTheme.of(context)
                                                .grey,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ].divide(const SizedBox(width: 12.0)),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
