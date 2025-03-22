/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImgGen {
  const $AssetsImgGen();

  /// File path: assets/img/github-logo-48.png
  AssetGenImage get githubLogo48 =>
      const AssetGenImage('assets/img/github-logo-48.png');

  /// File path: assets/img/nekodroid_logo.png
  AssetGenImage get nekodroidLogoPng =>
      const AssetGenImage('assets/img/nekodroid_logo.png');

  /// File path: assets/img/nekodroid_logo.svg
  String get nekodroidLogoSvg => 'assets/img/nekodroid_logo.svg';

  /// File path: assets/img/nekodroid_logo_dark.png
  AssetGenImage get nekodroidLogoDark =>
      const AssetGenImage('assets/img/nekodroid_logo_dark.png');

  /// File path: assets/img/nekodroid_logo_dark_margin.png
  AssetGenImage get nekodroidLogoDarkMargin =>
      const AssetGenImage('assets/img/nekodroid_logo_dark_margin.png');

  /// File path: assets/img/nekodroid_logo_margin.png
  AssetGenImage get nekodroidLogoMargin =>
      const AssetGenImage('assets/img/nekodroid_logo_margin.png');

  /// File path: assets/img/nekodroid_splash.png
  AssetGenImage get nekodroidSplash =>
      const AssetGenImage('assets/img/nekodroid_splash.png');

  /// File path: assets/img/nekodroid_splash_android12.png
  AssetGenImage get nekodroidSplashAndroid12 =>
      const AssetGenImage('assets/img/nekodroid_splash_android12.png');

  /// File path: assets/img/nekodroid_splash_dark.png
  AssetGenImage get nekodroidSplashDark =>
      const AssetGenImage('assets/img/nekodroid_splash_dark.png');

  /// List of all assets
  List<dynamic> get values => [
        githubLogo48,
        nekodroidLogoPng,
        nekodroidLogoSvg,
        nekodroidLogoDark,
        nekodroidLogoDarkMargin,
        nekodroidLogoMargin,
        nekodroidSplash,
        nekodroidSplashAndroid12,
        nekodroidSplashDark
      ];
}

class $AssetsJsGen {
  const $AssetsJsGen();

  /// File path: assets/js/webview_channel.js
  String get webviewChannel => 'assets/js/webview_channel.js';

  /// File path: assets/js/webview_tweaks.js
  String get webviewTweaks => 'assets/js/webview_tweaks.js';

  /// List of all assets
  List<String> get values => [webviewChannel, webviewTweaks];
}

class Assets {
  Assets._();

  static const $AssetsImgGen img = $AssetsImgGen();
  static const $AssetsJsGen js = $AssetsJsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
