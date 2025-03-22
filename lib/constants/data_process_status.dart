
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/widgets/large_icon.dart';


enum DataProcessStatus {
  exporting,
  importing,
  errored(Boxicons.bx_error_circle),
  userCancelled(Boxicons.bx_x_circle),
  invalidFile(Boxicons.bx_x_circle),
  done(Boxicons.bx_check_circle),
  unknown(Boxicons.bx_question_mark);

  final IconData? icon;

  const DataProcessStatus([this.icon]);

  bool get canExit => const [
    DataProcessStatus.errored,
    DataProcessStatus.userCancelled,
    DataProcessStatus.done,
    DataProcessStatus.unknown,
  ].contains(this);

  LargeIcon? get largeIconW => icon != null ? LargeIcon(icon) : null;
}
