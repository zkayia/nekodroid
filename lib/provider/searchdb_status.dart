
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/searchdb_status.dart';


final searchdbStatusProv = StateProvider<SearchdbStatus>(
  (ref) => SearchdbStatus.unknown,
);
