import 'package:nekodroid/core/extensions/episode_history_data.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_progress.g.dart';

@riverpod
Stream<Map<int, double>> episodesProgress(EpisodesProgressRef ref, Uri animeUrl) async* {
  final db = ref.watch(dbSqlProvider);
  final stream = (db.select(db.episodeHistory)..where((tbl) => tbl.animeUrl.equalsValue(animeUrl))).watch();
  await for (final event in stream) {
    yield {
      for (final entry in event) entry.episodeNumber: entry.ratio,
    };
  }
}
