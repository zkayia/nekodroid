extension UriX on Uri {
  static Uri? tryParseNull(String? uri, [int start = 0, int? end]) {
    try {
      if (uri == null) {
        return null;
      }
      return Uri.tryParse(uri, start, end);
    } on FormatException {
      return null;
    }
  }

  String get encoded => Uri.encodeComponent(toString());

  Uri stripQueryParameters() => replace(
        queryParameters: {},
      );
}
