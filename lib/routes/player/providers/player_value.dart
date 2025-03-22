
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/models/player_value.dart';


final playerValueProv = StateProvider.autoDispose<PlayerValue?>(
  (ref) => null,
);
