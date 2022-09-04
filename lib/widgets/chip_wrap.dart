
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class ChipWrap extends StatelessWidget {

  final List<Widget> genres;

  const ChipWrap({
    required this.genres,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    clipBehavior: Clip.hardEdge,
    crossAxisAlignment: WrapCrossAlignment.center,
    runSpacing: kPaddingGenresGrid,
    spacing: kPaddingGenresGrid,
    children: genres,
  );
}
