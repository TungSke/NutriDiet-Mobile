// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:numberpicker/numberpicker.dart';

class Spinner extends StatefulWidget {
  const Spinner({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  int _currentValue = 10;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          itemHeight: 60,
          itemWidth: 100,
          selectedTextStyle: TextStyle(
              color: FlutterFlowTheme.of(context).primary,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          textStyle: TextStyle(
              color: FlutterFlowTheme.of(context).grey,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          value: _currentValue,
          minValue: 1,
          maxValue: 1000,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ],
    );
  }
}
