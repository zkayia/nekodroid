import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekodroid/features/dev_tools/logic/display_dev_tools.dart';

class DevToolsToggle extends ConsumerStatefulWidget {
  final Widget? child;

  const DevToolsToggle({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<DevToolsToggle> createState() => _DevToolsToggleState();
}

class _DevToolsToggleState extends ConsumerState<DevToolsToggle> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          tapCount++;
          if (tapCount == 8) {
            ref.read(displayDevToolsProvider.notifier).on();
            Fluttertoast.showToast(msg: "Dev tools enabled");
          }
        },
        child: widget.child,
      );
}
