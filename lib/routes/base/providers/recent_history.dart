
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';


final recentHistoryProv = StreamProvider.autoDispose<List<IsarEpisodeStatus>>(
  (ref) => Isar.getInstance()!.isarEpisodeStatus.filter()
    .lastExitTimestampIsNotNull()
    .sortByLastExitTimestampDesc()
    .watch(fireImmediately: true),
);
