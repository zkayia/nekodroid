
import 'dart:convert';
import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/data_process_status.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/int.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/data/providers/data_status.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/list_tile_icon.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';


class DataRoute extends ConsumerWidget {

  const DataRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
    onExitTap: (_) async => ref.read(dataStatusProv).canExit,
    hideExitFab: !ref.watch(dataStatusProv).canExit,
    body: Stack(
      fit: StackFit.expand,
      children: [
        SliverTitleScrollview.list(
          title: context.tr.backupRestore,
          children: [
            ListTile(
              title: Text(context.tr.warning),
              subtitle: Text(context.tr.backupRestoreWarning),
              leading: const ListTileIcon(Boxicons.bx_error),
            ),
            Row(
              children: [
                Expanded(
                  child: GenericButton.text(
                    onPressed: () => _backup(ref),
                    child: SingleLineText(context.tr.backup),
                  ),
                ),
                const SizedBox(width: kPaddingMain),
                Expanded(
                  child: GenericButton.text(
                    onPressed: () => _restore(ref),
                    child: SingleLineText(context.tr.restore),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (ref.watch(dataStatusProv) != DataProcessStatus.unknown)
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.5),
              child: InkWell(
                onTap: () {
                  if (ref.read(dataStatusProv).canExit) {
                    ref.invalidate(dataStatusProv);
                  }
                },
                child: Center(
                  child: ref.watch(dataStatusProv).largeIconW
                    ?? const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Future<Map<String, dynamic>> _buildBackupData(WidgetRef ref) async {
    final data = <String, dynamic>{};
    final isar = Isar.getInstance()!;
    final animes = await isar.isarAnimeListItems.where().exportJson();
    if (animes.isNotEmpty) {
      data["animes"] = animes;
    }
    final eps = await isar.isarEpisodeStatus.where().findAll();
    if (eps.isNotEmpty) {
      data["episodes"] = {};
      for (final ep in eps) {
        await ep.anime.load();
        final url = ep.anime.value?.url ?? "null";
        if (data["episodes"].containsKey(url)) {
          data["episodes"][url].add(ep.toMap());
        } else {
          data["episodes"][url] = [ep.toMap()];
        }
      }
    }
    final listsQuery = isar.isarAnimeLists.where();
    final listsJson = await listsQuery.exportJson();
    final lists = await listsQuery.findAll();
    if (lists.isNotEmpty && listsJson.isNotEmpty) {
      for (final listJson in listsJson) {
        final list = lists.firstWhere((e) => e.id == listJson["id"]);
        await list.animes.load();
        listJson["animes"] = list.animes.map((e) => e.url).toList();
      }
      data["lists"] = listsJson;
    }
    final recentSearches = Hive.box("misc-data").get("recent-searches") as List?;
    if (recentSearches != null) {
      data["recent-searches"] = (
        await isar.isarSearchAnimes.getAll(recentSearches.cast<int>())
      ).whereType<IsarSearchAnime>().map((e) => e.url).toList();
    }
    await ref.read(settingsProv.notifier).saveToHive();
    data["settings"] = Hive.box("settings").toMap();
    return data;
  }

  void _backup(WidgetRef ref) async {
    try {
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.exporting);
      final data = const JsonEncoder.withIndent("  ").convert(
        await _buildBackupData(ref),
      );
      final now = DateTime.now();
      final result = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          data: Uint8List.fromList(data.codeUnits),
          fileName: "nekodroid_${
            now.year.toPaddedString(4)
          }-${
            now.month.toPaddedString()
          }-${
            now.day.toPaddedString()
          }_${
            now.hour.toPaddedString()
          }-${
            now.minute.toPaddedString()
          }",
          mimeTypesFilter: ["application/json"],
        ),
      );
      ref.read(dataStatusProv.notifier).update(
        (_) => result == null
          ? DataProcessStatus.userCancelled
          : DataProcessStatus.done,
      );
    } on Exception {
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.errored);
      // ignore: avoid_catching_errors
    } on Error { // json convert throws JsonUnsupportedObjectError
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.errored);
    }
  }

  Future<void> _restoreData(String jsonData) async {
    final data = jsonDecode(jsonData);
    final isar = Isar.getInstance()!;
    if (data["animes"] != null) {
      await isar.isarAnimeListItems.importJson(data["animes"]);
    }
    if (data["episodes"] != null) {
      await isar.writeTxn(() async {
        for (final entry in data["episodes"].entries) {
          final anime = await isar.isarAnimeListItems.getByUrl(entry.key);
          if (anime == null) {
            continue;
          }
          await anime.episodeStatuses.load();
          anime.episodeStatuses.addAll(entry.value.map(IsarEpisodeStatus.fromMap));
          await anime.episodeStatuses.save();
        }
      });
    }
    if (data["lists"] != null) {
      await isar.writeTxn(() async {
        for (final list in data["lists"]) {
          var isarList = await isar.isarAnimeLists
            .filter()
            .nameEqualTo(list["name"])
            .findFirst();
          await isarList?.animes.load();
          if (isarList == null) {
            isarList = IsarAnimeList(position: list["position"], name: list["name"]);
            await isar.isarAnimeLists.put(isarList);
          }
          isarList.animes.addAll(
            [
              ...await isar.isarAnimeListItems.getAllByUrl(list["animes"])
            ].whereType<IsarAnimeListItem>(),
          );
          await isarList.animes.save();
        }
      });
    }
    if (data["recent-searches"] != null) {
      await Hive.box("misc-data").put(
        "recent-searches",
        [
          for (final url in data["recent-searches"])
            (await isar.isarSearchAnimes.filter().urlEqualTo(url).findFirst())?.id
        ].whereType<int>().toList(),
      );
    }
    if (data["settings"] != null) {
      await Hive.box("settings").putAll(data["settings"]);
    }

  }

  void _restore(WidgetRef ref) async {
    try {
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.importing);
      final filePath = await FlutterFileDialog.pickFile(
        params: const OpenFileDialogParams(
          mimeTypesFilter: ["application/json"],
          fileExtensionsFilter: ["json"],
          dialogType: OpenFileDialogType.document,
        ),
      );
      if (filePath == null) {
        ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.userCancelled);
        return;
      }
      await _restoreData(await File(filePath).readAsString());
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.done);
    } on PlatformException catch (err) {
      ref.read(dataStatusProv.notifier).update(
        (_) => err.code == "invalid_file_extension"
          ? DataProcessStatus.invalidFile
          : DataProcessStatus.errored,
      );
    } on Exception {
      ref.read(dataStatusProv.notifier).update((_) => DataProcessStatus.errored);
    }
  }
}
