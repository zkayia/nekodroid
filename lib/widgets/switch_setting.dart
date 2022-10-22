
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class SwitchSetting extends StatelessWidget {
  
  final String title;
  final String? subtitle;
  final bool value;
  final bool enabled;
  final void Function(bool v)? onChanged;

  const SwitchSetting({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled=true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: kPaddingSecond,
    ),
    title: SingleLineText(title),
    subtitle: subtitle == null
      ? null
      : Text(
        subtitle!,
        overflow: TextOverflow.clip,
      ),
    isThreeLine: (subtitle?.length ?? 0) > 46,
    value: value,
    onChanged: enabled ? onChanged : null,
  );
}
