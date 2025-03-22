import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';

class LabelledIcon extends StatelessWidget {
  final Axis _axis;
  final Widget icon;

  /// A text to display after the [icon] in the selected axis.
  ///
  /// Only one of [label] and [labelWidget] can be used.
  /// If both are set, [label] will be used.
  final String? label;

  /// A widget to display after the [icon] in the selected axis.
  ///
  /// Only one of [label] and [labelWidget] can be used.
  /// If both are set, [label] will be used.
  final Widget? labelWidget;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final double padding;
  final Widget? action;

  const LabelledIcon.horizontal({
    required this.icon,
    this.label,
    this.labelWidget,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding = kPadding / 2,
    this.action,
    super.key,
  }) : _axis = Axis.horizontal;

  const LabelledIcon.vertical({
    required this.icon,
    this.label,
    this.labelWidget,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding = kPadding / 2,
    this.action,
    super.key,
  }) : _axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final paddingBox = _axis == Axis.horizontal ? SizedBox(width: padding) : SizedBox(height: padding);
    return Flex(
      direction: _axis,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        icon,
        if (label != null || labelWidget != null) ...[
          paddingBox,
          if (label != null)
            Text(
              label!,
              textAlign: TextAlign.center,
            )
          else if (labelWidget != null)
            labelWidget!,
        ],
        if (action != null) ...[
          paddingBox,
          action!,
        ],
      ],
    );
  }
}
