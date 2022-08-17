
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';


class GenericImage extends StatelessWidget {

  final Uri imageUrl;
  final Widget? Function(BuildContext context, Widget child)? childBuilder;

  const GenericImage(
    this.imageUrl,
    {
      this.childBuilder,
      super.key,
    });

  @override
  Widget build(BuildContext context) => Image.network(
    imageUrl.toString(),
    fit: BoxFit.cover,
    loadingBuilder: (context, child, event) => event == null
      ? childBuilder?.call(context, child) ?? child
      : Center(
        child: CircularProgressIndicator(
          value: event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
        ),
      ),
    errorBuilder: (context, err, stackTrace) => const Center(
      child: Icon(Boxicons.bxs_error_circle),
    ),
  );
}
