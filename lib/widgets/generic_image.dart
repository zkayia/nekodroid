
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';


class GenericImage extends StatelessWidget {

  final Uri imageUrl;
  final num? cacheHeight;
  final num? cacheWidth;
  final bool doNotAutoResize;
  final Widget? Function(BuildContext context, Widget child)? childBuilder;

  const GenericImage(
    this.imageUrl,
    {
      this.cacheHeight,
      this.cacheWidth,
      this.doNotAutoResize=false,
      this.childBuilder,
      super.key,
    }
  );
  
  Widget loadingBuilder(context, child, event) => event == null
    ? childBuilder?.call(context, child) ?? child
    : Center(
      child: CircularProgressIndicator(
        value: event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
      ),
    );
  Widget errorBuilder(context, err, stackTrace) => const Center(
    child: Icon(Boxicons.bxs_error_circle),
  );

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return (cacheHeight != null && cacheWidth != null) || doNotAutoResize
      ? Image.network(
        imageUrl.toString(),
        fit: BoxFit.cover,
        cacheHeight: cacheHeight == null
          ? null
          : (cacheHeight! * mq.devicePixelRatio).round(),
        cacheWidth: cacheWidth == null
          ? null
          : (cacheWidth! * mq.devicePixelRatio).round(),
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
      )
      : LayoutBuilder(
        builder: (context, constraints) => Image.network(
          imageUrl.toString(),
          fit: BoxFit.cover,
          cacheHeight: constraints.hasBoundedHeight && !constraints.hasInfiniteHeight
            ? (constraints.maxHeight * mq.devicePixelRatio).round()
            : null,
          cacheWidth: constraints.hasBoundedWidth && !constraints.hasInfiniteWidth
            ? (constraints.maxWidth * mq.devicePixelRatio).round()
            : null,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        ),
      );
  }
}
