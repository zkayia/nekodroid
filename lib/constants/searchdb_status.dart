
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';


enum SearchdbStatus {
  ready,
  processing,
  fetching,
  verifying,
  erroredNoInternet,
  errored,
  unknown;

  bool get inProcess => const {
    SearchdbStatus.verifying,
    SearchdbStatus.fetching,
    SearchdbStatus.processing,
  }.contains(this);

  IconData get icon {
    switch (this) {
      case SearchdbStatus.ready:
        return Boxicons.bx_search;
      case SearchdbStatus.processing:
        return Boxicons.bx_chip;
      case SearchdbStatus.fetching:
        return Boxicons.bx_cloud_download;
      case SearchdbStatus.verifying:
        return Boxicons.bx_check_shield;
      case SearchdbStatus.erroredNoInternet:
        return Boxicons.bx_wifi_off;
      default:
        return Boxicons.bx_error_circle;
    }
  }
}
