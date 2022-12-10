
import 'package:flutter/material.dart';


@immutable
class NavBarItem {

  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  const NavBarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}
