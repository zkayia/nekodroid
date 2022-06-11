
import 'package:flutter/material.dart';
import 'package:nekodroid/widgets/overflow_text.dart';


class SingleLineText extends OverflowText {

	const SingleLineText(
		String text,
		{
			Key? key,
			Locale? locale,
			String? semanticsLabel,
			TextStyle? style,
			StrutStyle? strutStyle,
			TextAlign? textAlign,
			TextDirection? textDirection,
			TextHeightBehavior? textHeightBehavior,
			double? textScaleFactor,
			TextWidthBasis? textWidthBasis,
		}
	) : super(
		text,
		maxLines: 1,
		key: key,
		locale: locale,
		semanticsLabel: semanticsLabel,
		strutStyle: strutStyle,
		style: style,
		textAlign: textAlign,
		textDirection: textDirection,
		textHeightBehavior: textHeightBehavior,
		textScaleFactor: textScaleFactor,
		textWidthBasis: textWidthBasis,
	);

	const SingleLineText.secondary(
		String text,
		{
			Key? key,
			Locale? locale,
			String? semanticsLabel,
			StrutStyle? strutStyle,
			TextAlign? textAlign,
			TextDirection? textDirection,
			TextHeightBehavior? textHeightBehavior,
			double? textScaleFactor,
			TextWidthBasis? textWidthBasis,
		}
	) : super.secondary(
		text,
		maxLines: 1,
		key: key,
		locale: locale,
		semanticsLabel: semanticsLabel,
		strutStyle: strutStyle,
		textAlign: textAlign,
		textDirection: textDirection,
		textHeightBehavior: textHeightBehavior,
		textScaleFactor: textScaleFactor,
		textWidthBasis: textWidthBasis,
	);
}
