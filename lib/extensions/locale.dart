
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/iterable.dart';


extension LocaleX on Locale {

  static Locale? fromSettingString(String localeString) => localeString == "system"
    ? null
    : fromString(localeString);
  
  static Locale fromString(String localeString) {
    final strReg = RegExp("_|-");
    if (localeString.contains(strReg)) {
      final parts = localeString.split(strReg);
      return Locale.fromSubtags(
        languageCode: parts.first,
        scriptCode: parts.length == 3 ? parts.elementAtOrNull(1) : null,
        countryCode: parts.elementAtOrNull(parts.length == 3 ? 2 : 1),
      );
    }
    return Locale(localeString);
  }
}
