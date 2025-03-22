
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/data_process_status.dart';


final dataStatusProv = StateProvider.autoDispose<DataProcessStatus>(
  (ref) => DataProcessStatus.unknown,
);
