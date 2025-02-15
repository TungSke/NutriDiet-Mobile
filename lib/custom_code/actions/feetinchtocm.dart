// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> feetinchtocm(
  String feet,
  String inch,
) async {
  // Add your function code here!

  int feets = int.parse(feet);
  int inches = int.parse(inch);
  // Convert feet to inches and add the given inches
  int totalInches = feets * 12 + inches;
  // Convert inches to centimeters (1 inch = 2.54 cm)
  double cm = totalInches * 2.54;
  // Return the result in centimeters as a string
  return cm.toStringAsFixed(2);
}
