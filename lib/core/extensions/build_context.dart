import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  NavigatorState get nav => Navigator.of(this);
  MediaQueryData get mq => MediaQuery.of(this);
  ThemeData get th => Theme.of(this);
  TextStyle get defTextStyle => DefaultTextStyle.of(this).style;
  bool get isDarkTheme => th.brightness == Brightness.dark;
}
