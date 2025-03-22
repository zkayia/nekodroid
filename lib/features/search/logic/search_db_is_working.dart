import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_db_is_working.g.dart';

@riverpod
class SearchDbIsWorking extends _$SearchDbIsWorking {
  @override
  bool build() => false;

  set working(bool working) => state = working;
  void isWorking() => state = true;
  void isNotWorking() => state = false;
}
