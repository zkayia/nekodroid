import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/router_shells/shells/banners.dart';
import 'package:nekodroid/features/anime/screens/anime.dart';
import 'package:nekodroid/features/backup/screens/backup.dart';
import 'package:nekodroid/features/explore/screens/explore.dart';
import 'package:nekodroid/features/explore/screens/latest_episodes.dart';
import 'package:nekodroid/features/explore/screens/popular_animes.dart';
import 'package:nekodroid/features/explore/screens/seasonal_animes.dart';
import 'package:nekodroid/features/history/screens/history.dart';
import 'package:nekodroid/features/library/screens/library.dart';
import 'package:nekodroid/features/more/screens/more.dart';
import 'package:nekodroid/core/router_shells/shells/bottom_navbar.dart';
import 'package:nekodroid/features/dev_tools/screens/dev_tools.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/features/player/data/player_route_params.dart';
import 'package:nekodroid/features/player/screens/player.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:nekodroid/features/search/screens/search.dart';
import 'package:nekodroid/features/settings/screens/library.dart';
import 'package:nekodroid/features/settings/screens/library_lists.dart';
import 'package:nekodroid/features/settings/screens/search.dart';
import 'package:nekodroid/features/settings/screens/settings.dart';
import 'package:nekodroid/features/settings/screens/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) => GoRouter(
      redirect: (context, state) {
        if (RegExp("https?").hasMatch(state.uri.scheme)) {
          return "/anime/${Uri.encodeComponent(state.uri.toString())}";
        }
        return null;
      },
      routes: [
        GoRoute(
          path: "/",
          redirect: (context, state) => "/library",
        ),
        ShellRoute(
          builder: (context, state, child) => BannersShell(child: child),
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) => BottomNavbarShell(
                index: navigationShell.currentIndex,
                child: navigationShell,
              ),
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: "/library",
                      builder: (context, state) => const LibraryScreen(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: "/explore",
                      builder: (context, state) => const ExploreScreen(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: "/more",
                      builder: (context, state) => const MoreScreen(),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: "/explore/latest_episodes",
              builder: (context, state) => const ExploreLatestEpisodesScreen(),
            ),
            GoRoute(
              path: "/explore/popular_animes",
              builder: (context, state) => const ExplorePopularAnimesScreen(),
            ),
            GoRoute(
              path: "/explore/seasonal_animes",
              builder: (context, state) => const ExploreSeasonalAnimesScreen(),
            ),
            GoRoute(
              path: "/settings",
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: "theme",
                  builder: (context, state) => const SettingsThemeScreen(),
                ),
                GoRoute(
                  path: "library",
                  builder: (context, state) => const SettingsLibraryScreen(),
                  routes: [
                    GoRoute(
                      path: "lists",
                      builder: (context, state) => const SettingsLibraryListsScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: "search",
                  builder: (context, state) => const SettingsSearchScreen(),
                ),
              ],
            ),
            GoRoute(
              path: "/dev_tools",
              builder: (context, state) => const DevToolsScreen(),
            ),
            GoRoute(
              path: "/search",
              builder: (context, state) => SearchScreen(initialFilters: state.extra as SearchFiltersState?),
            ),
            GoRoute(
              path: "/anime/:link",
              builder: (context, state) => AnimeScreen(
                url: UriX.tryParseNull(state.pathParameters["link"]),
              ),
            ),
            GoRoute(
              path: "/history",
              builder: (context, state) => const HistoryScreen(),
            ),
            GoRoute(
              path: "/backup",
              builder: (context, state) => const BackupScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "/player",
          pageBuilder: (context, state) => NoTransitionPage(child: PlayerScreen(state.extra as PlayerRouteParams)),
        ),
      ],
    );
