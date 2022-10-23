
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class GenericDialog<T> extends StatelessWidget {

  final bool isConfirm;
  final String title;
  final Widget? child;
  final T? Function(BuildContext context)? onConfirm;
  final T? Function(BuildContext context)? onCancel;
  final bool canAbortConfirm;
  final dynamic confirmAbortValue;
  
  const GenericDialog({
    required this.title,
    required this.child,
    required this.onConfirm,
    this.onCancel,
    this.canAbortConfirm=true,
    this.confirmAbortValue,
    super.key,
  }) : isConfirm = false;

  const GenericDialog.confirm({
    required this.title,
    required this.child,
    super.key,
  }) :
    isConfirm = true,
    onCancel = null,
    onConfirm = null,
    canAbortConfirm = false,
    confirmAbortValue = null;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(title),
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
              onPressed: () => Navigator.of(context).pop(
                isConfirm ? false : onCancel?.call(context),
              ),
              child: SingleLineText(context.tr.cancel),
            ),
          ),
          const SizedBox(width: kPaddingMain),
          Expanded(
            child: GenericButton.text(
              onPressed: () {
                final onConfirmCall = onConfirm?.call(context);
                if (
                  onConfirm != null
                  && canAbortConfirm
                  && onConfirmCall == confirmAbortValue
                ) {
                  return;
                }
                Navigator.of(context).pop(isConfirm ? true : onConfirmCall);
              },
              primary: true,
              child: SingleLineText(context.tr.ok),
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
