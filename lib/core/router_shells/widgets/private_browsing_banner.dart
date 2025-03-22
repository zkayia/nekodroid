import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:flutter/material.dart';

class PrivateBrowsingBanner extends StatelessWidget {
  const PrivateBrowsingBanner({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.th.colorScheme.primary,
        child: Padding(
          padding: EdgeInsets.only(
            left: kPadding,
            right: kPadding,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Text(
            "Navigation privée",
            style: context.th.textTheme.titleSmall?.copyWith(
              color: context.th.colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
