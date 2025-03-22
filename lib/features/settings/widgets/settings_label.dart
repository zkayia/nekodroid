import 'package:flutter/material.dart';
import 'package:nekodroid/core/extensions/build_context.dart';

class SettingsLabel extends StatelessWidget {
  final String label;

  const SettingsLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: context.th.textTheme.labelLarge,
        ),
      );
}
