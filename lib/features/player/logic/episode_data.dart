import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/api.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/features/player/data/player_route_params.dart';

part 'episode_data.g.dart';

@riverpod
Future<EpisodeDataState> episodeData(EpisodeDataRef ref, PlayerRouteParams params) async {
  final db = ref.watch(dbSqlProvider);
  final animeUrl = params.animeUrl ?? params.anime?.url;
  final query = db.select(db.episodeHistory)
    ..where((tbl) => tbl.animeUrl.equalsValue(animeUrl) & tbl.episodeNumber.equals(params.episode.episodeNumber))
    ..orderBy([(tbl) => OrderingTerm.desc(tbl.time)])
    ..limit(1);
  return EpisodeDataState(
    videoUrls: await ref.watch(apiProvider).getVideoUrls(params.episode.url),
    episodeHistory: await query.getSingleOrNull(),
  );
}

class EpisodeDataState extends Equatable {
  final List<Uri> videoUrls;
  final EpisodeHistoryData? episodeHistory;

  const EpisodeDataState({
    required this.videoUrls,
    this.episodeHistory,
  });

  @override
  List<Object?> get props => [videoUrls, episodeHistory];
}
