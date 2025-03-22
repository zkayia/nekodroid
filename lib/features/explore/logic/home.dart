import 'package:nekodroid/core/providers/api.dart';
import 'package:nekosama/nekosama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.g.dart';

@riverpod
Future<NSHome> home(HomeRef ref) => ref.watch(apiProvider).getHome();
