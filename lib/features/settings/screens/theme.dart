import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsThemeScreen extends ConsumerWidget {
  const SettingsThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        title: const Text("Thème"),
        body: ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            for (final mode in ThemeMode.values)
              RadioListTile(
                title: Text(
                  switch (mode) {
                    ThemeMode.dark => "Sombre",
                    ThemeMode.light => "Clair",
                    ThemeMode.system => "Appareil",
                  },
                ),
                secondary: Icon(
                  switch (mode) {
                    ThemeMode.dark => Symbols.dark_mode_rounded,
                    ThemeMode.light => Symbols.light_mode_rounded,
                    ThemeMode.system => Symbols.smartphone_rounded,
                  },
                ),
                value: mode,
                groupValue: ref.watch(settingsProvider.select((v) => v.themeMode)),
                onChanged: (_) => ref.read(settingsProvider.notifier).setThemeMode(mode),
                splashRadius: kBorderRad,
              ),
          ],
        ),
      );
}
