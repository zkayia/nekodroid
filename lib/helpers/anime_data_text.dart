
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


String animeDataText(BuildContext context, NSAnimeExtendedBase anime) => "${
	anime.type == NSTypes.movie
		? ""
		: "${context.tr.episodeCountShort(anime.episodeCount)} \u2022 " 
	}${
		context.tr.formats(anime.type.name)
	} \u2022 ${
		context.tr.statuses(anime.status.name)
	} \u2022 ${
		(
			anime is NSAnime
				? anime.startDate?.year
				: (anime as NSSearchAnime).year
		) ?? "?"
	}";
