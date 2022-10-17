
import 'package:flutter/material.dart';


@immutable
class HlsProvData {

  final Uri videoUrl;
  final AssetBundle assetBundle;

  const HlsProvData({
    required this.videoUrl,
    required this.assetBundle,
  });

  @override
  String toString() => "HlsProviderData(videoUrl: $videoUrl, assetBundle: $assetBundle)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HlsProvData && other.videoUrl == videoUrl && other.assetBundle == assetBundle;
  }

  @override
  int get hashCode => videoUrl.hashCode ^ assetBundle.hashCode;
}
