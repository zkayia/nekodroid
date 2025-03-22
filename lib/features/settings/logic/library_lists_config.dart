import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';

part 'library_lists_config.g.dart';

@riverpod
class LibraryListsConfig extends _$LibraryListsConfig {
  @override
  Future<List<SelectableLibraryList>> build() async {
    final db = ref.watch(dbSqlProvider);
    final query = db.libraryLists.select()..orderBy([(tbl) => OrderingTerm.asc(tbl.position)]);
    return (await query.get()).map(SelectableLibraryList.fromLibraryList).toList();
  }

  Future<void> saveToDb() async {
    final value = state.valueOrNull;
    if (value != null) {
      final db = ref.read(dbSqlProvider);
      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.libraryLists,
          [for (int i = 0; i < value.length; i++) value.elementAt(i).toLibraryList(i)],
        );
        batch.deleteWhere(db.libraryLists, (tbl) => tbl.name.isNotIn(value.map((e) => e.name)));
      });
    }
  }

  void addList(String name) {
    final value = state.valueOrNull;
    if (value != null) {
      state = AsyncValue.data([...value, SelectableLibraryList(name: name)]);
    }
  }

  void setSelected(int index, bool selected) {
    final value = state.valueOrNull;
    if (value != null) {
      state = AsyncValue.data([
        for (int i = 0; i < value.length; i++)
          if (i == index) value[i].copyWith(selected: selected) else value[i],
      ]);
    }
  }

  void deleteSelected() {
    final value = state.valueOrNull;
    if (value != null) {
      state = AsyncValue.data([...value.where((e) => !e.selected)]);
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final value = state.valueOrNull;
    if (value != null) {
      final lists = [...value];
      lists.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, lists.removeAt(oldIndex));
      state = AsyncValue.data(lists);
    }
  }
}

class SelectableLibraryList extends Equatable {
  final String name;
  final bool selected;

  const SelectableLibraryList({
    required this.name,
    this.selected = false,
  });

  factory SelectableLibraryList.fromLibraryList(LibraryList list) => SelectableLibraryList(name: list.name);

  @override
  List<Object?> get props => [name, selected];

  SelectableLibraryList copyWith({
    String? name,
    bool? selected,
  }) =>
      SelectableLibraryList(
        name: name ?? this.name,
        selected: selected ?? this.selected,
      );

  LibraryList toLibraryList(int position) => LibraryList(name: name, position: position);
}
