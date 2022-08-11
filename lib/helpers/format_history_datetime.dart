
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/extensions/int.dart';


String formatHistoryDatetime(BuildContext context, DateTime dateTime) => "\n${
		dateTime.day
	} ${
		context.tr.monthsShort(dateTime.month)
	}. ${
		dateTime.year == DateTime.now().year
			? ""
			: dateTime.year
	} ${
		dateTime.hour.toPaddedString()
	}:${
		dateTime.minute.toPaddedString()
	}";
