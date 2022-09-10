
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';


final scoreFilterProv = StateNotifierProvider.autoDispose<
  _RangeValuesFiltersProvNotif,
  RangeValues
>(
  (ref) => _RangeValuesFiltersProvNotif(const RangeValues(0, 5)),
);

final popularityFilterProv = StateNotifierProvider.autoDispose<
  _RangeValuesFiltersProvNotif,
  RangeValues
>(
  (ref) {
    final miscBox = Hive.box("misc-data");
    return _RangeValuesFiltersProvNotif(
      RangeValues(
        miscBox.get("searchdb-lowest-popularity"),
        miscBox.get("searchdb-highest-popularity"),
      ),
    );
  },
);

class _RangeValuesFiltersProvNotif extends StateNotifier<RangeValues> {

  final RangeValues initial;

  _RangeValuesFiltersProvNotif(this.initial) : super(initial);

  bool get hasChanged => state != initial;

  void updateValue(RangeValues value) => state = value;
  
  void reset() => state = initial;
}
