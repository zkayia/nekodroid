import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class NavRail extends StatelessWidget {
  final int index;

  const NavRail({required this.index, super.key});

  @override
  Widget build(BuildContext context) => NavigationRail(
        onDestinationSelected: (index) => switch (index) {
          0 => context.go("/library"),
          1 => context.go("/explore"),
          2 => context.go("/more"),
          _ => context.go("/library"),
        },
        selectedIndex: index,
        labelType: NavigationRailLabelType.all,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Symbols.collections_bookmark_rounded),
            label: Text("Bibliothèque"),
          ),
          NavigationRailDestination(
            icon: Icon(Symbols.explore_rounded),
            // FIXME: bugged icon fill on 700 weight
            selectedIcon: Icon(Symbols.explore_rounded, fill: 1, weight: 400),
            label: Text("Explorer"),
          ),
          NavigationRailDestination(
            icon: Icon(Symbols.add_rounded),
            label: Text("Plus"),
          ),
        ],
      );
}
