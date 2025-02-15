import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

String cmtoinch(String cm) {
  double centimeters = double.tryParse(cm) ?? 0;
  double totalInches = centimeters / 2.54;
  int feet = (totalInches ~/ 12).toInt();
  int inches = (totalInches % 12).toInt();
  // FFAppState().feet = feetValue;
  // FFAppState().inch = remainingInchValue;
  return '$inches ';
}

String cmtofeet(String cm) {
  double centimeters = double.tryParse(cm) ?? 0;
  // Convert centimeters to inches (1 inch = 2.54 cm)
  double totalInches = centimeters / 2.54;
  // Calculate feet
  int feet = (totalInches ~/ 12).toInt();
  // Calculate remaining inches
  int inches = (totalInches % 12).toInt();

  return '$feet $inches ';
}

String cmtofeet3(String cm) {
  double centimeters = double.tryParse(cm) ?? 0;
  double totalInches = centimeters / 2.54;
  int feet = (totalInches ~/ 12).toInt();
  int inches = (totalInches % 12).toInt();
  // FFAppState().feet = feetValue;
  // FFAppState().inch = remainingInchValue;
  return '$feet  ';
}

String kgtolb(String kg) {
  double kgValue = double.parse(kg);

  double lb = kgValue * 2.20;
  return lb.toStringAsFixed(2);
}

String lbtokg(String lb) {
  double lbValue = double.parse(lb);
  double kg = lbValue / 2.20;
  return kg.toStringAsFixed(2);
}

String calculatedata(
  String feet,
  String inch,
) {
  int feets = int.parse(feet);
  int inchs = int.parse(inch);
  // Convert feet to inches and add the given inches
  int totalInches = feets * 12 + inchs;
  // Convert inches to centimeters (1 inch = 2.54 cm)
  double cm = totalInches * 2.54;
  // Return the result in centimeters as a string

  return cm.toStringAsFixed(2);
}
