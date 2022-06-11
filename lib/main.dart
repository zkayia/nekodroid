

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/app.dart';
import 'package:nekodroid/constants.dart';

// import 'dart:io';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:device_preview/device_preview.dart';


void main() async {
	
	WidgetsFlutterBinding.ensureInitialized();

	await SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitDown,
		DeviceOrientation.portraitUp,
	]);

	await EasyLocalization.ensureInitialized();

	await Hive.initFlutter();

	// // Webview debug mode
	// if (Platform.isAndroid) {
	// 	await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
	// }

	// // Suppresses (most) debug messages from easy_localization
	// EasyLocalization.logger.printer = (object, {level, name, stackTrace}) {}; 
	
	// // Clears all Hive db storage at restart
	// await Hive.openBox<int>("favorites");
	// await Hive.openBox<Map>("history");
	// await Hive.openBox<String>("recent-history");
	// await Hive.openBox<String>("anime-cache");
	// await Hive.openBox("settings");
	// await Hive.deleteFromDisk();

	await Hive.openBox<int>("favorites");
	await Hive.openBox<Map>("history");
	await Hive.openBox<String>("recent-history");
	await Hive.openBox<String>("anime-cache");
	final settingsBox = await Hive.openBox("settings");
	if (settingsBox.isEmpty) {
		await settingsBox.putAll(kDefaultSettings.toMap());
	}

	runApp(
		// // Layout testing tool
		// DevicePreview(
		// 	builder: (context) =>
				ProviderScope(
					child: EasyLocalization(
						supportedLocales: const [
							Locale("en"),
							Locale("fr"),
						],
						fallbackLocale: const Locale("en"),
						path: "assets/translations",
						useOnlyLangCode: true,
						useFallbackTranslations: true,
						child: const App(),
					),
			),
		// ),
	);
}
