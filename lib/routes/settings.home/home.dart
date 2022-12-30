
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/home_anime_card_action.dart';
import 'package:nekodroid/constants/home_episode_card_action.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/radio_setting.dart';
import 'package:nekodroid/widgets/slider_setting.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';


class SettingsHomeRoute extends ConsumerWidget {

  const SettingsHomeRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
    body: SliverTitleScrollview.list(
      title: context.tr.home,
      children: [
        SliderSetting(
          title: context.tr.carouselColumnCount,
          label: ref.watch(
            settingsProv.select((v) => v.home.carouselColumnCount),
          ).toString(),
          value: ref.watch(settingsProv.select((v) => v.home.carouselColumnCount)),
          min: 3,
          max: 10,
          steps: 1,
          onChanged: (v) => ref.read(settingsProv.notifier).carouselColumnCount = v.toInt(),
        ),
        RadioSetting<HomeEpisodeCardAction>(
          title: context.tr.episodeCardPressAction,
          subtitle: context.tr.episodeCardActions(
            ref.watch(settingsProv.select((v) => v.home.episodeCardPressAction)).name,
          ),
          elements: [
            ...HomeEpisodeCardAction.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.episodeCardActions(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.home.episodeCardPressAction),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).episodeCardPressAction = v,
        ),
        RadioSetting<HomeEpisodeCardAction>(
          title: context.tr.episodeCardLongPressAction,
          subtitle: context.tr.episodeCardActions(
            ref.watch(settingsProv.select((v) => v.home.episodeCardLongPressAction)).name,
          ),
          elements: [
            ...HomeEpisodeCardAction.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.episodeCardActions(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.home.episodeCardLongPressAction),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).episodeCardLongPressAction = v,
        ),
        RadioSetting<HomeAnimeCardAction>(
          title: context.tr.animeCardPressAction,
          subtitle: context.tr.animeCardActions(
            ref.watch(settingsProv.select((v) => v.home.animeCardPressAction)).name,
          ),
          elements: [
            ...HomeAnimeCardAction.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.animeCardActions(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.home.animeCardPressAction),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).animeCardPressAction = v,
        ),
        RadioSetting<HomeAnimeCardAction>(
          title: context.tr.animeCardLongPressAction,
          subtitle: context.tr.animeCardActions(
            ref.watch(settingsProv.select((v) => v.home.animeCardLongPressAction)).name,
          ),
          elements: [
            ...HomeAnimeCardAction.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.animeCardActions(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.home.animeCardLongPressAction),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).animeCardLongPressAction = v,
        ),
      ],
    ),
  );
}
