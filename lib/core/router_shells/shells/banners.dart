import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/providers/error.dart';
import 'package:nekodroid/core/router_shells/widgets/animated_appbar_banner.dart';
import 'package:nekodroid/core/router_shells/widgets/appbar_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/features/search/logic/search_db_is_working.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:nekosama/nekosama.dart';

class BannersShell extends ConsumerWidget {
  final Widget child;

  const BannersShell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(errorProvider.select((v) => v.firstOrNull));
    final privateBrowsingEnabled = ref.watch(settingsProvider.select((v) => v.privateBrowsingEnabled));
    final searchDbIsWorking = ref.watch(searchDbIsWorkingProvider);
    Widget? banner;
    if (error != null) {
      banner = AppbarBanner.error(
        label: switch (error) {
          final NoNetworkError _ => "Aucune connexion",
          final CantAccessHostError _ => "Impossible d'accéder à ${NSConfig.host}",
        },
        actionLabel: switch (error) {
          final NoNetworkError _ || final CantAccessHostError _ => "Réessayer",
        },
        icon: Icon(
          switch (error) {
            final NoNetworkError _ => Symbols.wifi_off_rounded,
            final CantAccessHostError _ => Symbols.event_busy_rounded,
          },
        ),
        onAction: switch (error) {
          final NoNetworkError _ => () => ref.read(errorProvider.notifier).checkForErrors(),
          final CantAccessHostError _ => () => ref.read(errorProvider.notifier).checkForErrors(),
        },
      );
    } else if (searchDbIsWorking) {
      banner = AppbarBanner.primary(
        label: "Mise à jour en cours",
        icon: Center(
          child: SizedBox.square(
            dimension: context.th.textTheme.titleSmall?.fontSize ?? 14,
            child: CircularProgressIndicator(
              color: context.th.colorScheme.onPrimary,
              strokeWidth: 2,
              strokeCap: StrokeCap.round,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
        ),
      );
    } else if (privateBrowsingEnabled) {
      banner = AppbarBanner.primary(
        onTap: () => ref.read(settingsProvider.notifier).setPrivateBrowsingEnabled(false),
        label: "Navigation privée",
      );
    }
    return Scaffold(
      appBar: AnimatedAppbarBanner(
        banner: banner,
        topPadding: context.mq.padding.top,
      ),
      body: child,
    );
  }
}
