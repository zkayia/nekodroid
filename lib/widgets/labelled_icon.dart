
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/overflow_text.dart';


class LabelledIcon extends StatelessWidget {

  final Axis _axis;
  final Widget icon;
  final String? label;
  final Widget? labelWidget;
  final bool minMainAxis;

  const LabelledIcon.horizontal({
    required this.icon,
    this.label,
    this.labelWidget,
    this.minMainAxis=false,
    super.key,
  }) : _axis = Axis.horizontal;

  const LabelledIcon.vertical({
    required this.icon,
    this.label,
    this.labelWidget,
    this.minMainAxis=false,
    super.key,
  }) : _axis = Axis.vertical;

  @override
  Widget build(BuildContext context) => Flex(
    direction: _axis,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: minMainAxis ? MainAxisSize.min : MainAxisSize.max,
    children: [
      icon,
      if (label != null || labelWidget != null)
        ...[
          if (_axis == Axis.horizontal)
            const SizedBox(width: kPaddingSecond)
          else
            const SizedBox(height: kPaddingSecond),
          if (labelWidget != null)
            labelWidget!
          else if (label != null)
            OverflowText(
              label!,
              textAlign: TextAlign.center,
            ),
        ],
    ],
  );
}
