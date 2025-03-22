import 'package:cyapp/constants.dart';
import 'package:flutter/material.dart';

class AnimatedAppbarBanner extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? banner;
  final double topPadding;

  const AnimatedAppbarBanner({
    required this.banner,
    this.topPadding = 0,
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight((banner?.preferredSize.height ?? 0) + topPadding);

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        curve: kDefaultAnimCurve,
        duration: kDefaultAnimDuration,
        height: (banner?.preferredSize.height ?? 0) + topPadding,
        child: AnimatedOpacity(
          curve: kDefaultAnimCurve,
          duration: Duration(microseconds: kDefaultAnimDuration.inMicroseconds ~/ 2),
          opacity: banner != null ? 1 : 0,
          child: banner,
        ),
      );
}
