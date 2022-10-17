
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';


part 'isar_anime_list.g.dart';


@collection
class IsarAnimeList {
  
  Id id = Isar.autoIncrement;
  int position;
  String name;
  
  final animes = IsarLinks<IsarAnimeListItem>();
  
  IsarAnimeList({
    required this.position,
    required this.name,
  });
}
