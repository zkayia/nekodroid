import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:nekodroid/features/search/logic/search_query.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_results.g.dart';

@riverpod
Stream<List<SearchAnime>> searchResults(SearchResultsRef ref, SearchFiltersState? initialFilters) {
  final query = ref.read(searchQueryProvider);
  final filters = ref.read(searchFiltersProvider(initialFilters));
  final db = ref.read(dbSqlProvider);
  final dbQuery = db.select(db.searchAnimes);

  if (query?.isNotEmpty ?? false) {
    dbQuery.where((tbl) => tbl.title.contains(query!));
  }
  if (filters.sources.isNotEmpty) {
    dbQuery.where((tbl) => tbl.source.isIn(filters.sources.map((e) => e.name)));
  }
  if (filters.types.isNotEmpty) {
    dbQuery.where((tbl) => tbl.type.isIn(filters.types.map((e) => e.name)));
  }
  if (filters.statuses.isNotEmpty) {
    dbQuery.where((tbl) => tbl.status.isIn(filters.statuses.map((e) => e.name)));
  }
  for (final genre in filters.genres) {
    dbQuery.where((tbl) => tbl.genres.contains(genre.apiName));
  }
  if (filters.score != null) {
    dbQuery.where((tbl) => tbl.score.isBetweenValues(filters.score!.start, filters.score!.end));
  }
  if (filters.popularity != null) {
    dbQuery.where((tbl) => tbl.popularity.isBetweenValues(filters.popularity!.start, filters.popularity!.end));
  }
  dbQuery.orderBy([(tbl) => OrderingTerm.desc(tbl.score), (tbl) => OrderingTerm.desc(tbl.popularity)]);

  return dbQuery.watch();
}
