import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekosama/nekosama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_db_stats.g.dart';

@riverpod
Stream<SearchDbStatsState> searchDbStats(SearchDbStatsRef ref) {
  final db = ref.read(dbSqlProvider);
  final columns = [
    countAll(),
    for (final source in NSSources.values) db.searchAnimes.source.count(filter: db.searchAnimes.source.equalsValue(source)),
  ];
  final query = db.searchAnimes.selectOnly()..addColumns(columns);
  return query
      .map(
        (row) => SearchDbStatsState(
          numberOfAnimes: row.read(columns.first),
          numberOfAnimesPerSource: {
            for (int i = 1; i < NSSources.values.length + 1; i++)
              NSSources.values.elementAt(i - 1): row.read(columns.elementAt(i)),
          },
        ),
      )
      .watchSingle();
}

class SearchDbStatsState extends Equatable {
  final int? numberOfAnimes;
  final Map<NSSources, int?> numberOfAnimesPerSource;

  const SearchDbStatsState({
    required this.numberOfAnimes,
    required this.numberOfAnimesPerSource,
  });

  @override
  List<Object?> get props => [numberOfAnimes, numberOfAnimesPerSource];
}
