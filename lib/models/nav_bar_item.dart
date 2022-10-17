
import 'package:flutter/material.dart';


@immutable
class NavBarItem {

  final IconData? icon;
  final IconData? selectedIcon;
  final String? label;

  const NavBarItem({
    this.icon,
    this.selectedIcon,
    this.label,
  }) : assert(
    icon != null || label != null,
    "NavBarItem: An icon or a label must be provided.",
  );
}
