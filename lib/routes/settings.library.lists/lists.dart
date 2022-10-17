
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/switch_setting.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/generic_input_dialog.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class SettingsLibraryListsRoute extends ConsumerWidget {

  const SettingsLibraryListsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isar = Isar.getInstance()!;
    return GenericRoute(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingSecond,
          vertical: kPaddingMain,
        ),
        child: Column(
          children: [
            // TODO: desc for lib & hist
            SwitchSetting(
              title: context.tr.libraryHistory,
              value: ref.watch(settingsProv.select((v) => v.library.enableHistory)),
              onChanged: (v) => ref.read(settingsProv.notifier).enableHistory = v,
            ),
            SwitchSetting(
              title: context.tr.libraryFavorites,
              value: ref.watch(settingsProv.select((v) => v.library.enableFavorites)),
              onChanged: (v) => ref.read(settingsProv.notifier).enableFavorites = v,
            ),
            const Divider(),
            ref.watch(listsProv).when(
              error: (_, __) => const LabelledIcon.vertical(
                icon: LargeIcon(Boxicons.bx_error_circle),
                label: "Error loading lists", //TODO: tr
              ),
              loading: () => const LabelledIcon.vertical(
                icon: CircularProgressIndicator(),
                label: "Loading lists", //TODO: tr
              ),
              data: (data) => data.isEmpty
                ? const SizedBox()
                : ReorderableListView(
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    isar.writeTxn(() async {
                      final current = await isar.isarAnimeLists
                        .filter()
                        .positionEqualTo(oldIndex)
                        .findFirst();
                      final lists = await isar.isarAnimeLists
                        .filter()
                        .positionBetween(
                          min(oldIndex, newIndex),
                          max(oldIndex, newIndex),
                          includeLower: oldIndex > newIndex,
                          includeUpper: oldIndex < newIndex,
                        )
                        .sortByPosition()
                        .findAll();
                      if (current != null) {
                        current.position = newIndex;
                        await isar.isarAnimeLists.put(current);
                      }
                      for (final list in lists) {
                        list.position = list.position + (
                          oldIndex > newIndex ? 1 : -1
                        );
                      }
                      await isar.isarAnimeLists.putAll(lists);
                    });
                  },
                  children: [
                    ...data.map(
                      (e) => ListTile(
                        key: ValueKey(e.id),
                        onTap: () async {
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => GenericInputDialog(
                              title: "Edit list", //TODO: tr
                              hintText: "List name", //TODO: tr
                              initialText: e.name,
                              validator: (v, c) => _listNameValidator(v, c, ref),
                            ),
                          );
                          if (result != null) {
                            await isar.writeTxn(
                              () {
                                e.name = result;
                                return isar.isarAnimeLists.put(e);
                              },
                            );
                          }
                        },
                        title: Text(e.name),
                        trailing: const Icon(Boxicons.bx_expand_vertical),
                        leading: IconButton(
                          icon: const Icon(Boxicons.bx_x),
                          onPressed: () => showDialog<bool>(
                            context: context,
                            builder: (context) => GenericDialog.confirm(
                              title: "Delete list", //TODO: tr
                              child: Text("Delete list '${e.name}' ?"), //TODO: tr
                            ),
                          ).then(
                            (value) {
                              if (value ?? false) {
                                isar.writeTxn(
                                  () => isar.isarAnimeLists.delete(e.id),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            ListTile(
              onTap: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => GenericInputDialog(
                    title: "Create a new list", //TODO: tr
                    hintText: "List name", //TODO: tr
                    validator: (v, c) => _listNameValidator(v, c, ref),
                  ),
                );
                if (result != null) {
                  final lastList = await isar.isarAnimeLists
                    .buildQuery<IsarAnimeList>(
                      limit: 1,
                      sortBy: const [
                        SortProperty(property: "position", sort: Sort.desc),
                      ],
                    )
                    .findFirst();
                  await isar.writeTxn(
                    () => isar.isarAnimeLists.put(
                      IsarAnimeList(
                        position: (lastList?.position ?? -1) + 1,
                        name: result,
                      ),
                    ),
                  );
                }
              },
              title: const Text("Create a new list"), //TODO: tr
              leading: const Icon(Boxicons.bx_plus),
            ),
          ],
        ),
      ),
    );
  }

  String? _listNameValidator(String? value, BuildContext context, WidgetRef ref) {
    if (value == null) {
      return "Invalid list name"; //TODO: tr
    } else if (value.isEmpty) {
      return "List name can't be empty"; //TODO: tr
    } else if (
      ref.read(listsProv).asData?.value.any(
        (e) => e.name == value,
      ) ?? false
    ) {
      return "List '$value' already exists"; //TODO: tr
    }
    return null;
  }
}
