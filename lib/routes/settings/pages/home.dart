
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/home_anime_card_action.dart';
import 'package:nekodroid/constants/home_episode_card_action.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/radio_setting.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/slider_setting.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';


class SettingsHomePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsHomePage(
    this.title,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: title,
    children: [
      SliderSetting(
        title: context.tr.carouselColumnCount,
        label: ref.watch(
          settingsProvider.select((v) => v.home.carouselColumnCount),
        ).toString(),
        value: ref.watch(settingsProvider.select((v) => v.home.carouselColumnCount)),
        min: 3,
        max: 10,
        steps: 1,
        onChanged: (v) => ref.read(settingsProvider.notifier).carouselColumnCount = v.toInt(),
      ),
      RadioSetting<HomeEpisodeCardAction>(
        title: context.tr.episodeCardPressAction,
        subtitle: context.tr.episodeCardActions(
          ref.watch(settingsProvider.select((v) => v.home.episodeCardPressAction)).name,
        ),
        elements: [
          ...HomeEpisodeCardAction.values.map(
            (e) => GenericFormDialogElement(
              label: context.tr.episodeCardActions(e.name),
              value: e,
              selected: e == ref.watch(
                settingsProvider.select((v) => v.home.episodeCardPressAction),
              ),
            ),
          ),
        ],
        onChanged: (v) => ref.read(settingsProvider.notifier).episodeCardPressAction = v,
      ),
      RadioSetting<HomeEpisodeCardAction>(
        title: context.tr.episodeCardLongPressAction,
        subtitle: context.tr.episodeCardActions(
          ref.watch(settingsProvider.select((v) => v.home.episodeCardLongPressAction)).name,
        ),
        elements: [
          ...HomeEpisodeCardAction.values.map(
            (e) => GenericFormDialogElement(
              label: context.tr.episodeCardActions(e.name),
              value: e,
              selected: e == ref.watch(
                settingsProvider.select((v) => v.home.episodeCardLongPressAction),
              ),
            ),
          ),
        ],
        onChanged: (v) => ref.read(settingsProvider.notifier).episodeCardLongPressAction = v,
      ),
      RadioSetting<HomeAnimeCardAction>(
        title: context.tr.animeCardPressAction,
        subtitle: context.tr.animeCardActions(
          ref.watch(settingsProvider.select((v) => v.home.animeCardPressAction)).name,
        ),
        elements: [
          ...HomeAnimeCardAction.values.map(
            (e) => GenericFormDialogElement(
              label: context.tr.animeCardActions(e.name),
              value: e,
              selected: e == ref.watch(
                settingsProvider.select((v) => v.home.animeCardPressAction),
              ),
            ),
          ),
        ],
        onChanged: (v) => ref.read(settingsProvider.notifier).animeCardPressAction = v,
      ),
      RadioSetting<HomeAnimeCardAction>(
        title: context.tr.animeCardLongPressAction,
        subtitle: context.tr.animeCardActions(
          ref.watch(settingsProvider.select((v) => v.home.animeCardLongPressAction)).name,
        ),
        elements: [
          ...HomeAnimeCardAction.values.map(
            (e) => GenericFormDialogElement(
              label: context.tr.animeCardActions(e.name),
              value: e,
              selected: e == ref.watch(
                settingsProvider.select((v) => v.home.animeCardLongPressAction),
              ),
            ),
          ),
        ],
        onChanged: (v) => ref.read(settingsProvider.notifier).animeCardLongPressAction = v,
      ),
    ],
  );
}
