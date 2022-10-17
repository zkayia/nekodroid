
import 'package:flutter_riverpod/flutter_riverpod.dart';


final lastTextQueryProv = StateProvider.autoDispose<String?>(
  (ref) => null,
);
