
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekosama/nekosama.dart';


class AddToListButton extends ConsumerWidget {

  final NSAnime anime;

  const AddToListButton(this.anime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(listsProvider).when(
    error: (_, __) => const Icon(Boxicons.bx_error_circle),
    loading: () => const CircularProgressIndicator(),
    data: (lists) => GenericButton.elevated(
      onPressed: () async {
        final isar = Isar.getInstance()!;
        final isarAnime = await isar.writeTxn<IsarAnimeListItem>(
          () async => (
              await isar.isarAnimeListItems.getByUrl(anime.url.toString())
            ) ?? (
              await isar.isarAnimeListItems.get(
                await isar.isarAnimeListItems.put(IsarAnimeListItem.fromNSAnime(anime)),
              )
            )!,
        );
        await isarAnime.lists.load();
        final result = await showDialog<List<int>>(
          context: context,
          builder: (context) => GenericFormDialog.checkbox(
            title: "Add to list", //TODO: tr
            elements: [
              GenericFormDialogElement(
                label: context.tr.libraryFavorites,
                value: -1,
                selected: isarAnime.favoritedTimestamp != null,
              ),
              ...lists.map(
                (e) => GenericFormDialogElement(
                  label: e.name,
                  value: e.id,
                  selected: isarAnime.lists.contains(e),
                ),
              ),
            ],
          ),
        );
        if (result?.isEmpty ?? true) {
          return;
        }
        if (result!.contains(-1)) {
          isarAnime.favoritedTimestamp ??= DateTime.now().millisecondsSinceEpoch;
        } else {
          isarAnime.favoritedTimestamp = null;
        }
        isarAnime.lists
          ..removeWhere((e) => !result.contains(e.id))
          ..addAll(lists.where((e) => result.contains(e.id)));
        await isar.writeTxn(() async {
          await isar.isarAnimeListItems.put(isarAnime);
          return isarAnime.lists.save();
        });
      },
      child: const Icon(Boxicons.bx_list_plus),
    ),
  );
}
