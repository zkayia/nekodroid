import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webview_channel_port.g.dart';

@riverpod
class WebviewChannelPort extends _$WebviewChannelPort {
  bool _initialised = false;
  bool _closed = false;

  @override
  WebMessagePort? build() {
    ref.onDispose(close);
    return null;
  }

  void setPort(WebMessagePort value) => state = value;

  Future<void> initChannel({
    required InAppWebViewController webviewController,
    required WebMessagePort remotePort,
  }) async {
    if (_closed) {
      return;
    }
    await webviewController.postWebMessage(
      message: WebMessage(
        data: jsonEncode({
          "channel": "nekodroid_player",
          "action": "set_port",
          "arg": null,
        }),
        ports: [remotePort],
      ),
    );
    _initialised = true;
  }

  Future<void> send(String action, {Object? arg}) async {
    if (state == null || !_initialised || _closed) {
      return;
    }
    await state?.postMessage(
      WebMessage(
        data: jsonEncode({
          "channel": "nekodroid_player",
          "action": action,
          "arg": arg,
        }),
      ),
    );
  }

  Future<void> close() async {
    await state?.close();
    _closed = true;
  }

  Future<void> playPause() => send("set_playing");
  Future<void> play() => send("set_playing", arg: true);
  Future<void> pause() => send("pause", arg: false);

  Future<void> muteUnmute() => send("set_mute");
  // Future<void> mute() => send("set_mute", arg: true);
  // Future<void> unmute() => send("set_mute", arg: false);

  Future<void> goTo(int position) => send("go_to", arg: position);

  Future<void> moveBy(int amount) => send("move_by", arg: amount);

  Future<void> setPlaybackSpeed(num speed) => send("set_playback_speed", arg: speed);

  Future<void> setQuality(int index) => send("set_quality", arg: index);
}
