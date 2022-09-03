
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/build_context.dart';


enum SearchdbStatus {
  errored,
  fetched,
  fetching,
  unknown;

  IconData get icon {
    switch (this) {
      case SearchdbStatus.fetched:
        return Boxicons.bx_search;
      case SearchdbStatus.fetching:
        return Boxicons.bx_cloud_download;
      case SearchdbStatus.errored:
      case SearchdbStatus.unknown:
      default:
        return Boxicons.bx_error_circle;
    }
  }

  String getMessage(BuildContext context) {
    switch (this) {
      case SearchdbStatus.fetched:
        return context.tr.search;
      case SearchdbStatus.fetching:
        return context.tr.searchdbFetching;
      case SearchdbStatus.errored:
      case SearchdbStatus.unknown:
      default:
        return context.tr.searchdbUnavailable;
    }
  }
}
