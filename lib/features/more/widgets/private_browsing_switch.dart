import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';

class PrivateBrowsingSwitch extends ConsumerWidget {
  const PrivateBrowsingSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SwitchListTile(
        value: ref.watch(settingsProvider.select((v) => v.privateBrowsingEnabled)),
        onChanged: (value) => ref.read(settingsProvider.notifier).setPrivateBrowsingEnabled(value),
        secondary: const Icon(Symbols.domino_mask_rounded),
        title: const Text("Navigation privée"),
        subtitle: const Text("Met en pause l'historique"),
      );
}
