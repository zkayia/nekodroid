import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => SliverScaffold(
        title: const Text("Paramètres"),
        body: ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            ListTile(
              onTap: () => context.push("/settings/theme"),
              leading: const Icon(Symbols.contrast_rounded),
              trailing: const Icon(Symbols.chevron_right_rounded),
              title: const Text("Thème"),
            ),
            ListTile(
              onTap: () => context.push("/settings/library"),
              leading: const Icon(Symbols.collections_bookmark_rounded),
              trailing: const Icon(Symbols.chevron_right_rounded),
              title: const Text("Bibliothèque"),
            ),
            ListTile(
              onTap: () => context.push("/settings/search"),
              leading: const Icon(Symbols.search_rounded),
              trailing: const Icon(Symbols.chevron_right_rounded),
              title: const Text("Recherche"),
            ),
          ],
        ),
      );
}
