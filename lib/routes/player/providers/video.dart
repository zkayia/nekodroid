
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/routes/player/providers/player_params.dart';


final videoProv = FutureProvider.autoDispose.family<Uri?, PlayerRouteParams>(
  (ref, params) => ref.watch(apiProv).getVideoUrl(
    ref.watch(playerParamsProv(params).select((e) => e.episode)),
  ),
);
