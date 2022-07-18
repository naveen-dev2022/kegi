import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_bloc.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_event.dart';
import 'package:kegi_sudo/models/registration_model.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    @required this.repository,
    @required this.authenticationBloc,
  })  :  super(RegistrationInitial());

  final Repository? repository;
  final AuthenticationBloc? authenticationBloc;
  SharedPreference? sharedPreference;

  @override
  RegistrationState get initialState => RegistrationInitial();

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegistrationButtonPressed) {
      yield RegistrationInProgress();

      try {
        final RegistrationModel token = await repository!.register(
          event.name!,
          event.mobile!,
          event.email!,
          event.otp!);
        if (token.token != null) {
          sharedPreference = SharedPreference();
          SharedPreference.addStringToSF(SharedPreference.GET_TOKEN, token.token);
          SharedPreference.addStringToSF(SharedPreference.GET_UID, token.user!.userId.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_EMAIL, token.user!.email.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_MOBILE, event.mobile);
          SharedPreference.addStringToSF(SharedPreference.GET_FIRSTNAME, token.user!.firstName.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_PROFILEPIC, token.user!.coverImage.toString());
          authenticationBloc!
              .add(AuthenticationLoggedIn(token: token.token.toString()));
          yield RegistrationInitial();
        } else {
          yield RegistrationFailure(error: token.error.toString());
        }
      } catch (error) {
        yield RegistrationFailure(error: error.toString());
      }
    }
  }
}
