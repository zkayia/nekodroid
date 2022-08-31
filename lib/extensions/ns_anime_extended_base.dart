
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekosama_hive/nekosama_hive.dart';


extension NSAnimeExtendedBaseX on NSAnimeExtendedBase {

  String dataText(BuildContext context) => "${
      type == NSTypes.movie
        ? ""
        : "${context.tr.episodeCountShort(episodeCount)} \u2022 " 
    }${
      context.tr.formats(type.name)
    } \u2022 ${
      context.tr.statuses(status.name)
    } \u2022 ${
      (
        this is NSAnime
          ? (this as NSAnime).startDate?.year
          : (this as NSSearchAnime).year
      ) ?? "?"
    }";
}
