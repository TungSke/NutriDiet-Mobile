import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';
import 'package:flutter/material.dart';

import '../../components/appbar_model.dart';
import '../../flutter_flow/flutter_flow_model.dart';

class BuyPremiumPackageScreenModel
    extends FlutterFlowModel<BuyPremiumPackageScreenWidget> {
  ///  Local state fields for this page.

  ///  State fields for stateful widgets in this page.
  late AppbarModel? appbarModel;

  @override
  void initState(BuildContext context) {
    appbarModel = createModel(context, () => AppbarModel());
  }

  @override
  void dispose() {
    appbarModel?.dispose();
  }
}
