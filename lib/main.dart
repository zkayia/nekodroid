
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl_standalone.dart';
import 'package:nekodroid/app.dart';

// import 'dart:io';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:device_preview/device_preview.dart';


void main() async {
	
	WidgetsFlutterBinding.ensureInitialized();

	await SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitDown,
		DeviceOrientation.portraitUp,
	]);
	
	await findSystemLocale();

	await Hive.initFlutter();

	// // Webview debug mode
	// if (Platform.isAndroid) {
	// 	await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
	// }

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
	await Hive.openBox("settings");

	runApp(
		// // Layout testing tool
		// DevicePreview(
		// 	builder: (context) =>
			const ProviderScope(child: App()),
		// ),
	);
}
