
import 'package:flutter/material.dart';


class OverflowText extends StatelessWidget {

	final bool _isSecondary;
	final String text;
	final int? maxLines;
	final Locale? locale;
	final String? semanticsLabel;
	final TextStyle? style;
	final StrutStyle? strutStyle;
	final TextAlign? textAlign;
	final TextDirection? textDirection;
	final TextHeightBehavior? textHeightBehavior;
	final double? textScaleFactor;
	final TextWidthBasis? textWidthBasis;

	const OverflowText(
		this.text,
		{
			super.key,
			this.maxLines,
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
	) :
		_isSecondary = false;

	const OverflowText.secondary(
		this.text,
		{
			super.key,
			this.maxLines,
			this.locale,
			this.semanticsLabel,
			this.strutStyle,
			this.textAlign,
			this.textDirection,
			this.textHeightBehavior,
			this.textScaleFactor,
			this.textWidthBasis,
		}
	) :
		_isSecondary = true,
		style = null;

	@override
	Widget build(BuildContext context) => Text(
		text,
		softWrap: false,
		maxLines: maxLines,
		locale: locale,
		semanticsLabel: semanticsLabel,
		strutStyle: strutStyle,
		style: style ?? (
			_isSecondary
				? Theme.of(context).textTheme.bodySmall
				: null
		),
		textAlign: textAlign,
		textDirection: textDirection,
		textHeightBehavior: textHeightBehavior,
		textScaleFactor: textScaleFactor,
		textWidthBasis: textWidthBasis,
	);
}
