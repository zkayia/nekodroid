import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String errorText;
  final String? actionLabel;
  final IconData? icon;
  final void Function()? onAction;

  const ErrorBanner({
    required this.errorText,
    this.actionLabel,
    this.icon = Symbols.error_outline_rounded,
    this.onAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.th.colorScheme.errorContainer,
        child: Padding(
          padding: EdgeInsets.only(
            left: kPadding,
            right: kPadding,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: context.th.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: kPadding, height: 48),
              ],
              Text(
                errorText,
                style: context.th.textTheme.titleSmall?.copyWith(
                  color: context.th.colorScheme.onErrorContainer,
                ),
              ),
              const Spacer(),
              if (onAction != null && actionLabel != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel ?? ""),
                ),
            ],
          ),
        ),
      );
}
