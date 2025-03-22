import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nekodroid/app.dart';
import 'package:nekodroid/core/providers/db_kv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/features/player/logic/web_msg_supported.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  // final dbFolder = await getApplicationDocumentsDirectory();
  // await File(join(dbFolder.path, "nekodroid_db.sqlite")).delete();

  // Webview debug mode
  if (kDebugMode && Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  final webMsgSupported = await WebViewFeature.isFeatureSupported(WebViewFeature.POST_WEB_MESSAGE) &&
      await WebViewFeature.isFeatureSupported(WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL);

  runApp(
    ProviderScope(
      overrides: [
        dbKvProvider.overrideWithValue(sharedPreferences),
        webMsgSupportedProvider.overrideWithValue(webMsgSupported),
      ],
      // child: DevicePreview(builder: (context) => App(devicePreviewLocale: DevicePreview.locale(context))),
      child: const App(),
    ),
  );
}
