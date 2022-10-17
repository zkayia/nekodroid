
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


final blurThumbsProv = StateProvider.autoDispose<bool>(
  (ref) => ref.watch(settingsProv.select((v) => v.anime.blurThumbs)),
);
