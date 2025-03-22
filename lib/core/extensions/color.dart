import 'dart:ui';

extension ColorX on Color {
  static Color? tryFromHexString(String hex) {
    var str = hex.toLowerCase().trim();
    if (str.startsWith("#")) {
      str = str.substring(1);
    }
    if (str.isNotEmpty && str.length < 6) {
      str = str.length <= 3 ? str * (6 ~/ str.length) : str.padRight(6, str.substring(str.length - 1));
    }
    if (str.isNotEmpty && str.length < 8) {
      str = "ff$str";
    }
    final hexStr = int.tryParse(str, radix: 16);
    return hexStr == null ? null : Color(hexStr);
  }

  /// [factor] between 0.0 and 1.0
  Color darkenBy(double factor) => Color.fromARGB(
        alpha,
        (red * factor).round(),
        (green * factor).round(),
        (blue * factor).round(),
      );
}
