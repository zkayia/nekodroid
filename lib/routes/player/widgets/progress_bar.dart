
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/routes/player/providers/player_controls.dart';
import 'package:nekodroid/routes/player/providers/progress_bar_is_changing.dart';
import 'package:nekodroid/routes/player/providers/progress_bar_value.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


// TODO: buffer bar
class ProgressBar extends ConsumerWidget {

  final Duration position;
  final Duration duration;
  final void Function(Duration newPos)? onSeek;

  const ProgressBar({
    required this.position,
    required this.duration,
    this.onSeek,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final labelsStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: kNativePlayerControlsColor,
    );
    ref.watch(progressBarValueProv);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: screenSize.width,
        maxHeight: screenSize.height * 0.1,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
            child: SingleLineText(
              position.prettyToString(),
              style: labelsStyle,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                trackHeight: 4,
                inactiveTrackColor: kNativePlayerControlsColor,
              ),
              child: Slider(
                divisions: duration.inSeconds == 0 ? null : duration.inSeconds,
                max: duration.inSeconds.toDouble(),
                value: ref.watch(progressBarIsChangingProv)
                  ? ref.watch(progressBarValueProv)
                  : position.inSeconds.toDouble(),
                label: (
                  ref.watch(progressBarIsChangingProv)
                    ? Duration(seconds: ref.watch(progressBarValueProv).toInt())
                    : position
                ).prettyToString(),
                onChanged: (v) => ref.read(progressBarValueProv.notifier).update((_) => v),
                onChangeStart: (_) {
                  ref.read(progressBarIsChangingProv.notifier).update((_) => true);
                  ref.read(playerControlsProv.notifier).isSeeking = true;
                },
                onChangeEnd: (value) {
                  if (onSeek != null) {
                    ref.read(progressBarIsChangingProv.notifier).update((_) => false);
                    onSeek?.call(Duration(seconds: value.toInt()));
                  }
                  ref.read(playerControlsProv.notifier).isSeeking = false;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
            child: SingleLineText(
              duration.prettyToString(),
              style: labelsStyle,
            ),
          ),
        ],
      ),
    );
  }
}
