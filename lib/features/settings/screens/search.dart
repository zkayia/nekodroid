import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/core/utils/search_db.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/search/logic/search_db_is_working.dart';
import 'package:nekodroid/features/search/logic/search_db_stats.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:nekodroid/features/settings/widgets/settings_divider.dart';
import 'package:nekodroid/features/settings/widgets/settings_label.dart';
import 'package:nekodroid/features/settings/widgets/settings_title.dart';
import 'package:nekosama/nekosama.dart';

class SettingsSearchScreen extends ConsumerWidget {
  const SettingsSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        title: const Text("Recherche"),
        body: ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            const SettingsTitle("Source"),
            for (final source in NSSources.values)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: CheckboxListTile(
                  title: Text(source.displayName.toUpperCase()),
                  value: ref.watch(settingsProvider.select((v) => v.searchSources.contains(source))),
                  onChanged: (value) => ref.read(settingsProvider.notifier).toggleSearchSource(source, value ?? false),
                ),
              ),
            const SettingsDivider(),
            const SettingsTitle("Base de données"),
            ...[
              ListTile(
                enabled: ref.watch(searchDbIsWorkingProvider.select((v) => !v)),
                onTap: () => SearchDbUtils.updateDb(ref, force: true)
                    .onError((error, stackTrace) => Fluttertoast.showToast(msg: "Echec de la mise à jour"))
                    .then((_) => Fluttertoast.showToast(msg: "Base de données à jour")),
                leading: const Icon(Symbols.refresh_rounded),
                title: const Text("Mettre à jour"),
              ),
              ListTile(
                enabled: ref.watch(searchDbIsWorkingProvider.select((v) => !v)),
                onTap: () => SearchDbUtils.clear(ref)
                    .onError((error, stackTrace) => Fluttertoast.showToast(msg: "Echec de la suppression"))
                    .then((_) => Fluttertoast.showToast(msg: "Base de données vidée")),
                leading: const Icon(Symbols.delete_forever_rounded),
                title: const Text("Vider"),
              ),
              const SizedBox(height: kPadding),
              SettingsLabel(
                "Nombre d'élements: ${ref.watch(searchDbStatsProvider.select((v) => v.valueOrNull?.numberOfAnimes ?? "?"))}",
              ),
              for (final source in NSSources.values)
                SettingsLabel(
                  "Nombre d'élements ${source.displayName}: ${ref.watch(searchDbStatsProvider.select((v) => v.valueOrNull?.numberOfAnimesPerSource[source] ?? "?"))}",
                ),
            ].map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: kPadding), child: e)),
          ],
        ),
      );
}
