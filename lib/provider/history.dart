
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

	Future<void> toggleEntry(
		String animeJson,
		NSEpisode episode,
		int completedTimestamp,
	) async {
		final animeUrl = episode.animeUrl.toString();
		final episodeJson = episode.toJson();
		Map<int, int> current = state.get(animeUrl)?.cast<int, int>() ?? {};
		if (current.remove(episode.episodeNumber) == null) {
			current[episode.episodeNumber] = completedTimestamp;
			// will break on: `2106-02-07 07:28:15.000`
			await _recentHistoryBox.put(completedTimestamp ~/ 1000, episodeJson);
		} else {
			await _recentHistoryBox.delete(
					_recentHistoryBox.toMap().entries.firstWhere(
					(element) => element.value == episodeJson,
					orElse: () => const MapEntry(null, ""),
				).key,
			);
		}
		if (current.isNotEmpty) {
			await _animeCacheBox.put(animeUrl, animeJson);
			await state.put(animeUrl, current);
		} else {
			if (!_favoritesBox.containsKey(animeUrl)) {
				await _animeCacheBox.delete(animeUrl);
			}
			await state.delete(animeUrl);
		}
		state = state;
	} 
}
