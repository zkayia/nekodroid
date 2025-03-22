import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';

class FiltersDialogTitle extends StatelessWidget {
  final String text;
  final String infoText;

  const FiltersDialogTitle({
    required this.text,
    required this.infoText,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(infoText),
          ],
        ),
      );
}
