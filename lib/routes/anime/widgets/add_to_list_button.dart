
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekosama/nekosama.dart';


class AddToListButton extends ConsumerWidget {

  final NSAnime anime;

  const AddToListButton(this.anime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(listsProv).when(
    error: (_, __) => const Icon(Boxicons.bx_error_circle),
    loading: () => const CircularProgressIndicator(),
    data: (lists) => GenericButton.elevated(
      onPressed: () async {
        final isar = Isar.getInstance()!;
        var isarAnime = isar.isarAnimeListItems.getByUrlSync(anime.url.toString());
        final wasNotInDb = isarAnime == null;
        isarAnime ??= IsarAnimeListItem.fromNSAnime(anime);
        if (!wasNotInDb) {
          isarAnime.episodeStatuses.loadSync();
          isarAnime.lists.loadSync();
        }
        final result = await showDialog<List<int>>(
          context: context,
          builder: (context) => GenericFormDialog.checkbox(
            title: context.tr.addToList,
            elements: [
              GenericFormDialogElement(
                label: context.tr.libraryFavorites,
                value: -1,
                selected: isarAnime!.favoritedTimestamp != null,
              ),
              ...lists.map(
                (e) => GenericFormDialogElement(
                  label: e.name,
                  value: e.id,
                  selected: !wasNotInDb && isarAnime!.lists.any((list) => e.id == list.id),
                ),
              ),
            ],
          ),
        );
        if (result == null || (wasNotInDb && result.isEmpty)) {
          return;
        }
        if (result.contains(-1)) {
          isarAnime.favoritedTimestamp ??= DateTime.now().millisecondsSinceEpoch;
        } else {
          isarAnime.favoritedTimestamp = null;
        }
        // only add and remove actually have effect on the link state
        for (final list in lists) {
          if (result.contains(list.id)) {
            isarAnime.lists.add(list);
          } else {
            isarAnime.lists.remove(list);
          }
        }
        await isar.writeTxn(() async {
          if (isarAnime!.episodeStatuses.isEmpty && result.isEmpty) {
            await isar.isarAnimeListItems.delete(isarAnime.id);
          } else {
            await isar.isarAnimeListItems.put(isarAnime);
            await isarAnime.lists.save();
          }
        });
      },
      child: const Icon(Boxicons.bx_list_plus),
    ),
  );
}
