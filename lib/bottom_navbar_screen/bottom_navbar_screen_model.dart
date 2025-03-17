import 'package:diet_plan_app/components/activity_component_model.dart';
import 'package:diet_plan_app/components/mealLog_component_model.dart';
import 'package:flutter/material.dart';

import '/components/home_componet_widget.dart';
import '/components/profile_componet_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../components/my_mealplan_component_model.dart';
import 'bottom_navbar_screen_widget.dart' show BottomNavbarScreenWidget;

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
  late ActivityComponentModel activityComponentModel;
  // Model for profile_componet component.
  late ProfileComponetModel profileComponetModel;
  // Model for mealplan_componet component.
  late MyMealPlanComponentModel mymealplanComponentModel;
  // Model for meal_log_component component.
  late MealLogComponentModel mealLogComponentModel;

  @override
  void initState(BuildContext context) {
    homeComponetModel = createModel(context, () => HomeComponetModel());
    activityComponentModel =
        createModel(context, () => ActivityComponentModel());
    profileComponetModel = createModel(context, () => ProfileComponetModel());
    mymealplanComponentModel =
        createModel(context, () => MyMealPlanComponentModel());
    mealLogComponentModel = createModel(context, () => MealLogComponentModel());
  }

  @override
  void dispose() {
    homeComponetModel.dispose();
    activityComponentModel.dispose();
    profileComponetModel.dispose();
    mymealplanComponentModel.dispose();
    mealLogComponentModel.dispose();
  }
}
