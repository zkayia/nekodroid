
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


final navIndexProvider = StateProvider.autoDispose<int>(
	(ref) => ref.watch(settingsProvider.select((value) => value.defaultPage)),
);
