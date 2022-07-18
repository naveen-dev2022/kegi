import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_bloc.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_event.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/models/login_model.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required this.repository,
    @required this.authenticationBloc,
    @required this.homeBloc,
  }) : super(LoginInitial());

  final Repository? repository;
  final AuthenticationBloc? authenticationBloc;
  HomeBloc? homeBloc;

  SharedPreference? sharedPreference;

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginInProgress();

      try {
        LoginModel? loginModel = await repository!.authenticate(
          event.mobile!,
          event.email!,
          event.otp!,
        );

        if (loginModel.serverError != null) {
          print('loginModel.error---------');
          yield LoginFailure(error: loginModel.serverError.toString());
        }
        else if(loginModel.error!=null){
          yield LoginFailure(error: loginModel.error.toString());
        }
        else if (loginModel.token != null) {
          print('Mobile:: ${event.mobile}');
          SharedPreference.addStringToSF(SharedPreference.GET_TOKEN, loginModel.token);
          SharedPreference.addStringToSF(SharedPreference.GET_UID, loginModel.user!.userId.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_EMAIL, loginModel.user!.email.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_MOBILE, event.mobile);
          SharedPreference.addStringToSF(SharedPreference.GET_FIRSTNAME, loginModel.user!.firstName.toString());
          SharedPreference.addStringToSF(SharedPreference.GET_PROFILEPIC, loginModel.user!.coverImage.toString());
          /*sharedPreference = SharedPreference();
          sharedPreference!.setToken(loginModel.token);
          sharedPreference!.setUid(loginModel.user!.userId.toString());
          sharedPreference!.setProfilePic(loginModel.user!.coverImage.toString());
          sharedPreference!.setEmail(loginModel.user!.email.toString());
          sharedPreference!.setFirstName(loginModel.user!.firstName.toString());*/
          authenticationBloc!
              .add(AuthenticationLoggedIn(token: loginModel.token.toString()));
          print('loginModel.token ---------${loginModel.token }');
          yield LoginInitial();
        }
      } on DioError catch (error) {
        print('DioError catch---------');
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
