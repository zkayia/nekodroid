
import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class GenericCachedImage extends StatelessWidget {

  final Uri imageUrl;

  const GenericCachedImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
    imageUrl: imageUrl.toString(),
    fit: BoxFit.cover,
    progressIndicatorBuilder: (context, url, progress) => Center(
      child: CircularProgressIndicator(value: progress.progress),
    ),
    errorWidget: (context, message, err) => const Center(
      child: Icon(Boxicons.bxs_error_circle),
    ),
  );
}
