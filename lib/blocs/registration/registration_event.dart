part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationButtonPressed extends RegistrationEvent {
  const RegistrationButtonPressed({
    @required this.email,
    @required this.name,
    @required this.mobile,
    @required this.otp,
  });

  final String? name;
  final String? email;
  final String? mobile;
  final String? otp;

  @override
  List<Object> get props => [name!, email!,mobile!,otp!];

  @override
  String toString() =>
      'RegistrationButtonPressed { username: $name, email: $email, mobileNo: $mobile, otp: $otp }';
}
