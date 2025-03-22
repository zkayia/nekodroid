
import 'package:flutter_riverpod/flutter_riverpod.dart';


final playerErrorsProv = StateProvider.autoDispose<List<String>>(
  (ref) => <String>[],
);
