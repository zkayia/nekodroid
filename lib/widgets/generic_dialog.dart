
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class GenericDialog<T> extends StatelessWidget {

  final String title;
  final Widget? child;
  final T cancelValue;
  final T okValue;
  
  const GenericDialog({
    required this.title,
    required this.child,
    required this.cancelValue,
    required this.okValue,
    super.key,
  });

  const GenericDialog.confirm({
    required this.title,
    required this.child,
    super.key,
  }) :
    cancelValue = false as T,
    okValue = true as T;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: SingleLineText(title),
    titlePadding: const EdgeInsets.only(
      top: kPaddingMain,
      left: kPaddingMain,
      right: kPaddingMain,
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      Row(
        children: [
          Expanded(
            child: GenericButton.text(
              onPressed: () => Navigator.of(context).pop(cancelValue),
              child: const SingleLineText("Cancel"),
            ),
          ),
          const SizedBox(width: kPaddingMain),
          Expanded(
            child: GenericButton.text(
              onPressed: () => Navigator.of(context).pop(okValue),
              primary: true,
              child: const SingleLineText("Ok"),
            ),
          ),
        ],
      )
    ],
    contentPadding: const EdgeInsets.symmetric(
      horizontal: kPaddingMain,
      vertical: kPaddingSecond,
    ),
    content: child,
  );
}
