import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => <dynamic>[];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  const AuthenticationLoggedIn({@required this.token});

  final String? token;

  @override
  List<Object?> get props => <dynamic>[token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class AuthenticationLoggedOut extends AuthenticationEvent {}
