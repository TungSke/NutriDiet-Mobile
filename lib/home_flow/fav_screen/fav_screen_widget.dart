import 'package:flutter/material.dart';

import '/components/appbar_widget.dart';
import '/components/foodList_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'fav_screen_model.dart';

export 'fav_screen_model.dart';

class FavScreenWidget extends StatefulWidget {
  const FavScreenWidget({super.key});

  @override
  State<FavScreenWidget> createState() => _FavScreenWidgetState();
}

class _FavScreenWidgetState extends State<FavScreenWidget> {
  late FavScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.appbarModel,
                updateCallback: () => safeSetState(() {}),
                child: const AppbarWidget(
                  title: 'Danh sách yêu thích',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: wrapWithModel(
                    model: _model.foodListComponentModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const FoodListComponentWidget(
                      showFavoritesOnly: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}