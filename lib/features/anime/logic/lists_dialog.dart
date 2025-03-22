import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/features/library/logic/library_lists.dart';
import 'package:nekodroid/features/library/logic/lists_anime_is_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lists_dialog.g.dart';

@riverpod
class ListsDialog extends _$ListsDialog {
  @override
  Future<ListsDialogState> build(Uri animeUrl) async => ListsDialogState(
        libraryLists: await ref.watch(libraryListsProvider.future),
        libraryListsAnimeIsIn: await ref.watch(listsAnimeIsInProvider(animeUrl).future),
      );

  Future<void> applyChanges(Map<LibraryList, bool> changes) async {
    final List<LibraryList> listsAnimeIsIn =
        state.valueOrNull?.libraryListsAnimeIsIn ?? await ref.watch(listsAnimeIsInProvider(animeUrl).future);
    final toAdd = changes.keys.where((e) => (changes[e] ?? false) && !listsAnimeIsIn.contains(e)).map((e) => e.name);
    final toRemove = changes.keys.where((e) => changes[e] == false && listsAnimeIsIn.contains(e)).map((e) => e.name);

    final db = ref.read(dbSqlProvider);
    db.batch((batch) {
      batch.insertAll(
        db.libraryAnimes,
        toAdd.map((e) => LibraryAnimesCompanion.insert(list: e, animeUrl: animeUrl, addedAt: DateTime.now())),
      );
      batch.deleteWhere(db.libraryAnimes, (tbl) => tbl.animeUrl.equalsValue(animeUrl) & tbl.list.isIn(toRemove));
    });
  }
}

class ListsDialogState extends Equatable {
  final List<LibraryList> libraryLists;
  final List<LibraryList> libraryListsAnimeIsIn;

  const ListsDialogState({
    required this.libraryLists,
    required this.libraryListsAnimeIsIn,
  });

  @override
  List<Object?> get props => [libraryLists, libraryListsAnimeIsIn];
}
