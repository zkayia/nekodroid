import 'package:nekodroid/core/utils/network.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error.g.dart';

@Riverpod(keepAlive: true)
class Error extends _$Error {
  @override
  Set<ErrorState> build() => const <ErrorState>{};

  void addError(ErrorState error) => state = {error, ...state};
  void removeError(ErrorState error) => state = {...state.where((e) => e != error)};

  void toggleError(ErrorState error, {bool? set}) => set ?? !state.contains(error) ? addError(error) : removeError(error);

  Future<void> checkForErrors() async {
    final hasNetwork = await NetworkUtils.hasNetworkConnection();
    toggleError(const NoNetworkError(), set: !hasNetwork);
    if (!hasNetwork) {
      return;
    }

    final canAccessHost = await NetworkUtils.canConnectToHost();
    toggleError(const CantAccessHostError(), set: !canAccessHost);
    if (!canAccessHost) {
      return;
    }

    // final hasSession = (await ref.read(sessionProvider.future)) is SessionLoggedIn;
    // toggleError(const NoSessionError(), set: !hasSession);
  }
}

sealed class ErrorState extends Equatable {
  const ErrorState();

  @override
  List<Object?> get props => [];
}

// class GenericError extends ErrorState {
//   final Object? error;
//   final StackTrace? stackTrace;
//   const GenericError({required this.error, required this.stackTrace});

//   @override
//   List<Object?> get props => [error, stackTrace];
// }

class NoNetworkError extends ErrorState {
  const NoNetworkError();
}

class CantAccessHostError extends ErrorState {
  const CantAccessHostError();
}
