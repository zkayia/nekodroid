
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final historyProvider = StateNotifierProvider<_HistoryProviderNotifier, Box<Map>>(
  (ref) => _HistoryProviderNotifier(Hive.box<Map>("history")),
);

class _HistoryProviderNotifier extends StateNotifier<Box<Map>> {

  final _recentHistoryBox = Hive.box<String>("recent-history");
  final _animeCacheBox = Hive.box<String>("anime-cache");
  final _favoritesBox = Hive.box<int>("favorites");
  
  _HistoryProviderNotifier(Box<Map> initialState) : super(initialState);

  @override
  bool updateShouldNotify(Box<Map> old, Box<Map> current) => true;

  Future<bool> addEntry(
    String animeJson,
    NSEpisode episode,
    int completedTimestamp,
  ) async {
    final animeUrl = episode.animeUrl.toString();
    final current = state.get(animeUrl)?.cast<int, int>() ?? {};
    if (current.containsKey(episode.episodeNumber)) {
      return false;
    }
    current[episode.episodeNumber] = completedTimestamp;
    // will break on: `2106-02-07 07:28:15.000`
    await _recentHistoryBox.put(completedTimestamp ~/ 1000, episode.toJson());
    await _updateWith(animeUrl, animeJson, current);
    return true;
  }

  Future<bool> removeEntry(
    String animeJson,
    NSEpisode episode,
  ) async {
    final animeUrl = episode.animeUrl.toString();
    final current = state.get(animeUrl)?.cast<int, int>() ?? {};
    if (!current.containsKey(episode.episodeNumber)) {
      return false;
    }
    // will break on: `2106-02-07 07:28:15.000`
    await _recentHistoryBox.delete(current[episode.episodeNumber]! ~/ 1000);
    current.remove(episode.episodeNumber);
    await _updateWith(animeUrl, animeJson, current);
    return true;
  }

  Future<bool> toggleEntry(
    String animeJson,
    NSEpisode episode,
    int completedTimestamp,
  ) => state.get(
    episode.animeUrl.toString(),
  )?.cast<int, int>().containsKey(episode.episodeNumber) ?? false
      ? removeEntry(animeJson, episode)
      : addEntry(animeJson, episode, completedTimestamp);
    // await _recentHistoryBox.delete(
    //     _recentHistoryBox.toMap().entries.firstWhere(
    //     (element) => element.value == episodeJson,
    //     orElse: () => const MapEntry(null, ""),
    //   ).key,
    // );

  Future<void> _updateWith(String animeUrl, String animeJson, Map<int, int> data) async {
    if (data.isNotEmpty) {
      await _animeCacheBox.put(animeUrl, animeJson);
      await state.put(animeUrl, data);
    } else {
      if (!_favoritesBox.containsKey(animeUrl)) {
        await _animeCacheBox.delete(animeUrl);
      }
      await state.delete(animeUrl);
    }
    state = state;
  }
}
