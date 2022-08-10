
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final animeProvider = FutureProvider.autoDispose.family<NSAnime, Uri>(
	(ref, animeUrl) {
		final animeCacheBox = Hive.box<String>("anime-cache");
		return animeCacheBox.containsKey(animeUrl.toString())
			? Future.value(NSAnime.fromJson(animeCacheBox.get(animeUrl.toString())!))
			: ref.watch(apiProvider).getAnime(animeUrl);
	},
);
