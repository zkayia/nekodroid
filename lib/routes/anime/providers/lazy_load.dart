
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


final lazyLoadProv = StateProvider.autoDispose.family<int, int>(
  (ref, total) => ref.watch(
    settingsProv.select((v) => v.anime.lazyLoadItemCount),
  ).clamp(0, total),
);
