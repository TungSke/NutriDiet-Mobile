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

  FoodService _foodService = FoodService();
  CusinetypeService _cusinetypeService = CusinetypeService();

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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lý do từ chối",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: reasonController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Nhập lý do...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Hủy"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        String reason = reasonController.text.trim();
                        if (reason.isNotEmpty) {
                          await _rejectRecipe(foodId, reason, context);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Gửi"),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
