
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class GenericToastText extends StatelessWidget {

  final String text;

  const GenericToastText(
    this.text,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMain,
        vertical: kPaddingSecond,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}
