
import 'dart:convert';

import 'package:flutter/material.dart';


extension RangeValuesX on RangeValues {

  String prettyToString() => "${start.toStringAsFixed(2)} - ${end.toStringAsFixed(2)}";

  Map<String, double> toMap() => {
    "start": start,
    "end": end,
  };
  
  static RangeValues fromMap(Map<String, double> map) => RangeValues(
    map["start"] ?? 0,
    map["end"] ?? 0,
  );

  String toJson() => jsonEncode(toMap());

  static RangeValues fromJson(String json) => fromMap(jsonDecode(json));
}
