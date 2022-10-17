
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/api.dart';


final homeProv = FutureProvider(
  (ref) async => ref.watch(apiProv).getHome(),
);
