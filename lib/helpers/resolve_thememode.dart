
import 'package:flutter/material.dart';


ThemeMode? resolveThemeMode(String? name) {
  switch (name) {
    case "dark":
      return ThemeMode.dark;
    case "light":
      return ThemeMode.light;
    case "system":
      return ThemeMode.system;
    default:
      return null;
  }
}
