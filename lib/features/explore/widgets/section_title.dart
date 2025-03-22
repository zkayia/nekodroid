import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const SectionTitle({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kBorderRadCirc,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(kPadding / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.th.textTheme.titleMedium.bold(),
                  ),
                ),
                const Icon(Symbols.chevron_right_rounded),
              ],
            ),
          ),
        ),
      );
}
