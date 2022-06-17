
import 'package:flutter/material.dart';


extension LocaleFromString on Locale {

	static Locale? fromSettingString(String localeString) => localeString == "system"
		? null
		: fromString(localeString);
	
	static Locale fromString(String localeString) {
		if (localeString.contains("_")) {
			final parts = localeString.split("_");
			return Locale.fromSubtags(
				languageCode: parts.first,
				countryCode: parts.last,
			);
		}
		return Locale(localeString);
	}
}
