
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final videoProvider = FutureProvider.autoDispose.family<Uri?, NSEpisode>(
	(ref, episode) => ref.watch(apiProvider).getVideoUrl(episode),
);
