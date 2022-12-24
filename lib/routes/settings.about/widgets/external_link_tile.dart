
import 'package:android_intent_plus/android_intent.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekodroid/extensions/build_context.dart';


class ExternalLinkTile extends StatelessWidget {

  final String title;
  final Uri link;
  final Widget? logo;

  const ExternalLinkTile({
    required this.title,
    required this.link,
    this.logo,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: Text(link.toString()),
    leading: logo,
    trailing: const Icon(Boxicons.bx_link_external),
    onTap: () => AndroidIntent(
      action: "action_view",
      data: link.toString(),
    ).launch(),
    onLongPress: () => Clipboard.setData(ClipboardData(text: link.toString()))
      ..then(
        (_) => Fluttertoast.showToast(msg: context.tr.linkCopiedToClipboard),
      )
      ..catchError(
        (_, __) => Fluttertoast.showToast(msg: context.tr.failedToCopyLinkToClipboard),
      ),
  );
}
