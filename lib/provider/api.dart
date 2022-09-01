
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/http_client.dart';
import 'package:nekosama/nekosama.dart';


final apiProvider = Provider<NekoSama>(
  (ref) => NekoSama(httpClient: ref.watch(httpClientProvider)),
);
