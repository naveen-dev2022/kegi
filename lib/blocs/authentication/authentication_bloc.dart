import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({this.repository}) : super(AuthenticationInitial());

  final Repository? repository;

  @override
  AuthenticationState? get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent? event,
  ) async* {
    if (event is AuthenticationStarted) {
      final bool? hasToken = await repository!.hasToken();

      if (hasToken!) {
        yield AuthenticationSuccess();
      } else {
        yield AuthenticationFailure();
      }
    }

    if (event is AuthenticationLoggedIn) {
      yield AuthenticationInProgress();
      await repository!.persistToken(event.token!);
      yield AuthenticationSuccess();
    }

    if (event is AuthenticationLoggedOut) {
      yield AuthenticationInProgress();
      await repository!.deleteToken();
      yield AuthenticationFailure();
    }
  }
}
