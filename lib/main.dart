
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/app.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:device_preview/device_preview.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  
  Intl.defaultLocale = kFallbackLocale.toString();
  await findSystemLocale();

  await Hive.initFlutter();

  final isarDir = Directory("${(await getApplicationSupportDirectory()).path}/isar");
  // if (isarDir.existsSync()) {
  //   await isarDir.delete(recursive: true);
  // }
  if (!isarDir.existsSync()) {
    await isarDir.create(recursive: true);
  }
  await Isar.open(
    [
      IsarSearchAnimeSchema,
      IsarAnimeListItemSchema,
      IsarAnimeListSchema,
      IsarEpisodeStatusSchema,
    ],
    directory: isarDir.path,
  );
  // Isar.getInstance()!.writeTxnSync(Isar.getInstance()!.clearSync);

  // Webview debug mode
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // // Clears all Hive db storage at restart
  // await Hive.openBox("settings");
  // await Hive.openBox("misc-data");
  // await Hive.deleteFromDisk();

  await Hive.openBox("settings");
  await Hive.openBox("misc-data");

  runApp(
    // // Layout testing tool
    // DevicePreview(
    //   builder: (context) =>
      const ProviderScope(child: App()),
    // ),
  );
}
