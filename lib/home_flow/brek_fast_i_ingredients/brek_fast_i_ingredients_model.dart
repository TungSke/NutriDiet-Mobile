import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/services/cusinetype_service.dart';
import 'package:diet_plan_app/services/food_service.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'brek_fast_i_ingredients_widget.dart' show BrekFastIIngredientsWidget;
import 'package:flutter/material.dart';

class BrekFastIIngredientsModel extends FlutterFlowModel<BrekFastIIngredientsWidget>{
  ///  Local state fields for this page.

  VoidCallback? onStateChange;
  int tabar = 0;
  Map<String, dynamic>? food;
  List<Map<String, dynamic>> cusinetypelist = [];
  int? selectedCuisineId;
  String? foodRecipe;
  bool isLoading = false;

  final FoodService _foodService = FoodService();
  final CusinetypeService _cusinetypeService = CusinetypeService();

  Future<void> loadFood(int foodId) async {
    final response = await _foodService.getFoodById(foodId: foodId);
    final responseBody = jsonDecode(response.body);
    food = responseBody["data"];
  }

  Future<void> getAllCusineType() async {
    final response = await _cusinetypeService.getAllCuisineType();
    final responseBody = jsonDecode(response.body);
    cusinetypelist = List<Map<String, dynamic>>.from(responseBody["data"]);
  }

  Future<void> getFoodRecipe(int foodId, BuildContext context) async{
    final response = await _foodService.getFoodRecipe(foodId: foodId, context: context);
    if(response.statusCode != 200){
      return;
    }
    final responseBody = jsonDecode(response.body);
    foodRecipe = responseBody["data"]["airesponse"].toString();
  }


  Future<void> createFoodRecipeAI(int foodId, BuildContext context) async {
    if (selectedCuisineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn loại ẩm thực!")),
      );
      return;
    }
    isLoading = true;
    onStateChange?.call();

    final response = await _foodService.createFoodRecipeAI(
      foodId: foodId,
      cusineId: selectedCuisineId!,
      context: context,
    );

    final responseBody = jsonDecode(response.body);
    foodRecipe = responseBody["data"].toString();

    isLoading = false;
    onStateChange?.call();
  }


  List<TextSpan> parseFormattedText() {
    if (foodRecipe == null) {
      return [TextSpan(text: "Không có công thức", style: TextStyle(color: Colors.red))];
    }

    List<TextSpan> spans = [];
    final parts = foodRecipe!.split("**");

    for (int i = 0; i < parts.length; i++) {
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(fontWeight: i.isOdd ? FontWeight.bold : FontWeight.normal),
        ),
      );
    }
    return spans;
  }

  void showRejectDialog(int foodId, BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Text(
                      "Lý do từ chối",
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'figtree',
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // TextField nhập lý do
                    TextField(
                      controller: reasonController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Nhập lý do từ chối...",
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'figtree',
                          color: FlutterFlowTheme.of(context).grey,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).lightGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'figtree',
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Nút hành động
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Nút Hủy
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Hủy",
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).grey,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),

                        // Nút Gửi
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            String reason = reasonController.text.trim();
                            if (reason.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              await _rejectRecipe(foodId, reason, context);
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Vui lòng nhập lý do!",
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'figtree',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      useGoogleFonts: false,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FlutterFlowTheme.of(context).primary,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3.0,
                          ),
                          child: isLoading
                              ? SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              strokeWidth: 2.0,
                            ),
                          )
                              : Text(
                            "Gửi",
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'figtree',
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _rejectRecipe(int foodId, String rejectionReason, BuildContext context) async {
    await _foodService.RejectRecipeAI(foodId: foodId, rejectionReason: rejectionReason, context: context);
    await createFoodRecipeAI(foodId, context);
  }



  @override
  void initState(BuildContext context){}

  @override
  void dispose() {}
}
