import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';

class SettingsTitle extends StatelessWidget {
  final String label;

  const SettingsTitle(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: kPadding,
        ),
        child: Text(
          label,
          style: context.th.textTheme.titleSmall.bold(),
        ),
      );
}
