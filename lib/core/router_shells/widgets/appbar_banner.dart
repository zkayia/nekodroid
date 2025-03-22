import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';

class AppbarBanner extends StatelessWidget {
  final String label;
  final String? actionLabel;
  final Widget? icon;
  final void Function()? onTap;
  final void Function()? onAction;
  final _BannerType _type;

  const AppbarBanner.primary({
    required this.label,
    this.actionLabel,
    this.icon,
    this.onTap,
    this.onAction,
    super.key,
  }) : _type = _BannerType.primary;

  const AppbarBanner.error({
    required this.label,
    this.actionLabel,
    this.icon,
    this.onTap,
    this.onAction,
    super.key,
  }) : _type = _BannerType.error;

  @override
  Widget build(BuildContext context) {
    final noAction = onAction == null && actionLabel == null;
    final background = switch (_type) {
      _BannerType.primary => context.th.colorScheme.primary,
      _BannerType.error => context.th.colorScheme.errorContainer,
    };
    final onBackground = switch (_type) {
      _BannerType.primary => context.th.colorScheme.onPrimary,
      _BannerType.error => context.th.colorScheme.onErrorContainer,
    };

    final text = Text(
      label,
      style: context.th.textTheme.titleSmall?.copyWith(color: onBackground),
      textAlign: noAction ? TextAlign.center : null,
    );
    final body = ColoredBox(
      color: background,
      child: Padding(
        padding: EdgeInsets.only(
          left: kPadding,
          right: kPadding,
          top: MediaQuery.of(context).padding.top,
        ),
        child: icon == null && noAction
            ? Center(child: text)
            : LabelledIcon.horizontal(
                mainAxisAlignment: noAction ? MainAxisAlignment.center : MainAxisAlignment.start,
                labelWidget: noAction ? text : Expanded(child: text),
                icon: IconTheme(
                  data: context.th.iconTheme.copyWith(color: onBackground),
                  child: icon!,
                ),
                action: noAction
                    ? null
                    : TextButton(
                        onPressed: onAction,
                        child: Text(actionLabel ?? ""),
                      ),
              ),
      ),
    );
    return onTap != null
        ? GestureDetector(
            onTap: onTap,
            child: body,
          )
        : body;
  }
}

enum _BannerType {
  primary,
  error,
}
