
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class SliderSetting extends StatelessWidget {
  
  final String title;
  final String? subtitle;
  final String? label;
  final String? minLabel;
  final String? maxLabel;
  final num value;
  final num min;
  final num max;
  final num? steps;
  final bool enabled;
  final void Function(double v)? onChanged;

  const SliderSetting({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.subtitle,
    this.label,
    this.minLabel,
    this.maxLabel,
    this.steps,
    this.enabled=true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = enabled ? null : Theme.of(context).disabledColor;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingSecond,
        vertical: kPaddingSecond,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title * 2,
                  style: textTheme.subtitle1?.apply(color: textColor),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: kPaddingSecond),
              SingleLineText(value.toString()),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: textTheme.bodyText2?.apply(color: textColor),
              overflow: TextOverflow.clip,
            ),
          const SizedBox(height: kPaddingSecond),
          Row(
            children: [
              SingleLineText(
                minLabel ?? min.toString(),
                style: textTheme.bodyText2?.apply(color: textColor),
              ),
              Expanded(
                child: Slider(
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: steps == null ? null : (max - min) ~/ steps!,
                  value: value.toDouble(),
                  label: label,
                  onChanged: enabled ? onChanged : null,
                ),
              ),
              SingleLineText(
                "${maxLabel ?? max}",
                style: textTheme.bodyText2?.apply(color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
