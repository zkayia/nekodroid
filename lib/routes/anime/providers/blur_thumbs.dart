
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


final blurThumbsProvider = StateProvider.autoDispose<bool>(
  (ref) => ref.watch(settingsProvider.select((value) => value.blurThumbs)),
);
