
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/models/player_route_params.dart';


final playerParamsProv = StateProvider.autoDispose.family<
  PlayerRouteParams,
  PlayerRouteParams
>(
  (ref, params) => params,
);
