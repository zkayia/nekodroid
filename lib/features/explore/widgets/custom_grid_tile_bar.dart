// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';

/// A header used in a Material Design [GridTile].
///
/// Typically used to add a one or two line header or footer on a [GridTile].
///
/// For a one-line header, include a [title] widget. To add a second line, also
/// include a [subtitle] widget. Use [leading] or [trailing] to add an icon.
///
/// See also:
///
///  * [GridTile]
///  * <https://material.io/design/components/image-lists.html#anatomy>
class CustomGridTileBar extends StatelessWidget {
  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or an [IconButton] widget.
  final Widget? leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] or an [IconButton] widget.
  final Widget? trailing;

  final EdgeInsets padding;

  /// Defaults to a black to transparent gradiant.
  /// Use [reversedGradiant] if used as a header
  final Decoration? decoration;

  final bool reversedGradiant;

  /// Creates a grid tile bar.
  ///
  /// Typically used to with [GridTile].
  const CustomGridTileBar({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(kPadding),
    this.decoration,
    this.reversedGradiant = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData.dark();
    return DecoratedBox(
      decoration: decoration ??
          BoxDecoration(
            borderRadius: kBorderRadCirc,
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              stops: const [0.5, 1],
              begin: reversedGradiant ? Alignment.topCenter : Alignment.bottomCenter,
              end: reversedGradiant ? Alignment.bottomCenter : Alignment.topCenter,
            ),
          ),
      child: Padding(
        padding: padding,
        child: Theme(
          data: darkTheme,
          child: IconTheme.merge(
            data: const IconThemeData(color: Colors.white),
            child: Row(
              children: <Widget>[
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: kPadding),
                    child: leading,
                  ),
                if (title != null && subtitle != null)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                          style: darkTheme.textTheme.titleMedium!,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        ),
                        DefaultTextStyle(
                          style: darkTheme.textTheme.bodySmall!,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                      ],
                    ),
                  )
                else if (title != null || subtitle != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style: darkTheme.textTheme.titleMedium!,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      child: title ?? subtitle!,
                    ),
                  ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: kPadding),
                    child: trailing,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
