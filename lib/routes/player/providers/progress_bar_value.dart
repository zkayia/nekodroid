
import 'package:flutter_riverpod/flutter_riverpod.dart';


final progressBarValueProv = StateProvider.autoDispose<double>(
  (ref) => 0,
);
