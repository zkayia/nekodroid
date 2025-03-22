import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/duration.dart';

// TODO: better buffer bar
class ProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Duration? bufferPosition;
  final void Function()? onSeekStart;
  final void Function(Duration position)? onSeekEnd;

  const ProgressBar({
    required this.position,
    required this.duration,
    this.bufferPosition,
    this.onSeekStart,
    this.onSeekEnd,
    super.key,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double _value = 0;
  late Duration _position;
  bool _isChanging = false;

  @override
  void initState() {
    _position = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    setState(() => _position = widget.position);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final labelsStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: kNativePlayerControlsColor,
        );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: screenSize.width,
        maxHeight: screenSize.height * 0.1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: Row(
          children: [
            Text(
              _position.prettyToString(),
              style: labelsStyle,
              maxLines: 1,
            ),
            Expanded(
              child: SliderTheme(
                data: Theme.of(context).sliderTheme.copyWith(
                      trackHeight: 4,
                      inactiveTrackColor: kNativePlayerControlsColor,
                    ),
                child: Slider(
                  divisions: widget.duration.inSeconds == 0 ? null : widget.duration.inSeconds,
                  max: widget.duration.inSeconds.toDouble(),
                  value: _isChanging ? _value : _position.inSeconds.toDouble(),
                  secondaryTrackValue: widget.bufferPosition?.inSeconds.toDouble(),
                  label: (_isChanging ? Duration(seconds: _value.toInt()) : _position).prettyToString(),
                  onChanged: (v) => setState(() => _value = v),
                  onChangeStart: (_) {
                    setState(() => _isChanging = true);
                    widget.onSeekStart?.call();
                  },
                  onChangeEnd: (value) {
                    final position = Duration(seconds: value.toInt());
                    setState(() {
                      _isChanging = false;
                      _position = position;
                    });
                    widget.onSeekEnd?.call(position);
                  },
                ),
              ),
            ),
            Text(
              widget.duration.prettyToString(),
              style: labelsStyle,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
