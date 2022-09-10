
import 'package:flutter/material.dart';


extension RangeValuesX on RangeValues {

  String prettyToString() => "${start.toStringAsFixed(2)} - ${end.toStringAsFixed(2)}";
}
