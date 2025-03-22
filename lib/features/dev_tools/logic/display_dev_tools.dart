import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'display_dev_tools.g.dart';

@riverpod
class DisplayDevTools extends _$DisplayDevTools {
  @override
  bool build() => kDebugMode;

  void on() {
    state = true;
    ref.keepAlive();
  }
}
