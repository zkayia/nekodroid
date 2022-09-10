
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekosama/nekosama.dart';


final selectableFiltersProv = StateNotifierProvider.autoDispose<
  _SelectableFiltersProvNotif,
  Set
>(
  (ref) => _SelectableFiltersProvNotif(),
);

class _SelectableFiltersProvNotif extends StateNotifier<Set> {

  _SelectableFiltersProvNotif() : super({});

  bool get hasType => state.any((e) => e is NSTypes);
  bool get hasStatus => state.any((e) => e is NSStatuses);
  bool get hasGenre => state.any((e) => e is NSGenres);

  void add(element) => state = {...state, element};

  void remove(element) => state = {...state.where((e) => e != element)};

  void toggle(element) => state.contains(element)
    ? remove(element)
    : add(element);
  
  void reset() => state = {};
}
