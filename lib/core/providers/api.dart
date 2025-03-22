import 'package:nekodroid/core/providers/http_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nekosama/nekosama.dart';

part 'api.g.dart';

@Riverpod(keepAlive: true)
NekoSama api(ApiRef ref) => NekoSama(
  httpClient: ref.watch(httpClientProvider),
);
