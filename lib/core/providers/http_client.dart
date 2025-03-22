import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client.g.dart';

@Riverpod(keepAlive: true)
HttpClient httpClient(HttpClientRef ref) {
  final client = HttpClient();
  ref.onDispose(() => client.close(force: true));
  return client;
}
