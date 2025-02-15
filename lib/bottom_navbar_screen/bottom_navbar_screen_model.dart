import '/components/home_componet_widget.dart';
import '/components/profile_componet_widget.dart';
import '/components/recipe_compnoet_widget.dart';
import '/components/serch_data_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bottom_navbar_screen_widget.dart' show BottomNavbarScreenWidget;
import 'package:flutter/material.dart';

class BottomNavbarScreenModel
    extends FlutterFlowModel<BottomNavbarScreenWidget> {
  ///  Local state fields for this page.

  int? bottomadd = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for Home_componet component.
  late HomeComponetModel homeComponetModel;
  // Model for serch_data component.
  late SerchDataModel serchDataModel;
  // Model for recipe_compnoet component.
  late RecipeCompnoetModel recipeCompnoetModel;
  // Model for profile_componet component.
  late ProfileComponetModel profileComponetModel;

  @override
  void initState(BuildContext context) {
    homeComponetModel = createModel(context, () => HomeComponetModel());
    serchDataModel = createModel(context, () => SerchDataModel());
    recipeCompnoetModel = createModel(context, () => RecipeCompnoetModel());
    profileComponetModel = createModel(context, () => ProfileComponetModel());
  }

  @override
  void dispose() {
    homeComponetModel.dispose();
    serchDataModel.dispose();
    recipeCompnoetModel.dispose();
    profileComponetModel.dispose();
  }
}
