
import 'package:flutter_riverpod/flutter_riverpod.dart';


final isInSearchProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
