
import 'package:flutter_riverpod/flutter_riverpod.dart';


final progressBarIsChangingProv = StateProvider.autoDispose<bool>(
  (ref) => false,
);
