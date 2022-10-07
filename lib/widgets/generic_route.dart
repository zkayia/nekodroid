
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class GenericRoute extends StatelessWidget {

  final String? title;
  final bool hideExitFab;
  final bool resizeToAvoidBottomInset;
  final bool useSafeArea;
  final Widget? leading;
  final Widget? trailing;
  final Widget? body;
  final Future<bool> Function(BuildContext context)? onExitTap;
  
  const GenericRoute({
    super.key,
    this.title,
    this.hideExitFab=false,
    this.resizeToAvoidBottomInset=false,
    this.useSafeArea=true,
    this.leading,
    this.trailing,
    this.body,
    this.onExitTap,
  });

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () => onExitTap == null
      ? Future.value(true)
      : onExitTap!.call(context),
    child: SafeArea(
      top: useSafeArea,
      left: useSafeArea,
      right: useSafeArea,
      bottom: useSafeArea,
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: hideExitFab
          ? null
          : SizedBox(
            height: kFabSize,
            width: kFabSize,
            child: FittedBox(
              child: FloatingActionButton(
                child: const Icon(Boxicons.bx_x),
                onPressed: () {
                  if (onExitTap == null) {
                    return Navigator.of(context).pop();
                  }
                  onExitTap!.call(context).then(
                    (value) => value ? Navigator.of(context).pop() : null,
                  );
                },
              ),
            ),
          ),
        extendBodyBehindAppBar: true,
        appBar: [title, leading, trailing].any((e) => e != null)
          ? _GenericRouteAppbar(
            title: title, 
            leading: leading, 
            trailing: trailing,
          )
          : null,
        body: body,
      ),
    ),
  );
}

class _GenericRouteAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  const _GenericRouteAppbar({
    required this.title,
    required this.leading,
    required this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kTopBarHeight + kPaddingSecond);

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(
      top: kPaddingSecond,
      left: kPaddingSecond,
      right: kPaddingSecond,
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints.tight(const Size.fromHeight(kTopBarHeight)),
      child: Stack(
        children: [
          if (title != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
                child: SingleLineText(
                  title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          if (leading != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
                child: leading,
              ),
            ),
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
                child: trailing,
              ),
            ),
        ],
      ),
    ),
  );
}
