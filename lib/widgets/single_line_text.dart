
import 'package:nekodroid/widgets/overflow_text.dart';


class SingleLineText extends OverflowText {

	const SingleLineText(
		String text,
		{
			super.key,
			super.locale,
			super.semanticsLabel,
			super.style,
			super.strutStyle,
			super.textAlign,
			super.textDirection,
			super.textHeightBehavior,
			super.textScaleFactor,
			super.textWidthBasis,
		}
	) : super(text, maxLines: 1);

	const SingleLineText.secondary(
		String text,
		{
			super.key,
			super.locale,
			super.semanticsLabel,
			super.strutStyle,
			super.textAlign,
			super.textDirection,
			super.textHeightBehavior,
			super.textScaleFactor,
			super.textWidthBasis,
		}
	) : super.secondary(text, maxLines: 1);
}
