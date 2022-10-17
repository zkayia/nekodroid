
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama/nekosama.dart';


final animeProv = FutureProvider.autoDispose.family<NSAnime, Uri>(
  (ref, animeUrl) => ref.watch(apiProv).getAnime(animeUrl),
);
