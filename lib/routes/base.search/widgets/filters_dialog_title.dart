
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


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
    padding: const EdgeInsets.only(
      top: kPaddingMain,
      bottom: kPaddingSecond,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleLineText(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SingleLineText(infoText),
      ],
    ),
  );
}
