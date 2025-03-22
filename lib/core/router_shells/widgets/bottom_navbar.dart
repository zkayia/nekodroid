import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class BottomNavbar extends StatelessWidget {
  final int index;

  const BottomNavbar({required this.index, super.key});

  @override
  Widget build(BuildContext context) => NavigationBar(
        onDestinationSelected: (index) => switch (index) {
          0 => context.go("/library"),
          1 => context.go("/explore"),
          2 => context.go("/more"),
          _ => context.go("/library"),
        },
        selectedIndex: index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Symbols.collections_bookmark_rounded),
            label: "Bibliothèque",
          ),
          NavigationDestination(
            icon: Icon(Symbols.explore_rounded),
            // FIXME: bugged icon fill on 700 weight
            selectedIcon: Icon(Symbols.explore_rounded, fill: 1, weight: 400),
            label: "Explorer",
          ),
          NavigationDestination(
            icon: Icon(Symbols.add_rounded),
            label: "Plus",
          ),
        ],
      );
}
