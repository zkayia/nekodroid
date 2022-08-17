

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/api.dart';

final homeProvider = FutureProvider(
  (ref) async => ref.watch(apiProvider).getHome(),
);
