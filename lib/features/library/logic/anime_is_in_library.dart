import 'package:drift/drift.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_is_in_library.g.dart';

@riverpod
Stream<bool> animeIsInLibrary(AnimeIsInLibraryRef ref, Uri url) {
  final db = ref.watch(dbSqlProvider);
  final stream = db.customSelect(
    "SELECT EXISTS (SELECT 1 FROM library_animes WHERE anime_url = ?) AS is_in_library",
    variables: [Variable.withString(url.toString())],
    readsFrom: {db.libraryAnimes},
  ).watchSingle();
  return stream.map((row) => row.read<bool>("is_in_library"));
}
