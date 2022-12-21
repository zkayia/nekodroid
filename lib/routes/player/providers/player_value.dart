
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';


final playerValueProv = StateProvider<VideoPlayerValue>(
  (ref) => VideoPlayerValue(duration: Duration.zero),
);
