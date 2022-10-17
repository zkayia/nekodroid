
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


final navIndexProv = StateProvider.autoDispose<int>(
  (ref) => ref.watch(settingsProv.select((v) => v.general.defaultPage)),
);
