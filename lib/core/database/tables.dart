import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/converters.dart';
import 'package:nekosama/nekosama.dart';

class SearchAnimes extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {animeId, source};

  IntColumn get animeId => integer()();
  TextColumn get title => text()();
  TextColumn get genres => text().map(const NSGenresListConverter())();
  TextColumn get source => textEnum<NSSources>()();
  TextColumn get status => textEnum<NSStatuses>()();
  TextColumn get type => textEnum<NSTypes>()();
  RealColumn get score => real()();
  TextColumn get url => text().map(const UriConverter())();
  TextColumn get thumbnail => text().map(const UriConverter())();
  IntColumn get episodeCount => integer().nullable()();
  IntColumn get year => integer()();
  RealColumn get popularity => real()();
}

@TableIndex(name: "animes_url", columns: {#url}, unique: true)
class Animes extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {animeId, source};

  IntColumn get animeId => integer()();
  TextColumn get title => text()();
  TextColumn get url => text().unique().map(const UriConverter())();
  TextColumn get thumbnail => text().map(const UriConverter())();
  IntColumn get episodeCount => integer().nullable()();
  TextColumn get titles => text().map(const NSAnimeTitlesConverter())();
  TextColumn get genres => text().map(const NSGenresListConverter())();
  TextColumn get source => textEnum<NSSources>()();
  TextColumn get status => textEnum<NSStatuses>()();
  TextColumn get type => textEnum<NSTypes>()();
  RealColumn get score => real()();
  TextColumn get synopsis => text().nullable()();
  TextColumn get episodes => text().map(const NSEpisodeListConverter())();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get lastModified => text().nullable()();
}

class LibraryLists extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {name};

  TextColumn get name => text()();
  IntColumn get position => integer()();
}

class LibraryAnimes extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {list, animeUrl};

  TextColumn get list => text().references(LibraryLists, #name, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();
  TextColumn get animeUrl => text().map(const UriConverter()).references(Animes, #url)();
  DateTimeColumn get addedAt => dateTime()();
}

class EpisodeHistory extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {time, animeUrl, episodeNumber};

  DateTimeColumn get time => dateTime()();
  TextColumn get animeUrl => text().map(const UriConverter()).references(Animes, #url)();
  IntColumn get episodeNumber => integer()();
  IntColumn get position => integer().map(const DurationConverter())();
  IntColumn get duration => integer().map(const DurationConverter())();
}
