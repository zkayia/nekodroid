import 'package:flutter/material.dart';

extension TextStyleX on TextStyle? {
  TextStyle? bold() => this?.copyWith(fontWeight: FontWeight.bold);
}
