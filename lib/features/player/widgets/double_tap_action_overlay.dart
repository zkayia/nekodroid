import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/features/player/data/double_tap_action.dart';

class DoubleTapActionOverlay extends StatelessWidget {
  final DoubleTapAction action;

  const DoubleTapActionOverlay(this.action, {super.key});

  @override
  Widget build(BuildContext context) => Align(
        alignment: switch (action) {
          DoubleTapAction.rewind => Alignment.centerLeft,
          DoubleTapAction.forward => Alignment.centerRight,
        },
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.fromWidth(MediaQuery.of(context).size.width * 0.3)),
          child: Center(
            child: Icon(
              switch (action) {
                DoubleTapAction.rewind => Symbols.fast_rewind_rounded,
                DoubleTapAction.forward => Symbols.fast_forward_rounded,
              },
              fill: 1,
              color: kNativePlayerControlsColor,
            ),
          ),
        ),
      );
}
