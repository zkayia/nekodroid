
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/routes/player/players/native/providers/player_controls.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final _valueProvider = StateProvider.autoDispose<double>(
	(ref) => 0,
);

final _isChangingProvider = StateProvider.autoDispose<bool>(
	(ref) => false,
);


/* MISC */




/* WIDGETS */

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
		ref.watch(_valueProvider);
		return ConstrainedBox(
			constraints: BoxConstraints(
				minWidth: screenSize.width,
				maxHeight: screenSize.height * 0.1,
			),
			child: Row(
				children: [
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
						child: SingleLineText.secondary(
							position.prettyToString(),
						),
					),
					Expanded(
						child: SliderTheme(
							data: Theme.of(context).sliderTheme.copyWith(
								trackHeight: 4,
							),
							child: Slider(
								divisions: duration.inSeconds == 0 ? null : duration.inSeconds,
								max: duration.inSeconds.toDouble(),
								value: ref.watch(_isChangingProvider)
									? ref.watch(_valueProvider)
									: position.inSeconds.toDouble(),
								label: (
									ref.watch(_isChangingProvider)
										? Duration(seconds: ref.watch(_valueProvider).toInt())
										: position
								).prettyToString(),
								onChanged: (value) => ref.read(_valueProvider.notifier).update((_) => value),
								onChangeStart: (_) {
									ref.read(_isChangingProvider.notifier).update((_) => true);
									ref.read(playerControlsProvider.notifier).isSeeking = true;
								},
								onChangeEnd: (value) {
									if (onSeek != null) {
										ref.read(_isChangingProvider.notifier).update((_) => false);
										onSeek?.call(Duration(seconds: value.toInt()));
									}
									ref.read(playerControlsProvider.notifier).isSeeking = false;
								},
							),
						),
					),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
						child: SingleLineText.secondary(
							duration.prettyToString(),
						),
					),
				],
			),
		);
	}
}
