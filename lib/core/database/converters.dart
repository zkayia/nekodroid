import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:nekosama/nekosama.dart';

class UriConverter extends TypeConverter<Uri, String> with JsonTypeConverter<Uri, String> {
  const UriConverter();
  @override
  Uri fromSql(String fromDb) => Uri.parse(fromDb);
  @override
  String toSql(Uri value) => value.toString();
}

class DurationConverter extends TypeConverter<Duration, int> with JsonTypeConverter<Duration, int> {
  const DurationConverter();
  @override
  Duration fromSql(int fromDb) => Duration(microseconds: fromDb);
  @override
  int toSql(Duration value) => value.inMicroseconds;
}

class NSAnimeTitlesConverter extends TypeConverter<NSAnimeTitles, String>
    with JsonTypeConverter2<NSAnimeTitles, String, Map<String, dynamic>> {
  const NSAnimeTitlesConverter();
  @override
  NSAnimeTitles fromSql(String fromDb) => NSAnimeTitles.fromJson(fromDb);
  @override
  String toSql(NSAnimeTitles value) => value.toJson();
  @override
  NSAnimeTitles fromJson(Map<String, dynamic> json) => NSAnimeTitles.fromMap(json);
  @override
  Map<String, dynamic> toJson(NSAnimeTitles value) => value.toMap();
}

// LISTS

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(jsonDecode(fromDb));
  @override
  String toSql(List<String> value) => jsonEncode(value);
}

class NSGenresListConverter extends TypeConverter<List<NSGenres>, String> with JsonTypeConverter2<List<NSGenres>, String, List> {
  const NSGenresListConverter();
  @override
  List<NSGenres> fromSql(String fromDb) => fromJson(const StringListConverter().fromSql(fromDb));
  @override
  String toSql(List<NSGenres> value) => const StringListConverter().toSql(toJson(value));
  @override
  List<NSGenres> fromJson(List json) => json.cast<String>().map(NSGenres.fromString).whereType<NSGenres>().toList();
  @override
  List<String> toJson(List<NSGenres> value) => value.map((e) => e.name).toList();
}

class NSEpisodeListConverter extends TypeConverter<List<NSEpisode>, String>
    with JsonTypeConverter2<List<NSEpisode>, String, List> {
  const NSEpisodeListConverter();
  @override
  List<NSEpisode> fromSql(String fromDb) => List<String>.from(jsonDecode(fromDb)).map(NSEpisode.fromJson).toList();
  @override
  String toSql(List<NSEpisode> value) => jsonEncode(value);
  @override
  List<NSEpisode> fromJson(List json) => json.cast<Map>().map((e) => NSEpisode.fromMap(e.cast<String, dynamic>())).toList();
  @override
  List<Map<String, dynamic>> toJson(List<NSEpisode> value) => value.map((e) => e.toMap()).toList();
}
