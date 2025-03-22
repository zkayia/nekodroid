import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekosama/nekosama.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class NetworkUtils {
  const NetworkUtils._();

  static Future<bool> hasNetworkConnection() async => connectivityResultHasNetwork(await Connectivity().checkConnectivity());

  static bool connectivityResultHasNetwork(List<ConnectivityResult> connectivityResult) {
    final goodResults = [
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
    ];
    return connectivityResult.any(goodResults.contains);
  }

  static Future<bool> canConnectToHost() async {
    try {
      final result = await InternetAddress.lookup(NSConfig.host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  static Future<void> launchUrl(Uri url, BuildContext context) async {
    if (!await url_launcher.launchUrl(url) && context.mounted) {
      Fluttertoast.showToast(msg: "Impossible d'ouvrir le lien");
    }
  }
}
