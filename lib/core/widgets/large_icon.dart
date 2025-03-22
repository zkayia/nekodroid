import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';

class LargeIcon extends Icon {
  const LargeIcon(
    super.icon, {
    super.fill,
    super.weight,
    super.grade,
    super.color,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
    super.applyTextScaling,
    super.key,
  }) : super(size: kLargeIconSize, opticalSize: kLargeIconSize);
}
