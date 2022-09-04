
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/build_context.dart';


enum SearchdbStatus {
  ready,
  processing,
  fetching,
  erroredNoInternet,
  errored,
  unknown;

  bool get inProcess =>
    this == SearchdbStatus.fetching || this == SearchdbStatus.processing;

  IconData get icon {
    switch (this) {
      case SearchdbStatus.ready:
        return Boxicons.bx_search;
      case SearchdbStatus.processing:
        return Boxicons.bx_chip;
      case SearchdbStatus.fetching:
        return Boxicons.bx_cloud_download;
      case SearchdbStatus.erroredNoInternet:
        return Boxicons.bx_wifi_off;
      default:
        return Boxicons.bx_error_circle;
    }
  }

  String getMessage(BuildContext context) {
    switch (this) {
      case SearchdbStatus.ready:
        return context.tr.search;
      case SearchdbStatus.processing:
        return context.tr.searchdbProcessing;
      case SearchdbStatus.fetching:
        return context.tr.searchdbFetching;
      default:
        return context.tr.searchdbUnavailable;
    }
  }
}
