import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';

class CachedRoundedNetworkImage extends CachedNetworkImage {
  final BorderRadiusGeometry borderRadius;

  CachedRoundedNetworkImage(
    String imageUrl, {
    super.httpHeaders,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration,
    super.fadeOutCurve,
    super.fadeInDuration,
    super.fadeInCurve,
    super.width,
    super.height,
    super.fit = BoxFit.cover,
    super.alignment,
    super.repeat,
    super.matchTextDirection,
    super.cacheManager,
    super.useOldImageOnUrlChange,
    super.color,
    super.filterQuality,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    super.errorListener,
    super.imageRenderMethodForWeb,
    super.scale,
    this.borderRadius = kBorderRadCirc,
    super.key,
  }) : super(imageUrl: imageUrl);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: borderRadius,
        child: super.build(context),
      );
}
