
import 'package:easy_localization/easy_localization.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


String animeDataText(NSAnime anime) => "${
	anime.type == NSTypes.movie
		? ""
		: "${"episodes.short".plural(anime.episodeCount)} \u2022 " 
	}${
		"types-statuses-list".tr(gender: anime.type.name)
	} \u2022 ${
		"types-statuses-list".tr(gender: anime.status.name)
	} \u2022 ${
		anime.startDate?.year ?? "?"
	}";
