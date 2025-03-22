
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/double_tap_action.dart';
import 'package:nekodroid/routes/player/providers/player_controls.dart';


class PlayerControlsQuickSkipOverlay extends ConsumerWidget {
  
  const PlayerControlsQuickSkipOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(playerControlsProv.select((v) => v.dtDisplay));
    return display == null
      ? const SizedBox.shrink()
      : Align(
        alignment: display == DoubleTapAction.rewind
          ? Alignment.centerLeft
          : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(
            Size.fromWidth(MediaQuery.of(context).size.width * 0.3),
          ),
          child: Center(
            child: Icon(
              display == DoubleTapAction.rewind
                ? Boxicons.bx_rewind
                : Boxicons.bx_fast_forward,
              color: kNativePlayerControlsColor,
            ),
          ),
        ),
      );
  }
}
