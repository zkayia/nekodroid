import 'package:nekosama/nekosama.dart';

class KvDbUtils {
  const KvDbUtils._();

  static String searchdbEtagSource(NSSources source) => "searchdb-etag-${source.apiName}";

  static const String settingsThemeMode = "settings_theme_mode";
  static const String settingsSearchSources = "settings_search_sources";
}
