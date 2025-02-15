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

import 'package:readmore/readmore.dart';

class Readmore extends StatefulWidget {
  const Readmore({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Readmore> createState() => _ReadmoreState();
}

class _ReadmoreState extends State<Readmore> {
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      'A balanced breakfast typically includes protein, fiber and a range of nutrients If youre looking for a healthy morning meal try easy A balanced breakfast typically includes protein, fiber and a range of nutrients If youre looking for a healthy morning meal try easy ',
      style: TextStyle(
          color: FlutterFlowTheme.of(context).primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w400),
      trimMode: TrimMode.Line,
      trimLines: 2,
      colorClickableText: Color(0xffE75434),
      trimCollapsedText: 'Read more..',
      trimExpandedText: 'Show less',
      lessStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: FlutterFlowTheme.of(context).primary),
      moreStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: FlutterFlowTheme.of(context).primary),
    );
  }
}
