import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';

class SettingsLibraryScreen extends StatelessWidget {
  const SettingsLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) => SliverScaffold(
        title: const Text("Bibliothèque"),
        body: ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            ListTile(
              onTap: () => context.push("/settings/library/lists"),
              leading: const Icon(Symbols.list_rounded),
              trailing: const Icon(Symbols.chevron_right_rounded),
              title: const Text("Modifier les listes"),
            ),
          ],
        ),
      );
}
