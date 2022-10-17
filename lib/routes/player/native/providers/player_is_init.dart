
import 'package:flutter_riverpod/flutter_riverpod.dart';


final playerIsInitProv = StateProvider.autoDispose<bool>(
  (ref) => false,
);
