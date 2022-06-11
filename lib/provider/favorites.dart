
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final favoritesProvider = StateNotifierProvider.autoDispose<
	_FavoritesProviderNotifier,
	Map<Uri, int>
>(
	(ref) => _FavoritesProviderNotifier(Hive.box<int>("favorites")),
);

class _FavoritesProviderNotifier extends StateNotifier<Map<Uri, int>> {
	
	final Box<int> _favsBox;
	final _recentHistoryBox = Hive.box<String>("recent-history");
	final _animeCacheBox = Hive.box<String>("anime-cache");

	_FavoritesProviderNotifier(this._favsBox) : super(
		_favsBox.toMap().cast<String, int>().map(
			(key, value) => MapEntry(Uri.parse(key), value),
		),
	);

	@override
	bool updateShouldNotify(Map<Uri, int> old, Map<Uri, int> current) => true;

	bool isFavoritedBox(Uri url) => _favsBox.containsKey(url.toString());

	Future<void> toggleFav(Uri url, DateTime addedAt, NSAnime anime) async {
		final timestamp = addedAt.millisecondsSinceEpoch;
		await _boxUpdate(url.toString(), timestamp, anime);
		state = {
			if (!state.containsKey(url))
				...{
					...state,
					url: timestamp,
				}
			else
				for (final entry in state.entries)
					if (entry.key != url)
						entry.key: entry.value,
		};
	}

	Future<void> toggleFavBoxOnly(Uri url, DateTime addedAt, NSAnime anime) async {
		// will break on: `2106-02-07 07:28:15.000`
		await _boxUpdate(url.toString(), addedAt.millisecondsSinceEpoch, anime);
		state = state;
	}

	Future<void> _boxUpdate(String urlString, int addedAtTimestamp, NSAnime anime) async {
		if (_favsBox.containsKey(urlString)) {
			if (!_recentHistoryBox.containsKey(urlString)) {
				await _animeCacheBox.delete(anime.id);
			}
			return _favsBox.delete(urlString);
		}
		_animeCacheBox.put(anime.id, anime.toJson());
		return _favsBox.put(urlString, addedAtTimestamp);
	}
}
