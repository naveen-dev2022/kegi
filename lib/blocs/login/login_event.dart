part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  const LoginButtonPressed({
    @required this.email,
    @required this.mobile,
    @required this.otp,
  });

  final String? email;
  final String? mobile;
  final String? otp;

  @override
  List<Object?> get props => [email!, mobile!,otp!];

  @override
  String toString() =>
      'LoginButtonPressed {pass:$email!, mobile:$mobile , otp:$otp}';
}
