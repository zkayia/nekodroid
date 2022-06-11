
import 'package:easy_localization/easy_localization.dart';
import 'package:nekodroid/extensions/int.dart';


String formatHistoryDatetime(DateTime dateTime) => "\n${
		dateTime.day
	} ${
		"months.short".tr(gender: dateTime.month.toString())
	}. ${
		dateTime.year == DateTime.now().year
			? ""
			: dateTime.year
	} ${
		dateTime.hour.toPaddedString()
	}:${
		dateTime.minute.toPaddedString()
	}";
