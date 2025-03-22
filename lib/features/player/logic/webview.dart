import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webview.g.dart';

@riverpod
class Webview extends _$Webview {
  @override
  WebviewState build() => const WebviewState();

  void setController(InAppWebViewController controller) => state = state.copyWith(controller: controller);
  void setLoading(bool isLoading) => state = state.copyWith(isLoading: isLoading);
}

class WebviewState extends Equatable {
  final InAppWebViewController? controller;
  final bool isLoading;

  const WebviewState({
    this.controller,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [controller, isLoading];

  WebviewState copyWith({
    InAppWebViewController? controller,
    bool? isLoading,
  }) =>
      WebviewState(
        controller: controller ?? this.controller,
        isLoading: isLoading ?? this.isLoading,
      );
}
