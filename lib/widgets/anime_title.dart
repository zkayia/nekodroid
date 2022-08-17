
import 'package:flutter/material.dart';


class AnimeTitle extends StatelessWidget {

  final bool _isBold;
  final String title;
  final bool isExtended;
  final Locale? locale;
  final String? semanticsLabel;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;

  const AnimeTitle(
    this.title,
    {
      super.key,
      this.isExtended=true,
      this.locale,
      this.semanticsLabel,
      this.strutStyle,
      this.style,
      this.textAlign,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis,
    }
  ) : _isBold = false;

  const AnimeTitle.bold(
    this.title,
    {
      super.key,
      this.isExtended=true,
      this.locale,
      this.semanticsLabel,
      this.strutStyle,
      this.style,
      this.textAlign,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis,
    }
  ) : _isBold = true;

  @override
  Widget build(BuildContext context) => Text(
    title,
    maxLines: isExtended ? 3 : 1,
    softWrap: isExtended,
    locale: locale,
    semanticsLabel: semanticsLabel,
    strutStyle: strutStyle,
    style: style ?? (
      _isBold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium
    ),
    textAlign: textAlign,
    textDirection: textDirection,
    textHeightBehavior: textHeightBehavior,
    textScaleFactor: textScaleFactor,
    textWidthBasis: textWidthBasis,
  );
}
