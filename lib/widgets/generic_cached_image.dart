
import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class GenericCachedImage extends StatelessWidget {

  final Uri imageUrl;
  final num? cacheHeight;
  final num? cacheWidth;
  final bool doNotAutoResize;

  const GenericCachedImage(
    this.imageUrl,
    {
      this.cacheHeight,
      this.cacheWidth,
      this.doNotAutoResize=false,
      super.key,
    }
  );

  Widget progressIndicatorBuilder(context, url, progress) => Center(
    child: CircularProgressIndicator(value: progress.progress),
  );

  Widget errorWidget(context, message, err) => const Center(
    child: Icon(Boxicons.bxs_error_circle),
  );

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if ((cacheHeight != null && cacheWidth != null) || doNotAutoResize) {
      final height = cacheHeight == null
        ? null
        : (cacheHeight! * mq.devicePixelRatio).round();
      final width = cacheWidth == null
        ? null
        : (cacheWidth! * mq.devicePixelRatio).round();
      return CachedNetworkImage(
        imageUrl: imageUrl.toString(),
        fit: BoxFit.cover,
        maxHeightDiskCache: height,
        maxWidthDiskCache: width,
        memCacheHeight: height,
        memCacheWidth: width,
        progressIndicatorBuilder: progressIndicatorBuilder,
        errorWidget: errorWidget,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.hasBoundedHeight && !constraints.hasInfiniteHeight
          ? (constraints.maxHeight * mq.devicePixelRatio).round()
          : null;
        final width = constraints.hasBoundedWidth && !constraints.hasInfiniteWidth
          ? (constraints.maxWidth * mq.devicePixelRatio).round()
          : null;
        return CachedNetworkImage(
          imageUrl: imageUrl.toString(),
          fit: BoxFit.cover,
          maxHeightDiskCache: height,
          maxWidthDiskCache: width,
          memCacheHeight: height,
          memCacheWidth: width,
          progressIndicatorBuilder: progressIndicatorBuilder,
          errorWidget: errorWidget,
        );
      },
    );
  }
}
