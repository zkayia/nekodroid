
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/http_client.dart';
import 'package:nekosama_hive/nekosama_hive.dart';


final apiProvider = Provider<NekoSama>(
  (ref) => NekoSama(httpClient: ref.watch(httpClientProvider)),
);
